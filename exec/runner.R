#!/usr/bin/env Rscript
##{{{
# runner.R: R main script
# ====================================
#
#  R main script invoked by runner.sh via Rscript
#
#  "./exec/runner.sh help" for arguments and available environment
#
#}}} \\\    

library("logger")

#{{{ [ MAIN ] /////////////////////////////////////////////////////////////////

# ---(scripts)------------------------------------------------

E_PROJECT_SCRIPTS <- c(
  "dummy_runner.R",
  "example_data_loader.R"
)

E_DEFAULT_SCRIPT <- paste0("./exec/", E_PROJECT_SCRIPTS[1])

# ---(main)------------------------------------------------

runner_job <- list(
    script = E_DEFAULT_SCRIPT,
    args = commandArgs(trailingOnly=TRUE),
    start_time = Sys.time()
  )


runner_call <- function() {
  tryCatch(source(runner_job$script),
           error = function(ex){
             log_error("#! RUN: ({ex}) {runner_job$script} -- {runner_job$args}")
             runner_job.failed <- TRUE
             runner_job.error <- ex
             print(ex)
           })
}

runner_main <- function() {
  log_info("#> RUN: ({runner_job$start_time}) {runner_job$script} -- {runner_job$args}")
  
  time(runner_call())

#  runner_job.end_time <- Sys.time()
#  runner_job.elapsed <- (runner_job.end_time - runner_job$start_time)

#  log_info("#< RUN: ({runner_job.end_time}) {runner_job$script} -- {runner_job$args}")
  log_info("#< RUN: () {runner_job$script} -- {runner_job$args}")

}

runner_main()

#}}} \\\
