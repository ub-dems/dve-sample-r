#!/usr/bin/env Rscript
#:: AI Generated at 2025-10-31T14:32:45 -- Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)
#:: @Seealso: notes/howtos/Rcpp-HOWTO-Q7-all.md
#:: @Seealso: dummy_finder.cpp
#
# A* Pathfinding Benchmark Script
# Compares sequential vs parallel C++ implementations on random graphs

# Load required libraries
suppressPackageStartupMessages({
  library(Rcpp)
  library(RcppParallel)
  library(igraph)
  library(ggraph)
  library(ggplot2)
  library(argparse)
  library(logger)
  library(yaml)
  library(foreach)
  library(doParallel)
  library(parallelly)
  library(microbenchmark)
  library(tidyverse)
})

USAGE_DOC <- "
A* Pathfinding Performance Benchmark

Tests sequential and parallel C++ implementations of A* algorithm
on randomly generated spatial graphs with configurable properties.

Usage:
  dummy-rcpp-finder.r [options] [GRAPH_SIZE]
  dummy-rcpp-finder.r -h | --help

The script generates a random graph, runs pathfinding algorithms,
and optionally produces visualizations and performance reports.
"

# =======================================
# Global variables
# =======================================

g_args <- NULL
g_log_prefix <- NULL
g_log_dir <- NULL
g_start_time <- NULL
g_rnd_seed <- NULL
g_cpp_source_path <- NULL

# =======================================
# Housekeeping Phase
# =======================================

#' Parse command-line arguments
parse_arguments <- function() {
  parser <- ArgumentParser(description = USAGE_DOC)
  
  # Generic arguments
  parser$add_argument("-v", "--verbose", action = "count", default = 0,
                     help = "Increase verbosity (-v: debug, -vv: trace)")
  parser$add_argument("-u", "--seed", type = "integer", default = 0,
                     help = "Random seed for reproducibility (0 = random)")
  
  # Sample graph arguments
  parser$add_argument("-g", "--graph-type", type = "character", default = "route",
                     choices = c("grg", "rad", "geo", "route"),
                     help = "Graph type: grg|rad|geo|route")
  parser$add_argument("-r", "--graph-radius", type = "double", default = 0.1,
                     help = "Radius for edge generation")
  parser$add_argument("-q", "--graph-fill", type = "double", default = 1.0,
                     help = "Edge retention probability (0-1)")
  parser$add_argument("-c", "--congestion-rate", type = "double", default = 0.5,
                     help = "Mean of exponential congestion distribution")
  parser$add_argument("-k", "--congestion-coeff", type = "double", default = 1.0,
                     help = "Congestion multiplier for edge weights")
  parser$add_argument("graph_size", type = "integer", nargs = "?", default = 100,
                     help = "Number of vertices in graph")
  
  # Execution modes
  parser$add_argument("-x", "--exec", type = "character", default = "par",
                     choices = c("nil", "seq", "par", "all", "bench"),
                     help = "Execution mode: nil|seq|par|all|bench")
  
  # Benchmark arguments
  parser$add_argument("-m", "--samples", type = "integer", default = 10,
                     help = "Number of benchmark iterations")
  
  # Graph plot arguments
  parser$add_argument("-p", "--plot", action = "store_true",
                     help = "Generate graph visualization PDF")
  parser$add_argument("-z", "--image-size", type = "character", default = "A4",
                     choices = c("A2", "A3", "A4", "A5", "A6"),
                     help = "PDF page size")
  parser$add_argument("-o", "--image-orient", type = "character", default = "L",
                     choices = c("P", "L"),
                     help = "PDF orientation: P(ortrait)|L(andscape)")
  
  # Save output data arguments
  parser$add_argument("-s", "--save", action = "store_true",
                     help = "Save benchmark and statistics")
  parser$add_argument("-f", "--export-graph", action = "store_true",
                     help = "Export graph data as TSV")
  
  args <- parser$parse_args()
  return(args)
}

