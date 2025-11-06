#!/usr/bin/env Rscript

##
# runner script example
#

#rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

library(logger)
library(optparse)

# =======================================
# Housekeeping Phase
# =======================================

SCRIPT_NAME <- "dummy-runner"

USAGE_DOC <- "

Usage:
  %prog [options] ...
---

"
DESC_DOC <- "
demo script for simple \"hello world\" package function call.

In aduition, some environment info are show in output:
   - system HW summary (taken by inxi command)
   - dependency packages availabe with versions
   - R sessionInfo() output


During initializaion ``
"


# =======================================
# Global variables
# =======================================

g_script_name <- SCRIPT_NAME
g_args <- NULL
g_log_dir <- NULL
g_log_prefix <- NULL
g_start_time <- NULL
g_rnd_seed <- NULL


# =======================================
# Housekeeping Phase
# =======================================


#' Parse command-line arguments
parse_arguments <- function(argv = c()) {

  p <- OptionParser(usage=USAGE_DOC)
  
  p <- add_option(p, c("-v", "--verbose"), type = "integer", action = "count", default = 0,
                  help = "Increase verbosity (-v: debug, -vv: trace) [default %default]")
  
  p <- add_option(p, c("-q", "--quiet"), action="store_true", default=FALSE,
                  help = "Suppress diagnostic output [default %default]")
  
  p <- add_option(p, "-u", "--seed", type = "integer", default = 0,
                     help = "Random seed for reproducibility (0 = random) [default %default]")

  args <- parse_args(p)
  return(args)
}



#' Script initialization
run_init <- function(argv = c()){
  args <- parse_arguments(argv)
  assign("g_args", args, envir = .GlobalEnv)
  init_script(g_script_name, args=args)

  assign("g_start_time", getOption("o_start_time"), envir = .GlobalEnv)
  assign("g_log_dir", getOption("o_log_dir"), envir = .GlobalEnv)
  assign("g_log_prefix", getOption("o_log_prefix"), envir = .GlobalEnv)
  assign("g_seed", getOption("o_rnd_seed"), envir = .GlobalEnv)
  
  return(args)
 
}

#' Script failure
run_fail <- function(rc = 1, ex = NULL, msg = "_undefined error_") {
  fail_script(g_script_name, rc = rc, ex = ex, msg = msg)
}

#' Script complention
run_exit <- function(rc = 0, msg = "success."){
  exit_script(g_script_name, rc = rc, msg = msg)
}

# =======================================
# Diagnostic Info
# =======================================

list_dependencies <- function() {

  pkgs <- data.frame()
  for(i in 1:(length((.packages())))){
    package <-(.packages())[i]
    version <- packageVersion(package)
    PV <- data.frame(package, version)
    pkgs <- rbind(pkgs,PV)
  }
  return (pkgs)
}

show_dependencies <- function() {
  
  pkgs <- list_dependencies()
  
  deps <- capture.output(print(pkgs))
  log_info("Dependencies: [[\n\n\n{deps}\n]]\n")
}



show_session_info <- function() {
  
  sx <- capture.output(sessionInfo())
  log_info("Session info: [[\n\n\n{sx}\n]]\n")
  
}


show_diagnostics <- function() {
  
  args <- g_args
  if (args$quiet) {
    return(0)
  }
  
  show_dependencies()
  show_session_info()


}


# =======================================
# Internal Package Call Demo
# =======================================

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


main <- function(argv = commandArgs(trailingOnly=TRUE)) {
  
  run_init(argv = argv)
  rc <- 0 
  tryCatch({
    log_info('#> start: %s', paste(argv,sep = " "))
    print(elapsed <- system.time({ rc <- task()  }))
    log_success('#< end(%d): %s', rc, summary(elapsed))
  }, error = function(ex) {
    run_fail(rc=1, ex=ex, msg="#FAILED!")
  })
  run_exit(rc, msg="#success.")
  rc
  
}

# Execute main function if script is run directly
if (sys.nframe() == 0) {
  main()
}
