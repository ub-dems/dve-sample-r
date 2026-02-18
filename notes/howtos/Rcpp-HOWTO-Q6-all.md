---
title: TODO:(title)
subtitle: TODO:(subtitle)
# {{{ // %+

category: RCPP-Howto
keywords: [GEN, TODO:(keywords)]
abstract: |
  TODO:(abstract)
  
  ...

doctype: md-report

# }}} // %+
---
<!-- {{{ #TAG: TODO:(toc) // -->

<!-- markdownlint-disable MD012 -->
<!-- markdownlint-disable MD025 -->
<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD051 -->


# TOC

1. [Q:1 - TODO:(q1-ref)](#q1)
   - see: [TODO:(a1-ref-claude) (Claude)](#a1-claude)
   - see: [TODO:(a1-ref-gemini) (Gemini)](#a1-gemini)
   - see: [TODO:(a1-ref-chatgpt) (ChatGPT)](#a1-chatgpt)
   - see: [TODO:(a1-ref-perplexity) (Perplexity)](#a1-perplexity)
   - see: [TODO:(a1-ref-deepseek) (DeepSeek)](#a1-deepseek)
2. [Q:2 - TODO:(q2-ref)](#q2)
   - see: [TODO:(a2-ref-claude) (Claude)](#a2-claude)
   - see: [TODO:(a2-ref-gemini) (Gemini)](#a2-gemini)
   - see: [TODO:(a2-ref-chatgpt) (ChatGPT)](#a2-chatgpt)
   - see: [TODO:(a2-ref-perplexity) (Perplexity)](#a2-perplexity)
   - see: [TODO:(a2-ref-deepseek) (DeepSeek)](#a2-deepseek)
3. [A:a - TODO:(appendix-a)](#aa)
4. [A:b - Q1: Prompt distiller](#ab)
   - see: [Q1: Prompt distiller (Claude)](#ab-claude)
   - see: [Q1: Prompt distiller (Gemini)](#ab-gemini)
   - see: [Q1: Prompt distiller (ChatGPT)](#ab-chatgpt)
   - see: [Q1: Prompt distiller (Perplexity)](#ab-perplexity)
   - see: [Q1: Prompt distiller (DeepSeek)](#ab-deepseek)

<details>
<summary></summary>

```{=latex}
\begin{comment}
```

</details>

---

|                   |                        |
|-------------------|------------------------|
| [<<<<](README.md) | [PDF](TODO:(file).pdf) |

---

<details>
<summary>[index]</summary>

[[_TOC_]]

</details>
<details>
<summary></summary>

```{=latex}
\end{comment}
```

</details>

<!-- ::}}} \\ %0. -->
<!-- ::{{{ #TAG: TODO:(q1-section) // -->

# Q:1

## Q:1 - **TODO:(q1-title)**

[⇧](#toc)

>>> [!tip]

## Role

You are an expert R and C++ developer.

All examples should be compact, clear, and focused on a small set of relevant features of a single package.

The code should be very performant, using alternatively, implicit parallelism and vectorization via OpenMP/SIMD intrinsics, or via library-based interfaces to multitasking and multiprocessing OS facilities.

## Context

- The examples will be integrated in a CRAN compliant R package: `dve-sample-r`
- The package,, based on `renv` (in "explicit" mode) already includes `Rcpp`, `RcppArmadillo`

>>>

## Objective

Your task is to prepare an introduction to parallelism in R development with examples in R and C++ with standard library support.

The tutorial must include an interesting use-case example for the `RcppParallel` package,
focusing on `parallelFor` and `parallelReduce` functions.

The example should also be "inspiring", based on an interesting use case or algorithm that is worth reading,
and not just a library API demo.

Possible examples of interesting use case could be:

- a minimal toy implementation of an A* heuristic search algorithm, applied to a random generated graph
- a path search algorithm for random maze escaping
- a pay toll queue traffic simulation with different service points, with metrics on waiting and idle times
- a biologiacal sequence comparison on random DNA fragments of predefined lenght

Only one implementation example shoud be proveded, chosen on the above list or with a better different solution.

The test R script shoud use `foreach` parallelism to run tests in parallel, collecting result for summary aggregation.

Different allocation policies for vcpu core allocation among R script
and parallel C++ should be discussed, describing prons and cons in
terms of total workload optimization.



## Specifications

All C++ examples must be R callable.

An R test script must be provided to run the C++ code, with performance metrics evaluated for different input sizes.

This script should accepts several command-line arguments, not mandatory, with sensible defaults, as described bolow.
The argument parsing must use a standard argument parser, provided by some library facility and implements the requirement described in the heading:

- [test-script-cli-arguments](#test-script-cli-arguments)

As a final section, prepare a "R parallelism quick start" guide that
decribes the minimal steps required to include `foreach/parallelly`
and `RcppParallel` in a R package project, based on `renv` (in
"explicit" configuration mode), that already include supports for
`Rcpp` and `RcppArmadillo`.

In particular, provide code modification for `DESCRIPTION` and
`./src/Makevars`. 

Include also a note for "SIMD" support in `~/.R/Makevars`, like adding
a `-march=native` in `CXXFLAGS` variable. 

For package installation, discuss possible OS system library
dependencies and `TinyThread` library distribution. Show basic `renv`
command sequence for installation: `renv::install()` and
`renv::snapshot()`.


### test-script-cli-arguments

#### Generic arguments

- `help`:   (option: -h|--help, type: boolean, default:`false`) - Prints script usage info and command-line argument descriptions. Execution is skipped.
- `verbose`:  (option: -v|--verbose, mode: count, type: integer, default:`0`) - "Verbose", can be repeated (`-v`, `-vv`), to set the logging level (`0`:info, `1`:debug).
- `rnd_seed`: (option: -u|--seed, type: integer, default:`0`) - "Random Seed", for deterministic random sequence initialization.

#### Common arguments

- `save_data`  (option: -s|--save) - boolean value to require the dump of the randon input and tast results over an external (text or json) file for further analysys or plotting.
- `input_size` (positional, for many values) - cardinality of input domain fot the example model (e.g., number of nodes of a graph, DNS fragment lenght, number of service points)

#### Additional arguments

Additional arguments, all with sensible defautls, may be introduced, depending on example chosen. For instance:

- `graph_density` (option: -g|--density) - graph density (e.g., rate of links over nodes, with 1.0 means full connected, 0.0 full isolated)
- `arrival_rate`  (option: -r|--rate) - traffic arrival rate on pay toll
- `sequence_similarity`  (option: -c|--cross) - number of random crossovers between sequences




## Deliverables

Here's a breakdown of what you need to deliver:

1.  **Markdown Structure:**
    -   Use clear headings and subheadings to organize the content.
    -   Provide a brief introduction to the A* search algorithm.
    -   Explain the use of `RcppParallel` in the context of the example proposed.
    -   Explain the use of `foreach/parallely` in the context of the example proposed.
    -   Include footnotes for references to online resources (e.g., documentation for the packages, A* algorithm explanation).

2.  **C++ Code:**
    -   Implement the parallel version of the example proposed.
    -   Use `parallelFor` and `parallelReduce` from `RcppParallel`
    -   Provide clear and concise comments to explain the code.

3.  **R Callable Functions:**
    -   Implement the driver logic for parallel execution of the C++ functions for the different input sizes.
    -   Collect and summarize results and performance metrics (elapsed times).
    -   Use `foreach/parallely` for parallel executiom

4.  **Concurrency Issues:**
    -   Provide all syncronization promitives to avoid concurrency issues
    -   Prefer funcional message passing paradigm versus monitors and semaphore locking
    -   Introduce mutex around (no-wait) critical sections when required

4.  **Multiple Worker Node Variant:**
    -   Discuss the R script modifications to run examples on multi-node cluster
    -   Consider internode connectivity, focusing on `ssh`, `mpi` and `zmq` for control and data communication

6.  **RcppParallel Quick Start guide:**
    -   Describe miniman package configuration required for RcppParallel dependency.
    -   Only if required, show `apt` commands to install required OS system library dependencies.
    -   Show `renv` commands required for installation.


## Code Format



## Output Format

### R Package Contraints

- The R package must adhere to CRAN guidelines, integrated by `tidyverse` best practices.
- The R package must support `R CMD check`
- The only warning admitted is about a `-march=native` option, placed on local `~/.R/Makevars`

### R Output Format

- The R script must be placed under the `exec` directory
- The R script must be directly executable, with a "she-bang" line for `Rscript` invocation.
- The `library` dependencies, placed in the inital part of the script must suppress warning messages.

### C++ Output Format

- the C++ code follows `Rcpp` package guidelines
- the entry point example function must be exportable as package C++ api
- the code must be placed under `src` directory.
- the C++ api, automatically generated by `roxygen2`, must be placed under `inst/include` directory.
- the C++ code must follow the Google C++ style guide
- the code must be moderately but well documented.



### Markdown Output Format

- Reply in clear formatted "GitLab Flavored Markdown (GLFM)" Markdown,
with precise (lint) validation:
  - codeblock delimiters ``` placed atline start). Avoid codeblock nesting.
  - use _underscore markup_ for emphasys
  - prefer nested headings to text markup with asterisks
  - use only "dash" for unordered lists, with correct indentation
  - insert appropriate blank line separation after headings, list and codeblocks

- Ignore document formatting markup, like:
  - <details><summary> HTML blocks
  - {=latex} codeblocks
  - [!tip] [!note] block quotes
  - code folding tags ("three curly braces pairs")
  - internal links: e.g. [⇧]

- At the end, provide, as Markdown footnotes, a list of references to
online documentation resources, linked to answer text where
appropriate. To avoid reference clashing with other part of the
document, prefix references with the string "rf-".

- Add any additional important information not explicitly required in
an "Additional Notes" section.



# A:1 (Claude)

[⇧](#toc) **_TODO:(a1-ref-claude)_**

TODO:(a1-claude) ...

# A:1 (Gemini)

[⇧](#toc) **_TODO:(a1-ref-gemini)_**

TODO:(a1-gemini) ...

# A:1 (ChatGPT)

[⇧](#toc) **_TODO:(a1-ref-chatgpt)_**

TODO:(a1-chatgpt) ...

# A:1 (Perplexity)

[⇧](#toc) **_TODO:(a1-ref-perplexity)_**

TODO:(a1-perplexity) ...

## Q:1.2 (Perplexity)

[⇧](#toc) **_(=> continue)_**

TODO:(q1.2-perplexity) ...

---

## A:1.2 (Perplexity)

[⇧](#toc) **_(=> continue)_**

TODO:(a1.2-perplexity) ...

# A:1 (DeepSeek)

[⇧](#toc) **_TODO:(a1-ref-deepseek)_**

TODO:(a1-deepseek) ...

<!-- }}} \\ %1. -->
<!-- {{{ // %*
LocalWords:  GitLab CommonMark GFM GLFM YAML
vim: set foldmethod=marker :
}}} // %* -->
