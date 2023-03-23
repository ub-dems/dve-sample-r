##
# sample reader script functions, referenced in _targets.R pipeline
#

## library(readr)
## library(ggplot2)
## library(dplyr)
## library(lubridate)

## library(logging)
## library("modules")

m <- modules::module({

fn_path  <- function() { return("examples/kaggle-pjm") }

dd_def <- function(filename) { def_path(path=fn_path(), name=filename) }
dd_loc <- function(filename) { loc_path(path=fn_path(), name=filename) }
dd_net <- function(filename) { net_path(path=fn_path(), name=filename) }

dd_tmp <- function(filename) { tmp_path(name=filename) }
dd_log <- function(filename) { log_path(name=filename) }

dd_out <- dd_net
  
})

dmy_fn_net_PJME_hourly_z  <- function() { m$dd_net("zip/PJME_hourly.csv.zip") }
dmy_fn_loc_PJME_hourly    <- function() { m$dd_loc("raw/PJME_hourly.csv") }
dmy_fn_def_PJME_hourly_3y <- function() { m$dd_def("raw/PJME_hourly-3y.csv") }

dmy_fn_tmp_PJME_hourly    <- function() { m$dd_tmp("PJME_hourly.pdf") }
dmy_fn_tmp_PJME_hourly_3y <- function() { m$dd_tmp("PJME_hourly-3y.pdf") }

dmy_fn_txt_PJME_hourly    <- function() { m$dd_tmp("PJME_hourly.txt") }
dmy_fn_txt_PJME_hourly_3y <- function() { m$dd_tmp("PJME_hourly-3y.txt") }


dmy_fn_sts_p01_proc_task  <- function() { m$dd_tmp("dmy_p01_task.sts") }
dmy_fn_sts_p01_proc_main  <- function() { m$dd_tmp("dmy_p01_main.sts") }


