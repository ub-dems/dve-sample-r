---
title: Development Environment Overview
subtitle: project features and models
caption: Introduction
author: --
date: 2021-10-29
---
|                                                  |   |                                             |                               |                                   |
|--------------------------------------------------|---|---------------------------------------------|-------------------------------|-----------------------------------|
| [Next: Dependency Management](../libs/README.md) |   | [Up: DEVELOPMENT Environment](../README.md) | [[Contents]](../../README.md) | [[Index]](../../_index/README.md) |

Overview
========

Features
--------

This project is base on generic R project template:

* https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r

* supporting R package builder `as-cran`,
* packaging runtime environment (RStudio, dependencies) as a container image
* packaging project contents (code, scripts) as an executable container image
* externalized data directories, imported (with [symbolic link](https://en.wikipedia.org/wiki/Symbolic_link)) as path relative to project root
* demo scripts, functions and tests


Developments Models
------------------

This project supports two different development models:

- ["direct" (legacy) environment](legacy/README.md): traditional execution environment that runs system installed R/RStudio (desktop).
- ["containerized" environment](containers/README.md): execution environment that runs a container image with a fully customizable R/RStudio (server) setup.


The `direct` model is simpler but with many limitations:
- it is "bound" to a single host and it is based to a predefined R setup
- the system installed environment is periodically upgraded by management scripts, not customizable.
- these is no support for dependency versioning and remote execution.

The `containerized` model more complex, but presents many advantages:
- full control in runtime definition (R version, predefined packages)
- container images based on: [Rocker Project Images](https://www.rocker-project.org/images/)
- [renv](https://rstudio.github.io/renv/articles/renv.html) support for [Reproducible research](https://en.wikipedia.org/wiki/Reproducibility#Reproducible_research) project specification
- [Podman](https://podman.io/) containers enable remote execution and distribution, prerequisite for shared computational resource access.


