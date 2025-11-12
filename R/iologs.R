# Logging Configuration and Utility Functions
# 
# Note:
#
#  - the `logging` package was replaced by `logger` package
#
#  - standard R functions: message, warning, error, stop are hooked to
#    logger channel
#
#  - legacy `logging` function calls are redirected to `logger`
#    equivalents
#
#  - a fail-safe `logger` formatter in installed in failure handling
#    to avoid formatting problems
#
#  - a file logging naming prefix, based on start timestamp, is stored
#    in options for possible usage in other script outputs
#
# ////////////////////////////////////////////////////////////////////////////

# ---(conditional logging)---------------------------------------------

#' retrieve an optional argument fron the named list of parsed arguments.
#' if missing, the value is retrieved fron system environment with "X_ARG_" prefix
#' and uppercase name. If efalt value is nyumeric, this value is converted
#' as numeric from string.
#'
#' @param args parsed arguments as a named list
#' @param level verbosity level
#' @return TRUE if verbosity is greater or equal level
#' @export
is_verbose <- function(args, level = 1) {
  verbose <-args_get(args, "verbose", 0)

  if (is.logical(verbose)) {
    verbose <- ifelse(verbose,1,0)
  }

  if (!(is.numeric(verbose))) {
    return(FALSE)
  }
  result <- ifelse(verbose >= level, TRUE, FALSE)
  return(result)
}

#' retrieve an optional argument fron the named list of parsed arguments.
#' if missing, the value is retrieved fron system environment with "X_ARG_" prefix
#' and uppercase name. If efalt value is nyumeric, this value is converted
#' as numeric from string.
#'
#' @param args parsed arguments as a named list
#' @return TRUE if quiet option set
#' @export
is_quiet <- function(args) {
  quiet <-args_get(args, "quiet", FALSE)
  if (!(is.logical(quiet))) {
    return(FALSE)
  }
  return(quiet)
}


# ---(startup diagnostics)---------------------------------------------

#' Log system information
#' @param name script name
#' @param args parsed args as a named list
init_script_show_system_info <- function(name = "script", args = list()) {
  
  if (!(is_verbose(args))) {
    return(invisible(NULL))
  }  
  
    
  sys_info <- get_system_info()
  sys_info_yaml <- as.yaml(sys_info)
  message(sprintf("=== System Information === \n\n%s\n\n", sys_info_yaml))
  
  return(invisible(NULL))
  
}

#' Log system information
#' @param name script name
#' @param args parsed args as a named list
init_script_show_arguments <- function(name = "script", args = list()) {
  args_wrap = list(script = list(name = name, args = args))
  args_yaml <- as.yaml(args_wrap)
  message(sprintf("=== Script Arguments === \n\n%s\n\n", args_yaml))
}

# ---(log marks)---------------------------------------------

mark_log_init <- function(name = NULL, args = list()) {

  script_name <- ifelse(is.null(name), getOption("o_script_name","script"), name)
  timestamp <- getOption("o_timestamp","?(timestamp)") 
  log_dir <- getOption("o_log_dir","?(log_dir)") 
  log_file <- getOption("o_log_file","?(log_file)") 
  log_threshold <- getOption("o_log_threshold","?(log_threshold)") 

  # Mark Log Start
  logger::log_info(">>*CTL:START: {script_name} -- at: {timestamp}")
  logger::log_info("Log file: {log_file}")
  logger::log_info("Log dir: {normalizePath(log_dir)}")
  logger::log_info("Log level: {log_threshold}")
  
}

mark_log_exit <- function(rc = 0, msg = "success.") {

  script_name <- getOption("o_script_name")

  start_time <- getOption("o_start_time")
  end_time <- getOption("o_endtime")

  timestamp <- format(end_time, "%Y%m%d-%H%M%S")
  elapsed_millis <- end_time - start_time
  duration <- format_elapsed(elapsed_millis)

  # Mark Log End
  logger::log_success("<<*CTL:END{rc} {script_name} -- at: {timestamp} (elapsed: {duration}) -- {msg}")

}

mark_log_fail <- function(rc = 1, ex = NULL, msg = "_undefined error_") {

  script_name <- getOption("o_script_name")

  start_time <- getOption("o_start_time")
  end_time <- getOption("o_endtime")

  timestamp <- format(end_time, "%Y%m%d-%H%M%S")
  elapsed_millis <- end_time - start_time
  duration <- format_elapsed(elapsed_millis)

  # Mark Log Fail
  tryCatch({

    failsafe_setup_logging()

    em <- ifelse(is.null(ex),"#UNKERR", as.character(ex))
  
    stop_fail <- sprintf("==*CTL:FAIL(%d) %s -- at: %s (elapsed: %s) ?? %s -- %s",
                        rc, script_name, timestamp, duration, em, msg)
    # traceback()
    xt <- capture.output(traceback())

    logger::log_error(xt)
    logger::log_error(stop_fail)
    stop_fail
    
  }, error = function(ea) {
    tryCatch({
      stop_error <- sprintf("==*CTL:ABORT: ex: %s", ea)
      logger::log_error(stop_error)
      stop_error
    }, error = function(ez) {
      stop_quit <- paste("==*CTL:PANIC:", script_name )
      print(stop_quit)
      stop_quit
    })
  })

}

