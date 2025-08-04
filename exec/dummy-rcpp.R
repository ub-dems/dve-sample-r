#!/usr/bin/env Rscript

##
# runner script example
#

#rm(list=ls())
devtools::load_all(".") 

library(dvesimpler)

library(logging)
library(Rcpp)
library(RcppArmadillo)
library(microbenchmark)

init_logging <- function(args = c()){
  log_init("dummy-rcpp.log", args=args)
}

cap <- function(args = c()){
   return paste(capture.output(print(args)),collapse = "\n") 
}

arma_threads <- function(){
  n <- armadillo_get_number_of_omp_threads()
  return sprintf("OMP Threads: %d\n",n)
}



v <- function(...) cat(sprintf(...), "\n", sep=' ', file=stderr())
s <- function(...) do.call(paste,as.list(c(..., sep=", ")))


cppFunction('double dmy_l_mean(NumericVector x) {
  int n = x.size();
  double total = 0;

  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total / n;
}')


lcall <- function (){
  x <- runif(1e5)
  c( arma_threads(),
     paste(capture.output(print( 
       microbenchmark(
        mean(x),
        dmy_l_mean(x)
     ))), collapse = "\n"))
}

pcall <- function (){
  x <- runif(1e5)
 c( arma_threads(),
    paste(capture.output(print( 
      microbenchmark(
      mean(x),
      dmy_mean(x)
    ))), collapse = "\n"))
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
  rc <- 0 
  print(elapsed <- system.time({ rc <- task()  }))
  loginfo('#< end(%d): %s', rc, summary(elapsed))
  rc
}

main()
