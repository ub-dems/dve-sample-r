``` /// vim: set foldmethod=marker : ```
# ::{{{ #ANY: ... //
# Q:3 - ...



-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# M:3 (Vertex)
> ...


<system>

You are an expert R and C++ developer.

Your task is to prepare example C++ sources to introduce core features
of main Rcpp ecosystem packages.

The answer must be in well-formatted, clearly structured (GFM)
markdown, with footnotes for links to relevant online resource
references.

The C++ code fragments must be placed in `cpp` markdown codeblocks,
formatted following the Google C++ style guide, and moderately but
well documented, following Roxygen2 CRAN standards, with minimal
invocation example, under 'notrun' tags.

The C++ reference standard is C++11.

The replies must adhere to CRAN guidelines, integrated by `tidyverse`
best practices.

The code should discuss performance details in depth, with an overall
judgement of every implementation alternative, over expected runtime
performance in a multicore (32 HyperThreaded Intel XEON or AMD EPYC)
Ubuntu 24.04 Linux virtual machines, running on Microsoft Azure
platform.

As a stylistic note, discuss also every alternative from for language
idiomaic and pragmaic point of view.

</system>



Your task is to produce two source to be included in a `Rcpp` and `RcppArmadillo` enabled R package project:

- a C++ source: `./src/dummy_iter.cpp`
- a R script:   `./exec/dummy-rcpp-bench.r`


## C++ source loop strategy alternatives: `./src/dummy_iter.cpp`


The C++ source: `./src/dummy_iter.cpp`, used to provide an
implementation example of different approaches in vector iteration.

In this source will be placed two group of C++ functions "sum" and
"outer", with the following specifications, delimited in XML
`*-test-specification` tags, that can be testes to verify how
different inplementation alternatives affect runtime performance,
depending on the input size. In the test, also standard R library
function should be included, as a performance reference.

In addition, a small group of logging support functions, R callable,
will be used for conditional function tracing. The trace output will
be activated only if test script "verbose" invocation argument is set
to maximum level (verbosity >= 3). C++ logging support specification
follows, delimited in XML `cpp-trace-support-specification` tag.

### "sum" function group specification

<sum-test-specification>

The "sum" gruup of functions compute the sum of a numeric input vector.

The list of implementation alternatives should consider:

- C-style `for` with manual index increment.
- C++-style `for` with STL idiomatic range iterators.
- on OpenMP `parallel for` for parallel execution
- on OpenMP `parallel for simd` for parallel execution with vectorization
- some RcppArmadillo library function
- the R `base::sum`, called from C++ code

Add further examples if appropriate.

All the functions must be R callable, and start with name prefix `dmy_pf_sum_` with a short, but clear, suffix name

</sum-test-specification>


### "outer" function group specification

<outer-test-specification>

The "outer" group of functions compute the outer product (tensor product) of a pair of input vectors.

In the tests, a random vector of the specifiled input size will be passed as both arguments.

The list of implementation alternatives should consider:

- C-style nested `for` with manual index increment.
- C++-style nested `for` with STL idiomatic range iterators.
- on OpenMP nested `parallel for collapse` for parallel execution with loop linearization 
- on OpenMP `parallel for; parellel simd` for parallel execution of the outer loop mixed with vectorization of inner loop
- some RcppArmadillo library function
- the R `base::outer`, called from C++ code, inkoked as `base::outer(v,v,"*")`

Add further examples if appropriate.

All the functions must be R callable, and start with name prefix `dmy_pf_outer_` with a short, but clear, suffix name

</outer-test-specification>


All examples must be R callable.

### C++ trace logging support functions

<cpp-trace-support-specification>

- this functions provide a way to trace messages to be output to stdout/stderr using `Rcpp::cout`, `Rcpp::cerr` channels
- a function: `dmy_pf_log_set_level`, called by the R test
  script to set a static integer variable for the "verbosiy level",
  from command line invocation arguuments (see `--verbose` script
  argument below).
