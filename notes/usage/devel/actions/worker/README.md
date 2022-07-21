---
title: Project "worker" Actions
subtitle: development environment actions
caption: worker.sh
author: --
date: 2021-10-29
---
|                                               |                                               |                                          |                                  |                                      |
|-----------------------------------------------|-----------------------------------------------|------------------------------------------|----------------------------------|--------------------------------------|
| [Next: Starter Actions](../starter/README.md) | [Prev: Runtime Actions](../runtime/README.md) | [Up: Development Commands](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |

**WARNING:** _this script isn't released yet ..._

Project "worker" Actions
=======================

The `./worker.sh` script
-----------------------

In `containerized` projects, the worker script embeds project contents in an executable image that can be executed locally or _"pushed"_ to a image registry to enable remote execution.

The [`worker.sh`](../../../../../worker.sh) script invokes (thru [`Makefile`](../../../../../decker/r-images/Makefile)) 
all: 

* [podman "build"](https://docs.podman.io/en/latest/markdown/podman-build.1.html) 
* [podman "push"](https://docs.podman.io/en/latest/markdown/podman-push.1.html) 
* [podman "pull"](https://docs.podman.io/en/latest/markdown/podman-pull.1.html) 
* [podman "run"](https://docs.podman.io/en/latest/markdown/podman-run.1.html) 

runtime actions for the project.

For `worker.sh`, usage info is shown by:

```bash

./worker.sh --help

# usage ./worker.sh target[,target,target ...]

```

_this script isn't released yet ..._

### Examples

```bash

./worker.sh pack,exec

```
