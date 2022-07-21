---
title: "legacy" development environmnt
subtitle: system package manager (apt) based setup
caption: devel - legacy
date: 2021-10-29
---
|                                                              |   |                                          |                                  |                                      |
|--------------------------------------------------------------|---|------------------------------------------|----------------------------------|--------------------------------------|
| [Next: "containerized" environment](../containers/README.md) |   | [Up: Development Overview](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |


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
