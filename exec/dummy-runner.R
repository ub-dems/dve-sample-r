#!/usr/bin/env Rscript

##
# runner script example
#

#rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(logging)

init_logging <- function(args = c()){
  log_init("dummy-runner.log", args=args)
}



v <- function(...) cat(sprintf(...), "\n", sep=' ', file=stderr())
s <- function(...) do.call(paste,as.list(c(..., sep=", ")))

scall <- function (){
  c(
    dmy_hello(),
    dmy_hello("Earth"),
    dmy_hello("Moon", "'Night")
  )
}

vcall <- function (){
  dmy_hello(c(
    "Mars",
    "Venus"
  ))
}

task <- function(){
  v("scall: %s", s(scall()))
  v("vcall: %s", s(vcall()))
  0
}


main <- function(){
  args <- commandArgs(trailingOnly=TRUE)
  init_logging(args = args)
  loginfo('#> start: %s', paste(args,sep = " "))
  logdebug('#? args: %s', paste(commandArgs(),sep = ", "))
  print(sx <- sessionInfo())
  logfinest(sx)
  rc <- 0 
  print(elapsed <- system.time({ rc <- task()  }))
  loginfo('#< end(%d): %s', rc, summary(elapsed))
  rc
}

main()
