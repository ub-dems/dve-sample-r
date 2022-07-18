---
title: DEVELOPMENT Cheat Sheet
subtitle: development environment actions
author: --
date: 2021-10-29
---
|                                             |                                             |                            |                                |
|---------------------------------------------|---------------------------------------------|----------------------------|--------------------------------|
| [Next: "build" Actions](../build/README.md) | [Up: Development Environment](../README.md) | [[Contents]](../README.md) | [[Index]](../_index/README.md) |

Overview
========

Features
--------

The `dvesimpler` package is a simple R project template:

* supporting R package builder `as-cran`,
* packagin runtime environment (rstudio, dependencies) as a container image
* packagin project contents (code, scripts) as an executable container image
* externalize data directories symlinked relative to project root,
* demo scripts, functions and tests.

Runtime Environments
--------------------

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


