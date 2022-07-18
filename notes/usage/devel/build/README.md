---
title: "build" actions
subtitle: development environment actions
author: --
date: 2021-10-29
---
|                                               |                           |                               |                        |
|-----------------------------------------------|---------------------------|-------------------------------|------------------------|
| [Next: Runtime Actions](../runtime/README.md) | [Up: Development Environment](../README.md) | [[Contents]](../README.md) | [[Index]](../_index/README.md) |

Project "build" Actions
=======================

The `./build.sh` script
-----------------------

The [`build.sh`](../../../../build.sh) script invokes (thru [`Makefile`](../../../../Makefile)) 
all `devtools` actions for the project.

In `containerized` projects, provides actions for runtime image preparation.

For `build.sh` usage info:

```bash

./build.sh --help

# usage ./build.sh target[,target,target ...]

```

Project "standard" (devtools) actions
-------------------------------------

  
/**help**/
: describe "targets" (actions)
  
/*all*/
: make: "init,check,test,docs,build"  targets

**clean**
: clean generated build files

**init**
: initialize local (temp,logs) directories

**check**
: runs: `devtools::check()`

**test**
: runs: `devtools::test()`

**docs**
: make: "man,readme,vignettes"  targets

**man**
: runs: `devtools::document()`

**vignettes**
: runs: `devtools::build_vignettes()`

**readme**
: runs: `knitr::knit("README.Rmd")`

**build**
: runs: `devtools::build()`

**install**
: runs: `devtools::install()`

**uninstall**
: runs: `devtools::uninstall()`


### Examples

```bash

./build.sh all
./build.sh clean
./build.sh init
./build.sh check
./build.sh test
./build.sh docs
./build.sh man
./build.sh vignettes
./build.sh readme
./build.sh build
./build.sh install
./build.sh uninstall

./build.sh check,test
./build.sh man,readme

```


