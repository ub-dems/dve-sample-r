---
title: Unmanaged Dependency Management
subtitle: dependencies management without "renv"
caption: deps - unmanaged
author: --
date: 2021-10-29
---
|   |                                                               |                                           |                                  |                                      |
|---|---------------------------------------------------------------|-------------------------------------------|----------------------------------|--------------------------------------|
|   | [Prev: Managed Dependency Management](../deps-renv/README.md) | [Up: Dependency Management](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |

_**WARNING:**_ *this module isn't released yet ...*


Unmanaged Dependency Management
===============================

Without `renv` automatic dependency resolution, package installation can be specified in two ways:

1.- ["rocker images tags"](https://hub.docker.com/r/rocker/tidyverse/tags),
  Image dependency may include a `version tag` to declare a (nearly[^1]) immutable base image.
  See:
  - [`docker/r-images/dockerfile/anchor.Dockerfile`](../../../../../docker/r-images/dockerfile/anchor.Dockerfile)

1.- ["intall2.r"](https://dirk.eddelbuettel.com/code/littler.examples.html),
  ["devtools::install_version()"](https://devtools.r-lib.org/)
  can be used to install a specific package version.
  See:
  - [`docker/r-images/scripts/runtime/install_ubs-runtime.sh`](../../../../../docker/r-images/scripts/runtime/install_ubs-runtime.sh)


[^1]: "rocker" images are rebuilt periodically to include minor fixes and system upgrades, but avoiding major upgrades.


Dependency declaration
----------------------

As described in:

* [R Packages - Dependencies: What does your package need?](https://r-pkgs.org/dependencies.html)
it is required to list package dependencies, under "Imports" or "Suggest" section, in package metadata:

* [DESCRIPTION](../../../../../DESCRIPTION)

To avoid warning related to _"unused imported package"_, the `@importFrom` clause can be added to `package reference` R source in:

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



