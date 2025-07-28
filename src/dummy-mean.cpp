// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::plugins(cpp11)]]

#include <numeric>
#include <Rcpp.h>
using namespace Rcpp;


//' Sample Rcpp arithmetic mean (C)
//'
//' @param xs       numeric vector
//'
//' @return         arithmetic mean
//'
//' @export
// [[Rcpp::export]]
double dummy_mean_v0(NumericVector xs) {
   int n = xs.size();
   double total = 0;
   
   for(int i = 0; i < n; ++i) {
    total += xs[i];
  }
    
  return total / n;
 }
 
 

 
//' Sample Rcpp arithmetic mean (STL)
//'
//' @param xs       numeric vector
//'
//' @return         arithmetic mean
//'
// [[Rcpp::export]]
double dummy_mean_v1(NumericVector xs) {
   int n = xs.size();
   double total = 0;
   
   NumericVector::iterator it;
   for(it = xs.begin(); it != xs.end(); ++it) {
     total += *it;
   }  
   return total / n;
 }
 

//' Sample Rcpp arithmetic mean (NUM)
//'
//' @param xs       numeric vector
//'
//' @return         arithmetic mean
//'
// [[Rcpp::export]]
double dummy_mean_v2(NumericVector xs) {
   int n = xs.size();
   return std::accumulate(xs.begin(), xs.end(), 0.0) / n;
 }


//' Sample Rcpp arithmetic mean (C++11)
//'
//' @param xs       numeric vector
//'
//' @return         arithmetic mean
//'
// [[Rcpp::export]]
double dummy_mean_v3(NumericVector xs) {
   int n = xs.size();
   double total = 0;
   
   for(const auto &x : xs) {
     total += x;
   }   
   return total / n;
 }
 
//' Sample Rcpp arithmetic mean (API)
//'
//' @param xs       numeric vector
//'
//' @return         arithmetic mean
//'
//' @export
// [[Rcpp::export]]
 double dummy_mean(NumericVector xs) {
   return dummy_mean_v3(xs);
 }
 
 
 
 /*** R
library(microbenchmark)
x <- runif(1e5)
microbenchmark(
  mean(x),
  dummy_mean(x)
)
*/