#' Initialize logging facility
setup_logging <- function(args) {
  # Get log directory from environment or default
  log_dir <- Sys.getenv("P_LOGS_DIR", "logs")
  if (!dir.exists(log_dir)) {
    dir.create(log_dir, recursive = TRUE)
  }
  
  # Create log file with timestamp
  start_time <- Sys.time()
  timestamp <- format(start_time, "%Y%m%d-%H%M%S")
  script_name <- "dummy-rcpp-finder"
  log_prefix <- sprintf("%s-%s", script_name, timestamp)
  log_file <- file.path(log_dir, sprintf("%s.log", log_prefix))
  
  # Configure logger
  log_threshold <- if (args$verbose >= 1) DEBUG else INFO
  log_appender(appender_tee(log_file))
  log_threshold(log_threshold)
  log_layout(layout_glue_colors)
  
  # Store in globals
  assign("g_log_dir", log_dir, envir = .GlobalEnv)
  assign("g_log_prefix", log_prefix, envir = .GlobalEnv)
  assign("g_start_time", start_time, envir = .GlobalEnv)
  
  log_info("Logging initialized: {log_file}")
  log_info("Log directory: {normalizePath(log_dir)}")
  
  return(list(dir = log_dir, prefix = log_prefix, file = log_file))
}

#' Log system information
log_system_info <- function() {
  log_info("=== System Information ===")
  
  # Try to run inxi command
  tryCatch({
    cpu_info <- system("inxi -C", intern = TRUE, ignore.stderr = TRUE)
    log_info(paste(cpu_info, collapse = "\n"))
  }, error = function(e) {
    log_warn("Could not retrieve CPU info (inxi not available)")
    log_info("R version: {R.version.string}")
    log_info("Platform: {R.version$platform}")
  })
}

#' Setup random number generator
setup_rng <- function(seed) {
  if (seed == 0) {
    seed <- as.integer(runif(1) * 2e9)
  }
  set.seed(seed)
  assign("g_rnd_seed", seed, envir = .GlobalEnv)
  log_info("Random seed: {seed}")
  return(seed)
}

#' Link C++ source code
link_cpp_source <- function() {
  # Try multiple locations for C++ source
  script_dir <- tryCatch({
    dirname(sys.frame(1)$ofile)
  }, error = function(e) NULL)
  
  search_paths <- c(
    if (!is.null(script_dir)) file.path(script_dir, "dummy_finder.cpp"),
    "dummy_finder.cpp",
    "exec/dummySearch/dummy_finder.cpp"
  )
  
  cpp_path <- NULL
  for (path in search_paths) {
    if (file.exists(path)) {
      cpp_path <- path
      break
    }
  }
  
  if (is.null(cpp_path)) {
    log_error("Could not find dummy_finder.cpp in any search location")
    stop("C++ source file not found")
  }
  
  log_info("Compiling C++ source: {cpp_path}")
  sourceCpp(cpp_path)
  assign("g_cpp_source_path", cpp_path, envir = .GlobalEnv)
  log_info("C++ functions loaded successfully")
}

# =======================================
# Preparation Phase - Graph Generation
# =======================================

#' Calculate edge weight from distance and congestion
calc_edge_weight <- function(distance, congestion, cong_coeff) {
  distance * (1 + cong_coeff * congestion)
}

#' Setup edge attributes (distance, congestion, weight)
setup_edge <- function(g, pairs, congestion = 0.0, cong_coeff = 1.0) {
  # pairs should be even-length vector of vertex indices
  if (length(pairs) %% 2 != 0) {
    stop("Pairs must have even length")
  }
  
  for (i in seq(1, length(pairs), by = 2)) {
    v1 <- pairs[i]
    v2 <- pairs[i + 1]
    
    # Add edge if not present (undirected)
    if (!are_adjacent(g, v1, v2)) {
      g <- add_edges(g, c(v1, v2))
    }
    
    eid <- get_edge_ids(g, c(v1, v2))
    
    # Calculate Euclidean distance
    pos1 <- c(V(g)[v1]$x, V(g)[v1]$y)
    pos2 <- c(V(g)[v2]$x, V(g)[v2]$y)
    dist <- sqrt(sum((pos1 - pos2)^2))
    
    # Set attributes
    E(g)[eid]$distance <- dist
    E(g)[eid]$congestion <- congestion
    E(g)[eid]$weight <- calc_edge_weight(dist, congestion, cong_coeff)
  }
  
  return(g)
}

