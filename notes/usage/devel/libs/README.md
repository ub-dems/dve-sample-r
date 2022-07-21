---
title: Library Dependency Management
subtitle: runtime package library specification
caption: Dependencies
author: --
date: 2021-10-29
---
|                                                   |                                          |                                             |                               |                                   |
|---------------------------------------------------|------------------------------------------|---------------------------------------------|-------------------------------|-----------------------------------|
| [Next: Development Actions](../actions/README.md) | [Prev: Introduction](../intro/README.md) | [Up: DEVELOPMENT Environment](../README.md) | [[Contents]](../../README.md) | [[Index]](../../_index/README.md) |

Library Dependency Management
-----------------------------

Dependency management is supported only in ["containerized" model](../intro/containers/README.md). 
In ["legacy" model](../intro/legacy/README.md), packages are installed at system level  without version management at project level.

[Reproducibility](https://en.wikipedia.org/wiki/Reproducibility) requirement of _"strict"_ dependency versioning is supported by [`renv`](https://rstudio.github.io/renv/articles/renv.html).
As an alternative, ["rocker images tags"](https://hub.docker.com/r/rocker/tidyverse/tags) can be use to declare a (nearly) immutable base image.

  - [managed dependency management ("renv")](deps-renv/README.md)
  - [unmanaged dependency management](deps-no-renv/README.md)



