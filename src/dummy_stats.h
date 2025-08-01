#pragma once

// Enable C++11 support
// [[Rcpp::plugins(cpp11)]]

// Rcpp dependencies
#include <Rcpp.h>

namespace dvesimpler {

  Rcpp::DataFrame dmy_dplyr_grouped_sum(Rcpp::DataFrame df, Rcpp::String group_col, Rcpp::String value_col)
  Rcpp::List dmy_summary_stats(const Rcpp::NumericVector& data,
                         double confidence_level = 0.95,
                               bool na_rm = true);    
  
}

