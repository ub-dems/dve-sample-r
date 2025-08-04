/*
 * Package: dvesimpler
 * File: dvesimpler.h
 * Author: datalab
 * Description: Demo C++ source file with Rcpp
 * Seealso: ../notes/howtos/Rcpp-HOWTO.md
 * Seealso: ../notes/howtos/Rcpp-HOWTO-claude-v4.md
 * Seealso: ../src/dummy-mean.cpp
 * Seealso: ../src/dummy-stats.cpp
 * Seealso: ../src/dvesimpler.h
 * Seealso: ../exec/dummy-rcpp-mean.R
 * Seealso: ../exec/dummy-rcpp-stats.R
 * Seealso: ../src/Makevars
 * Seealso: ../R/dvesimpler-package.r
 * Seealso: ../DESCRIPTION
 * Created: 2025
 * License: GPL (>= 2)
 */

// Enable C++11 support
// [[Rcpp::plugins(cpp11)]]

// Declare dependencies
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::depends(RcppEigen)]]

/*
// {{Rcpp::depends(RcppGSL)}}
*/

#pragma once

#ifdef DVESIMPLER_INTERNALS
#define DVESIMPLER_INTERNALS_DEFINED 1
#endif  

#include "dummy_mean.h"
#include "dummy_stats.h"

