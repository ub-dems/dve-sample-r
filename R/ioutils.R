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

find_path <- function(fp) {
  result <- rprojroot::find_root_file(fp, criterion = 
                                        rprojroot::is_r_package | 
                                        rprojroot::is_rstudio_project | 
                                        rprojroot::is_testthat)
  return (result)
}


io_path <- function(pathname, filename, create_path=TRUE) {
  basename <- find_path(pathname)
  result <- paste(basename, filename, sep='/')
  if (create_path) {
    ensure_path(result)
  }
  return (result)
}
