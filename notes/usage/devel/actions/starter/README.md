---
title: Project "starter" Actions
subtitle: development environment actions
caption: starter.sh
author: --
date: 2021-10-29
---
|   |                                             |                                          |                                  |                                      |
|---|---------------------------------------------|------------------------------------------|----------------------------------|--------------------------------------|
|   | [Prev: Worker Actions](../worker/README.md) | [Up: Development Commands](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |


Project "starter" Actions
=======================

The `./starter.sh` script
---------------------

The [`starter.sh`](../../../../../starter.sh) script is the *"entry-point"* for 
project script execution or service startup (shiny, plumber).

Current behavior in to execute an executable shell script name, that defaults to:

  `./exec/runner.sh` : runs default script [`runner.sh`](../../../../../exec/runner.sh) from project root

See also:
* ["runner" actions](../../exec/runner/README.md) 


For `starter.sh` usage info:

```bash

./starter.sh --help

# usage ./starter.sh [-x script] [args, ...]

```

_this script isn't released yet ..._

### Examples

```bash

./starter.sh

```
