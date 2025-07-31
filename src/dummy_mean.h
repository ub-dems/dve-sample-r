#pragma once

// Enable C++11 support
// [[Rcpp::plugins(cpp11)]]

// Rcpp dependencies
#include <Rcpp.h>

namespace dvesimpler
{

  Rcpp::NumericVector dummy_mean(NumericVector xs);
  
}

