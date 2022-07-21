---
title: Project Quick Start
subtitle: Basic configuration
caption: Quick Start
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
For "containerized" projects, typically based on a ["rocker project" image](https://rocker-project.org/images/), inheritance is specified in "anchor" image:

* [docker/r-images/dockerfiles/anchor.Dockerfile](../../../../../../docker/r-images/dockerfiles/anchor.Dockerfile)

Default configuration specifies `tidyverse` rolling release:

```
FROM rocker/tidyverse:latest
```

Then, additional libraries can be included in runtime image.
Custom runtime installation is provided by the script:

* [docker/r-images/scripts/runtime/install_ubs-runtime.sh](../../../../../../docker/r-images/scripts/runtime/install_ubs-runtime.sh)


### Runtime Image Build

Next step is to build "runtime" image with this specification:

```bash
./build.sh setup
```

### Runtime Image Start

After successful build, runtime image can be started, with one of "runtime.sh" commands.

```bash
# to start RStudio Server
./runtime.sh

# to start R (console-mode)
./runtime.sh r

# for script usage help
./runtime.sh --help

```

Running RStudio Server is available at:

- http://localhost:28787

with credentials:

|              |                                                 |
| ------------ | ----------------------------------------------- |
| **user**     | `root`                                          |
| **password** | *default remote user password (generated)* [^1] |

[^1]: please contact support for details


### Runtime Volume Mapping

Inside runtime environment (R,RStudio), virtual file-system _"mounts"_  these user directories at the same path in the running container:

```
 ~/work => ~/work
 ~/data => ~/data
``` 

Runtime volume mapping is described in:

* [DEVELOPMENT Environment](../devel/actions/runtime/README.md)


### Dependency Configuration

In order to declare package dependencies, it is required to list package dependencies, under "Imports" or "Suggest" section, in:

* [DESCRIPTION](../../../../../../DESCRIPTION)

To avoid warning related to *"unused imported package"*, the `@importFrom` can be added to `package reference` R source in:

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

After configuration, project status can be verified with the command:

```bash
./build.sh all
```


