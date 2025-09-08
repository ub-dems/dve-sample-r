/*
 * Package: dvesimpler
 * File: dummy_eigen.cpp
 * Author: datalab@unimib.it
 * Description: Demo C++ source file with RcppEigen
 * Seealso: ../notes/howtos/Rcpp-HOWTO.md
 * Seealso: ../notes/howtos/Rcpp-HOWTO-Q4-*.md
 * Seealso: ../exec/dummy-rcpp.R
 * Seealso: ../src/config.h
 * Seealso: ../src/Makevars
 * Seealso: ../etc/R/Makevars
 * Seealso: ../R/dvesimpler-package.r
 * Seealso: ../DESCRIPTION
 * Created: 2025
 * License: GPL (>= 2)
 */

// Enable C++20 support
// [[Rcpp::plugins(cpp20)]]
// [[Rcpp::plugins(openmp)]]

// Declare dependencies
// NO RcppEigen dependency here
// Seealso: ../notes/howtos/Rcpp-HOWTO-Q4-*.md#A4.2



// static config
#include "config.h"


// Rcpp dependencies
#include <RcppEigen.h>
#include <Rcpp.h>

#ifdef _OPENMP
#include <omp.h>
#endif


// Standard library headers
// #include <algorithm>
// #include <cmath>
// #include <exception>
// #include <functional>
// #include <iterator>
// #include <limits>
// #include <memory>
// #include <numeric>
// #include <random>
// #include <stdexcept>
// #include <string>
// #include <vector>

// Package Public Functions

//#include <dvesimpler.h>

// Package Private Functions

#include "dummy_eigen.h"



// Use namespaces
using namespace Rcpp;
using namespace std;


/*
  // Type aliases for cleaner code
  using Matrix = Eigen::MatrixXd;
  using Vector = Eigen::VectorXd;
  using MapMatrix = Eigen::Map<Eigen::MatrixXd>;
  using MapVector = Eigen::Map<Eigen::VectorXd>;
*/

using Eigen::Map;
using Eigen::MatrixXd;
using Eigen::VectorXd;

/*
 * =============================================================================
 * LINEAR ALGEBRA WITH RcppEigen
 * =============================================================================
 */

//" Matrix Multiplication with Transpose with RcppEigen
//"
//" Performs parallel Gram matrix \eqn{A^T * A}  computation efficiently in C++.
//"
//" @param A an Eigen matrix
//"
//" @return The prodoct of transposed matrix with itsself as Eigen Matrix
//"
Eigen::MatrixXd dmy_core_gram_matrix_eigen_impl(const Eigen::Map<Eigen::MatrixXd>& A) {
    // Transpose and multiply
    return A.transpose() * A;
}
Rcpp::NumericMatrix dmy_core_gram_matrix_eigen(const Rcpp::NumericMatrix& A) {
  const Eigen::Map<Eigen::MatrixXd>& Ae = Rcpp::as<Eigen::Map<Eigen::MatrixXd>>(A);
  return Rcpp::wrap(dmy_core_gram_matrix_eigen_impl(Ae));
}



//" Linear Regression with RcppEigen
//"
//" Compute (parallel) linear regression via QR decomposition efficiently in C++.
//"
//" @param X an Eigen matrix
//" @param y an Eigen vector
//"
//" @return A Named list with linear regression coefficients and residuals
//"
Rcpp::List dmy_core_linear_regression_eigen_impl(const Eigen::Map<Eigen::MatrixXd>& X,
                             const Eigen::Map<Eigen::VectorXd>& y) {
    // Solve using QR decomposition
    Eigen::VectorXd coefficients = X.colPivHouseholderQr().solve(y);
    
    // Calculate residuals
    Eigen::VectorXd residuals = y - X * coefficients;
    
    return List::create(
        Named("coefficients") = coefficients,
        Named("residuals") = residuals
    );
}
Rcpp::List dmy_core_linear_regression_eigen(const Rcpp::NumericMatrix& X,
                             const Rcpp::NumericVector& y) {
  const Eigen::Map<Eigen::MatrixXd>& Xe = Rcpp::as<Eigen::Map<Eigen::MatrixXd>>(X);
  const Eigen::Map<Eigen::VectorXd>& ye = Rcpp::as<Eigen::Map<Eigen::VectorXd>>(y);
  return dmy_core_linear_regression_eigen_impl(Xe,ye);
}

