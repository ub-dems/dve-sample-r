---
title: File-system DATA Sources Setup
subtitle: filesystem data source setup
caption: Local data
author: --
date: 2021-10-29
---
|   |   |                                               |                               |                                   |
|---|---|-----------------------------------------------|-------------------------------|-----------------------------------|
|   |   | [Up: Data Source Configuration](../README.md) | [[Contents]](../../README.md) | [[Index]](../../_index/README.md) |

File-system DATA Sources Setup
===========================

## Project Directory Mapping

### Data Directories


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



### Examples

In [./exec/example_data_loader.R](https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r/-/blob/main/exec/example_data_loader.R), data usage example:

```R

dd_user  <- "inst/extdata/ext/dve-ds.def/examples/kaggle-pjm/raw"
dd_local <- "inst/extdata/ext/dve-ds.loc/examples/kaggle-pjm/raw"
dd_share <- "inst/extdata/ext/dve-ds.net/examples/kaggle-pjm/zip"

# ...

load_user_private_data <- function (){
  e$PJME_hourly_3y <- read_csv(paste(dd_user, "PJME_hourly-3y.csv", sep = "/"));
}

save_user_private_data <- function (){
  PJME_hourly_3y_tmp <- PJME_hourly %>% filter(Datetime >= as.Date("2016-01-01"),Datetime < as.Date("2019-01-01"))
  write_csv(PJME_hourly_3y_tmp, paste(dd_user, "PJME_hourly-3y.csv", sep = "/"));
}

load_host_local_data <- function (){
  e$PJME_hourly <- read_csv(paste(dd_local, "PJME_hourly.csv", sep = "/"), 
                               col_types = cols(Datetime = col_datetime(format = "%Y-%m-%d %H:%M:%S")));
}

```
