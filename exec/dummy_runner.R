rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(logging)

init_logging <- function(args = c()){
  logging::basicConfig()
  logging::setLevel("DEBUG")
  dir.create("./logs", showWarnings = FALSE, recursive = TRUE)  
  logging::addHandler(logging::writeToFile, file="./logs/dummy_runner.log", level='DEBUG')
  logging::setLevel(Sys.getenv("R_LOGGING_LEVEL", "INFO"), getHandler("basic.stdout"))
}



v <- function(...) cat(sprintf(...), "\n", sep=' ', file=stderr())
s <- function(...) do.call(paste,as.list(c(..., sep=", ")))

scall <- function (){
  c(
    dummy_hello(),
    dummy_hello("Earth"),
    dummy_hello("Moon", "'Night")
  )
}

vcall <- function (){
  dummy_hello(c(
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
