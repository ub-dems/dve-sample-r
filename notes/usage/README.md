---
title: project Cheat Sheet
subtitle: quick start meno
author: --
date: 2021-10-29
---

Project Quick Start
===================


DEVELOPMENT Environment
=======================

Project Actions
---------------


### `./build.sh` script


#### Project "global" (container) actions


`setup`
: aaaa

`update`
: aaaa

`upgrade`
: aaaa


#### Project "standard" (devtools) actions

`all`
: aaaa

`clean`
: aaaa

`check`
: aaaa

`test`
: aaaa

`roxygen`
: aaaa

`vignettes`
: aaaa

`readme`
: aaaa

`build`
: aaaa

`install`
: aaaa





#### Examples

```bash


##
# project "global" actions
#

./build.sh setup
./build.sh update
./build.sh upgrade



##
# project "standard" actions
#

./build.sh all
./build.sh clean
./build.sh check
./build.sh test
./build.sh roxygen
./build.sh vignettes
./build.sh readme
./build.sh build
./build.sh install





```





DATA Sources
============


### data directories


Data directories are accessible under a path relative to the base project directory:

* data path: `inst/extdata/ext`


Under this path:

* user writable working data dir: `inst/extdata/ext/nrg-rp.def`
* local machine (read-only) input data dir: `inst/extdata/ext/nrg-rp.loc`
* network shared (slow/archive) data dir: `inst/extdata/ext/nrg-rp.net`

*WARNING*

External data path: `inst/extdata/ext` is ignored by git.

Internal data path: `inst/extdata/int` can be committed in git repository. Intended _only_ for *small* files, used in automatic test or for demo scripts.




### listing external data directories

```bash
# go to project base dir
cd ~/work/vs/dve-sample-r

# show data

find -L inst/extdata/
find -L inst/extdata/ext -type d -exec ls -ld {} \;
find -L inst/extdata/ext -type f -exec ls -lh {} \;

```

* [./inst/extdata/] 



**NOTE**

It should be avoided to use path references relative to:

   * home directory: `~/data/...`
   * root (absolute): `/store/local/dd/...`
   * home (absolute): `/home/un21000/data/local/dd/...`




Environment Setup
-----------------

### Libraries


```bash

sudo apt search ^r- | less
sudo apt search ^r- | grep -P -i -e 'str.*r' -e '^tidy'



sudo apt install r-cran-stringr

# R -e 'install.packages("LMest")'



```


```R

# base
library(stringr)


sessionInfo()


```

### Project


```bash

mkdir -p ~/work/vs
cd       ~/work/vs

git clone git@gitlab.com:ub-dems-public/ds-labs/dve-sample-r.git

```

## Build


####  Rebuld

```bash
R CMD INSTALL --preclean --no-multiarch --with-keep.source dve-sample-r
```

####  ReLoad

```R
devtools::load_all(".")
```


####  Document

```R
devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
```

####  Verify

```R
# test
devtools::test()

# check
devtools::check()
```



####  Package

```R

# source package
devtools::build()

#binary package
devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
devtools::build(binary = TRUE, args = c('--preclean'))

```


## Usage

#### exec scripts

```bash
# go to project base dir
cd ~/work/vs/dve-sample-r

# run batch scripts
Rscript exec/dummy_runner.R

```


---

