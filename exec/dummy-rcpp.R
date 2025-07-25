#!/usr/bin/env Rscript

##
# runner script example
#

#rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(logging)
library(Rcpp)
library(RcppArmdillo)
library(microbenchmark)

init_logging <- function(args = c()){
  log_init("dummy-rcpp.log", args=args)
}



v <- function(...) cat(sprintf(...), "\n", sep=' ', file=stderr())
s <- function(...) do.call(paste,as.list(c(..., sep=", ")))


cppFunction('double dummy_local_mean(NumericVector x) {
  int n = x.size();
  double total = 0;

  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total / n;
}')


lcall <- function (){
  x <- runif(1e5)
  c( armadillo_get_number_of_omp_threads(),
    microbenchmark(
      mean(x),
      dummy_local_mean(x)
    ))
}

pcall <- function (){
  x <- runif(1e5)
 c( armadillo_get_number_of_omp_threads(),
   microbenchmark(
     mean(x),
     dummy_mean(x)
   ))
}

task <- function(){
  v("pcall: %s", s(pcall()))
  v("lcall: %s", s(lcall()))
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
