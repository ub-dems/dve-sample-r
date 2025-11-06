
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
  if (name %in% names(args)) {
    result <- args[[name]]
  } else {
    env_value <- Sys.getenv(paste0("X_ARG_",toupper(name)))
    if (!is.na(env_value)) {
      if (is.numeric(default) && is_numeric(env_value)) {
        result <- as.numeric(env_value)
      } else {
        result <- env_value
      }
    }
  }
}

# ////////////////////////////////////////////////////////////////////////////

#' Setup random number generator
init_script_setup_rng <- function(name = "script", args = list(), seed = 0) {
  env_seed <- as.integer(Sys.getenv("R_SEED", unset="0"))
  env_seed <- ifelse(is.na(env_seed) == TRUE, 0, env_seed)
  arg_seed <- args_get(args, "seed", env_seed)

  if (seed == 0) {
    seed <- arg_seed
  }
  if (seed == 0) {
    seed <- as.integer(runif(1) * 2e9)
  }
  set.seed(seed)
  options("o_rnd_seed"=seed)
  message("Random seed:",seed)
  message("Random start:",runif(1))
  return(seed)
}

# ////////////////////////////////////////////////////////////////////////////

#' Initialize logging facility
init_script_setup_logging <- function(name = "script", args = list()) {

  script_name <- getOption("o_script_name")
  
  # Get log directory from environment or default
  log_dir <- dirname(io_logs("logfile.log"))
  if (!dir.exists(log_dir)) {
    dir.create(log_output_dir, showWarnings = FALSE, recursive = TRUE)
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
  options("o_log_prefix"=log_prefix)
  
  # Configure logger
  logger::log_threshold <- if (verbose >= 1) DEBUG else INFO
  logger::log_appender(appender_tee(log_file))
  logger::log_threshold(log_threshold)
  logger::log_layout(layout_glue_colors)

  # Inject hooks in base logging

  logger::log_messages()
  logger::log_warnings()
  logger::log_errors()
  
  # Store in options
  message(">>#CTL:START: {script_name} -- at: {timestamp}")
  message("Logging initialized: {log_file}")
  message("Log directory: {normalizePath(log_dir)}")
  
  return(list(dir = log_dir, prefix = log_prefix, file = log_file))
}

# ////////////////////////////////////////////////////////////////////////////

#' Log system information
init_script_show_system_info <- function(name = "script", args = list()) {
  message("=== System Information ===")
  
  # Try to run inxi command
  tryCatch({
    cpu_info <- system("inxi -C", intern = TRUE, ignore.stderr = TRUE)
    message(paste(cpu_info, collapse = "\n"))
  }, error = function(e) {
    warning("Could not retrieve CPU info (inxi not available)")
  })
  message("R version:", R.version.string)
  message("Platform:", R.version$platform)
  
}

#' Log system information
init_script_show_arguments <- function(name = "script", args = list()) {
  args_yaml <- as.yaml(args)
  message("=== Script Arguments === \n\n{args_yaml}\n\n\n")
  
}



# ////////////////////////////////////////////////////////////////////////////

#' init logging
#'
#' @param logfile String logfile under logs/ (.gitignored) dir
#' @param args list args, defaults to command-line arg
#' @param loglevel String appender logging level
#' @param filelevel String logfile logging level
#' @param outlevel String console logging level
#' @export
log_init <- function(logfile = "logfile.log", args = c(), loglevel='DEBUG', filelevel='DEBUG', outlevel='INFO'){
  logdir <- dirname(io_logs("logfile.log"))
  if (!dir.exists(logdir)) {
    dir.create(logdir, showWarnings = FALSE, recursive = TRUE)
  }
  
  logging::basicConfig()
  logging::setLevel(loglevel)
  logging::addHandler(logging::writeToFile, file=log_file(logfile), level=filelevel)
  logging::setLevel(Sys.getenv("R_LOGGING_LEVEL", outlevel), getHandler("basic.stdout"))
}

# ////////////////////////////////////////////////////////////////////////////

#' init script
#'
#' @param logfile String logfile under logs/ (.gitignored) dir
#' @param args list args, defaults to command-line arg
#' @param loglevel String appender logging level
#' @param filelevel String logfile logging level
#' @param outlevel String console logging level
#' @export
init_script <- function(name = "script", args = list()) {

  script_name <- name
  options("o_script_name"=script_name)
  
  init_script_setup_logging(name = name, args = args)
  init_script_show_arguments(name = name, args = args)
  init_script_setup_rng(name = name, args = args)
  init_script_show_system_info(name = name, args = args)
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

  message("<<#CTL:END{rc} {script_name} -- at: {timestamp} (elapsed: {duration}) -- {msg}")
  
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
  elapsed_millis <- end_time - start_time
  duration <- format_elapsed(elapsed_millis)

  stop("!!#CTL:FAIL{rc} {script_name} -- at: {timestamp} (elapsed: {duration}) ?? {ex} -- {msg}")
  
  
}

# ////////////////////////////////////////////////////////////////////////////

