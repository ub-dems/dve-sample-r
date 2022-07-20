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
For "containerized" projects, tipically based on a "rocker project" image,
inheritance is specified in "anchor" image:

* [[/docker/r-images/](../../../../../../docker/r-images/dockerfiles/anchor.Dockerfile)]

default configuration specify `tidyverse` rolling release

```
FROM rocker/tidyverse:latest

```