# ---(`logger` setup)---------------------------------------------

# Registration hooks for standard R message functions
init_script_hook_logging <- function() {
  if (any(sapply(
    globalCallingHandlers()[names(globalCallingHandlers()) == "message"],
    attr,
    which = "implements"
  ) == "log_messages")) {
    return(invisible(NULL))
  }  
  logger::log_messages()
  logger::log_warnings()
  logger::log_errors()
  return(invisible(NULL))
}

#' Initialize logging facility provided by 'logger' package
#' @param name script name
#' @param args parsed args as a named list
init_script_setup_logging <- function(name = NULL, args = list()) {

  script_name <- ifelse(is.null(name), getOption("o_script_name","script"), name)

  # Get log directory from environment or default
  log_dir <- dirname(io_logs("logfile.log"))
  if (!dir.exists(log_dir)) {
    dir.create(log_dir, showWarnings = FALSE, recursive = TRUE)
  }
  options("o_log_dir"=log_dir)

  verbose <- args_get(args, "verbose", 0)
  # Create log file with timestamp
  start_time <- Sys.time()
  options("o_start_time"=start_time)

  timestamp <- format(start_time, "%Y%m%d-%H%M%S")
  options("o_timestamp"=timestamp)

  log_prefix <- sprintf("%s-%s", script_name, timestamp)
  log_file <- file.path(log_dir, sprintf("%s.log", log_prefix))
  log_threshold <- if (verbose >= 1) logger::DEBUG else logger::INFO
  options("o_log_prefix"=log_prefix)
  options("o_log_dir"=log_dir)
  options("o_log_file"=log_file)
  options("o_log_threshold"=log_threshold)

  # Configure logger
  logger::log_appender(logger::appender_tee(log_file))
  logger::log_threshold(log_threshold)
  logger::log_layout(logger::layout_glue_colors)
  logger::log_formatter(logger::formatter_glue_or_sprintf)
  
  # Inject hooks in base logging
  init_script_hook_logging()

  # Mark Log Start
  mark_log_init(name = script_name, args = args)

  return(list(log_dir = log_dir, log_prefix = log_prefix, log_file = log_file))
}

failsafe_setup_logging <- function() {
  
  # Configure logger
  logger::log_formatter(logger::formatter_paste)
  return(list(log_formatter = logger::formatter_glue_or_sprintf))
}


# ////////////////////////////////////////////////////////////////////////////

#' Log system information
#' @param name script name
#' @param args parsed args as a named list
init_script_show_system_info <- function(name = "script", args = list()) {
  
  if (!(is_verbose(args))) {
    return(invisible(NULL))
  }  
  
    
  sys_info <- get_system_info()
  sys_info_yaml <- as.yaml(sys_info)
  message(sprintf("=== System Information === \n\n%s\n\n", sys_info_yaml))
  
  return(invisible(NULL))
  
}

#' Log system information
#' @param name script name
#' @param args parsed args as a named list
init_script_show_arguments <- function(name = "script", args = list()) {
  args_wrap = list(script = list(name = name, args = args))
  args_yaml <- as.yaml(args_wrap)
  message(sprintf("=== Script Arguments === \n\n%s\n\n", args_yaml))
}



# ////////////////////////////////////////////////////////////////////////////

# legacy `logging` package support

logfinest <- function(msg, ...) {
  logger::log_trace(sprintf(msg,...))
}

logfiner <- function(msg, ...) {
  logger::log_trace(sprintf(msg,...))
}

logfine <- function(msg, ...) {
  logger::log_trace(sprintf(msg,...))
}

logdebug <- function(msg, ...) {
  logger::log_debug(sprintf(msg,...))
}

loginfo <- function(msg, ...) {
  logger::log_info(sprintf(msg,...))
}

logwarn <- function(msg, ...) {
  logger::log_warn(sprintf(msg,...))
}

logerror <- function(msg, ...) {
  logger::log_error(sprintf(msg,...))
}

# ## @deprecated("removed logging dependency, replaced by logger package")
# ## init logging
# ##
# ## @param logfile String logfile under logs/ (.gitignored) dir
# ## @param args list args, defaults to command-line arg
# ## @param loglevel String appender logging level
# ## @param filelevel String logfile logging level
# ## @param outlevel String console logging level
# ## @export
# log_init <- function(logfile = "logfile.log", args = c(), loglevel='DEBUG', filelevel='DEBUG', outlevel='INFO'){
#   logdir <- dirname(io_logs("logfile.log"))
#   if (!dir.exists(logdir)) {
#     dir.create(logdir, showWarnings = FALSE, recursive = TRUE)
#   }
#
#   logging::basicConfig()
#   logging::setLevel(loglevel)
#   logging::addHandler(logging::writeToFile, file=log_file(logfile), level=filelevel)
#   logging::setLevel(Sys.getenv("R_LOGGING_LEVEL", outlevel), getHandler("basic.stdout"))
# }

# ////////////////////////////////////////////////////////////////////////////
