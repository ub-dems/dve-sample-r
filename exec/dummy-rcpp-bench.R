#!/usr/bin/env Rscript

#' Rcpp Performance Benchmark Script
#' 
#' This script benchmarks various C++ iteration strategies for sum and outer 
#' product operations across different input sizes. It supports command-line
#' arguments for flexible testing and generates comprehensive performance reports.
#' 
#' @details
#' The ./exec directory is chosen as a CRAN-compliant location for storing 
#' package support scripts. This directory can contain executable scripts that
#' call package R code and can also be invoked via system() calls from internal
#' package code, providing flexibility for both interactive and programmatic use.
#'
#' @seealso 
#' - C++ source: \code{./src/dummy_iter.cpp}
#' - Build configuration: \code{./src/Makevars}  
#' - User configuration: \code{~/.R/Makevars}
#' - Documentation: \code{./notes/howtos/Rcpp-HOWTO-Q3-all.md}

# Suppress package startup messages
suppressMessages({
  library(microbenchmark)
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(logger)
  library(argparse)
})

# Global variables
script_name <- "dummy-rcpp-bench"
start_time <- as.integer(Sys.time())

#' Initialize logging configuration  
setup_logging <- function(log_dir, verbosity) {
  log_threshold <- switch(as.character(verbosity),
    "0" = INFO,
    "1" = DEBUG,  
    DEBUG  # verbosity >= 2
  )
  
  log_file <- file.path(log_dir, paste0(script_name, "-", start_time, "-test.log"))
  log_layout(layout_glue_generator(format = 
    '{time} [{level}] {msg}'))
  log_appender(appender_tee(log_file))
  log_threshold(log_threshold)
}

#' Create output directory if it doesn't exist
ensure_log_dir <- function(log_dir) {
  if (!dir.exists(log_dir)) {
    dir.create(log_dir, recursive = TRUE)
    log_info("Created log directory: {log_dir}")
  }
  return(normalizePath(log_dir))
}

#' Get system information for benchmarking context
get_system_info <- function() {
  info <- list(
    timestamp = Sys.time(),
    user = Sys.getenv("USER"),
    r_version = R.version.string,
    platform = R.version$platform
  )
  
  # Try to get CPU info (Linux-specific)  
  if (Sys.which("inxi") != "") {
    info$cpu_info <- system("inxi -C", intern = TRUE)
  }
  
  return(info)
}

#' Generate comprehensive system information report
generate_system_report <- function(log_dir, test_type) {
  info_file <- file.path(log_dir, 
    paste0(script_name, "-", start_time, "-", test_type, "-info.log"))
  
  system_cmd <- paste(
    "date;", 
    "whoami;",
    "inxi -CfGMS 2>/dev/null || echo '#NO_INXI';",
    "lscpu 2>/dev/null || echo '#NO_LSCPU';", 
    "cpupower frequency-info 2>/dev/null || echo '#NO_CPUPOWER';",
    "nvidia-smi 2>/dev/null || echo '#NOGPU'"
  )
  
  system(paste("(", system_cmd, ") >", info_file))
  log_debug("System information saved to: {info_file}")
}

#' Get all sum-related functions from the package
get_sum_functions <- function() {
  funcs <- c(
    "dmy_pf_sum_c_style",
    "dmy_pf_sum_cpp_range", 
    "dmy_pf_sum_stl_iter",
    "dmy_pf_sum_armadillo",
    "dmy_pf_sum_r_base"
  )
  
  # Add OpenMP functions if available
  if (exists("dmy_pf_sum_omp_parallel")) {
    funcs <- c(funcs, "dmy_pf_sum_omp_parallel", "dmy_pf_sum_omp_simd")
  }
  
  return(funcs)
}

#' Get all outer product functions from the package  
get_outer_functions <- function() {
  funcs <- c(
    "dmy_pf_outer_c_style",
    "dmy_pf_outer_cpp_iter",
    "dmy_pf_outer_armadillo", 
    "dmy_pf_outer_r_base"
  )
  
  # Add OpenMP functions if available
  if (exists("dmy_pf_outer_omp_collapse")) {
    funcs <- c(funcs, "dmy_pf_outer_omp_collapse", "dmy_pf_outer_omp_simd")
  }
  
  return(funcs)
}

#' Create function label by removing common prefix
create_function_labels <- function(func_names) {
  # Remove common prefixes for cleaner labels
  labels <- gsub("^dmy_pf_(sum|outer)_", "", func_names)
  return(labels)
}