- a function: `dmy_pf_log_get_level`, that returns the static value set in `dmy_pf_log_set_level`.
- a function: `dmy_pf_log_out`, invoked with `__FILE__`, `__LINE__`
  macros and a string message arguments, that outputs the message,
  using `Rcpp::cout`, if `dmy_pf_log_get_level` is >=0.
- a function: `dmy_pf_log_trace`, invoked with `__FILE__`, `__LINE__`
  macros and a string message arguments, that outputs the message,
  using `Rcpp::cerr`, if `dmy_pf_log_get_level` is >=3.  The trace
  function must log the message only once, for the same `__FILE__`,
  `__LINE__` argument, until `dmy_pf_log_reset` is called. This is to
  avoid floading the stderr with too many messages in case of repeted
  inviction. Performance should be minimal.  The could be implemented
  with a `stl::set` to check repeated invocations.
- a function: `dmy_pf_log_reset`, that clears the repeted invocation condition, reenabling trace output.
- a macro `V_LOG`, that takes a message string argument, that traslate to a call `dmy_pf_log_out` with `__FILE__`, `__LINE__` filled.
- a macro `V_TRACE`, that takes a message string argument, that traslate to a call `dmy_pf_log_trace` with `__FILE__`, `__LINE__` filled.
- in the "sum" and "outer" funcions described above the V_TRACE calls
  will be put around R library function invokation: `base::outer` and
  `base::sum`. For example:
  
```
V_TRACE("base::sum, ...")
s = base::sum(v)
V_TRACE("base::sum, done.")
```

</cpp-trace-support-specification>



## R script for looping alternative benchmarks, with variable input size: `./exec/dummy-rcpp-bench.r`


A microbenchmark R test script must be provided to verify the performance advantage of the parallel version. 
This script should accepts several command-line arguments, not mandatory, with sensible defaults, as described bolow.
The script specification is placed below, delimited in XML `test-script-specification` tags.
Add a comment about the choice of the `./exec` directory as a CRAN compliant position where to store package support sctipts,
able to call package R code, but also callable, via "system" call, from internal package code.

### Benckmark Script Specification

<test-script-specification>

- the script admits the command line arguments, descibed below, delimited in XML `test-script-cli-arguments` tags.
- the argument parsing must use a standard argument parser, provided by some library facility.
- the script output should go to stdout and logged to a file, using standard logging facilities.
- the log directory will be used also for storing benchmark results and plots
- the log directory will be taken from environment variable `P_LOGS_DIR` with `logs` as default. 
- the log directory should be created if absent.
- the script execution should be logged at info level (argumnts, benchmark invokation, final summary) while the "save data" section shold be logged at "debug" level (verbose>=1).
- the script shoud set verbose level in C++ module via `dmy_pf_log_set_level` call. Before all benchmark invocations should call `dmy_pf_log_reset` to reenable tracing.
- all the log artifacts should contain the test type and a timestamp suffix as a part of the filename.
- during script initalization, log: 1. the script arguments, 2. the full path of the log directory, 3. the output of system command: `inxi -C`
- the benchmark script should iterate the test group for the "Test Type" argument for every "Input Size" value
- the results should be aggregated and shown in a summary multi series line plot, that shows the elapsed time, with a series for every function in the group under test, depending on input size.
- the benchmark are made several `microbenchmark`invocation, with "Sample Size" runs to stabilize results. 
- for all the tests, every `microbenchmark` invocation uses a single random numeric vector of the varing input size.
- the input vector should be filled by random normal values of 0 mean and 10000 variance (100 sd)
- every script invocation should prodice a log file, a CSV file with summaries of the `microbenchmark` results and generate graphic dump of the summary plot.
- if, in addition, the "Save Data" argument is specified also the
  output should be generated, following specification below, delimited
  in `save-data-script-specification` XML tag.

</test-script-specification>


### Script Output Generation

<save-data-script-specification>

- all the outputs should go in the logging directory: fron environment `${P_LOGS_DIR:-'logs'}`, created if missing, as described above.
- all the output filenames should start with this prefix: "<script-name>-<sec-timestamp>-<test-type>-" with a variable suffix. 
- the output to generate in all runs, indipentenly fron "Save Data" option are:
   - a log file (suffix: `test.log`) generated by logging facilities, with logging level set according to verbosity option (0:INFO, >=1: DEBUG)
   - a benchmark summary plot (suffix: `bench.png`), as described above, function label as abbreviated series names, taken by function names with the common prefix stripped.
   - a Rprof output (suffix: `rprof.out`), generated only if "Profile" option is selected.
