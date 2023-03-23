##
# sample reader script functions, referenced in _targets.R pipeline
#

## library(readr)
## library(ggplot2)
## library(dplyr)
## library(lubridate)

## library(logging)
## library("modules")

#init_logging <- function(args = c()){ log_init("dummy-p01-proc.log", args=args) }


# m <- modules::module({
#   
# 
# log_info <- function(...) {
#   msg <- .makeMessage(...)  
#   text = paste(format(Sys.time(), "%c"), "| INFO  |", msg)
#   message(text)
# }
# 
# #init_logging <- function(args = c()){ log_init("dummy-p01-proc.log", args=args) }
# 
# auto_load <- function() { init_logging() }
# 
# })
# m$auto_load()
# 

m <- modules::amodule({


log_info <- function(...) {
  msg <- .makeMessage(...)
  text = paste(format(Sys.time(), "%c"), "| INFO  |", msg)
  message(text)
}

init_logging <- function(args = c()){ log_init("dummy-p01-proc.log", args=args) }

#auto_load <- function() { init_logging() }
auto_load <- function() { print("Hi") }

})
m$auto_load()


utils::suppressForeignCheck(c("Datetime","PJME_MW"))
utils::globalVariables(c("Datetime","PJME_MW"))

dmy_p01_env_dump <- function (){
  s <- modules::getSearchPathContent(m)
  cat(str(s))
  print(m)
  return(0)
}


#' load 3y PJME hourly data (def)
#'
#' @param fn String filtered PJME_hourly file name
#' @return PJME_hourly_3y
#' @export
dmy_p01_load_user_private_data <- function (fn = dmy_fn_def_PJME_hourly_3y()){
  logdebug('# read_csv: %s', fn)
  PJME_hourly_3y <- read_csv(fn);
  return (PJME_hourly_3y)
}

#' filter and save 3y PJME hourly data (def)
#'
#' @param PJME_hourly dataframe unfiltered PJME hourly data
#' @return PJME_hourly_3y
#' @export
dmy_p01_save_user_private_data <- function (PJME_hourly){
  PJME_hourly_3y_tmp <- PJME_hourly %>%
    filter(Datetime >= as.Date("2016-01-01"),Datetime < as.Date("2019-01-01"))
  fn <- dmy_fn_def_PJME_hourly_3y()
  logdebug('# write_csv: %s', fn)
  write_csv(PJME_hourly_3y_tmp, fn);
  return (fn)
}

#' test compressed unfiltered PJME hourly data (net)
#' 
#' @return fn_net_PJME_hourly_z
#' @export
dmy_p01_test_zip_share_data <- function (){
  fz <- dmy_fn_net_PJME_hourly_z()
  if (!file.exists(fz)) {
    logerror('# missing: %s', fz)
    return(fz)
  }
  return (fz)
}

#' copy compressed unfiltered PJME hourly data (net)
#' to uncompressed unfiltered PJME hourly data (loc)
#' 
#' @param fz String compressed PJME_hourly file name
#' @return fn_net_PJME_hourly
#' @export
dmy_p01_copy_zip_share_data <- function (fz = dmy_fn_net_PJME_hourly_z()){
  fn <- dmy_fn_loc_PJME_hourly()
  if (!file.exists(fn)) {
    loginfo('# existing: %s', fn)
    return(fn)
  }
  loginfo('# read_csv: %s', fz)
  PJME_hourly_z <- read_csv(fz, 
                            col_types = cols(Datetime = col_datetime(format = "%Y-%m-%d %H:%M:%S")));
  PJME_hourly_z$Datetime = format(PJME_hourly_z$Datetime,format="%Y-%m-%d %H:%M:%S")
  loginfo('# write_csv: %s', fn)
  write_csv(PJME_hourly_z, fn);
  return (fn)
}

#' copy compressed unfiltered PJME hourly data (net)
#' to uncompressed unfiltered PJME hourly data (loc)
#' 
#' @param fn String uncompressed PJME_hourly file name
#' @return PJME_hourly dataframe
#' @export
dmy_p01_load_host_local_data <- function(fn = dmy_fn_loc_PJME_hourly()){
  logdebug('# read_csv: %s', fn)
  PJME_hourly <- read_csv(fn, 
                     col_types = cols(Datetime = col_datetime(format = "%Y-%m-%d %H:%M:%S")));
  return (PJME_hourly)
}

dmy_p01_view_user_private_data <- function (PJME_hourly_3y){
  View(PJME_hourly_3y)
  return (0)
}

