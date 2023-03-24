#!/usr/bin/env Rscript

##
# targets pipeline runner
#

#rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(logging)
library(targets)

init_logging <- function(args = c()){
  log_init("pipeline-runner.log", args=args)
}


setup <- function(){
  prev_dir <- getwd()
  setwd_base()
  curr_dir <- getwd()
  logdebug('#? wd: %s  (was: %s)', curr_dir, prev_dir)
  0
}


task <- function(){
  targets::tar_make()
  0
}


main <- function(){
  args <- commandArgs(trailingOnly=TRUE)
  init_logging(args = args)
  loginfo('#> start: %s', paste(args,sep = " "))
  logdebug('#? args: %s', paste(commandArgs(),sep = ", "))
  rc <- 0 
  setup()
  print(elapsed <- system.time({ rc <- task()  }))
  loginfo('#< end(%d): %s', rc, with_digits(summary(elapsed)))
  rc
}

main()