#' Create geometric random graph (grg)
create_grg_graph_model <- function(n, radius) {
  g <- sample_grg(n, radius, coords = TRUE)
  
  # Set edge attributes
  for (e in E(g)) {
    ep <- ends(g, e)
    v1 <- ep[1, 1]
    v2 <- ep[1, 2]
    
    pos1 <- c(V(g)[v1]$x, V(g)[v1]$y)
    pos2 <- c(V(g)[v2]$x, V(g)[v2]$y)
    dist <- sqrt(sum((pos1 - pos2)^2))
    
    E(g)[e]$distance <- dist
    E(g)[e]$congestion <- 0.0
    E(g)[e]$weight <- dist
  }
  
  return(g)
}

#' Create radial graph (randomly pruned grg)
create_rad_graph_model <- function(n, radius, fill) {
  g <- create_grg_graph_model(n, radius)
  
  # Randomly remove edges
  if (fill < 1.0) {
    edges_to_remove <- c()
    for (e in E(g)) {
      if (runif(1) > fill) {
        edges_to_remove <- c(edges_to_remove, e)
      }
    }
    if (length(edges_to_remove) > 0) {
      g <- delete_edges(g, edges_to_remove)
    }
  }
  
  return(g)
}

#' Create geographic graph (connected rad graph)
create_geo_graph_model <- function(n, radius, fill) {
  g <- create_rad_graph_model(n, radius, fill)
  
  # Connect components
  while (TRUE) {
    comp <- components(g)
    if (comp$no == 1) break
    
    # Find disconnected component
    comp_sizes <- comp$csize
    if (length(comp_sizes) == 1) break
    
    # Get vertices in first small component
    comp_members <- which(comp$membership == 2)
    if (length(comp_members) == 0) break
    
    # Find closest vertex pair between components
    min_dist <- Inf
    best_pair <- c(NA, NA)
    
    for (v_in in comp_members) {
      for (v_out in which(comp$membership != comp$membership[v_in])) {
        pos_in <- c(V(g)[v_in]$x, V(g)[v_in]$y)
        pos_out <- c(V(g)[v_out]$x, V(g)[v_out]$y)
        dist <- sqrt(sum((pos_in - pos_out)^2))
        
        if (dist < min_dist) {
          min_dist <- dist
          best_pair <- c(v_in, v_out)
        }
      }
    }
    
    # Connect components
    if (!any(is.na(best_pair))) {
      g <- setup_edge(g, best_pair, 0.0, g_args$congestion_coeff)
    } else {
      break
    }
  }
  
  return(g)
}

#' Create route graph (geo graph with congestion)
create_route_graph_model <- function(n, radius, fill, cong_rate, cong_coeff) {
  g <- create_geo_graph_model(n, radius, fill)
  
  # Add congestion to edges
  for (e in E(g)) {
    congestion <- rexp(1, rate = 1 / cong_rate)
    E(g)[e]$congestion <- congestion
    E(g)[e]$weight <- calc_edge_weight(
      E(g)[e]$distance, congestion, cong_coeff)
  }
  
  return(g)
}

#' Dispatch graph creation based on type
create_graph_model <- function(args) {
  log_info("Generating {args$graph_type} graph with {args$graph_size} vertices")
  
  g <- switch(args$graph_type,
    grg = create_grg_graph_model(args$graph_size, args$graph_radius),
    rad = create_rad_graph_model(args$graph_size, args$graph_radius, args$graph_fill),
    geo = create_geo_graph_model(args$graph_size, args$graph_radius, args$graph_fill),
    route = create_route_graph_model(args$graph_size, args$graph_radius, 
                                     args$graph_fill, args$congestion_rate,
                                     args$congestion_coeff),
    stop("Unknown graph type")
  )
  
  return(g)
}

#' Compute graph statistics
create_graph_stats <- function(g) {
  list(
    vertex_size = vcount(g),
    edge_size = ecount(g),
    edge_density = edge_density(g),
    knn = mean(knn(g)$knn, na.rm = TRUE)
  )
}

