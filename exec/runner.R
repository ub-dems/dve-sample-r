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
library("yaml")
library("magrittr")

#{{{ [ MAIN ] /////////////////////////////////////////////////////////////////

# ---(scripts)------------------------------------------------

log_layout(layout_glue_colors)

#log_threshold(INFO)
#log_threshold(DEBUG)
#log_threshold(TRACE)

# ---(scripts)------------------------------------------------

E_PROJECT_SCRIPTS <- c(
  "dummy_runner.R",
  "example_data_loader.R"
)

E_DEFAULT_SCRIPT <- paste0("./exec/", E_PROJECT_SCRIPTS[1])

#{{{ [ JOB ] /////////////////////////////////////////////////////////////////


# ---(globals)---------------------------------------------

E_RUNNER_JOB <- NULL


# ---(desc)------------------------------------------------

runner_conf <- function(script = E_DEFAULT_SCRIPT,args = commandArgs(trailingOnly=TRUE)) {
  result <- list(
    script = script,
    args = args
  )
  class(result) <- "runner_conf"
  return (result)
}

print.runner_conf <- function(x) {
  cat("# runner_conf:","\n")
  s <- as.yaml(x)
  cat(x, "\n")

}

runner_job <- function(job_conf, store_fun = function(x) { E_RUNNER_JOB <<- x; return (x)}) {
  result <- list(
      
      job_conf = job_conf,
      store_fun = store_fun,
      
      info = paste0("job:", job_conf$script, "(", job_conf$args, ")"),
      
      #source_rev <- try(system("git rev-parse HEAD", intern = TRUE)) 
      
      started = FALSE,
      completed = FALSE,
      failed = NA,
      
      start = function(.self, job_conf) {
        start_time <- Sys.time()
        return (.self$set(.self,list(
          job_conf = job_conf,
          start_time = start_time,
          started = TRUE
        )))
      },
      
      complete = function(.self, job_time) {
        end_time <- Sys.time()
        elapsed <- end_time - .self$start_time
        return (.self$set(.self,list(
          job_time = job_time,
          end_time = end_time,
          elapsed = elapsed,
          completed = TRUE,
          rc = 0
        )))
      },
      
      fail = function(.self, ex) {
        return (.self$set(.self,list(
          ex = ex,
          failed = TRUE,
          rc = 0
        )))
      },
      
      set = function(.self, val) {
        return (store_fun(modifyList(.self, val)))
      },
      
      init_time = Sys.time()
      
  )
  class(result) <- "runner_job"
  store_fun(result)
  return (result)
}

print.runner_job <- function(x) {
  cat("# runner_job:","\n")
  s <- as.yaml(x)
  cat(x, "\n")
  
}


init_job <- function() {
  job_conf <- runner_conf()
  job_desc <- runner_job(job_conf)
  return (job_desc)
}

#}}} \\\

#{{{ [ MAIN ] /////////////////////////////////////////////////////////////////

# ---(call)------------------------------------------------

runner_call <- function(job_desc) {

  job_time <- NA

  result = tryCatch({
    
    job_conf <- job_desc$job_conf

    job_desc %<>% job_desc$start(job_conf)
    
    #job_desc <- job_desc$start(job_desc, job_conf)
    
    script <- job_conf$script
    args <- job_conf$args
    
#   job_time <<- time(system("date"))
    job_time <<- time(source(script))
    
    job_desc %<>% job_desc$complete(job_time)
    
    (job_desc)

  }, warning = function(we) {
    log_warning("#? RUN: ({we}) -- {job_desc$info}")
  }, error = function(ex) {
    print(ex)
    log_error("#! RUN: ({ex}) -- {job_desc$info}")
    job_desc %<>% job_desc$fail(ex)
    return (job_desc)
  }, finally = {
    # job_desc %<>% job_desc$complete(job_time)
    log_debug("#. RUN: (ended) -- {job_desc$info}")
  })
  
}

# ---(main)------------------------------------------------

runner_main <- function() {

  job_desc <- init_job()
  
  log_info("#> RUN: enter -- {job_desc$info}")
  
  job_desc <- runner_call(job_desc)

  log_info("#< RUN: exit (rc:{job_desc$rc}, time:{job_desc$elapsed}) -- {job_desc$info}")
  
  if (!interactive()) {
    quit(status=job_desc$rc)
  }

  return (job_desc$rc)
}

runner_main()


#}}} \\\
