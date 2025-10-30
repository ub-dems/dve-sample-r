--- 
title: RcppParallel example implementation
subtitle: RcppParallel A* search VibeCoding implementation
vim: set foldmethod=marker
author: --
date: 2025-10-27
documentclass: book
classoption:
   - a4paper
   - 10pt
output: 
   pdf_document:
      toc: true
      toc_depth: 3
      latex_engine: xelatex
---
# ::{{{ #RCPP: TOC - RcppParallel Contents //
[🠴](Rcpp-HOWTO.md)

# TOC
> RcppParallel A* search VibeCoding implementation - Contents

1. [Q:7.0 - RcppParallel A* search VibeCoding implementation](#Q1)
   - see: [Comprehensive Rcpp Guide for R Packages (Claude)](#a1-claude)
   - see: [Enhanced Prompt For LLM (Vertex)](#a1-vertex)

---------
[[_TOC_]]

# ::}}} \\ %+.

# ::{{{ #RCPP: Q:7.0 - RcppParallel code //

<a id="Q7" name="Q7" class="anchor"></a>


# Q:7.0 - RcppParallel A* search VibeCoding implementation

[⌃](#toc)

## System Hints
<system>

Think Hard.

You are an expert R and C++ developer.

Your task is to prepare example C++ source code to introduce the core features
of the main Rcpp ecosystem packages.

The answer must be in well-formatted, clearly structured (GFM)
markdown, with footnotes for links to relevant online resource
references.

The C++ code fragments must be placed in `cpp` markdown code blocks,
formatted following the Google C++ style guide, and be moderately but
well-documented, following Roxygen2 CRAN standards. Include a minimal
invocation example under 'notrun' tags.

All source files must contain two comment lines at the top (after the "she-bang" line, for scripts) with this template expanded:

if C++,
```cpp
// #:: AI Generated at {{current-date-timestamp}}-- {{ai-engine-model-specification}}
// #:: @Seealso: {{markdown-prompt-doc}}
```
if R, shell-scripts, Makefiles, and configuration files

```R
#:: AI Generated at {{current-date-timestamp}}-- {{ai-engine-model-specification}}
#:: @Seealso: {{markdown-prompt-doc}}
```

where:
- `{{current-date-timestamp}}`: expands to a compact current timestamp with seconds resolution.
- `{{ai-engine-model-specification}}`: expands to a string that identifies the AI engine and model/version used.
- `{{markdown-prompt-doc}}`: the name of a markdown prompt documentation file with a prompt reference.

For this query use:

- `{{markdown-prompt-doc}}` := `notes/howtos/Rcpp-HOWTO-Q7-all.md`


In standard legal comments, assume the following fields for expansion:

- `{{author}}`: "datalab"
- `{{email}}`: "datalab@unimib.it"
- `{{copyright-owner}}`: "University of Milano-Bicocca"
- `{{copyright-year}}`: the current date year

In the implementation, prefer shorter names for local variables but
use clear, descriptive names for function names and arguments.

In C++ local variable declarations, use `auto` for type inference where
appropriate.

In complex template declarations, introduce `using` aliases (or `typedef`) to
simplify the code.

Tend to prefer idiomatic C++/R code, unless performance considerations
advise better alternatives.

Terse, readable code is a primary goal for the generated output.

Prefer richer data type structures to overly complex code.

The C++ reference standard is C++17.

The replies must adhere to CRAN guidelines, integrated with `tidyverse`
best practices.

The response should discuss performance details in depth, providing an overall
assessment of every implementation alternative regarding expected runtime
performance on a multicore (32 Hyper-Threaded Intel Xeon or AMD EPYC)
Ubuntu 24.04 Linux virtual machine, running on the Microsoft Azure
platform.

As a stylistic note, also discuss every alternative from an idiomatic and
pragmatic point of view.

</system>


Your task is to produce an interesting use-case example for the
`RcppParallel` package, focusing on the `parallelFor` and `parallelReduce`
functions.

The use case is a minimal toy implementation of an A*
heuristic search algorithm, applied to a randomly generated undirected graph.

The parallel code should be paired with a traditional sequential implementation.

All C++ interface functions must be callable from R.


## Task Overview

Your task is to produce a tutorial example within an existing R
package project that illustrates parallel computation in both C++ (via `Rcpp`)
and R, using facilities provided by `RcppParallel` (C++) and
`parallel` (R).

The tutorial example is a demo program that provides both sequential
and parallel C++ implementations of an A* pathfinding
algorithm.


The search functions will receive, for a graph with N vertices:
- a graph representation as a symmetric N x N adjacency matrix containing edge weights.
- a bi-dimensional N x 2 matrix with the (x,y) position of the vertices.
- the ID (index) of the "start" vertex at the beginning of the target path.
- the ID (index) of the "goal" vertex at the end of the target path.

The return value of the search is a vector that lists all the vertex
IDs (indexes) of the "best" path. The "best" path is the one with the
minimal cost, i.e., the sum of edge weights that link the path's vertices.
In case of a search failure—caused by the "start" and "goal" vertices
belonging to disconnected parts of the graph or if the start and goal are the same—a zero-length vector is
returned.[^8]

The nodes of the graph are linked by edges with a weight representing
the "cost" of traversal. The nodes also have a pair of
(planar) spatial coordinates (x,y) that can be used to introduce an
admissible heuristic, assuming the following condition is met:

* `distance(i,j) <= weight(i,j)`

where the following conditions are also valid:

* `distance(i,j) == distance(j,i)` (symmetry for an undirected graph)
* `weight(i,j) == weight(j,i)`   (symmetry for an undirected graph)
* `distance(i,j) := sqrt( (v[i].x - v[j].x)^2 + (v[i].y - v[j].y)^2 )` (Euclidean vertex distance)


In addition, an R script is to be provided to generate random graph samples
inspired by geographical route networks, which can be searched for the "best" path
between a random pair of vertices.

The script supports the generation of different types of random graphs,
depending on command-line arguments.

IMPORTANT: In any graph type variant, the undirected structure of the
graph must be ensured; i.e., the symmetry of the adjacency matrix of edge
weights must be preserved.

The path search can be invoked once directly on the sequential and
parallel C++ search functions or, alternatively, repeated several
times in a benchmark to compare the performance of both implementation
strategies.

After performing the path search, the script, conditional on the
execution mode, generates a plot (as a PDF output file) of the graph,
with the solution path highlighted.

If additional stats are required, detailed benchmark results, graph
statistics, and a full data dump are produced as separate output files.

## Project Environment

The target package, called `dvesimpler`, is based on `renv` and
already includes the following dependencies:

 - `Imports` dependencies:
  - `Rcpp`
  - `RcppArmadillo`
  - `igraph`
  - `tidygraph`
  - `ggraph`
  - `tidyverse`
  - `ggplot2`
  - `argparse`
  - `logger`
  - `yaml`
  - `parallelly`
  - `doParallel`
  - `foreach`
 - `Suggests` dependencies:
  - `devtools`
  - `knitr`
  - `microbenchmark`
  - `usethis`
  - `roxygen2`
  - `rmarkdown`
  - `testthat`
 - `LinkingTo` dependencies:
  - `Rcpp`
  - `RcppArmadillo`
  - `RcppParallel`

## Implementation Details

As an implementation detail, your task is to produce two source files to be
included in a CRAN-compliant R package project:

- a C++ source: `./exec/dummySearch/dummy_finder.cpp`
- an R script:  `./exec/dummySearch/dummy-rcpp-finder.r`

with the following specifications.

## C++ "A* pathfinding" implementation: `dummy_finder.cpp`

The C++ source file `./exec/dummySearch/dummy_finder.cpp` provides an
implementation example of sequential and parallel approaches
to the A* pathfinding algorithm.

This source will contain two groups of C++ functions, "seq" and
"par", with the specifications below, delimited by XML
`*-finder-specification` tags. These can be tested to verify how
different implementation alternatives affect runtime performance,
depending on the input size.

Both specifications inherit a shared set of specifications, delimited
by the XML tag `common-finder-specification`.

### "common" function specification

<common-finder-specification>

- Use the C++ STL and `Rcpp`/`RcppArmadillo` data types.
- Use similar data structures for graph representation in both implementations.
- For both implementations (seq/par), provide a pair of functions:
 - An R-callable C++ function `*_astar_finder` that receives:[^5]
  - `Rcpp::NumericMatrix adjacency_matrix`: A square matrix with symmetric edge weights.
  - `Rcpp::NumericMatrix positions`: A two-column matrix with (x,y) vertex coordinates for heuristic evaluation.
  - `int start`: The ID of the start vertex.
  - `int goal`: The ID of the goal vertex.
  - This function unboxes and converts the input arguments to
   `arma::mat` equivalents and dispatches the call to the
   corresponding `*_finder_impl` function.
  - The return value is an `Rcpp::IntegerVector` containing the IDs of the vertices on the path from the start vertex to the goal vertex.
  - If no path is found (e.g., because the vertices are disconnected), a zero-size vector is returned.
- The internal (not R-callable) functions `*_finder_impl` perform the A* search:
 - Their arguments are:
  - `const arma::mat& adjacency_matrix`: The input undirected graph as an adjacency matrix.
  - `const arma::mat& positions`: The (x,y) planar coordinates for each node.
  - `int start`: The starting node ID.
  - `int goal`: The target (goal) node ID.
 - Their return value is:
  - `std::vector<int> path`: The "best" path (minimal sum of edge weights) connecting the start and goal nodes.
- To manage the A* open set, use a `std::priority_queue` for efficient retrieval of the node with the lowest f-score.[^10]
- All public functions of this module must start with the name prefix `dmy_astar_`.
- Common utility functions must be placed in an anonymous namespace.
- A common function `euclidean_heuristic` is used to compute the planar
 distance between vertices and can be used to compute an admissible
 heuristic for search optimization.

</common-finder-specification>



### "seq" function group specification

<seq-finder-specification>

The "seq" group of functions provides a "sequential" (single-CPU core)
implementation of the A* pathfinding algorithm.

- Prefer a "simple" implementation to clarify the algorithm's behavior.

The main functions are:
- `dmy_astar_seq_finder`, R-callable.
- `dmy_astar_seq_finder_impl`, internal, with `arma::mat` types.

</seq-finder-specification>[^3]


### "par" function group specification

<par-finder-specification>

The "par" group of functions provides a "parallel" (single machine,
multiple CPU cores) implementation of the A* pathfinding algorithm.

- For parallelism, use facilities provided by `RcppParallel`.
- Specifically, consider using `parallelFor` for the parallel exploration of a node's neighbors and
 `parallelReduce` to find the best node to explore next from the open set.
- Provide synchronization (e.g., mutexes, critical sections) to avoid
 concurrency issues when accessing shared data structures like the open and closed sets.
- Comment the code to highlight concurrency-related attention points.

The main functions are:
- `dmy_astar_par_finder`, R-callable.
- `dmy_astar_par_finder_impl`, internal, with `arma::mat` types.

</par-finder-specification>[^3]



## R script for "A* pathfinding" testing: `dummy-rcpp-finder.r`

### R Test Script Overview

The R test script `./exec/dummySearch/dummy-rcpp-finder.r` is used to
drive the search algorithm and verify the performance advantage of the
parallel version. This script should accept several command-line
arguments, which are not mandatory and have sensible defaults, as described below.
The script specification is placed below, delimited by the XML
`test-script-specification` tags.


### R Test Script Specification

<test-script-specification>

- The script is composed of 4 parts, performed in sequence:

#### 1. Housekeeping Phase

- Command-line arguments are parsed as described below, delimited by the XML `test-script-arguments-specification` tag.
- The logging facility is initialized as described below, delimited by the XML `test-script-logging-specification` tag.
- The R runtime environment is configured with C++ source linking, as described below, delimited by the XML `test-script-runtime-specification` tag.


#### 2. Preparation Phase

- A random graph is generated and embedded in a wider object of S3 class `space_graph_test`, as described below, delimited by the XML `sample-graph-specification` tag.
- After generation, a set of graph summary statistics is computed, attached to the working `space_graph_test` object, and logged at the `info` level.


#### 3. Search Execution Phase

- The search functions (`dmy_astar_seq_finder`, `dmy_astar_par_finder`) are called with different execution modes as described below, delimited by the XML `test-script-execution-modes-specification` tag.
- The resulting path is applied to the internal `igraph` model as vertex and edge attributes.


#### 4. Reporting Phase

- If required by the `show_plot` option, a PDF plot of the graph is produced, as specified below, delimited by the XML `graph-plot-script-specification` tag.
- If required by the `save_data` option, a set of outputs is produced, as specified below, delimited by the XML `save-data-script-specification` tag.

</test-script-specification>


### Script Command Line Arguments

<test-script-arguments-specification>
- Argument parsing must use a standard argument parser, provided by the `argparse` package.
- The parsed command-line arguments must be logged at the info level during script initialization.
- The list of command-line arguments, with their types, defaults, and enumeration constants, are described below, delimited by the XML `test-script-cli-arguments` tag.
</test-script-arguments-specification>

<test-script-cli-arguments>
#### Generic arguments

- `help`:   (option: -h|--help, type: boolean, default:`false`) - Prints script usage info and command-line argument descriptions. Execution is skipped.
- `verbose`:  (option: -v|--verbose, mode: count, type: integer, default:`0`) - "Verbose", can be repeated (`-v`, `-vv`), to set the logging level (`0`:info, `1`:debug).
- `rnd_seed`: (option: -u|--seed, type: integer, default:`0`) - "Random Seed", for deterministic random sequence initialization.

#### Sample graph arguments

- `graph_type`  (option: -g|--graph-type, type: string, enum: {`grg`,`rad`,`geo`,`route`}, default:`route`) - "Graph Type", specifies sample graph construction, detailed below in "Sample Graph Generation".
- `graph_radius` (option: -r|--graph-radius, type: double, default:`0.1`) - Vertex distance for edge generation, as in the `igraph::sample_grg` "radius" argument.
- `graph_fill`  (option: -q|--graph-fill, type: double, default:`1.0`) - In-radius edge probability, used to prune edges in initial graph post-processing.
- `cong_rate`  (option: -c|--congestion-rate, type: double, default:`0.5`) - "Congestion Rate", the mean of the exponential distribution for random edge congestion generation.
- `cong_coeff`  (option: -k|--congestion-coeff, type: double, default:`1.0`) - "Congestion Coefficient", a multiplier for the congestion effect on edge weight.
- `graph_size`  (positional, type: integer, default:`100`) - "Graph Size", specifies the number of vertices in the sample graph.[^6]

#### Execution modes

- `exec_mode` (option: -x|--exec, type: string, enum: {`nil`,`seq`,`par`,`all`,`bench`}, default:`par`) - "Execution Mode", detailed below in "Script Execution Modes".

#### Benchmark arguments

- `sample_size` (option: -m|--samples, type: integer, default:`0`) - "Sample Size", the `microbenchmark` sample size (e.g., number of iterations).

#### Graph plot arguments

- `show_plot`  (option: -p|--plot, type: boolean, default:`false`) - "Show Plot", enables the generation of a plot of the sample graph with the solution path.
- `image_size`  (option: -z|--image-size, type: string, enum: {`A2`,`A3`,`A4`,`A5`,`A6`}, default:`A4`) - "Image Size", specifies the graph plot resolution for PDF export, in ISO-216 A scale.
- `image_orient` (option: -o|--image-orient, type: string, enum: {`P`,`L`}, default:`L`) - "Image Orientation", for PDF export (`P`: Portrait, `L`: Landscape).

#### Save output data arguments

- `save_data`:  (option: -s|--save, type: boolean, default:`false`) - "Save Data", enables report production for result data and sample graph statistics.
- `export_raw`: (option: -f|--export-graph, type: boolean, default:`false`) - "Export Graph", enables dataframe export of the sample graph's internal `igraph` model in TSV format.

</test-script-cli-arguments>

### Script Logging Specification

<test-script-logging-specification>
- Script output should go to stdout and be logged to a file using standard `logger` facilities.
- The log directory will also be used for storing benchmark results and plots.
- The log directory path will be taken from the environment variable `P_LOGS_DIR`, with `logs` as the default.
- The log directory should be created if it does not exist.
- The log filename should have the prefix "<script-name>-<sec-timestamp>" with a '.log' extension.
- The "<sec-timestamp>" part is composed of the script's start time, formatted as localtime in "YYYYMMDD-hhmmss" format.
- The script's preparation and execution phases should be logged at the info level (arguments, benchmark invocation, final summary), while the final report section should be logged at the "debug" level (verbose>=1).
- All log artifacts should contain the test type and a localtime timestamp suffix as part of the filename.
- During script initialization, log: 1. the script arguments, 2. the full path of the log directory, and 3. the output of the system command: `inxi -C`.
</test-script-logging-specification>


### Script Runtime Specification

<test-script-runtime-specification>
- During runtime setup, the random number generator will be initialized deterministically:
  - If the `rnd_seed` argument is not specified (i.e., is equal to `0`), it will be generated as a random integer via `as.integer(runif(1)*2e9)`.
  - The random number generator is then initialized with this "seed" value.
  - The effective "seed" value will be logged.
- The C++ code in `dummy_finder.cpp` is linked via an `Rcpp::sourceCpp` invocation.
- The path name resolution rules for the C++ source file are as follows:[^9]
 - A `dummy_finder.cpp` file in the same directory as the `dummy-rcpp-finder.r` script, if this path can be determined.
 - A `dummy_finder.cpp` file in the current working directory.
 - A `dummy_finder.cpp` file in the `./exec/dummySearch` directory, if the script is run from the project root.
</test-script-runtime-specification>



### Sample Graph Generation

<sample-graph-specification>

- *Important*: All graphs considered are "undirected graphs";
 i.e., every transformation must preserve symmetry in the "adjacency matrix" of edge weights.
- For C++ calls, the graph will be represented by an S3 class `space_graph_query` with these attributes:
 - `positions`: A two-column `NumericMatrix` with (x,y) vertex coordinates for heuristic evaluation.
 - `adjacency`: A square `NumericMatrix` with symmetric weights.
 - `query`: A named list with the indexes of the `start` and `goal` vertices.
- In the R script, the internal graph representation will use the `igraph::graph` type.
- In the R script, the sample generation function `create_sample_graph` will embed the internal graph object
 into a wider object of S3 class `space_graph_test` with these attributes:
 - `type`: The graph type, corresponding to the constructor function selected by the `graph_type` argument.
 - `graph`: The sample graph in `igraph` representation.
 - `query`: A named list with a random pair `<start,goal>` of vertex IDs (indexes) to connect with an optimal path.
 - `path`: The solution from the (`par` if in `all` execution mode) execution as a `NumericVector` of vertex IDs, initialized as a
  zero-length vector and replaced by the search result.
 - `stats`: A named list of graph statistics computed after graph generation.
- A script function `as.space_graph_query.space_graph_test` converts between `space_graph_test` and `space_graph_query` models.
- A script function `create_sample_graph` forwards internal `igraph` creation to the `create_graph_model` function.
 The `igraph` result is then wrapped in a `space_graph_test` object by calling the `create_space_graph` function.
- The `create_space_graph` function takes the random `igraph` generated by `create_graph_model`, randomly selects a pair of vertices for the `query`
 attribute (a named list of `start` and `goal` vertex indexes), and sets the `stats` attribute as returned by the `create_graph_stats` function.
- The script function `create_graph_stats` takes the sample `igraph` model and returns a named list of summary statistics:
  - `vertex_size`: Number of vertices.
  - `edge_size`: Number of edges.
  - `edge_density`: Value of `igraph::edge_density` (Graph density).
  - `knn`: Value of `igraph::knn` (Average nearest neighbor degree).
- A script function `create_graph_model` will dispatch graph creation to a typed version based on the `graph_type` command-line argument.
- An utility function `setup_edge` provides a way to initialize edge attributes with default values.
 This function takes the graph, an even-sized collection of vertex pairs to connect (symmetrically), and a `congestion` value (defaulting to `0.0`).
 For every pair of `<i,j>` vertex indexes, it will:
 - Create, if missing, the symmetric, undirected edge between vertex `i` and vertex `j`.
 - Assign the `distance` attribute to the Euclidean distance between the (x,y) spatial coordinates of both vertices.
 - Assign the `congestion` attribute to the corresponding argument.
 - Compute the edge `weight` via the function `calc_edge_weight`, which takes `distance`, `congestion`, and the `cong_coeff` argument.
 - The function `calc_edge_weight(distance, congestion, cong_coeff)` returns the edge `weight` using this expression:
   * `weight := distance * (1 + cong_coeff * congestion)`
- For the `grg` graph type:
 - The function `create_grg_graph_model` will return an `igraph::sample_grg` object, created with `graph_size` vertices and the `graph_radius` parameter.
 - In the graph creation, with `coord=TRUE`, the resulting vertices will get a pair of `x` and `y` coordinate attributes, chosen uniformly at random in the [0..1]x[0..1] rectangle.
 - The `distance` edge attributes are to be assigned the same value as the `weight`, which is the Euclidean distance between vertex `(x,y)` coordinates.
 - Another edge attribute, `congestion`, will be added with a default constant value of `0.0`.
- For the `rad` graph type:
 - The function `create_rad_graph_model` will return a graph transformed by modifying the one created by `create_grg_graph_model`.
 - The transformation randomly removes edges from the original graph with probability `(1 - graph_fill)`, preserving symmetry: `edge(i,j)` is removed iff `edge(j,i)` is removed.
- For the `geo` graph type:
 - The function `create_geo_graph_model` will return a graph transformed by modifying the one created by `create_rad_graph_model`.
 - This graph type has the property that it contains no disconnected subsets.
 - By analyzing the `igraph::components()` collection, start with a disconnected component and find a vertex in the graph's complement with the minimal Euclidean distance to some vertex in the selected component.
  For this pair of indexes, `i_int_min` and `j_ext_min`, a new symmetric, undirected edge will be added, with attributes filled by the `setup_edge` function.
 - The previous step is repeated until the graph is fully connected.
- For the `route` graph type:
 - The function `create_route_graph_model` will return a graph transformed by modifying the one created by `create_geo_graph_model`.
 - For every edge, a `congestion` value will be sampled from a random exponential distribution with mean `cong_rate`.
 - For every edge, the edge `weight` will be recalculated by the `setup_edge` utility function, using the new `congestion` value and the existing `distance` edge attribute.
 - The rationale here is that `congestion` models "traffic intensity," which causes delays proportional to distance in a "fastest" path search where `distance` is the heuristic.
</sample-graph-specification>



### Script Execution Modes

<test-script-execution-modes-specification>

- The script function `run_path_search` will take a `space_graph_test` object as input and return the same object, modified by the `apply_result_path` function.
- The `run_path_search` function will dispatch the search to a `run_path_search_{nil|all|par|seq|bench}` function based on the `exec_mode` command-line argument.
- The `run_path_search` function will convert the `space_graph_test` object to `space_graph_query` via `as.space_graph_query.space_graph_test` to pass as a parameter to the dispatched functions.
- The `run_path_search` function returns the modified `space_graph_test` object returned by `apply_result_path`, which will receive the resulting search path and the execution elapsed time.
- The script supports different execution modes: `nil`, `all`, `par`, `seq`, `bench`, as specified by the `exec_mode` command-line argument.
 - `nil` mode: This mode does not execute the C++ search functions but returns an empty path. It is useful for testing sample graph generation.
 - `all` mode: This mode executes both `par` and `seq` modes in parallel (with the `foreach` package), waiting for both tasks to terminate.
 - `par` mode: This mode executes the parallel search `dmy_astar_par_finder` once on the random graph and a random `<start,goal>` vertex pair.
 - `seq` mode: This mode executes the sequential search `dmy_astar_seq_finder` once on the random graph and a random `<start,goal>` vertex pair.
 - `bench` mode: This mode executes a benchmark of both (`par` and `seq`) versions using the standard `microbenchmark` facility. The `sample_size` argument provides the number of iterations.
- For `par` and `seq` execution modes, log messages before and after execution will report the solution path length (or failure), elapsed time, and both numbers divided by the graph size.
- For `bench` execution mode, the summary of the benchmark results will be logged. In this case, an empty path is returned.
- For `all` mode, both solutions will be compared, and any differences will be reported at the warning log level. Only the `par` solution will be returned as the result.
- The script function `apply_result_path` receives the `space_graph_test` S3 object and the resulting search path as a list of vertex indexes.
- The `apply_result_path` function returns the same `space_graph_test` S3 object with the path stored in the `path` attribute and with a modified `igraph` model containing these additional attributes:
 - Path vertex attributes:
  - `in_path`: An integer value assigned as follows:
    - `V(g)[i]$in_path <- 0`: "out-of-path", if vertex `i` is not in the path.
    - `V(g)[i]$in_path <- 1`: "inner node", if vertex `i` is an internal vertex in the path.
    - `V(g)[i]$in_path <- 2`: "goal node", if vertex `i` is the "goal" vertex.
    - `V(g)[i]$in_path <- 3`: "start node", if vertex `i` is the "start" vertex.
 - Path edge attributes:
  - Assume a function `ee` is available for edge retrieval given a pair of vertex indexes: `ee(g)[i,j] := E(g)[get.edge.ids(g,c(i,j))]`, applied to undirected graphs (`ee(g)[i,j] == ee(g)[j,i]`).
  - `in_path`: An integer value assigned as follows:
    - `ee(g)[i,j]$in_path <- 0`: "out-of-path", if the edge is not part of the solution path.
    - `ee(g)[i,j]$in_path <- 1`: "in-path", if the edge is part of the solution path.
  - `path_pos`: An integer value assigned as follows:
    - `ee(g)[i,j]$path_pos <- k`: "in-path position", `min(k)` such that `(path[k], path[k+1])` corresponds to the edge.
    - `ee(g)[i,j]$path_pos <- -1`: "out-of-path marker", if the edge is not in the path.
  - `traffic`: A numeric value computed for every edge based on its `congestion` attribute (`traffic` is mean-normalized congestion, capped at the third quartile):
    - `traffic <- 0.0`: If the `graph_type` argument is not `route`.
    - `traffic <- min(congestion, log(4)*cong_rate) - cong_rate`: If the `graph_type` argument is `route`.
- The `apply_result_path` function will also add `path` statistics to the `stats` attribute:
 - `elapsed_time`: Execution time for the search method.
 - `path_length`: Length of the path.
 - `path_cost`: Sum of edge weights for all edges in the path.
 - `degree_sum`: Sum of `igraph::degree` for all vertices in the path.
 - `degree_avg`: Average of `igraph::degree` for all vertices in the path (or `NA` if the path is empty).
 - `path_complexity`: The product `path_length * degree_avg`.
 - `path_l_rate`: The value of `elapsed_time / path_length` (or `NA` if the path is empty).
 - `path_c_rate`: The value of `elapsed_time / path_complexity` (or `NA` if the path is empty).
- The `apply_result_path` function, after evaluation, will log all `stats` summaries at the info level.

</test-script-execution-modes-specification>




### Graph Plot Specification

<graph-plot-script-specification>

- In the script's "Reporting Phase," after execution, a plot of the graph will be generated and exported as a PDF file.
- Plot generation is enabled only if the `show_plot` command-line option is specified.
- The exported PDF output should go to the logging directory, with the same file name prefix rules as described in the `test-script-logging-specification` XML tag.
- The exported PDF output filename should have the suffix `-plot.pdf`.
- The plot is generated by the function `plot_sample_graph`, which receives the `space_graph_test` object returned by the `run_path_search` function.
- The image size and orientation for the PDF plot export use `image_size` (e.g., `A4`) and `image_orient` (`P`: Portrait, `L`: Landscape).
- The plot uses `ggraph` facilities to generate a plot from the internal `igraph` representation (`graph` attribute of the input object).
- Specifically, the graph rendering must consider the following requirements:
 - The graph is undirected.
 - Title:
  - Composed as a two-line interpolated label:
   - First line: `"graph: ${graph_type}(${graph_size}, rad=${graph_radius}, fill=${graph_fill}, cong=${cong_rate})"`
   - Second line: `"mode: ${exec_mode} time:${stats$elapsed_time} - path: len=${stats$path_length}, cost=${stats$path_cost}, deg=${stats$degree_avg}"`[^7]
 - Layers:
  - The image background must be a neutral solid color, chosen to contrast sufficiently with vertex and edge colors.
 - Legend:
  - Include a color scale for the `traffic` edge color mapping.
 - Layout:
  - The vertices were generated by `igraph::sample_grg` (with `coord=TRUE`), so they already have `x` and `y` spatial coordinates stored as vertex attributes.
 - Vertex rendering:
  - Vertices are rendered as small, filled circles with no labels.
  - Vertex size depends on the `in_path` attribute value.
  - Vertex fill color (solid, bright) depends on the `in_path` attribute value.
  - Vertex border color is `black`.
 - Edge rendering:
  - Edges are rendered as solid lines.
  - Edge line width depends on the `in_path` attribute value.
  - Edge color uses the `traffic` numeric attribute, mapped to a three-color gradient (`green`, `gray`, `red`) with these reference values:
   - `c(-cong_rate, 0.0, log(4)*cong_rate)`
   - As a `ggraph` example, consider:

```r
  p <- ggraph::plot(g, ...) +
     ...
     geom_edge_link(aes(colour = traffic, width = in_path)) +
     scale_edge_width_discrete(range = c(2, 6)) +
     scale_edge_color_gradientn(colours = c("green4", "gray90", "red3"), values=c(-cong_rate, 0.0, log(4)*cong_rate)) +
     ...
```

</graph-plot-script-specification>

### Script Output Generation

<save-data-script-specification>

- In the script's "Reporting Phase," after execution, a set of report files will be generated, depending on command-line arguments.
- Export generation is enabled only if the `save_data` command-line option is specified.
- The exported output files should go to the logging directory, with the same file name prefix rules as described in the `test-script-logging-specification` XML tag.
- The exported data is generated by the function `save_sample_data`, which receives the `space_graph_test` object returned by `run_path_search`.
- The `save_sample_data` function will dispatch output generation to several specific functions: `save_sample_info`, `save_bench_report`, and `save_graph_data`.
- The `save_sample_info` function generates a summary information file in YAML format.
- The summary information file from `save_sample_info` should have the suffix `info.yaml`.
- The `save_sample_info` summary file must report, in a well-organized hierarchical way:
  - All script arguments.
  - The effective "seed" value.
  - The script's start timestamp and the output file prefix for the log directory.
  - All graph statistics, retrieved from the `space_graph_test` input object.
  - All path statistics, retrieved from the `space_graph_test` input object.
- All output filenames should start with the prefix: "<script-name>-<sec-timestamp>-<exec-mode>-" followed by a variable suffix.
- The "<sec-timestamp>" part is composed of the script's start time, formatted as localtime in "YYYYMMDD-hhmmss" format.
- The `save_bench_report` function generates a pair of output files with microbenchmark performance data.
- The `save_bench_report` function is enabled only if `exec_mode` is `bench`.
- The outputs of `save_bench_report` are:
  - A benchmark summary report (suffix: `bench.txt`).
  - A dataframe export in tab-separated format (TSV) (suffix: `perf.tsv`) with microbenchmark data and these additional columns:
   - `graph_type`
   - `timestamp`
   - `function_name`
   - `graph_size`
   - `graph_radius`
   - `graph_fill`
   - `path_length`
   - `path_cost`
- The `save_graph_data` function generates a full export of graph data with attributes as a pair of dataframes.
- The `save_graph_data` function is enabled only if `export_raw` is enabled.
- The outputs of `save_graph_data` are:
  - A dataframe export in tab-separated format (TSV) (suffix: `nodes.tsv`) of all `igraph` model vertex data with attributes.
  - A dataframe export in tab-separated format (TSV) (suffix: `edges.tsv`) of all `igraph` model edge data with attributes.

</save-data-script-specification>




------------------------------------------------------------------------
## Response Template

### Response Breakdown

Here's a breakdown of what you need to deliver:

1. **Markdown Structure:**
  *  Use clear headings and subheadings to organize the content.
  *  Include a task summary.
  *  Provide a brief reference to key library functions.
  *  Include footnotes for references to online resources (e.g., documentation for packages, A* algorithm explanation).

2. **Generated Source for Solution Implementation:**
  *  C++ search source: `./exec/dummySearch/dummy_finder.cpp`
  *  R script source: `./exec/dummySearch/dummy_rcpp_finder.r`
  *  Follow template examples for code generation.
  *  In code templates, comments with Python-style pseudocode and typed function signatures can be used to describe the source structure.

### Response Template

Example Markdown Structure:

```markdown
# Parallel A* Search Algorithm

## Introduction

[Provide a brief overview of this task]

## Brief Function Reference

[Provide a brief description of the following functions:]
[ Rcpp::sourceCpp ]
[ RcppParallel::parallelFor ]
[ RcppParallel::parallelReduce ]
[ foreach ]
[ doParallel ]
[ parallelly::makeClusterPSOCK ]
[ igraph::sample_grg ]
[ igraph::components ]

## C++ Search Implementation: `dummy_finder.cpp`

### C++ Source: `./exec/dummySearch/dummy_finder.cpp`

\`\`\`cpp

// [AI Generated template comment]
// ["see also" note to the prompt markdown file]
// ["see also" note to the R script]
// [Standard Copyright and Legal notice for GPL code]

[C++ includes]

// =======================================

[common typedefs]

// =======================================

// Anonymous namespace for utility functions
namespace {

[utility functions]

} // namespace

// =======================================

// Common algorithm functions
[heuristic computation]

// =======================================

// Sequential algorithm functions

// Sequential A* implementation
std::vector<int> dmy_astar_seq_finder_impl(const arma::mat& adjacency_matrix,
                   const arma::mat& positions,
                   int start, int goal) {
 // [main sequential A* pathfinding search function]
}

// --------------------------------------

// [Roxygen2 complete documentation with simple example]
// [[Rcpp::export]]
Rcpp::IntegerVector dmy_astar_seq_finder(Rcpp::NumericMatrix adjacency_matrix,
                   Rcpp::NumericMatrix positions,
                   int start, int goal) {
 // [type conversion to RcppArmadillo types around internal implementation call]
}

// =======================================

// Parallel algorithm functions

// Parallel A* implementation
std::vector<int> dmy_astar_par_finder_impl(const arma::mat& adjacency_matrix,
                   const arma::mat& positions,
                   int start, int goal) {
 // [main parallel A* pathfinding search function]
}

// --------------------------------------

// [Roxygen2 complete documentation with simple example]
// [[Rcpp::export]]
Rcpp::IntegerVector dmy_astar_par_finder(Rcpp::NumericMatrix adjacency_matrix,
                   Rcpp::NumericMatrix positions,
                   int start, int goal) {
 // [type conversion to RcppArmadillo types around internal implementation call]
}

\`\`\`


## R Search Test Script: `dummy_rcpp_finder.r`

### R Source: `./exec/dummySearch/dummy_rcpp_finder.r`

\`\`\`R
#!/usr/bin/env Rscript
# [AI Generated template comment]
# ["see also" note to the prompt markdown file]
# ["see also" note to C++ source]
# [Brief Script description]

# Load required libraries
suppressPackageStartupMessages({
 [library() silent dependency loading]
})


[ usage documentation string for '--help' option ]

# Globals declarations
[global variables initialization]


# Housekeeping Phase
[argument parsing functions]
[logging facility control]
[Rcpp C++ source linking functions]
[runtime environment setup]


# Preparation Phase
[graph generation functions]


# Search Execution Phase

[function definition: apply_result_path ]
[function definition: run_path_search ]

# Reporting Phase

[function definition: plot_sample_graph ]
[function definition: save_sample_data ]
[function definition: save_sample_info ]
[function definition: save_bench_report ]
[function definition: save_graph_data ]

# Script Main Entry

[function definition: main ]

# Execute main function if script is run directly
if (sys.nframe() == 0) {
 main()
}

\`\`\`



## References

[^1]: [RcppParallel Documentation](https://cran.r-project.org/package=RcppParallel)
[^2]: [A* Search Algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm)
[^3]: [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
```

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:1 (Vertex)
> Enhanced Prompt For LLM

## Prompt Enhancement Query

<system> 

You are an experienced R programmer with extensive knowledge of using
Rcpp C++ sources in R packages. Your task is to enhnce a prompt
oriented to generate an implemenation of an algorithm described in a
detailed way.

</system>

Provide an enhanced VibeCoding prompt, to be submitted to "Claude" and "Gemini" LLMs,
in order to generate a correct implementation of the algorithm described.

In enhancement consider the following criteria:

1. Correct English language errors, reformulating requirements in a
clearer and more fluent form, if needed.

2. Preserve, as possible, semantic annotations in original markdown
structure and XML annotation tags.

3. Analyse logical requirements and provide, at end, a list of
   possible integration for under specified specifications.

4. Put in evidence consistences, contradictions in specifications.

5. Reference your comments as footnote annotations in the original prompt.

6. Delimit with 5 `---` horizontal lines the enhanced prompt from
additional comments, but do not escape the proposed prompt as
```markdown ``` code block.

The prompt to enhance follows, delimited with 5 `---` horizontal lines.

--------------------------------------------------------------------------

## Prompt Enhancement Footnotes and Comments

[1]: **(Language and Clarity)**: Minor grammatical errors, typos
    (e.g., "geogrphical", "implemenation", "bolow"), and awkward
    phrasing have been corrected throughout the document to improve
    fluency and clarity. Requirements were reformulated for
    conciseness without altering their meaning.

[2]: **(Contradiction)**: The original prompt was contradictory. The
    `<common-finder-specification>` stated that the `adjacency` matrix
    weights were "computed by euclidean distances," while the
    `<sample-graph-specification>` for the `route` graph type defined
    weights as a function of both distance and a random `congestion`
    factor. The prompt has been corrected to specify that the C++
    function simply receives a symmetric weight matrix, making it
    agnostic to how the weights were calculated in R. The Euclidean
    distance is now exclusively referenced for the heuristic
    calculation.

[3]: **(Consistency)**: The original XML-like closing tags for the
    "seq" and "par" specifications were both
    `<sum-test-specification>`. These have been corrected to
    `</seq-finder-specification>` and `</par-finder-specification>`
    respectively to ensure logical consistency.

[4]: **(Under-specified Logic)**: The prompt's suggestion to use
    `parallelFor` for "node exploration" and `parallelReduce` for
    "best node selection" is a high-level concept. Parallelizing the
    A* algorithm is non-trivial because its best-first search strategy
    is inherently sequential. A naive parallelization can lead to
    significant redundant work, negating performance gains. The
    enhanced prompt adds a more concrete suggestion: use `parallelFor`
    to expand the neighbors of the *current best node* and
    `parallelReduce` to efficiently find the node with the minimum
    f-score in the open set in each step. This guidance also
    highlights the critical need for proper synchronization (e.g.,
    mutexes) when accessing shared data structures, a key challenge in
    this parallelization strategy.

[5]: **(Inconsistency)**: The `<common-finder-specification>`
    described the R-callable C++ function as receiving a named list,
    but the `Response Template` showed a function signature with
    separate `NumericMatrix` arguments. The prompt has been updated to
    consistently specify separate matrix arguments
    (`Rcpp::NumericMatrix adjacency_matrix`, `Rcpp::NumericMatrix
    positions`), which is more idiomatic and efficient for `Rcpp`
    function calls as it avoids manual list element extraction in C++.

[6]: **(Under-specified Logic)**: The original description for the
    `graph_size` argument was "positional, for many values". Standard
    R argument parsers like `argparse` do not typically handle
    multiple positional arguments in this way. The specification has
    been simplified to a single positional integer argument, which is
    more conventional and easier to implement.

[7]: **(Consistency)**: A typo in the plot title specification,
    `stats$elapsd_time`, has been corrected to `stats$elapsed_time` to
    align with the definition in the `apply_result_path` statistics
    section.

[8]: **(Under-specified Logic)**: The original prompt mentioned
    search failure for disconnected graphs. The logic has been
    clarified to also include the trivial case where the start and
    goal nodes are identical, for which returning an empty path is
    also a sensible outcome.

[9]: **(Integration Concern)**: The specified file path resolution
    logic for `Rcpp::sourceCpp` is brittle. It depends on the current
    working directory and may fail, especially when run in different
    environments like RStudio vs. a command-line script. A more robust
    approach for a real package would be to place the C++ file in the
    `/src` directory and let the standard R package build process
    handle the compilation and linking. While the prompt's
    specification is preserved, this is a noteworthy integration point
    for a production-level implementation.

[10]: **(Under-specified Logic)**: The original prompt did not
    specify a data structure for managing the "open set" (the set of
    discovered nodes yet to be evaluated) in the A*
    implementation. This is a critical component for the algorithm's
    efficiency. The prompt has been enhanced to explicitly recommend
    using a `std::priority_queue`, which is the standard and most
    efficient C++ STL container for this purpose.


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:1 (Claude)
> Comprehensive Rcpp Guide for R Packages



# ::}}} \\ %5.1.

<!--  LocalWords:  STL pathfinding namespace mutex undirected geo lin
<!--  LocalWords:  RcppParallel Howto VibeCoding sqr sqrt datalab TSV
<!--  LocalWords:  Bicocca enum coeff RStudio dataframe HPC foreach
<!--  LocalWords:  doParallel parallelly quartile microbenchmark YAML
<!--  LocalWords:  dataframes pseudocode
 -->
 -->
 -->
 -->
 -->
