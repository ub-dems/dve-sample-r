---
title: "starter" actions
subtitle: development environment actions
author: --
date: 2021-10-29
---
|                                             |                                             |                                             |                            |                                |
|---------------------------------------------|---------------------------------------------|---------------------------------------------|----------------------------|--------------------------------|
| [Next: Runner Actions](../runner/README.md) | [Prev: Worker Actions](../worker/README.md) | [Up: Development Environment](../README.md) | [[Contents]](../README.md) | [[Index]](../_index/README.md) |


Project "starter" Actions
=======================
The `./starter.sh` script
-------------------------

The [`startup.sh`](../../../../startup.sh) script is the *"entry-point"* for 
project script execution or service startup (shiny, plumber).

Current behaviour in to execute n executable shell script name, 
that defaults to:

  `./exec/runner.sh` : runs default script `./exec/runner.R` from project root


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
