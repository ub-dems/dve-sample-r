#pragma once

// Enable C++11 support
// [[Rcpp::plugins(cpp11)]]

// Rcpp dependencies
#include <Rcpp.h>


Rcpp::NumericVector dmy_mean(Rcpp::NumericVector xs);

double dmy_mean_v0(Rcpp::NumericVector xs);
double dmy_mean_v1(Rcpp::NumericVector xs);
double dmy_mean_v2(Rcpp::NumericVector xs);
double dmy_mean_v3(Rcpp::NumericVector xs);
  
  

