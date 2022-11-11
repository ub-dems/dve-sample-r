#!/usr/bin/env Rscript

##
# data reader
#
rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(readr)
library(ggplot2)
library(dplyr)
library(lubridate)


dd_user  <- "inst/extdata/ext/dve-ds.def/examples/kaggle-pjm/raw"
dd_local <- "inst/extdata/ext/dve-ds.loc/examples/kaggle-pjm/raw"
dd_share <- "inst/extdata/ext/dve-ds.net/examples/kaggle-pjm/zip"

e <- globalenv()

log_info <- function(...) {
  msg <- .makeMessage(...)  
  text = paste(format(Sys.time(), "%c"), "| INFO  |", msg)
  message(text)
}

mkdirs <- function(fp) {
  if (!file.exists(fp)) {
    mkdirs(dirname(fp))
    dir.create(fp)
  }
}

load_user_private_data <- function (){
  e$PJME_hourly_3y <- read_csv(paste(dd_user, "PJME_hourly-3y.csv", sep = "/"));
}

save_user_private_data <- function (){
  PJME_hourly_3y_tmp <- PJME_hourly %>% filter(Datetime >= as.Date("2016-01-01"),Datetime < as.Date("2019-01-01"))
  mkdirs(dd_user)
  write_csv(PJME_hourly_3y_tmp, paste(dd_user, "PJME_hourly-3y.csv", sep = "/"));
}

load_host_local_data <- function (){
  e$PJME_hourly <- read_csv(paste(dd_local, "PJME_hourly.csv", sep = "/"), 
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
  print(p)  
}

plot_host_local_data <- function (){
  df <- PJME_hourly
  # nm <- names(PJME_hourly)
  
  # Most basic bubble plot
  p <- ggplot(df, aes(x=Datetime, y=PJME_MW)) +
    geom_line() + 
    xlab("")
  print(p)  
}



main <- function(){ 
  log_info("#start")
  load_host_local_data()
  save_user_private_data()
  load_user_private_data()
  show_user_private_data()
  plot_user_private_data()
  plot_host_local_data()
  log_info("#end")
  0
}

main()

