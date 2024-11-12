#!/usr/bin/env Rscript

env_script_full <- "exec/dummyCmd/cmd.R"
env_script_file <- scriptName::current_filename()
env_script_name <- basename(env_script_file)
env_script_dir <- dirname(env_script_file)
env_script_mod <- basename(env_script_dir)
env_script_base <- dirname(env_script_dir)
env_script_lib <- paste(env_script_base,"progs", sep = "/")


curdir <- getwd()
setwd(env_script_lib)
source("utils.R")
setwd(curdir)

setwd(env_script_dir)




#curdir <- getwd()
#setwd("~/latex/papers/hron/14_monti/2024knockoff2/simulations/progs/")
#source("utils.R")
#setwd(curdir)





##
# runner script example
#

#rm(list=ls())
devtools::load_all(".") 

require(rob)

library(logging)

init_logging <- function(args = c()){
  log_init("dummy-runner.log", args=args)
}



task <- function(){
  loginfo('#> hello cmd')
  loginfo('#=    file: %s', env_script_file)
  loginfo('#=    name: %s', env_script_name)
  loginfo('#=     dir: %s', env_script_dir)
  loginfo('#=     mod: %s', env_script_mod)
  loginfo('#=    base: %s', env_script_base)
  loginfo('#=     lib: %s', env_script_lib)
  loginfo('#=    wd(): %s', getwd())
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
