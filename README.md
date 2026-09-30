---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



## Overview

### Projct Notes

The development guides are available under `notes/`, see:

* [**Project Usage Notes**](notes/usage/README.md)


### Acknoledgements

> We greatly acknowledge the [University of Milano-Bicocca](http://www.unimib.it) "Data Science Lab" ([datalab](http://datalab.unimib.it))
> for supporting this work by providing computational resources.




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
#> 2023-02-24 17:38:20 INFO::#> start:
#> R version 4.2.2 (2022-10-31)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: Ubuntu 22.04.1 LTS
#>
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so
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
#> [1] logging_0.10-108      dvesimpler_1.0.0.9000 testthat_3.1.6
#>
#> loaded via a namespace (and not attached):
#>  [1] Rcpp_1.0.10       compiler_4.2.2    later_1.3.0       urlchecker_1.0.1
#>  [5] NCmisc_1.2.0      prettyunits_1.1.1 profvis_0.3.7     remotes_2.4.2
#>  [9] tools_4.2.2       digest_0.6.31     pkgbuild_1.4.0    pkgload_1.3.2
#> [13] evaluate_0.20     memoise_2.0.1     lifecycle_1.0.3   rlang_1.0.6
#> [17] shiny_1.7.4       cli_3.6.0         rstudioapi_0.14   yaml_2.3.7
#> [21] xfun_0.37         fastmap_1.1.0     knitr_1.42        reader_1.0.6
#> [25] withr_2.5.0       stringr_1.5.0     desc_1.4.2        fs_1.6.0
#> [29] htmlwidgets_1.6.1 vctrs_0.5.2       devtools_2.4.5    rprojroot_2.0.3
#> [33] glue_1.6.2        R6_2.5.1          processx_3.8.0    sessioninfo_1.2.2
#> [37] callr_3.7.3       purrr_1.0.1       magrittr_2.0.3    ps_1.7.2
#> [41] promises_1.2.0.1  ellipsis_0.3.2    htmltools_0.5.4   usethis_2.1.6
#> [45] mime_0.12         xtable_1.8-4      renv_0.16.0       httpuv_1.6.8
#> [49] stringi_1.7.12    miniUI_0.1.1.1    cachem_1.0.6      crayon_1.5.2
#> [53] brio_1.1.3
#>    user  system elapsed
#>   0.006   0.000   0.006
#> 2023-02-24 17:38:20 INFO::#< end(0): 0.00599999999999978,0,0.00600000000000023
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
devtools::install_gitlab("ub-dems/ds-labs/dve-sample-r")

```

### Basic demo

* `dummy_hello()` get default salutation


