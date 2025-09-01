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

Your task is to prepare example C++ sources to introduce core features of main Rcpp ecosystem packages. 

The answer must be in well-formatted, clearly structured (GFM) markdown, with footnotes for links to relevant online resource references.

The C++ code fragments must be placed in `cpp` markdown codeblocks, formatted following the Google C++ style guide, and moderately but well documented, following Roxygen2 CRAN standards, with minimal invocation example, under 'notrun' tags.

The C++ reference standard is C++11.

The replies must adhere to CRAN guidelines, integrated by `tidyverse` best practices.

The code should discuss performance details in depth, with an overall judgement of every implementation alternative, over expected runtime performance in a multicore (32 HyperThreaded Intel XEON or AMD EPYC) Ubuntu 24.04 Linux virtual machines, running on Microsoft Azure platform.

As a stylistic note, discuss also every alternative from for language idiomaic and pragmaic point of view.

</system>



Your task is to produce two source to be included in a `Rcpp` and `RcppArmadillo` enabled R package project:

- a C++ source: `./src/dummy_iter.cpp`
- a R script:   `./exec/dummy-rcpp-bench.r`


## C++ source loop strategy alternatives: `./src/dummy_iter.cpp`


The C++ source: `./src/dummy_iter.cpp`, used to provide an implementation example of different approaches in vector iteration.

In this source will be placed two group of C++ functions "sum" and "outer", with the following specifications, delimited in XML `*-test-specification` tags, that can be testes to verify how different inplementation alternatives affect runtime performance, depending on the input size. In the test, also standard R library function should be included, as a performance reference.


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

The "outer" gruup of functions compute the outer product (tensor product) of a pair of input vectors.

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


## R script for looping alternative benchmarks, with variable input size: `./exec/dummy-rcpp-bench.r`


A microbenchmark R test script must be provided to verify the performance advantage of the parallel version. 
This script should accepts several command-line arguments, not mandatory, with sensible defaults, as described bolow.
The script specification is placed below, delimited in XML `test-script-specification` tags.
Add a comment about the choice of the `./exec` directory as a CRAN compliant position where to store package support sctipts,
able to call package R code, but also callable, via "system" call, from internal package code.

<test-script-specification>

- the script admits the command line arguments, descibed below, delimited in XML `test-script-cli-arguments` tags.
- the argument parsing must use a standard argument parser, provided by some library facility.
- the script output should go to stdout and logged to a file, using standard logging facilities.
- the log directory will be used also for storing benchmark results and plots
- the log directory will be taken from environment variable `P_LOGS_DIR` with `logs` as default. 
- the log directory should be created if absent.
- all the log artifacts should contain the test type and a timestamp suffix as a part of the filename.
- the benchmark script should iterate the test group for the "Test Type" argument for every "Input Size" value
- the results should be aggregated and shown in a summary multi series line plot, that shows the elapsed time, with a series for every function in the group under test, depending on input size.
- the benchmark are made several `microbenchmark`invocation, with "Sample Size" runs to stabilize results. 
- for all the tests, every `microbenchmark` invocation uses a single random numeric vector of the varing input size.
- the input vector should be filled by random normal values of 0 mean and 10000 variance (100 sd)
- every script invocation should prodice a log file, a CSV file with summaries of the `microbenchmark` results and generate graphic dump of the summary plot.
- if, in addition, the "Save Data" argument is specified also input test data shoud be saved in an efficient file format.

</test-script-specification>


<test-script-cli-arguments>

- "Test Type"     (option: -t|--test) - name of the test to execute: either "sum" or "outer" (with "sum" as default value)
- "Sample Size"   (option: -m|--samples) - microbenchmark sample size (e.g., number of iterations)
- "Save Data"     (option: -s|--save) - boolean value to require the dump of the randon input and tast results over an external (text or json) file for further analysys or plotting.
- "Input Size" (positional, for many values) - to specify the dimension of the input vectors for tests

</test-script-cli-arguments>



As a final section, add a short guide that decribes the minimal steps required to configure the R package project, based on `renv` (in "explicit" configuration mode), that already include supports for `Rcpp`, `RcppArmadillo`. 
In particular, a minimal example of code modification for `DESCRIPTION` and `./src/Makevars` for `BLAS`, `LAPACK`and `OPENMP`support.

Include also a note for native "SIMD" support in `~/.R/Makevars`, like adding a `-march=native` in `CXXFLAGS` variable. 


--------------------------------------

Here's a breakdown of what you need to deliver:

1.  **Markdown Structure:**
    *   Use clear headings and subheadings to organize the content.
    *   Provide a brief comparization of C and C++ (STL) approach, including safety and performance consideration.
    *   Discuss the "rationale" behind "OpenMP" library. Focus on "Parallelism vs Vectorization trade-off" in the HPC context.
    *   In ralation to the intrinsic directive "#pragma omp", describe the clauses 
        *   "parallel", 
        *   "for", 
        *   "collapse", 
        *   "simd", 
        *   "private", "shared", "reduction"
    *   Comment on OpenMP/BLAS/SIMD support provided by RcppArmadillo and RcppEigen
    *   Include footnotes for references to online resources (e.g., documentation for the packages, A* algorithm explanation).

2.  **C++ Code:**
    *   Implement tho group of functions "sum" and "outer", following the above specification.
    *   Follow the Google C++ Style Guide for formatting.
    *   add Rcpp attributes for exposing all the functions to R code
    *   Provide clear and concise comments to explain the code.


3.  **Microbenchmark Test Script:**
    *   Create an R script that uses the `microbenchmark` package to compare the performance of all the funcion of a sigle gout ("Test Type"), passed as an argument.
    *   Provide an argument parsing support with library argument parsing facilities, for the script that allows the parameters specified above in `test-script-cli-arguments` XML tag
    *   For the positional argument "Input Size", consider that the argument can be expressed as a space separated list of integers (like "100 1000 10000") and perform test iteration for every value. Provide a graphical summary of parallel vs sequential benchmark for performance evaluation as function of problem size. In the graph subtitle, reports the value of options "Sample Size" and other parameters, like "Test Type".
    
5.  **CRAN and Tidyverse Compliance:**
    *   Ensure the code adheres to CRAN guidelines (e.g., no excessive memory allocation, proper error handling).
    *   Follow tidyverse best practices where applicable (e.g., consistent naming conventions).

6.  **Rcpp OpenMP/SIMD and BLAS/LAPACK Quick Start guide:**
    *   Describe miniman package configuration required for OpenMP dependency.
    *   Discuss the choice of `~/.R/Makevars`, instead of `~/.R/Makevars` for architectural options, like the `-march=native`compiler option.

Example Markdown Structure:

```markdown
# Rcpp iterarors performance optimization

[Provide a brief abstract of the contents of this subject]


## C/C++ Iteration strategies and HPC Libraries Alòternatives

[Provide a brief evaluation of prons and cons of different implementation patterns]

## C++ Implementation

### Sequential Version

\`\`\`cpp
// (standard CRAN prelude with Authors Copyright, License and Displaimers)

// (standard Rcpp attributes for code genetaion)
// (standard includes: RcppArmadillo, STL. OpenMP)

// (the "sum" group of funtions: "dmy_pf_sum_*" )

// (the "outer" group of funtions: "dmy_pf_outer_*" )

\`\`\`


## Microbenchmark Test

\`\`\`R

# (the standard debendency loading, in a silent way)

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
[^5]: [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
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

