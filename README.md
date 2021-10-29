
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Overview

The `dvesimpler` package offers a project template:

-   supporting R package builder `as-cran`,
-   externalize data directories symlinked relative to project root,
-   demo scripts, functions and tests.

``` r

salutation <- c( 
  dummy_hello(),
  dummy_hello("Earth"),
  dummy_hello("Moon", "'Night")
)

cat(salutation)
  
```

## Installation

``` r
# install from gitlab
# install.packages("devtools")
devtools::install_gitlab("ub-dems-public/ds-labs/dve-sample-r")
```

## Usage

### Basic demo

-   `dummy_hello()` get default salutation
