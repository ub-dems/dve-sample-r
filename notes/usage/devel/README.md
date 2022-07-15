---
title: DEVELOPMENT Cheat Sheet
subtitle: development environment actions
author: --
date: 2021-10-29
---
aaaa


| - | - | - |
| [Next: Data Configuration](../data/README.md) | [Up: Usage](../README.md) | [[Contents]](../../README.md) |
------------------------------------------------------------------------------------------------------------

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


Development Commands (Actions)
------------------------------

The development environment defines several actions for the projects, grouped in 4 categories:

- "build" actions: to initialize project runtime environment and to runs checks and tests
- "runtime" actions: for "containerized" projects only, to control R/RStudio (customized) container execution
- "worker" actions: for "containerized" projects only, to embend and run project code in a executable image 
- "starter" actions: project execution "entry-point", to trigger scripts invocations or service startup (shiny, plumber)


Project "build" Actions
=======================
The `./build.sh` script
-----------------------


The build script invokes all `devtools` actions for the project.

In `containerized` projects, provides actions for runtime image preparation.

For `build.sh` usage info:

```bash

./build.sh --help

# usage ./build.sh target[,target,target ...]

```

Project "standard" (devtools) actions
-------------------------------------

  
`help`
: describe "targets" (actions)
  
`all`
: make: "init,check,test,docs,build"  targets

`clean`
: clean generated build files

`init`
: initialize local (temp,logs) directories

`check`
: runs: `devtools::check()`

`test`
: runs: `devtools::test()`

`docs`
: make: "man,readme,vignettes"  targets

`man`
: runs: `devtools::document()`

`vignettes`
: runs: `devtools::build_vignettes()`

`readme`
: runs: `knitr::knit("README.Rmd")`

`build`
: runs: `devtools::build()`

`install`
: runs: `devtools::install()`

`uninstall`
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


Project "(containerized) runtime" (podman) actions
--------------------------------------------------

`setup`
: initial build of all runtime images

`update`
: rebuild of modified runtime images

`upgrade`
: fresh rebuild of all runtime images (pull)



### Examples

```bash

./build.sh setup
./build.sh update
./build.sh upgrade

```


Project "runtime" Actions
=======================
The `./runtime.sh` script
-----------------------


In `containerized` projects, the runtime script enter the execution context 
enabling developmet activities on the project.

This execution environment, internal in running container, shares filesystemm 
project folder with external (native) calling environment.


For `runtime.sh` usage info:

```bash

./runtime.sh --help

# usage ./runtime.sh [target] [args, ...]


```

Runtime actions (containerized)
-------------------------------

`rstudio` (default), aliases: `ide`, `RStudio`
: runs rstudio-server bound on port 28787

`repl`, aliases: `r`, `R`
: runs interactive R console

`cli`, aliases: `rscript`, `Rscript`
: runs interactive shell prompt

`shell`, aliases: `sh`, `prompt`
: runs interactive shell prompt

`bash`, aliases: `do`, `command`
: runs shell with args,...

`term`, aliases: `in`, `attach`
: attach interactive shell to running runtime



Runtime Drive Mapping
---------------------

default volume mapping:

```
 ~/work => ~/work
 ~/data => ~/data
``` 

*userid*
`user:group` UID:GID => `root:root` (0:0)

*path*:
  `~` := `/home/$USER` => `~` := `/root` (volatile, not shared)

*workdir*: 
   `/root/work/../....`: current project directory


### Examples

#### RStudio

```bash

./runtime.sh

./runtime.sh ide
./runtime.sh rstudio
./runtime.sh RStudio

```
then (depending on connection client),

- if X2Go,

```bash
   chromium-browser http://localhost:28787
```

- if nomachine,

```bash
firefox http://localhost:28787
```

- if remote (with ssh port forwarding) from remote PC

```bash
   ssh -L28787:localhost:28787 user@vm 

```
then open in browser: http://localhost:28787


RStudio login with user `root`, and default user password as password 
_(please contact support fot details)_

#### R Console

```bash
 ./runtime.sh repl
 ./runtime.sh r
 ./runtime.sh R
``` 

then check 'getwd()' and exit 'q()'


R Script
---------

```bash
 ./runtime.sh cli     exec/dummy_runner.R
 ./runtime.sh rscript exec/dummy_runner.R
 ./runtime.sh Rscript exec/dummy_runner.R
```

to run scripts from ./exec directory 


Shell Prompt
------------

```
 ./runtime.sh sh
 ./runtime.sh shell
 ./runtime.sh prompt
``` 
for interactive shell prompt

Shell Command
-------------

or with command args

```bash
 ./runtime.sh do bash -c 'echo "$$(date)" ; df -h ; ip a'
 ./runtime.sh do ( inxi -F | grep -i nvidia )
 ./runtime.sh do whoami
``` 
to run execute shell commands







Project "worker" Actions
=======================
The `./worker.sh` script
-----------------------

In `containerized` projects, the worker script embeds project contents in an executable image 
that can be executed locally or _"pushed"_ to a image registry to enable remote execution.

For `worker.sh` usage info:

```bash

./worker.sh --help

# usage ./worker.sh target[,target,target ...]

```

_this script isn't released yet ..._

### Examples

```bash

./worker.sh pack,exec

```

Project "starter" Actions
=======================
The `./starter.sh` script
-------------------------

This script is the entry-point" for project script execution or service startup (shiny, plumber).

Current ehaviour in to execute an executable shell script name, 
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


Legacy DIRECT Environment
=========================
Environment Setup
-----------------
### Libraries

To search available packages:

```bash

sudo apt search ^r- | less
sudo apt search ^r- | grep -P -i -e 'str.*r' -e '^tidy'

# to install CRAN binaries (system level)

# sudo apt install  apt-package-name ...



# to install from sources (user level)

# install.r LMest

# R -e 'devtools::install("...")'
# R -e 'devtools::install_github("...")'
# R -e 'devtools::install_gitlab("...")'

# 

```
### Examples

```bash

# system install
sudo apt install r-cran-stringr

# user install
# install.r LMest

```


```R

# base
library(stringr)

sessionInfo()

```

