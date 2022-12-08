#!/usr/bin/env Rscript

##
# reader script example
#

rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(readr)
library(ggplot2)
library(dplyr)
library(lubridate)


library(logging)

init_logging <- function(args = c()){ log_init("dummy_reader.log", args=args) }


fn_path  <- function() { return("examples/kaggle-pjm") }

dd_def <- function(filename) { def_path(path=fn_path(), name=filename) }
dd_loc <- function(filename) { loc_path(path=fn_path(), name=filename) }
dd_net <- function(filename) { net_path(path=fn_path(), name=filename) }

dd_tmp <- function(filename) { tmp_path(name=filename) }
dd_log <- function(filename) { log_path(name=filename) }

dd_out <- dd_net


fn_net_PJME_hourly_z  <- function() { dd_net("zip/PJME_hourly.csv.zip") }
fn_loc_PJME_hourly    <- function() { dd_loc("raw/PJME_hourly.csv") }
fn_def_PJME_hourly_3y <- function() { dd_def("raw/PJME_hourly-3y.csv") }

fn_tmp_PJME_hourly    <- function() { dd_tmp("PJME_hourly.pdf") }
fn_tmp_PJME_hourly_3y <- function() { dd_tmp("PJME_hourly-3y.pdf") }

e <- globalenv()

log_info <- function(...) {
  msg <- .makeMessage(...)  
  text = paste(format(Sys.time(), "%c"), "| INFO  |", msg)
  message(text)
}

load_user_private_data <- function (){
  fn <- fn_def_PJME_hourly_3y()
  logdebug('# read_csv: %s', fn)
  e$PJME_hourly_3y <- read_csv(fn);
}

save_user_private_data <- function (){
  PJME_hourly_3y_tmp <- PJME_hourly %>% filter(Datetime >= as.Date("2016-01-01"),Datetime < as.Date("2019-01-01"))
  fn <- fn_def_PJME_hourly_3y()
  logdebug('# write_csv: %s', fn)
  write_csv(PJME_hourly_3y_tmp, fn);
}

get_zip_share_data <- function (){
  fz <- fn_net_PJME_hourly_z()
  loginfo('# read_csv: %s', fz)
  PJME_hourly_z <- read_csv(fz, 
                            col_types = cols(Datetime = col_datetime(format = "%Y-%m-%d %H:%M:%S")));
  PJME_hourly_z$Datetime = format(PJME_hourly_z$Datetime,format="%Y-%m-%d %H:%M:%S")
  fn <- fn_loc_PJME_hourly()
  loginfo('# write_csv: %s', fn)
  write_csv(PJME_hourly_z, fn);
}

load_host_local_data <- function (){
  fn <- fn_loc_PJME_hourly()
  logdebug('# read_csv: %s', fn)
  if (!file.exists(fn)) {
    get_zip_share_data()
  }
  e$PJME_hourly <- read_csv(fn, 
                     col_types = cols(Datetime = col_datetime(format = "%Y-%m-%d %H:%M:%S")));
}

show_user_private_data <- function (){
  View(PJME_hourly_3y)
}

show_host_local_data <- function (){
  View(PJME_hourly)
}

show_user_private_data <- function (){
  df <- PJME_hourly_3y
  sm <- summary(df)
  print(sm)
}

plot_user_private_data <- function (){
  df <- PJME_hourly_3y
  #nm <- names(PJME_hourly_3y)
  
  # Most basic bubble plot
  p <- ggplot(df, aes(x=Datetime, y=PJME_MW)) +
    geom_line() + 
    xlab("")
  pdf(fn_tmp_PJME_hourly_3y())
  print(p)  
}

plot_host_local_data <- function (){
  df <- PJME_hourly
  # nm <- names(PJME_hourly)
  
  # Most basic bubble plot
  p <- ggplot(df, aes(x=Datetime, y=PJME_MW)) +
    geom_line() + 
    xlab("")
  pdf(fn_tmp_PJME_hourly())
  print(p)  
}




task <- function(){
  loginfo('#> extract, ...')
  load_host_local_data()
  save_user_private_data()
  loginfo('#< extract, done')
  loginfo('#> load, ...')
  load_user_private_data()
  loginfo('#> load, done.')
  loginfo('#> transform, ...')
  show_user_private_data()
  plot_user_private_data()
  plot_host_local_data()
  loginfo('#< transform,done.')
  0
}

main <- function(){ 
  args <- commandArgs(trailingOnly=TRUE)
  init_logging(args = args)
  loginfo('#> start: %s', paste(args,sep = " "))
  logdebug('#? args: %s', paste(commandArgs(),sep = ", "))
  log_info("#start")
  rc <- 0 
  print(elapsed <- system.time({ rc <- task()  }))
  loginfo('#< end(%d): %s', rc, summary(elapsed))
  rc
}

main()

