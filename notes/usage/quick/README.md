---
title: Project Quick Start
subtitle: Basic configuration
author: --
date: 2021-10-29
---
|                                                     |   |                           |                            |                                |
|-----------------------------------------------------|---|---------------------------|----------------------------|--------------------------------|
| [Next: DEVELOPMENT Environment](../devel/README.md) |   | [Up: Usage](../README.md) | [[Contents]](../README.md) | [[Index]](../_index/README.md) |

Project Quick Start
-------------------

### Project Runtime Dependencies

Before initial runtime image build, runtime inheritance must be checked.
For "containerized" projects, tipically based on a ["rocker project" image](https://rocker-project.org/images/),
inheritance is specified in "anchor" image:

* [docker/r-images/dockerfiles/anchor.Dockerfile](../../../../../../docker/r-images/dockerfiles/anchor.Dockerfile)

Default configuration specifies `tidyverse` rolling release:

```
FROM rocker/tidyverse:latest

```

Then check for additional installation steps, to be included in runtime image.
Custom runtime installation is provided by the script:

* [docker/r-images/scripts/runtime/install_ubs-runtime.sh](../../../../../../docker/r-images/scripts/runtime/install_ubs-runtime.sh)


### Runtime Image Build

Next step is to build "runtime" image with this specification:

```bash

./build.sh setup

```

### Runtime Image Start

After successfud build, runtime image can be started, with one of "runtime.sh" commands.

```bash

# to start RStudio
./runtime.sh

# to start R (console-mode)
./runtime.sh r

# for script usage help
./runtime.sh --help

```


### Dependency Configuration


In order to declare package dependencies, it is required to list package dependencies, under "Imports" or "Suggest" section,
in:

* [DESCRIPTION](../../../../../../DESCRIPTION)

To avoid warning related to "unused imported package", the `@importFrom` 
can be added to `package reference` R source in:

* [R/"package-name".R](../../../../../../R)

```R

#' @description
#' To learn more about simlab, start with the vignettes:
#' `browseVignettes(package = "<package-name>")`
#' @keywords internal
"_PACKAGE"

# Suppress R CMD check note
#' @importFrom logging loginfo
#' ...
#' @importFrom yaml as.yaml
NULL


```


### Check Project Validity

After configuration, project stat can be verifid with the command:

```bash

./build.sh all

```