#' Create space_graph_test object
create_space_graph <- function(g) {
  # Select random start and goal
  n <- vcount(g)
  query_pair <- sample(n, 2)
  
  obj <- list(
    type = g_args$graph_type,
    graph = g,
    query = list(start = query_pair[1], goal = query_pair[2]),
    path = integer(0),
    stats = create_graph_stats(g)
  )
  
  class(obj) <- "space_graph_test"
  return(obj)
}

#' Main graph generation function
create_sample_graph <- function(args) {
  g <- create_graph_model(args)
  sg <- create_space_graph(g)
  
  # Log statistics
  log_info("Graph statistics:")
  log_info("  Vertices: {sg$stats$vertex_size}")
  log_info("  Edges: {sg$stats$edge_size}")
  log_info("  Density: {sprintf('%.4f', sg$stats$edge_density)}")
  log_info("  Avg KNN: {sprintf('%.4f', sg$stats$knn)}")
  log_info("  Query: {sg$query$start} -> {sg$query$goal}")
  
  return(sg)
}

#' Convert space_graph_test to space_graph_query
as.space_graph_query.space_graph_test <- function(obj) {
  g <- obj$graph
  n <- vcount(g)
  
  # Extract positions
  positions <- matrix(c(V(g)$x, V(g)$y), ncol = 2)
  
  # Build adjacency matrix
  adjacency <- matrix(Inf, n, n)
  diag(adjacency) <- 0
  
  for (e in E(g)) {
    ep <- ends(g, e)
    i <- ep[1, 1]
    j <- ep[1, 2]
    w <- E(g)[e]$weight
    adjacency[i, j] <- w
    adjacency[j, i] <- w
  }
  
  query <- list(
    positions = positions,
    adjacency = adjacency,
    query = obj$query
  )
  
  class(query) <- "space_graph_query"
  return(query)
}

# =======================================
# Search Execution Phase
# =======================================

#' Apply result path to graph object
apply_result_path <- function(obj, path, elapsed_time) {
  obj$path <- path
  g <- obj$graph
  
  # Initialize all attributes
  V(g)$in_path <- 0
  E(g)$in_path <- 0
  E(g)$path_pos <- -1
  E(g)$traffic <- 0.0
  
  # Set traffic for route graphs
  if (obj$type == "route") {
    cong_cap <- log(4) * g_args$congestion_rate
    for (e in E(g)) {
      cong <- E(g)[e]$congestion
      E(g)[e]$traffic <- min(cong, cong_cap) - g_args$congestion_rate
    }
  }
  
  # Process path if non-empty
  if (length(path) > 0) {
    # Mark vertices
    for (i in seq_along(path)) {
      v <- path[i]
      if (i == 1) {
        V(g)[v]$in_path <- 3  # start
      } else if (i == length(path)) {
        V(g)[v]$in_path <- 2  # goal
      } else {
        V(g)[v]$in_path <- 1  # inner
      }
    }
    
    # Mark edges
    for (i in seq_len(length(path) - 1)) {
      v1 <- path[i]
      v2 <- path[i + 1]
      eid <- get_edge_ids(g, c(v1, v2))
      E(g)[eid]$in_path <- 1
      E(g)[eid]$path_pos <- i
    }
    
    # Calculate path statistics
    path_cost <- 0
    for (i in seq_len(length(path) - 1)) {
      eid <- get_edge_ids(g, c(path[i], path[i + 1]))
      path_cost <- path_cost + E(g)[eid]$weight
    }
    
    degrees <- degree(g, path)
    degree_sum <- sum(degrees)
    degree_avg <- mean(degrees)
    path_complexity <- length(path) * degree_avg
    
    obj$stats$elapsed_time <- elapsed_time
    obj$stats$path_length <- length(path)
    obj$stats$path_cost <- path_cost
    obj$stats$degree_sum <- degree_sum
    obj$stats$degree_avg <- degree_avg
    obj$stats$path_complexity <- path_complexity
    obj$stats$path_l_rate <- if (length(path) > 0) elapsed_time / length(path) else NA
    obj$stats$path_c_rate <- if (path_complexity > 0) elapsed_time / path_complexity else NA
  } else {
    obj$stats$elapsed_time <- elapsed_time
    obj$stats$path_length <- 0
    obj$stats$path_cost <- NA
    obj$stats$degree_sum <- NA
    obj$stats$degree_avg <- NA
    obj$stats$path_complexity <- NA
    obj$stats$path_l_rate <- NA
    obj$stats$path_c_rate <- NA
  }
  
  obj$graph <- g
  
  # Log statistics
  log_info("Path statistics:")
  log_info("  Elapsed: {sprintf('%.4f', elapsed_time)}s")
  log_info("  Length: {obj$stats$path_length}")
  if (length(path) > 0) {
    log_info("  Cost: {sprintf('%.4f', obj$stats$path_cost)}")
    log_info("  Avg degree: {sprintf('%.2f', obj$stats$degree_avg)}")
    log_info("  Rate (time/len): {sprintf('%.6f', obj$stats$path_l_rate)}")
  }
  
  return(obj)
}

