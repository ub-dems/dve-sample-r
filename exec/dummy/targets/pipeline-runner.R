#!/usr/bin/env Rscript

##
# targets pipeline runner
#

#rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(logging)
library(targets, warn.conflicts = FALSE)

# ////////////////////////////////////////////////////////////////////////////

log_file <- function(fn) {
  result <- io_logs(name=fn)
  return(result)
}

#' @keywords internal
#' @noRd
log_dir <- function() {
  logfile <- log_file("logfile.log")
  result <- dirname(logfile)
  return(result)
}

#' init logging
#'
#' @param logfile String logfile under logs/ (.gitignored) dir
#' @param args list args, defaults to command-line arg
#' @param log_level String appender logging level
#' @param file_level String logfile logging level
#' @param out_level String console logging level
#' @export
log_init <- function(logfile = "logfile.log", args = c(), log_level='DEBUG', file_level='DEBUG', out_level='INFO'){
  logging::basicConfig()
  logging::setLevel(log_level)
  dir.create(log_dir(), showWarnings = FALSE, recursive = TRUE)  
  logging::addHandler(logging::writeToFile, file=log_file(logfile), level=file_level)
  logging::setLevel(Sys.getenv("R_LOGGING_LEVEL", out_level), getHandler("basic.stdout"))
}

# ////////////////////////////////////////////////////////////////////////////


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
  loginfo('#< end(%d): %s', rc, summary(elapsed))
  # loginfo('#< end(%d): %s', rc, with_digits(summary(elapsed)))
  rc
}

main()
