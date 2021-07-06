##
# data reader
#

rm(list=ls())
devtools::load_all(".") # caricatì tutti quelli che sono script


require(ldcnrgrp60)

library(readr)
library(ggplot2)
library(dplyr)
library(lubridate)


dd_user  <- "inst/extdata/ext/nrg-rp.def/examples/kaggle-pjm/raw"
dd_local <- "inst/extdata/ext/nrg-rp.loc/examples/kaggle-pjm/raw"
dd_share <- "inst/extdata/ext/nrg-rp.net/examples/kaggle-pjm/zip"

e <- globalenv()

load_user_private_data <- function (){
  e$PJME_hourly_3y <- read_csv(paste(dd_user, "PJME_hourly-3y.csv", sep = "/"))
}

save_user_private_data <- function (){
  PJME_hourly_3y_tmp <- PJME_hourly %>% filter(Datetime >= as.Date("2016-01-01"),Datetime < as.Date("2019-01-01"))
  write_csv(PJME_hourly_3y_tmp, paste(dd_user, "PJME_hourly-3y.csv", sep = "/"))
}

load_host_local_data <- function (){
  e$PJME_hourly <- read_csv(paste(dd_local, "PJME_hourly.csv", sep = "/"), 
                               col_types = cols(Datetime = col_datetime(format = "%Y-%m-%d %H:%M:%S")))
}

show_user_private_data <- function (){
  View(PJME_hourly_3y)
}

show_host_local_data <- function (){
  View(PJME_hourly)
}

plot_user_private_data <- function (){
  df <- PJME_hourly_3y
  nm <- names(PJME_hourly_3y)
  
  # Most basic bubble plot
  p <- ggplot(df, aes(x=Datetime, y=PJME_MW)) +
    geom_line() + 
    xlab("")
  print(p)  
}

plot_host_local_data <- function (){
  df <- PJME_hourly
  nm <- names(PJME_hourly)
  
  # Most basic bubble plot
  p <- ggplot(df, aes(x=Datetime, y=PJME_MW)) +
    geom_line() + 
    xlab("")
  print(p)  
}



main <- function(){ 
  load_host_local_data()
  save_user_private_data()
  load_user_private_data()
  plot_user_private_data()
  plot_host_local_data()
  0
}

main()

