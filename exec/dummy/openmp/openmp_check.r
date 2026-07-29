#!/usr/bin/env Rscript

##
# OpenMP support test
#

#' Link C++ source code
link_cpp_source <- function(fn, dp=".") {

  # Try multiple locations for C++ source
  script_dir <- tryCatch({
    dirname(sys.frame(1)$ofile)
  }, error = function(e) NULL)
  
  search_paths <- c(
    if (!is.null(script_dir)) file.path(script_dir, fn),
    fn,
    paste(dp,fn,sep = "/")
  )
  
  cpp_path <- NULL
  for (path in search_paths) {
    if (file.exists(path)) {
      cpp_path <- path
      break
    }
  }
  
  if (is.null(cpp_path)) {
    warning("Could not find dummy_finder.cpp in any search location")
    stop("C++ source file not found")
  }
  
  message(paste("Compiling C++ source: ", cpp_path))
  Rcpp::sourceCpp(cpp_path)
  message("C++ functions loaded successfully")
}


link_cpp_source(fn="openmp_check.cpp", dp="/exec/dummy/openmp/")
openmp_test()