#' Run nil mode (no execution)
run_path_search_nil <- function(query) {
  log_info("Running NIL mode (no search)")
  return(list(path = integer(0), time = 0))
}

#' Run sequential search
run_path_search_seq <- function(query) {
  log_info("Running SEQUENTIAL search")
  start <- Sys.time()
  path <- dmy_astar_seq_finder(
    query$adjacency, query$positions,
    query$query$start - 1L, query$query$goal - 1L
  )
  elapsed <- as.numeric(Sys.time() - start, units = "secs")
  
  # Convert to 1-based indexing
  if (length(path) > 0) path <- path + 1L
  
  log_info("Sequential: {length(path)} nodes in {sprintf('%.4f', elapsed)}s")
  return(list(path = path, time = elapsed))
}

#' Run parallel search
run_path_search_par <- function(query) {
  log_info("Running PARALLEL search")
  start <- Sys.time()
  path <- dmy_astar_par_finder(
    query$adjacency, query$positions,
    query$query$start - 1L, query$query$goal - 1L
  )
  elapsed <- as.numeric(Sys.time() - start, units = "secs")
  
  # Convert to 1-based indexing
  if (length(path) > 0) path <- path + 1L
  
  log_info("Parallel: {length(path)} nodes in {sprintf('%.4f', elapsed)}s")
  return(list(path = path, time = elapsed))
}

#' Run both searches in parallel
run_path_search_all <- function(query) {
  log_info("Running BOTH (parallel execution)")
  
  # Setup parallel backend
  cl <- parallelly::makeClusterPSOCK(2)
  registerDoParallel(cl)
  
  # Export necessary data
  clusterExport(cl, c("g_cpp_source_path"), envir = .GlobalEnv)
  clusterEvalQ(cl, {
    library(Rcpp)
    sourceCpp(g_cpp_source_path)
  })
  
  # Run both
  results <- foreach(mode = c("seq", "par"), .combine = list) %dopar% {
    if (mode == "seq") {
      start <- Sys.time()
      path <- dmy_astar_seq_finder(
        query$adjacency, query$positions,
        query$query$start - 1L, query$query$goal - 1L
      )
      elapsed <- as.numeric(Sys.time() - start, units = "secs")
      if (length(path) > 0) path <- path + 1L
      list(path = path, time = elapsed, mode = "seq")
    } else {
      start <- Sys.time()
      path <- dmy_astar_par_finder(
        query$adjacency, query$positions,
        query$query$start - 1L, query$query$goal - 1L
      )
      elapsed <- as.numeric(Sys.time() - start, units = "secs")
      if (length(path) > 0) path <- path + 1L
      list(path = path, time = elapsed, mode = "par")
    }
  }
  
  stopCluster(cl)
  
  # Compare results
  seq_result <- results[[1]]
  par_result <- results[[2]]
  
  log_info("Sequential: {length(seq_result$path)} nodes in {sprintf('%.4f', seq_result$time)}s")
  log_info("Parallel: {length(par_result$path)} nodes in {sprintf('%.4f', par_result$time)}s")
  
  if (!identical(seq_result$path, par_result$path)) {
    log_warn("PATHS DIFFER between sequential and parallel!")
    log_warn("  Seq length: {length(seq_result$path)}")
    log_warn("  Par length: {length(par_result$path)}")
  }
  
  return(par_result)
}

