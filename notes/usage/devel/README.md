---
title: DEVELOPMENT environment
subtitle: project build/runtime/deploy operations
author: --
date: 2021-10-29
---
|                                               |                           |                               |                        |
|-----------------------------------------------|---------------------------|-------------------------------|------------------------|
| [Next: DATA SOURCE Configuration](../data/README.md) | [Up: Usage](../README.md) | [[Contents]](../README.md) | [[Index]](../_index/README.md) |

Introduction
------------

- [Overview](intro/README.md): introduction to developmnt environment
  - ["legacy" environment](devel/intro/legacy/README.md)
  - ["containerized" environment](devel/intro/containers/README.md)


Development Commands (Actions)
------------------------------

The development environment defines several actions for the projects, grouped in 4 categories:

- [Project Actions](action/README.md)
  - ["build" actions](action/build/README.md): to initialize project runtime environment and to runs checks and tests
  - ["runtime" actions](action/runtime/README.md): for "containerized" projects only, to control R/RStudio (customized) container execution
  - ["worker" actions](action/worker/README.md): for "containerized" projects only, to embend and run project code in a executable image 
  - ["starter" actions](action/starter/README.md): project execution "entry-point", to trigger scripts invocations or service startup (shiny, plumber)


Execution Context
-----------------

- [Execution Context](exec/README.md)
  - ["runner" actions](exec/runner/README.md): to initialize project runtime environment and to runs checks and tests