#' Run benchmarks for sum functions
benchmark_sum_functions <- function(input_sizes, sample_size, log_dir, test_type) {
  functions <- get_sum_functions()
  all_results <- list()
  
  log_info("Starting sum function benchmarks")
  log_info("Functions: {paste(functions, collapse = ', ')}")
  
  # Reset C++ tracing before benchmarks
  dmy_pf_log_reset()
  
  for (size in input_sizes) {
    log_info("Benchmarking sum functions with input size: {size}")
    
    # Generate test data once per size
    set.seed(42)  # For reproducibility
    test_data <- rnorm(size, mean = 0, sd = 100)
    
    # Create benchmark expressions
    expr_list <- list()
    for (func in functions) {
      expr_list[[func]] <- substitute(do.call(f, list(test_data)), 
                                      list(f = as.name(func)))
    }
    
    # Run microbenchmark
    mb_result <- microbenchmark(
      list = expr_list,
      times = sample_size,
      unit = "ms"
    )
    
    # Add metadata
    mb_result$input_size <- size
    mb_result$test_type <- test_type
    mb_result$timestamp <- start_time
    
    all_results[[as.character(size)]] <- mb_result
  }
  
  return(all_results)
}

#' Run benchmarks for outer product functions
benchmark_outer_functions <- function(input_sizes, sample_size, log_dir, test_type) {
  functions <- get_outer_functions()
  all_results <- list()
  
  log_info("Starting outer product function benchmarks")
  log_info("Functions: {paste(functions, collapse = ', ')}")
  
  # Reset C++ tracing before benchmarks  
  dmy_pf_log_reset()
  
  for (size in input_sizes) {
    log_info("Benchmarking outer functions with input size: {size}")
    
    # Generate test data once per size (same vector used for both arguments)
    set.seed(42)  # For reproducibility
    test_data <- rnorm(size, mean = 0, sd = 100)
    
    # Create benchmark expressions
    expr_list <- list()
    for (func in functions) {
      expr_list[[func]] <- substitute(do.call(f, list(test_data, test_data)),
                                      list(f = as.name(func)))
    }
    
    # Run microbenchmark
    mb_result <- microbenchmark(
      list = expr_list,
      times = sample_size,
      unit = "ms"
    )
    
    # Add metadata
    mb_result$input_size <- size
    mb_result$test_type <- test_type  
    mb_result$timestamp <- start_time
    
    all_results[[as.character(size)]] <- mb_result
  }
  
  return(all_results)
}

#' Combine and process benchmark results
process_results <- function(benchmark_results, test_type) {
  # Combine all results
  combined_df <- do.call(rbind, lapply(benchmark_results, as.data.frame))
  
  # Add function labels
  combined_df$function_label <- create_function_labels(combined_df$expr)
  
  # Calculate summary statistics
  summary_df <- combined_df %>%
    group_by(input_size, function_label, test_type) %>%
    summarise(
      mean_time = mean(time / 1e6),  # Convert to milliseconds
      median_time = median(time / 1e6),
      min_time = min(time / 1e6),
      max_time = max(time / 1e6),
      sd_time = sd(time / 1e6),
      .groups = 'drop'
    )
  
  return(list(raw = combined_df, summary = summary_df))
}

#' Create performance visualization
create_performance_plot <- function(summary_df, test_type, sample_size) {
  plot_title <- paste("Performance Comparison:", toupper(test_type), "Functions")
  plot_subtitle <- paste("Sample Size:", sample_size, "| Error bars: ±1 SD")
  
  p <- ggplot(summary_df, aes(x = input_size, y = median_time, color = function_label)) +
    geom_line(size = 1.2) +
    geom_point(size = 2.5) +
    geom_errorbar(aes(ymin = median_time - sd_time, ymax = median_time + sd_time),
                  width = 0.1, alpha = 0.7) +
    scale_x_log10(labels = scales::comma) +
    scale_y_log10(labels = scales::comma) +
    labs(
      title = plot_title,
      subtitle = plot_subtitle, 
      x = "Input Size (log scale)",
      y = "Median Execution Time (ms, log scale)",
      color = "Implementation"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold"),
      plot.subtitle = element_text(size = 10),
      legend.position = "bottom",
      legend.title = element_text(face = "bold")
    )
  
  return(p)
}

#' Save results and generate outputs  
save_results <- function(results, test_type, log_dir, sample_size, save_data) {
  file_prefix <- paste0(script_name, "-", start_time, "-", test_type, "-")
  
  # Always generate: benchmark plot
  plot_file <- file.path(log_dir, paste0(file_prefix, "bench.png"))
  plot <- create_performance_plot(results$summary, test_type, sample_size)
  ggsave(plot_file, plot, width = 12, height = 8, dpi = 300)
  log_info("Benchmark plot saved: {plot_file}")
  
  # Generate additional outputs if save_data is TRUE
  if (save_data) {
    # System information report
    generate_system_report(log_dir, test_type)
    
    # TSV data export
    tsv_file <- file.path(log_dir, paste0(file_prefix, "data.tsv"))
    write_tsv(results$raw, tsv_file)
    log_debug("Benchmark data exported: {tsv_file}")
  }
}

