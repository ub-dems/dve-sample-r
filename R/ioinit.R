# ////////////////////////////////////////////////////////////////////////////

#' retrieve an optional argument fron the named list of parsed arguments.
#' if missing, the value is retrieved fron system environment with "X_ARG_" prefix
#' and uppercase name. If efalt value is nyumeric, this value is converted
#' as numeric from string.
#'
#' @param args parsed arguments as a named list
#' @param name argument name
#' @param default default value
#' @return argument value or default value
#' @export
args_get <- function(args, name, default=NA) {
  result <- default
  if (name %in% names(args$options)) {
    result <- args$options[[name]]
  } else {
    env_value <- Sys.getenv(paste0("X_ARG_",toupper(name)))
    if (!is.na(env_value)) {
      if (is.numeric(default) && is.numeric(env_value)) {
        result <- as.numeric(env_value)
      } else {
        result <- env_value
      }
    }
  }
  return(result)
}

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




# ////////////////////////////////////////////////////////////////////////////

#' Initial setup for random number generator (rng)
#' @param name script name
#' @param args parsed args as a named list
#' @param seed seed to assign, if 0, retrieved from args or env, only set if defined
init_script_setup_rng <- function(name = "script", args = list(), seed = 0) {
  env_seed <- as.integer(Sys.getenv("R_SEED", unset="0"))
  env_seed <- ifelse(is.na(env_seed) == TRUE, 0, env_seed)
  arg_seed <- args_get(args, "seed", env_seed)

  if (is_verbose(args)) {
        message(sprintf("Random SEED.init: arg=%d  env=%d", arg_seed, env_seed))
  }

  if (seed == 0) {
    seed <- arg_seed
  }
  if (seed == 0) {
    seed <- as.integer(runif(1) * 2e9)
  }
  set.seed(seed)
  options("o_rnd_seed"=seed)
  message(sprintf("Random SEED: %d   (start: %f)", seed, runif(1)))
  return(seed)
}

# ////////////////////////////////////////////////////////////////////////////

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
init_script_setup_logging <- function(name = "script", args = list()) {

  script_name <- getOption("o_script_name")

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
  logger::log_info(">>*CTL:START: {script_name} -- at: {timestamp}")
  logger::log_info("Log file: {log_file}")
  logger::log_info("Log dir: {normalizePath(log_dir)}")
  logger::log_info("Log level: {log_threshold}")

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

#' init script
#'
#' @param name script name
#' @param args parsed args as a named list
#' @export
init_script <- function(name = "script", args = list()) {

  script_name <- name
  options("o_script_name"=script_name)

  init_script_setup_logging(name = name, args = args)
  init_script_show_arguments(name = name, args = args)
  init_script_setup_rng(name = name, args = args)
  init_script_show_system_info(name = name, args = args)

  return (invisible(NULL))

}

#' exit script
#'
#' @param rc return code
#' @param msg message
#' @export
exit_script <- function(rc = 0, msg = "success.") {

  script_name <- getOption("o_script_name")

  start_time <- getOption("o_start_time")
  end_time <- Sys.time()
  options("o_end_time"=end_time)

  timestamp <- format(end_time, "%Y%m%d-%H%M%S")
  elapsed_millis <- end_time - start_time
  duration <- format_elapsed(elapsed_millis)

  message("<<*CTL:END{rc} {script_name} -- at: {timestamp} (elapsed: {duration}) -- {msg}")

  return (invisible(NULL))

}

#' fail script
#'
#' @param rc return code
#' @param ex error
#' @param msg message
#' @export
fail_script <- function(rc = 1, ex = NULL, msg = "_undefined error_") {

    script_name <- getOption("o_script_name")

  start_time <- getOption("o_start_time")
  end_time <- Sys.time()
  options("o_end_time"=end_time)

  timestamp <- format(end_time, "%Y%m%d-%H%M%S")
  elapsed_time <- difftime(end_time, start_time, units="auto")
  duration <- format(elapsed_time)
  
  failsafe_setup_logging()
  
  traceback()
  xt <- capture.output(traceback())
  
  stop_msg <- sprintf("==*CTL:FAIL ...")
  tryCatch({
    stop_msg <- sprintf("==*CTL:FAIL(%d) %s -- at: %s (elapsed: %s) ?? %s -- %s",
                        rc, script_name, timestamp, duration, ex, msg)
    log_error(sprintf("==*CTL:FATAL: ex:%s, traceback:\n %s", ex, xt))
    stop(stop_msg)
  }, error = function(ea) {
    stop_exit <- log_error(sprintf("==*CTL:ABORT: ex: %s", ea))
    stop(stop_exit)
  })
  stop("==*CTL:PANIC: ...")

}

# ////////////////////////////////////////////////////////////////////////////