#' Run benchmark
run_path_search_bench <- function(query) {
  log_info("Running BENCHMARK with {g_args$samples} samples")
  
  bench_result <- microbenchmark(
    seq = dmy_astar_seq_finder(
      query$adjacency, query$positions,
      query$query$start - 1L, query$query$goal - 1L
    ),
    par = dmy_astar_par_finder(
      query$adjacency, query$positions,
      query$query$start - 1L, query$query$goal - 1L
    ),
    times = g_args$samples
  )
  
  log_info("Benchmark summary:")
  print(summary(bench_result))
  
  # Store benchmark for later saving
  assign("g_benchmark", bench_result, envir = .GlobalEnv)
  
  return(list(path = integer(0), time = 0))
}

#' Main search dispatcher
run_path_search <- function(obj) {
  query <- as.space_graph_query.space_graph_test(obj)
  
  result <- switch(g_args$exec,
    nil = run_path_search_nil(query),
    seq = run_path_search_seq(query),
    par = run_path_search_par(query),
    all = run_path_search_all(query),
    bench = run_path_search_bench(query),
    stop("Unknown execution mode")
  )
  
  return(apply_result_path(obj, result$path, result$time))
}

# =======================================
# Reporting Phase
# =======================================

#' Plot sample graph with path
plot_sample_graph <- function(obj) {
  if (!g_args$plot) return(invisible(NULL))
  
  log_info("Generating graph plot")
  
  # Page dimensions
  page_sizes <- list(
    A2 = c(420, 594),
    A3 = c(297, 420),
    A4 = c(210, 297),
    A5 = c(148, 210),
    A6 = c(105, 148)
  )
  
  size <- page_sizes[[g_args$image_size]]
  if (g_args$image_orient == "L") {
    size <- rev(size)
  }
  
  # Build title
  title_line1 <- sprintf(
    "graph: %s(%d, rad=%.3f, fill=%.2f, cong=%.2f)",
    g_args$graph_type, g_args$graph_size, g_args$graph_radius,
    g_args$graph_fill, g_args$congestion_rate
  )
  title_line2 <- sprintf(
    "mode: %s time:%.4fs - path: len=%d, cost=%.2f, deg=%.2f",
    g_args$exec, obj$stats$elapsed_time, obj$stats$path_length,
    ifelse(is.na(obj$stats$path_cost), 0, obj$stats$path_cost),
    ifelse(is.na(obj$stats$degree_avg), 0, obj$stats$degree_avg)
  )
  
  # Create plot
  g <- obj$graph
  
  p <- ggraph(g, layout = "manual", x = V(g)$x, y = V(g)$y) +
    geom_edge_link(aes(colour = traffic, width = factor(in_path))) +
    scale_edge_width_discrete(range = c(0.3, 2)) +
    scale_edge_colour_gradientn(
      colours = c("green4", "gray90", "red3"),
      values = scales::rescale(c(-g_args$congestion_rate, 0.0, 
                                  log(4) * g_args$congestion_rate))
    ) +
    geom_node_point(aes(size = factor(in_path), fill = factor(in_path)),
                    shape = 21, colour = "black") +
    scale_size_discrete(range = c(1, 4)) +
    scale_fill_manual(values = c("gray80", "steelblue", "red3", "green4")) +
    labs(title = title_line1, subtitle = title_line2) +
    theme_void() +
    theme(
      legend.position = "right",
      plot.background = element_rect(fill = "white"),
      plot.title = element_text(size = 10),
      plot.subtitle = element_text(size = 8)
    )
  
  # Save plot
  plot_file <- file.path(g_log_dir, sprintf("%s-plot.pdf", g_log_prefix))
  ggsave(plot_file, p, width = size[1], height = size[2], units = "mm")
  log_info("Plot saved: {plot_file}")
}

#' Save sample information as YAML
save_sample_info <- function(obj) {
  info <- list(
    script_info = list(
      timestamp = format(g_start_time, "%Y-%m-%d %H:%M:%S"),
      log_prefix = g_log_prefix,
      random_seed = g_rnd_seed
    ),
    arguments = as.list(g_args),
    graph_stats = obj$stats[c("vertex_size", "edge_size", "edge_density", "knn")],
    path_stats = obj$stats[setdiff(names(obj$stats), 
                                   c("vertex_size", "edge_size", "edge_density", "knn"))]
  )
  
  info_file <- file.path(g_log_dir, sprintf("%s-info.yaml", g_log_prefix))
  write_yaml(info, info_file)
  log_debug("Info saved: {info_file}")
}

