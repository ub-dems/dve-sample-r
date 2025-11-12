# Script Initialization and Termibnation Functions
# 
# Note:
#
#  - command-line parsed argument `args` stored in options
#  - log channel configuarion via `logger` package 
#  - random number generator initializazion with manual/random seed
#  - script termination logging with elasped times
#  - script failure reporting
#
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
  options("o_rc"=rc)
  
  mark_log_exit(rc = rc, msg = msg)
  return(rc)
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
  options("o_rc"=rc)

  stop_msg <- mark_log_fail(rc=rc, ex = ex, msg = msg)
  stop(stop_msg)
  return(rc)
}

# ////////////////////////////////////////////////////////////////////////////
