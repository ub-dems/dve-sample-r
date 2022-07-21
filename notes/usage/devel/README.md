---
title: DEVELOPMENT environment
subtitle: project build/runtime/deploy operations
caption: DEVEL env
author: --
date: 2021-10-29
---
|                                                      |                                         |                           |                            |                                |
|------------------------------------------------------|-----------------------------------------|---------------------------|----------------------------|--------------------------------|
| [Next: DATA SOURCE Configuration](../data/README.md) | [Prev: QUICK Start](../quick/README.md) | [Up: Usage](../README.md) | [[Contents]](../README.md) | [[Index]](../_index/README.md) |

Introduction
------------

- [Overview](intro/README.md): introduction to development environment
  - ["legacy" environment](intro/legacy/README.md)
  - ["containerized" environment](intro/containers/README.md)


Library Dependency Management
-----------------------------

External libraries (packages), related to environment "model" and dependency resolution specification.

- [Dependency Management](libs/README.md)
  - [managed dependency management ("renv")](libs/deps-renv/README.md)
  - [unmanaged dependency management](libs/deps-no-renv/README.md)


Development Commands (Actions)
------------------------------

The development environment defines several actions for the projects, grouped in 4 categories:

- [Project Actions](actions/README.md)
  - ["build" actions](actions/build/README.md): to initialize project runtime environment and to runs checks and tests
  - ["runtime" actions](actions/runtime/README.md): for "containerized" projects only, to control R/RStudio (customized) container execution
  - ["worker" actions](actions/worker/README.md): for "containerized" projects only, to embed and run project code in a executable image 
  - ["starter" actions](actions/starter/README.md): project execution "entry-point", to trigger scripts invocations or service startup (shiny, plumber)


Execution Context
-----------------

- [Execution Context](exec/README.md)
  - ["runner" actions](exec/runner/README.md): to initialize project runtime environment and to runs checks and tests

