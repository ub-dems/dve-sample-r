---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



## Overview

### Projct Notes

The development guides are available under `notes/`, see:

* [*Project Usage Notes*](notes/usage/README.md)



### Features

The `dvesimpler` package is a simple R project template:

* supporting R package builder `as-cran`,
* packagin runtime environment (rstudio, dependencies) as a container image
* packagin project contents (code, scripts) as an executable container image
* externalize data directories symlinked relative to project root,
* demo scripts, functions and tests.

### Runtime Environments

This project supports two different execution environments:

* `direct`: traditional execution environment that runs system installed R/RStudio (desktop).
* `containerized`: execution environment that runs a container image with a fully customizable R/RStudio (server) setup.


The `direct` model is simpler but with many limitations:
- it is "bound" to a single host and is based to a predefined R setup
- the system installed environment is periodically upgraded by management scripts, not customizable.
- these is no support for dependency versioning and remote execution.

The `containerized` model more complex, but presents many advantages:
- full control in runtime definition (R version, predefined packages)
- container images based on: [Rocker Project Images](https://www.rocker-project.org/images/)
- [renv](https://rstudio.github.io/renv/articles/renv.html) support for [Reproducible research](https://en.wikipedia.org/wiki/Reproducibility#Reproducible_research) project specification
- [Podman](https://podman.io/) containers enable remote execution and distribution, prerequisite for shared computaional resource access.



## Development Environment

### Project Dwevelopment Guides

* Build environment and execution scripts are documented in `./notes/usage`.

### Readme document update

This README.md is generated from README.Rmd. Please edit that file. To rebuild:


```sh

# in project base directory

./build.sh readme

```

This command can be run in container, by entering a shell in the inner environment


```sh

# externally, in project base directory

./runtime.sh sh

# internally, in project base directory

./build.sh readme

```




## Document Sample

### Code Evaluation


```r

salutation <- c(
  dummy_hello(),
  dummy_hello("Earth"),
  dummy_hello("Moon", "'Night")
)

cat(salutation)
#> Hello World! Hello Earth! 'Night Moon!
```



## Script Execution

### in Rsession


```r

# in project base directory

source("exec/dummy_runner.R")
#> ℹ Loading dvesimpler
#> 2022-07-15 14:20:01 INFO::#> start:
#> R version 4.2.1 (2022-06-23)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: Ubuntu 20.04.4 LTS
#>
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/liblapack.so.3
#>
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C
#>
#> attached base packages:
#> [1] stats     graphics  grDevices datasets  utils     methods   base
#>
#> other attached packages:
#> [1] logging_0.10-108      dvesimpler_1.0.0.9000 testthat_3.1.4
#>
#> loaded via a namespace (and not attached):
#>  [1] tidyselect_1.1.2  xfun_0.31         remotes_2.4.2     purrr_0.3.4
#>  [5] colorspace_2.0-3  vctrs_0.4.1       generics_0.1.2    usethis_2.1.6
#>  [9] yaml_2.3.5        utf8_1.2.2        rlang_1.0.3       pkgbuild_1.3.1
#> [13] pillar_1.7.0      glue_1.6.2        withr_2.5.0       DBI_1.1.3
#> [17] sessioninfo_1.2.2 lifecycle_1.0.1   stringr_1.4.0     munsell_0.5.0
#> [21] gtable_0.3.0      devtools_2.4.3    memoise_2.0.1     evaluate_0.15
#> [25] knitr_1.39        callr_3.7.0       tzdb_0.3.0        fastmap_1.1.0
#> [29] ps_1.7.1          fansi_1.0.3       readr_2.1.2       renv_0.15.4
#> [33] scales_1.2.0      cachem_1.0.6      desc_1.4.1        pkgload_1.3.0
#> [37] fs_1.5.2          brio_1.1.3        ggplot2_3.3.6     hms_1.1.1
#> [41] stringi_1.7.6     processx_3.6.1    dplyr_1.0.9       rprojroot_2.0.3
#> [45] grid_4.2.1        cli_3.3.0         tools_4.2.1       magrittr_2.0.3
#> [49] tibble_3.1.7      crayon_1.5.1      pkgconfig_2.0.3   ellipsis_0.3.2
#> [53] prettyunits_1.1.1 lubridate_1.8.0   assertthat_0.2.1  rstudioapi_0.13
#> [57] R6_2.5.1          compiler_4.2.1
#>    user  system elapsed
#>   0.005   0.001   0.006
#> 2022-07-15 14:20:01 INFO::#< end(0): 0.00499999999999989,0.001,0.00599999999999978
```

### from command-line (inside container)


```sh

# in project base directory

./starter.sh

```

### from command-line (outside container)


```sh

# in project base directory

./worker.sh pack,exec

```


## Sample Usage

## GitLab Installation



```r

# install from gitlab
# install.packages("devtools")
devtools::install_gitlab("ub-dems-public/ds-labs/dve-sample-r")

```

### Basic demo

* `dummy_hello()` get default salutation


