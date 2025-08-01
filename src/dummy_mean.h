#pragma once

// Enable C++11 support
// [[Rcpp::plugins(cpp11)]]

// Rcpp dependencies
#include <Rcpp.h>

namespace dvesimpler
{

  Rcpp::NumericVector dmy_mean(NumericVector xs);
  
}