- when the "Save Data" option is selected the following output will be generated:
   - a textual system info report (suffix: `info.log`) with the output of system commands: `date; whoami; inxi  -CfGMS;  lscpu; cpupower frequency-info; nvidia-smi || echo '#NOGPU'`.
   - a tab separated export (TSV) (suffix: `data.tsv`) with microbenchmark data export with additional columns: 'test_type", "timestamp", "function_label", "input_size"

</save-data-script-specification>

### Script Command Line Arguments

<test-script-cli-arguments>

#### generic arguments

- "Help"          (option: -h|--help) - boolean, to print script usage info and command line argument description. Execution skipped.
- "Verbose"       (option: -v|--verbose) - integer (option count), can be repeated (-v, -vv -vvv), set the logging level (default: 0 - "info")
- "Profile"       (option: -p|--profile) - boolean, enable profiling with `Rprof`. 
                  Profiling output filename should follow the same naming of other outputs, with `-rprof.out` suffix.

#### benchmark arguments

- "Test Type"     (option: -t|--test) - name of the test to execute: either "sum" or "outer" (with "sum" as default value)
- "Sample Size"   (option: -m|--samples) - microbenchmark sample size (e.g., number of iterations)
- "Save Data"     (option: -s|--save) - boolean value to produce the dump of result data and system information reports as specified below.
- "Input Size" (positional, for many values) - to specify the dimension of the input vectors for tests (with default to the sequence "10 100 1000")

</test-script-cli-arguments>

As a final section, add a short guide that decribes the minimal steps
required to configure the R package project, based on `renv` (in
"explicit" configuration mode), that already include supports for
`Rcpp`, `RcppArmadillo`.  In particular, a minimal example of code
modification for `DESCRIPTION` and `./src/Makevars` for `BLAS`,
`LAPACK`and `OPENMP`support.

Include also a note for native "SIMD" support in `~/.R/Makevars`, like
adding a `-march=native` in `CXXFLAGS` variable.


--------------------------------------

Here's a breakdown of what you need to deliver:

1.  **Markdown Structure:**
    *   Use clear headings and subheadings to organize the content.
    *   Include footnotes for references to online resources (e.g., documentation for the packages, A* algorithm explanation).

2  **CRAN and Tidyverse Compliance:**
    *   Ensure the code adheres to CRAN guidelines (e.g., no excessive memory allocation, proper error handling).
    *   Follow tidyverse best practices where applicable (e.g., consistent naming conventions).

3.  **Introduction:**
    *   Provide a brief comparization of C and C++ (STL) approach, including safety and performance consideration.
    *   Discuss the "rationale" behind "OpenMP" library. Focus on "Parallelism vs Vectorization trade-off" in the HPC context.
    *   In ralation to the intrinsic directive "#pragma omp", describe the clauses 
        *   "parallel", 
        *   "for", 
        *   "collapse", 
        *   "simd", 
        *   "private", "shared", "reduction"
    *   Comment on OpenMP/BLAS/SIMD support provided by RcppArmadillo and RcppEigen
    *   Comment on portability and CRAN compliance issues ralated to architectural "native" optimizaion

4.  **GPU alternatives:**
    *   Without going too deep, provide some consideration on GPU advantage in contexr of R HPC.
    *   Give some rough estimate on GPU advantage for sone class of comuttion problem
    *   Comment on cuBLAS and give some link to online known comparation vs OpenBLAS or Intel MKL
    *   In a (rootless podman container environment) provide a short
        answer if Python based CUDA distribution is a viable approach
        for GPU enabled R package system dependencies.

5.  **C++ Code:**
    *   Implement tho group of functions "sum" and "outer", following the above specification.
    *   Follow the Google C++ Style Guide for formatting.
    *   add Rcpp attributes for exposing all the functions to R code
    *   Provide clear and concise comments to explain the code.


