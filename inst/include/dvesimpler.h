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

// Rcpp dependencies
#include <RcppArmadillo.h>
#include <Rcpp.h>
#include <RcppEigen.h>

namespace dvesimpler
{

  Rcpp::NumericVector dmy_mean(Rcpp::NumericVector xs);

  Rcpp::NumericVector dmy_custom_mean(Rcpp::NumericVector data);
  Rcpp::NumericVector dmy_custom_mean_v0(Rcpp::NumericVector data);

  Rcpp::DataFrame dmy_dplyr_grouped_sum(Rcpp::DataFrame df, Rcpp::String group_col, Rcpp::String value_col);

  Rcpp::List dmy_summary_stats(const Rcpp::NumericVector& data,
                         double confidence_level = 0.95,
                               bool na_rm = true);    
  
  Rcpp::DataFrame dmy_group_op(const Rcpp::DataFrame& data,
                               const std::string& group_col,
                               const std::string& value_col,
                               const std::string& operation);
  
}

