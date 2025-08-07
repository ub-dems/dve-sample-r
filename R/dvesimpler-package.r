#' @description
#' To learn more about dvesimpler, start with the vignettes:
#' `browseVignettes(package = "dvesimpler")`
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
# 
# 
#' @useDynLib dvesimpler, .registration = TRUE
#' @importFrom Rcpp cppFunction
#' @importFrom RcppArmadillo armadillo_get_number_of_omp_threads
#' @importFrom RcppEigen fastLm
# 
## @importFrom RcppGSL fastLm
## @importFrom keras is_keras_available
# 
#' @importFrom here here
#' @importFrom logging loginfo logdebug logerror getHandler
#' @importFrom magrittr %>%
#' @importFrom modules module export import
#' @importFrom reticulate py_discover_config
#' @importFrom rprojroot is_r_package is_rstudio_project is_testthat find_root find_root_file
#' @importFrom rzmq subscribe
#' @importFrom scriptName current_filename
#' @importFrom targets tar_make
#' @importFrom yaml as.yaml
# 
#' @importFrom argparse ArgumentParser
# 
#' @importFrom tidyverse tidyverse_conflicts
#' @importFrom grDevices pdf
#' @importFrom utils str capture.output head View 
# 
## usethis namespace: end

utils::globalVariables(c("Datetime","PJME_MW"))


NULL


