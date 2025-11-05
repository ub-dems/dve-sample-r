#!/usr/bin/env Rscript

##
# runner script example
#

#rm(list=ls())
devtools::load_all(".") 

library(dvesimpler)

library(logging)
library(argparse)
library(Rcpp)
library(RcppArmadillo)
library(microbenchmark)

# /////////////////////////////////////////////////////////////

def_args <- function() {
  args <- list(
    verbose= FALSE,
    debug= FALSE,
    size= 10000,
    times=20
  )
  return (args)
}

parse_args <- function(args = c()) {
  defaults <- def_args()

  parser = argparse::ArgumentParser(
    description="dummy-rcpp-iter.R: test Rcpp module ../src/dummy_mean.cpp"
  )
  parser$add_argument("--verbose", "-v", action="count", default=defaults$verbose, help="verbose level")
  parser$add_argument("--debug", action="store_true", default=defaults$debug, help="debug mode")
  
  parser$add_argument(
    "-s",
    "--size",
    type="integer",
    default=defaults$size,
    dest="size",
    help="Size of test vector  [default %default]"
  )
  parser$add_argument(
    "-t",
    "--times",
    type="integer",
    default=defaults$times,
    dest="times",
    help="MIST epochs"
  )
  parser$add_argument(
    "-b",
    "--batch_size",
    type="integer",
    default=defaults$batch_size,
    dest="batch_size",
    help="Number of runs in benchmark [default %default]"
  )

  Args <- parser$parse_args(args)
  return (Args)
}


init_options <- function(args){
  Args <<- parse_args(args)
  options(Args = Args)
  logdebug('#? argv: %s', paste(commandArgs(),sep = ", "))
  logdebug('#? args: %s', paste(str(Args),sep = ", "))
}

init_logging <- function(args = c()){
  log_init("dummy-rcpp-iter.log", args=args)
}

init_script <- function(args = commandArgs(trailingOnly=TRUE)){
  init_logging(args = args)
  init_options(args = args)
}

cap <- function(xs = c()){
   paste(capture.output(print(xs)),collapse = "\n")
}

# /////////////////////////////////////////////////////////////


arma_threads <- function(){
  n <- armadillo_get_number_of_omp_threads()
}


cppFunction('double dmy_l_mean(NumericVector x) {
  int n = x.size();
  double total = 0;

  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total / n;
}')


mean_test <- function (){
  times <- Args$times
  size <- Args$size
  x <- runif(size)
  b <- microbenchmark(
      mean(x),
      dmy_l_mean(x),
      dmy_mean(x),
      times = times
  )
  print (b)
}

task <- function(){

  loginfo("OMP Threads: %d", arma_threads())

  mean_test()

  0
}



# /////////////////////////////////////////////////////////////

main <- function(args = commandArgs(trailingOnly=TRUE)){
  init_script(args = args)
  loginfo('#> start: %s', paste(str(args),sep = " "))
  rc <- 0 
  print(elapsed <- system.time({
    rc <- task()
  }))
  loginfo('#< end(%d): %s', rc, summary(elapsed))
  rc
}

main()