#' Save benchmark report
save_bench_report <- function(obj) {
  if (g_args$exec != "bench") return(invisible(NULL))
  if (!exists("g_benchmark", envir = .GlobalEnv)) return(invisible(NULL))
  
  bench <- get("g_benchmark", envir = .GlobalEnv)
  
  # Save summary
  bench_file <- file.path(g_log_dir, sprintf("%s-bench.txt", g_log_prefix))
  sink(bench_file)
  print(summary(bench))
  sink()
  log_debug("Benchmark summary saved: {bench_file}")
  
  # Save detailed data
  bench_df <- as.data.frame(bench)
  bench_df$graph_type <- g_args$graph_type
  bench_df$timestamp <- format(g_start_time, "%Y-%m-%d %H:%M:%S")
  bench_df$function_name <- as.character(bench_df$expr)
  bench_df$graph_size <- g_args$graph_size
  bench_df$graph_radius <- g_args$graph_radius
  bench_df$graph_fill <- g_args$graph_fill
  bench_df$path_length <- obj$stats$path_length
  bench_df$path_cost <- obj$stats$path_cost
  
  perf_file <- file.path(g_log_dir, sprintf("%s-perf.tsv", g_log_prefix))
  write_tsv(bench_df, perf_file)
}

#' Save graph data as TSV
save_graph_data <- function(obj) {
  if (!g_args$export_graph) return(invisible(NULL))
  
  g <- obj$graph
  
  # Export vertices
  vertex_df <- data.frame(
    id = seq_len(vcount(g)),
    x = V(g)$x,
    y = V(g)$y,
    in_path = V(g)$in_path
  )
  
  nodes_file <- file.path(g_log_dir, sprintf("%s-nodes.tsv", g_log_prefix))
  write_tsv(vertex_df, nodes_file)
  log_debug("Vertex data saved: {nodes_file}")
  
  # Export edges
  edge_list <- as_edgelist(g)
  edge_df <- data.frame(
    from = edge_list[, 1],
    to = edge_list[, 2],
    distance = E(g)$distance,
    congestion = E(g)$congestion,
    weight = E(g)$weight,
    traffic = E(g)$traffic,
    in_path = E(g)$in_path,
    path_pos = E(g)$path_pos
  )
  
  edges_file <- file.path(g_log_dir, sprintf("%s-edges.tsv", g_log_prefix))
  write_tsv(edge_df, edges_file)
  log_debug("Edge data saved: {edges_file}")
}

#' Save all sample data
save_sample_data <- function(obj) {
  if (!g_args$save && !g_args$export_graph) return(invisible(NULL))
  
  log_info("Saving output data")
  
  if (g_args$save) {
    save_sample_info(obj)
    save_bench_report(obj)
  }
  
  if (g_args$export_graph) {
    save_graph_data(obj)
  }
}

# =======================================
# Script Main Entry
# =======================================

#' Main execution function
main <- function() {
  # Parse arguments
  args <- parse_arguments()
  assign("g_args", args, envir = .GlobalEnv)
  
  # Setup logging
  log_info <- setup_logging(args)
  
  # Log arguments
  log_info("=== Script Arguments ===")
  for (name in names(args)) {
    log_info("  {name}: {args[[name]]}")
  }
  
  # Log system info
  log_system_info()
  
  # Setup RNG
  setup_rng(args$seed)
  
  # Link C++ source
  link_cpp_source()
  
  # Generate sample graph
  log_info("=== Preparation Phase ===")
  sample_graph <- create_sample_graph(args)
  
  # Run search
  log_info("=== Execution Phase ===")
  result_graph <- run_path_search(sample_graph)
  
  # Generate reports
  log_info("=== Reporting Phase ===")
  plot_sample_graph(result_graph)
  save_sample_data(result_graph)
  
  log_info("=== Execution Complete ===")
  
  invisible(result_graph)
}

# Execute main function if script is run directly
if (sys.nframe() == 0) {
  main()
}