6.  **Microbenchmark Test Script:**
    *   Create an R script that uses the `microbenchmark` package to compare the performance of all the funcion of a sigle gout ("Test Type"), passed as an argument.
    *   Provide an argument parsing support with library argument parsing facilities, for the script that allows the parameters specified above in `test-script-cli-arguments` XML tag
    *   For the positional argument "Input Size", consider that the argument can be expressed as a space separated list of integers (like "100 1000 10000") and perform test iteration for every value. Provide a graphical summary of parallel vs sequential benchmark for performance evaluation as function of problem size. In the graph subtitle, reports the value of options "Sample Size" and other parameters, like "Test Type".
    
7.  **Rcpp OpenMP/SIMD and BLAS/LAPACK Quick Start guide:**
    *   Describe minimal package configuration required for OpenMP dependency.
    *   Discuss the choice of `~/.R/Makevars`, instead of `~/.R/Makevars` for architectural options, like the `-march=native`compiler option.

Example Markdown Structure:

```markdown
# Rcpp iterarors performance optimization

[Provide a brief abstract of the contents of this subject]


## Introduction
### C/C++ Iteration strategies and HPC Libraries Alternatives

[Provide a brief evaluation of prons and cons of different implementation patterns]

### OpenMP/SIMD primer 

[Provide a brief description of OpenMP pourpose, focusing on parallelism, vectorization and thread syncronization]


### GPU Notes

[Provide a brief comment and pointers on CUDA beneefits for R computations]


## C++ Implementation

### Sequential Version

\`\`\`cpp
// (standard CRAN prelude with Authors Copyright, License and Displaimers)

// (standard Rcpp attributes for code genetaion)
// (standard includes: RcppArmadillo, STL. OpenMP)

// (the "logging" support group of funtions: "dmy_pf_log_*" )

// (the "sum" group of funtions: "dmy_pf_sum_*" )

// (the "outer" group of funtions: "dmy_pf_outer_*" )

\`\`\`


## Microbenchmark Test

\`\`\`R

# (a roxygen compliant documentation note on script usage)
# (include @seealso tags for C++ source, "./src/Makevars", "~/.R/Makevars")
# (include @seealso tag for the file: "./notes/howtos/Rcpp-HOWTO-Q3-all.md")

# (the standard dependency loading, in a silent way)

# (the benchmark execution code for "sum" group of functions)

# (the benchmark execution code for "outer" group of functions)

# (the test iteration logic on several input size and result collector)

# (the test result aggregation and transormation)

# (the test result plotting code)

# (the test result persistence stuff)

# (the argument parsing)

# (the script "main" entrypoint)

\`\`\`


## Quick Start Guide

### Project Configuration

#### \`DESCRIPTION\`

\`\`\`yaml

Depends
   ...
Imports
   ...
LinkingTo
   ...
SystemRequirements:
   ...

\`\`\`

#### \`src/Makevars\`

\`\`\`make
RCPPP_LIBS = $(Rscript ...)
PKG_LIBS = ... $(RCPPP_LIBS)
\`\`\`

#### \`~/.R/Makevars\`

\`\`\`make
CXXFLAGS = ... -march=native
\`\`\`


## References

[^1]: [High performance functions with Rcpp](http://adv-r.had.co.nz/Rcpp.html)
[^2]: [R Packages](https://r-pkgs.org/)
[^3]: [RcppArmadillo on CRAN](https://cran.r-project.org/web/packages/RcppArmadillo/index.html)
[^4]: [OpenMP Resources](https://www.openmp.org/resources/)
[^5]: [CRAN Task View: High-Performance and Parallel Computing with R](https://cran.r-project.org/web/views/HighPerformanceComputing.html)
[^6]: [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
```





-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (Claude)
> ...

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (Gemini)
> ...

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (Claude)
> ...

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (ChatGPT)
> ...

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (DeepSeek)
> ...

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (Kimi)
> ...

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (Diffusion)
> ...

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (LeChat)
> ...

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# A:3 (Perplexity)
> ...


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
# ::}}} \\ %1.

