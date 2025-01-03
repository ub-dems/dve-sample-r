#!/usr/bin/env Rscript

env_script_full <- "exec/dummyCmd/cmd.R"
env_script_file <- scriptName::current_filename() %||% env_script_full
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




##
# runner script example
#

#rm(list=ls())
#devtools::load_all(".") 


library(logging)

init_logging <- function(args = c()){
  log_init("dummy-runner.log", args=args)
}



dump_paths <- function(){
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

task <- function(){
  loginfo('#> task, ...')

  s1 <- dmy_hello("Jupiter")
  s2 <- dmy_alter("Jupiter")

  print (paste(s1," -- ",s2))

  loginfo('#: dmy_hello: %s', s1)
  loginfo('#: dmy_alter: %s', s2)

  of <- dmy_sepal_plot()
  print (paste("-> saved plot:",of))

  loginfo('#: dmy_sepal_plot: %s', of)

  rc <- 0 
  loginfo('#< task, done.')
  rc
}

main <- function(){
  args <- commandArgs(trailingOnly=TRUE)
  init_logging(args = args)
  loginfo('#> start: %s', paste(args,sep = " "))
  logdebug('#? args: %s', paste(commandArgs(),sep = ", "))
  print(sx <- sessionInfo())
  logfinest(sx)
  dump_paths()
  rc <- task() 
  print(elapsed <- system.time({ rc <- task()  }))
  loginfo('#< end(%d): %s', rc, summary(elapsed))
  rc
}

main()