#' show unfiltered PJME hourly data
#'
#' @param PJME_hourly dataframe unfiltered PJME hourly data
#' @return void
#' @export
dmy_p01_view_host_local_data <- function (PJME_hourly){
  View(PJME_hourly)
  return (0)
}

#' show 3y PJME hourly data
#'
#' @param PJME_hourly_3y dataframe 3y PJME hourly data
#' @return void
#' @export
dmy_p01_show_user_private_data <- function (PJME_hourly_3y){
  fn <- dmy_fn_txt_PJME_hourly_3y()
  df <- PJME_hourly_3y
  out<-capture.output(summary(df))
  cat(out,file=fn,sep="\n",append=TRUE)
  return (fn)
}

#' show PJME hourly data
#'
#' @param PJME_hourly dataframe unfiltered PJME hourly data
#' @return void
#' @export
dmy_p01_show_host_local_data <- function (PJME_hourly){
  fn <- dmy_fn_txt_PJME_hourly()
  df <- PJME_hourly
  out<-capture.output(summary(df))
  cat(out,file=fn,sep="\n",append=TRUE)
  return (fn)
}

#' plot 3y PJME hourly data
#'
#' @param PJME_hourly_3y dataframe unfiltered PJME hourly data
#' @return void
#' @export
dmy_p01_plot_user_private_data <- function (PJME_hourly_3y){
  
  fn <- dmy_fn_tmp_PJME_hourly_3y()
  df <- PJME_hourly_3y
  #nm <- names(PJME_hourly_3y)
  
  # Most basic bubble plot
  p <- ggplot(df, aes(x=Datetime, y=PJME_MW)) +
    geom_line() + 
    xlab("")
  pdf(fn)
  print(p)
  return (fn) 
}

#' plot unfiltered PJME hourly data
#'
#' @param PJME_hourly dataframe unfiltered PJME hourly data
#' @return void
#' @export
dmy_p01_plot_host_local_data <- function (PJME_hourly){
  utils::suppressForeignCheck(c("Datetime","PJME_MW"))

  fn <- dmy_fn_tmp_PJME_hourly()
  df <- PJME_hourly
  # nm <- names(PJME_hourly)
  
  # Most basic bubble plot
  p <- ggplot(df, aes(x=Datetime, y=PJME_MW)) +
    geom_line() + 
    xlab("")
  pdf(fn)
  print(p)  
  return (fn) 
}




#' PJME hourly data ELT pipeline
#'
#' @param args list commandline args
#' @return void
#' @export
dmy_p01_task <- function(args = commandArgs(trailingOnly=TRUE)){
  loginfo('#> extract, ...')
  fn_net_PJME_hourly_z <- dmy_p01_copy_zip_share_data()
  fn_net_PJME_hourly <- dmy_p01_copy_zip_share_data(fn_net_PJME_hourly_z)
  PJME_hourly <- dmy_p01_load_host_local_data(fn_net_PJME_hourly)
  fn_def_PJME_hourly_3y <- dmy_p01_save_user_private_data(PJME_hourly)
  loginfo('#< extract, done')
  loginfo('#> load, ...')
  PJME_hourly_3y <- dmy_p01_load_user_private_data(fn_def_PJME_hourly_3y)
  loginfo('#> load, done.')
  loginfo('#> transform, ...')
  fn_txt_PJME_hourly <- dmy_p01_show_host_local_data(PJME_hourly)
  fn_tmp_PJME_hourly <- dmy_p01_plot_host_local_data(PJME_hourly)
  fn_txt_PJME_hourly_3y <- dmy_p01_show_user_private_data(PJME_hourly_3y)
  fn_tmp_PJME_hourly_3y <- dmy_p01_plot_user_private_data(PJME_hourly_3y)
  loginfo('#< transform,done.')
  fn <- touch_path(dmy_fn_sts_p01_proc_main())
  return(fn)
}

#' PJME hourly data ELT process entry point
#'
#' @param args list commandline args
#' @return rc
#' @export
dmy_p01_main <- function(args = commandArgs(trailingOnly=TRUE)){ 
  #args <- commandArgs(trailingOnly=TRUE)
  m$init_logging(args = args)
  loginfo('#> start: %s', paste(args,sep = " "))
  logdebug('#? args: %s', paste(commandArgs(),sep = ", "))
  m$log_info("#start")
  rc <- 0 
  print(elapsed <- system.time({ rc <- dmy_p01_task()  }))
  loginfo('#< end(%d): %s', rc, summary(elapsed))
  fn <- touch_path(dmy_fn_sts_p01_proc_main())
  return(fn)
}

#dmy_p01_main()
