#!/usr/bin/env Rscript

##
# reader script example
#

#rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(logging)

init_logging <- function(args = c()){ log_init("dummy-reader.log", args=args) }

log_info <- function(...) {
  msg <- .makeMessage(...)  
  text = paste(format(Sys.time(), "%c"), "| INFO  |", msg)
  message(text)
}



task <- function(args = commandArgs(trailingOnly=TRUE)){
  fn <- dmy_p01_main(args)
  loginfo('#+ states: %s', paste(fn,sep = " "))
  0
}

main <- function(args = commandArgs(trailingOnly=TRUE)){ 
  init_logging(args = args)
  loginfo('#> start: %s', paste(args,sep = " "))
  logdebug('#? args: %s', paste(commandArgs(),sep = ", "))
  log_info("#start")
  rc <- 0 
  print(elapsed <- system.time({ rc <- task(args) }))
  loginfo('#< end(%d): %s', rc, summary(elapsed))
  rc
}

main()

