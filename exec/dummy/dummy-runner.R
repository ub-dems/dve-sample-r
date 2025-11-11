#!/usr/bin/env Rscript

##
# runner script example
#
rm(list = ls())
devtools::load_all(".")

require(dvesimpler)

# Load required libraries
suppressPackageStartupMessages({
  library(logger)
  library(optparse)
})

# =======================================
# Housekeeping Phase
# =======================================

c_script_name <- "dummy-runner"

c_usage_doc <- "

  'runtime' exec/dummy/%prog.R [options] ...

In RStudio, the script can be run directly, always from project root,
in console, or in terminal. 

```
exec/dummy/dummyRunner.R [options] ...
```

For long running scripts,
it is better to run the script directly in command line,
inside a tmux session, to avoid disconnection interruption.
In this mode, 'runtime', from the project root, can be one of:

```sh
./runtime.sh cli exec/dummy/dummyRunner.R [options] ...
./runtime.sh sh  exec/dummy/dummyRunner.R [options] ...
```

In order to keep a complete log of script execution,
in `~/aliases`, the `rrun` function can be defined:

```sh
rrun() {
 export RR_PID=$$
 export RR_TS=$(date -Isec)
 export RR_LOG=\"logs/rrun-$(date -Isec)-$RR_PID.log\"
 ( echo \"$(date),#RRUN($RR_PID)>,ARGS=$@\"; \
   ./runtime.sh cli $@; rc=$?; \
   echo \"$(date),#RRUN($RR_PID)<,rc=$rc,ARGS=$@\") 2>&1 \
  | tee -a $RR_LOG
  echo \"$(date),#RRUN($RR_PID):rc=$rc Logfile: $RR_LOG\"
  ls -l  $RR_LOG
}
```

with this function, the script can be run as:

```sh
rrun exec/dummy/dummyRunner.R [options] ...
```

Examples:

```sh

./runtime.sh cli exec/dummy/dummyRunner.R --help
./runtime.sh cli exec/dummy/dummyRunner.R -v

rrun exec/dummy/dummyRunner.R -q alice bob

```

---

"
c_desc_doc <- "

DESCRIPTION

Demo script for simple \"hello world\" package function call.

In addition, some environment info are show in output logfile:
   - system HW summary (taken by inxi command)
   - dependency packages availabe with versions
   - R sessionInfo() output
To avoid diagnostics, run the script with the `-q,--quiet` option.


To show last log ('q' for exit) run the command:

```sh
less -SRX $(ls logs/%prog* -t | head -n1)
```

"
c_trailer_doc <- "

SEE ALSO:

   @Seealso: R/ioinit.R
   @Seealso: R/ioutils.R

"


# =======================================
# Global variables
# =======================================

g_script_name <- c_script_name
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

  p <- OptionParser(prog = g_script_name, usage = c_usage_doc,
                    description = c_desc_doc, epilogue = c_trailer_doc)
  
  p <- add_option(p, c("-v", "--verbose"), action = "store_true", default = FALSE,
                  help = "Increase verbosity (-v: debug, -vv: trace) [default %default]")
  
  p <- add_option(p, c("-q", "--quiet"), action = "store_true", default = FALSE,
                  help = "Suppress diagnostic output [default %default]")
  
  p <- add_option(p, c("-u", "--seed"), type = "integer", default = 0,
                  help = "Random seed for reproducibility (0 = random) [default %default]")

  args <- parse_args(p, args = argv,
                     positional_arguments = TRUE,
                     convert_hyphens_to_underscores = TRUE)
  return(args)
}

# //////////////////////////////////////////////////////////////////

# =======================================
# Diagnostic Info
# =======================================

show_dependencies <- function() {
  pkgs <- as.yml(list_dependencies())
  log_info("Dependencies: [[\n\n\n{pkgs}\n]]\n")
}

show_session_info <- function() {
  sx <- as.yaml(get_session_info())
  log_debug("Session info: [[\n\n\n{sx}\n]]\n")
}

show_diagnostics <- function() {
  args <- g_args
  if (is_quiet(args)) {
    return(invisible(NULL))
  }
  show_dependencies()
  show_session_info()
  invisible(NULL)
}


# =======================================
# Script Tasks
# =======================================

say_hello <- function(args = g_args) {

  hello_msg <- dmy_hello()
  log_info("say_hello -- { hello_msg }")
  
}


say_hi_to_all <- function(args = g_args) {

  if (length(args$args) == 0) { # positional arguments
    return(2)
  }

  for (who in args$args) {
    hi_msg <- dmy_hello(salutation = "Hi", who = who)
    print("#hi.msg: ", hi_msg)
  }

  return(0)
}


task <- function(args = g_args) {
  show_diagnostics()
  say_hello(args = args)
  say_hi_to_all(args = args)
}

# //////////////////////////////////////////////////////////////////

#' Script initialization
run_init <- function(argv = c()) {
  args <- parse_arguments(argv)
  assign("g_args", args, envir = .GlobalEnv)
  init_script(g_script_name, args = args)

  assign("g_start_time", getOption("o_start_time"), envir = .GlobalEnv)
  assign("g_log_dir", getOption("o_log_dir"), envir = .GlobalEnv)
  assign("g_log_prefix", getOption("o_log_prefix"), envir = .GlobalEnv)
  assign("g_seed", getOption("o_rnd_seed"), envir = .GlobalEnv)

  return(args)

}

#' Script failure
run_fail <- function(rc = 1, ex = NULL, msg = "_undefined error_") {
  fail_script(rc = rc, ex = ex, msg = msg)
}

#' Script complention
run_exit <- function(rc = 0, msg = "success.") {
  exit_script(rc = rc, msg = msg)
}

# //////////////////////////////////////////////////////////////////

main <- function(argv = commandArgs(trailingOnly=TRUE)) {

  args <- run_init(argv = argv)
  rc <- 0 
  tryCatch({
    log_info('#> start: %s', paste(argv,sep = " "))
    print(elapsed <- system.time({ rc <- task(args = args)  }))
    log_success('#< end(%d): %s', rc, summary(elapsed))
  }, error = function(ex) {
    run_fail(rc = 1, ex = ex, msg = "#FAILED!")
  })
  run_exit(rc, msg = "#success.")
  rc

}

# Execute main function if script is run directly
if (sys.nframe() == 0) {
  main()
}
