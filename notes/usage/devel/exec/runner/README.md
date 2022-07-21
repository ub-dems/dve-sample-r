---
title: Project "runner" Actions
subtitle: development environment actions
caption: runner.sh
author: --
date: 2021-10-29
---
|   |   |                                       |                                  |                                      |
|---|---|---------------------------------------|----------------------------------|--------------------------------------|
|   |   | [Up: Execution Context](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |

_**WARNING:**_ *this script isn't released yet ...*

_**TODO:**_
- enable `yaml` configuration file for complex arguments and generic script invocation
- enable standard tracking logs with performance metrics
- could be extended to include [MlFlow](https://mlflow.org/) [experiment tracking](https://mlflow.org/docs/latest/tracking.html) support.



Project "runner" Actions
=======================
The `./runner.sh` script
-------------------------

The [`runner.sh`](../../../../exec/runner.sh) script is the *"entry-point"* for 
project script execution.

Current behavior in to execute an executable `R` script name, 
that defaults to:

  `./exec/runner.R` : runs default script [`runner.R`](../../../../exec/runner.R) from project root

This `R` is a *"wrapper"* scripts, that supports execution tracking and logging around custom scripts 
(like [`dummy_runner.R`](../../../../exec/dummy_runner.R) in template example).


For `runner.sh` usage info:

```bash

./exec/runner.sh --help

# usage exec/runner.sh [-e r-script] [args, ...]

```



### Examples

```bash

./exec/runner.sh

```
