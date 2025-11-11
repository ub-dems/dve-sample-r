# ////////////////////////////////////////////////////////////////////////////

fn_base <- function() { return("dve-ds") }

# ////////////////////////////////////////////////////////////////////////////

fn_temp <- function() { return("temp") }
fn_logs <- function() { return("logs") }
fn_exec <- function() { return("exec") }

fn_exdata <- function() { return("inst/extdata") }



# ////////////////////////////////////////////////////////////////////////////

mkdirs <- function(fp) {
  if (!file.exists(fp)) {
    mkdirs(dirname(fp))
    dir.create(fp)
  }
}

ensure_path <- function(fp) {
  mkdirs(dirname(fp))
  return (fp)
}



find_test_path <- function(fp) {
  parent_path <- rprojroot::find_root_file(".", criterion = 
        rprojroot::root_criterion(function(path) dir.exists(file.path(path, "tests")), "has tests subdir"))
  sib_dirs <- list.dirs(path = parent_path, full.names = TRUE, recursive = FALSE)
  desc_path <- reader::find.file("DESCRIPTION", dir = "", dirs = sib_dirs)
  root_path <- dirname(desc_path)
  result <- paste(root_path, fp, sep='/')
  return(result)
}



find_path <- function(fp) {
  result <- tryCatch(rprojroot::find_root_file(fp, criterion = 
                                        rprojroot::is_r_package | 
                                        rprojroot::is_rstudio_project ),
                     error=function(cond) {
                       testpath <- find_test_path(fp)
                       return(testpath)
                     })
  return(result)
}


is_check_mode <- function() {
  result <- tryCatch({
    rprojroot::find_root_file('.',
                              criterion =
                                rprojroot::is_r_package |
                                rprojroot::is_rstudio_project)
    return(FALSE)
  },
  error=function(cond) {
    return(TRUE)
  })
  return(result)
}

is_skip_mode <- function() {
  return(is_check_mode())
}


# ////////////////////////////////////////////////////////////////////////////

with_digits <- function(f, digits = 3) {
  oo <- options(digits = digits)
  result <- f()
  on.exit(options(oo))
  return(result)
}

# ////////////////////////////////////////////////////////////////////////////

format_elapsed <- function(elpsed_millis) {
  ms <- elpsed_millis %% 1000
  elapsed_sec <- floor(elpsed_millis / 1000)
  ss <- elapsed_sec %% 60
  mn <- floor(elapsed_sec / 60) %% 60
  hh <- floor(elapsed_sec / 3600)
  result <- paste0(sprintf("%02.f", hh), ":",
                   sprintf("%02.f", mn), ":",
                   sprintf("%02.f", ss), ".",
                   sprintf("%03.f", ms))
  return(result)
}

# ////////////////////////////////////////////////////////////////////////////

touch_path <- function(fp) {
  fn <- find_path(fp)
  system2("touch", args=c(fn))
  return(fn)
}



getwd_base <- function() {
  result <- find_path("")
  return(result)
}


setwd_base <- function() {
  result <- getwd()
  base_wd <- getwd_base()
  setwd(base_wd)
  return(result)
}

# ////////////////////////////////////////////////////////////////////////////

io_path <- function(path, name="", create_path=TRUE) {
  basename <- find_path(path)
  if (nchar(name) > 0) {
    result <- paste(basename, name, sep='/')
  } else {
    result <- basename
  }
  if (create_path) {
    ensure_path(result)
  }
  return(result)
}



io_data <- function(path = "", name = "", base = fn_base(),
                    kind = "def", mode = "ext", create_path = TRUE) {
  full <- paste(fn_exdata(), mode, paste(base, kind, sep = "."), sep = "/")
  if (nchar(path) > 0) {
    full <- paste(full, path, sep = "/")
  }
  if (nchar(name) > 0) {
    full <- paste(full, name, sep = "/")
  }
  result <- io_path(full, create_path = create_path)
  return(result)
}

io_temp <- function(path = "", name = "", create_path = TRUE) {
  full <- paste(fn_temp(), sep = "/")
  if (nchar(path) > 0) {
    full <- paste(full, path, sep = "/")
  }
  if (nchar(name) > 0) {
    full <- paste(full, name, sep = "/")
  }
  result <- io_path(full, create_path = create_path)
  return(result)
}

io_logs <- function(path = "", name = "", create_path = TRUE) {
  full <- paste(fn_logs(), sep = "/")
  if (nchar(path) > 0) {
    full <- paste(full, path, sep = "/")
  }
  if (nchar(name) > 0) {
    full <- paste(full, name, sep = "/")
  }
  result <- io_path(full, create_path=create_path)
  return(result)
}

io_exec <- function(path = "", name = "", create_path = FALSE) {
  result <- NULL
  if (file.exists(name)) {
    result <- name
  } else {
    full <- paste(fn_exec(), sep = "/")
    if (nchar(path) > 0) {
      full <- paste(full, path, sep = "/")
    }
    if (nchar(name) > 0) {
      full <- paste(full, name, sep = "/")
    }
    result <- io_path(full, create_path = create_path)
  }
  return(result)
}

# ////////////////////////////////////////////////////////////////////////////

#' retrieve all installed packages with versions
#'
#' @return dataframe of packages and versions
#' @export
list_dependencies <- function() {

  pkgs <- data.frame()
  for (i in 1:(length((.packages())))){
    package <- (.packages())[i]
    version <- utils::packageVersion(package)
    pv <- data.frame(package, version)
    pkgs <- rbind(pkgs,pv)
  }
  return(pkgs)
}

#' get system information
#' @returns list of system information
get_system_info <- function() {
  cpu_info <- NA
  # Try to run inxi command
  tryCatch({
    cpu_info_raw <- system("inxi -C", intern = TRUE, ignore.stderr = TRUE)
    cpu_info <- paste(cpu_info, collapse = "\n")
  }, error = function(e) {
    warning("Could not retrieve CPU info (inxi not available)")
  })
  result <- list(
    cpu_info = cpu_info,
    r_version = R.version.string,
    r_platform = R.version$platform
  )
  return(result)
}


#' get system information
#' @returns list session info
get_session_info <- function() {
  session_info <- capture.output(sessionInfo())
  result <- list(
    session_info = session_info
  )
  return(result)
}


# ////////////////////////////////////////////////////////////////////////////

#' convert filename to filedescriptor with access timestamp
#'
#' @param fn String filename
#' @return fd
#' @export
as.IOfd <- function(fn) {
  tm <- Sys.time()
  ts <- strftime(tm, "%Y-%m-%dT%H:%M:%S%z", usetz = TRUE)
  fd <- structure(list(fn = fn, tm = tm, ts = ts, class = "IOfd"))
  return(fd)
}

#' extract filename from filedesciptor
#'
#' @param fd IOfd descriptor
#' @return fn
#' @export
as.IOfn <- function(fd) {
  fn <- fd$fn
  return(fn)
}



# ////////////////////////////////////////////////////////////////////////////

def_path <- function(name, path, base = fn_base()) {io_data(base = base, kind = "def",path = path, name = name)}

loc_path <- function(name, path, base = fn_base()) {io_data(base=base, kind="loc", path=path, name=name) }
net_path <- function(name, path, base = fn_base()) {io_data(base=base, kind="net", path=path, name=name) }

tmp_path <- function(name, path = "") {io_temp(path = path, name = name)}
log_path <- function(name, path = "") {io_logs(path = path, name = name)}

exe_path <- function(name, path = "") {io_exec(path = path, name = name)}

# ////////////////////////////////////////////////////////////////////////////
