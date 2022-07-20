---
title: "runner" actions
subtitle: development environment actions
author: --
date: 2021-10-29
---
|   |                                                                      |                                           |                                  |                                      |
|---|----------------------------------------------------------------------|-------------------------------------------|----------------------------------|--------------------------------------|
|   | [Prev: "renv" managed dependency management](../deps-renv/README.md) | [Up: Dependency Management](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |

_**WARNING:**_ *this mudule isn't released yet ...*


Unmanaged Depencency Management
===============================

Without `renv` automatic dependency resolution, package installtion 
can be specified in two ways:

1.- ["rocker images version tag"](https://hub.docker.com/r/rocker/tidyverse/tags),
  can be use to declare a (nearly) immutable base image.
  see:
  - [`docker/r-images/dockerfile/anchor.Dockerfile`](../../../../../docker/r-images/dockerfile/anchor.Dockerfile)

1.- ["intall2.r"](https://dirk.eddelbuettel.com/code/littler.examples.html),
  ["devtools::install_version()"](https://devtools.r-lib.org/)
  can be used to install a specific version.
  see:
  - [`docker/r-images/scripts/runtime/install_ubs-runtime.sh`](../../../../../docker/r-images/scripts/runtime/install_ubs-runtime.sh)


Dependency declaration
----------------------


In order to declare package dependencies, it is required to list package dependencies, under "Imports" or "Suggest" section,
in:

* [DESCRIPTION](../../../../../DESCRIPTION)

To avoid warning related to "unused imported package", the `@importFrom` 
can be added to `package reference` R source in:

* [R/"package-name".R](../../../../../R)

```R

#' @description
#' To learn more about simlab, start with the vignettes:
#' `browseVignettes(package = "<package-name>")`
#' @keywords internal
"_PACKAGE"

# Suppress R CMD check note
#' @importFrom logging loginfo
#' ...
#' @importFrom yaml as.yaml
NULL


```