#' Parse command line arguments
parse_arguments <- function() {
  parser <- ArgumentParser(description = 
    'Benchmark Rcpp iteration strategies for sum and outer product operations')
  
  # Generic arguments
  parser$add_argument("-v", "--verbose", action = "count", default = 0,
                      help = "Increase verbosity (can be repeated: -v, -vv, -vvv)")
  parser$add_argument("-p", "--profile", action = "store_true", default = FALSE,
                      help = "Enable profiling with Rprof")
  
  # Benchmark arguments  
  parser$add_argument("-t", "--test", default = "sum", 
                      choices = c("sum", "outer"),
                      help = "Test type to execute: 'sum' or 'outer' (default: sum)")
  parser$add_argument("-m", "--samples", type = "integer", default = 10,
                      help = "Microbenchmark sample size (default: 10)")
  parser$add_argument("-s", "--save", action = "store_true", default = FALSE,
                      help = "Save detailed data and system information")
  
  # Positional arguments for input sizes
  parser$add_argument("input_sizes", nargs = "*", default = c("10", "100", "1000"),
                      help = "Input vector sizes for testing (default: 10 100 1000)")
  
  return(parser$parse_args())
}

#' Main benchmark execution function
run_benchmark <- function(test_type, input_sizes, sample_size, log_dir, 
                         verbosity, profile, save_data) {
  
  # Set up C++ logging level
  dmy_pf_log_set_level(verbosity)
  
  # Convert input_sizes to integers
  input_sizes <- as.integer(input_sizes)
  
  log_info("=== Benchmark Configuration ===")
  log_info("Test Type: {test_type}")
  log_info("Input Sizes: {paste(input_sizes, collapse = ', ')}")
  log_info("Sample Size: {sample_size}")
  log_info("Verbosity: {verbosity}")
  log_info("Profile: {profile}")
  log_info("Save Data: {save_data}")
  log_info("Log Directory: {log_dir}")
  
  # System information logging
  sys_info <- get_system_info()
  log_info("System: {sys_info$platform}")
  log_info("R Version: {sys_info$r_version}")
  if (!is.null(sys_info$cpu_info)) {
    log_info("CPU Info: {paste(sys_info$cpu_info, collapse = ' | ')}")
  }
  
  # Start profiling if requested
  if (profile) {
    prof_file <- file.path(log_dir, 
      paste0(script_name, "-", start_time, "-", test_type, "-rprof.out"))
    Rprof(prof_file)
    log_info("Profiling started: {prof_file}")
  }
  
  # Run appropriate benchmark
  benchmark_results <- switch(test_type,
    "sum" = benchmark_sum_functions(input_sizes, sample_size, log_dir, test_type),
    "outer" = benchmark_outer_functions(input_sizes, sample_size, log_dir, test_type),
    stop("Unknown test type: ", test_type)
  )
  
  # Stop profiling if it was started
  if (profile) {
    Rprof(NULL)
    log_info("Profiling completed")
  }
  
  # Process and save results
  processed_results <- process_results(benchmark_results, test_type)
  save_results(processed_results, test_type, log_dir, sample_size, save_data)
  
  # Final summary
  log_info("=== Benchmark Summary ===")
  summary_stats <- processed_results$summary %>%
    group_by(function_label) %>%
    summarise(
      avg_median_time = mean(median_time),
      .groups = 'drop'
    ) %>%
    arrange(avg_median_time)
  
  log_info("Average performance ranking (fastest to slowest):")
  for (i in seq_len(nrow(summary_stats))) {
    log_info("{i}. {summary_stats$function_label[i]}: {round(summary_stats$avg_median_time[i], 3)} ms")
  }
}

#' Script main entry point
main <- function() {
  # Parse command line arguments
  args <- parse_arguments()
  
  # Set up logging directory
  log_dir <- Sys.getenv("P_LOGS_DIR", default = "logs")
  log_dir <- ensure_log_dir(log_dir)
  
  # Initialize logging
  setup_logging(log_dir, args$verbose)
  
  log_info("=== Rcpp Performance Benchmark Started ===")
  log_info("Script: {script_name}")
  log_info("Arguments: {paste(deparse(args), collapse = ' ')}")
  
  # Load the package (assuming it's already installed/loaded)
  # In a real package, you might need: library(YourPackageName)
  
  # Run the benchmark
  tryCatch({
    run_benchmark(
      test_type = args$test,
      input_sizes = args$input_sizes,
      sample_size = args$samples,
      log_dir = log_dir,
      verbosity = args$verbose,
      profile = args$profile,
      save_data = args$save
    )
    log_info("=== Benchmark Completed Successfully ===")
  }, error = function(e) {
    log_error("Benchmark failed: {e$message}")
    quit(status = 1)
  })
}

# Execute main function if script is run directly
if (sys.nframe() == 0) {
  main()
}
