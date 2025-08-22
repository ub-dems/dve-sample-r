/*
 * Package: dvesimpler
 * File: dummy_stats.cpp
 * Author: datalab@unimib.it
 * Description: Demo C++ source file with Rcpp
 * Seealso: ../notes/howtos/Rcpp-HOWTO.md
 * Seealso: ../src/dummy-mean.cpp
 * Seealso: ../inst/include/dvesimpler.h
 * Seealso: ../exec/dummy-rcpp.R
 * Seealso: ../src/config.h
 * Seealso: ../src/Makevars
 * Seealso: ../R/dvesimpler-package.r
 * Seealso: ../DESCRIPTION
 * Created: 2025
 * License: GPL (>= 2)
 */

// [[Rcpp::interfaces(r,cpp)]]
// Enable C++11 support
// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::plugins(openmp)]]

// Declare dependencies
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::depends(RcppEigen)]]



// static config
#include "config.h"

// Rcpp dependencies
#include <RcppArmadillo.h>
#include <Rcpp.h>
#include <RcppEigen.h>

#ifdef _OPENMP
#include <omp.h>
#endif


// Standard library headers
#include <algorithm>
#include <cmath>
#include <exception>
#include <functional>
#include <iterator>
#include <limits>
#include <memory>
#include <numeric>
#include <random>
#include <stdexcept>
#include <string>
#include <vector>

// Package Public Functions

#include <dvesimpler.h>

// Package Internal Functions

#include "dummy_mean.h"

// Use namespaces
using namespace Rcpp;
using namespace std;


/*
  using namespace arma;

  // Type aliases for cleaner code
  using Matrix = Eigen::MatrixXd;
  using Vector = Eigen::VectorXd;
  using MapMatrix = Eigen::Map<Eigen::MatrixXd>;
  using MapVector = Eigen::Map<Eigen::VectorXd>;
*/


/*
 * =============================================================================
 * UTILITY FUNCTIONS (NOT EXPORTED)
 * =============================================================================
 */

namespace {  // Anonymous namespace for internal functions

// Input validation helper
void validate_input(const NumericVector& data, const std::string& param_name) {
  if (data.size() == 0) {
    throw std::invalid_argument(param_name + " cannot be empty");
  }
        
  if (any(is_infinite(data))) {
    throw std::invalid_argument(param_name + " contains infinite values");
  }
}
    
// Safe mathematical operations
double safe_sqrt(double value) {
  if (value < 0) {
    throw std::domain_error("Cannot take square root of negative number");
  }
  return std::sqrt(value);
}

NumericVector safe_divide(NumericVector a, NumericVector b) __attribute__((unused));
NumericVector safe_divide(NumericVector a, NumericVector b) {
  if (a.size() != b.size()) {
    Rcpp::stop("Vectors must be same length");
  }
  
  NumericVector result(a.size());
  for (int i = 0; i < a.size(); ++i) {
    if (b[i] == 0) {
      Rcpp::warning("Division by zero at index %d", i);
      result[i] = NA_REAL;
    } else {
      result[i] = a[i] / b[i];
    }
  }
  return result;
}


  
    
// Memory-efficient matrix operations
template<typename T>
void initialize_matrix(T& matrix, double fill_value = 0.0) {
  std::fill(matrix.begin(), matrix.end(), fill_value);
}

} // end anonymous namespace



/*
 * =============================================================================
 * INTERNAL PACKAGE LINKAGE
 * =============================================================================
 */

//' Calculate Aritmetic Mean 
//'
//' Compute mean directly without C or R library funcions
//' with exported package function
//' See: dummy_mean.cpp
//'
//' @param data A numeric vector
//'
//' @return Arithmetic mean of data
//'
//' @examples
//' \dontrun{
//' data <- rnorm(100)
//' m <- dmy_custom_mean(data)
//' }
//'
//' @export
// [[Rcpp::export]]
Rcpp::NumericVector dmy_custom_mean(Rcpp::NumericVector data) {
  return dmy_mean(data);
}

//' Print Aritmetic Mean 
//'
//' Print mean calling internal package custom_mean
//' calls inline namespace version from Rcpp::compileAttributes()
//' See: inst/include/*.h
//'
//' @param data A numeric vector
//'
//' @return Arithmetic mean of data
//'
//' @examples
//' \dontrun{
//' data <- rnorm(100)
//' m <- dmy_custom_mean(data)
//' }
//'
//' @export
// [[Rcpp::export]]
void dmy_print_mean(Rcpp::NumericVector data) {
  auto mean = dvesimpler::dmy_custom_mean(data);
  Rcpp::Rcout << "Mean: " << mean << endl;
}



/*
 * =============================================================================
 * DATA STATS COMPUTATION FUNCTIONS (R LIBRARY INTEGRATION)
 * =============================================================================
 */

//' Calculate Robust Summary Statistics
//'
//' Computes comprehensive summary statistics for a numeric vector with
//' robust error handling and missing value treatment.
//'
//' @param data A numeric vector
//' @param confidence_level Confidence level for intervals (default: 0.95)
//' @param na_rm Remove NA values (default: TRUE)
//'
//' @return A named list with summary statistics
//'
//' @examples
//' \dontrun{
//' data <- rnorm(100)
//' stats <- dmy_summary_stats(data)
//' }
//'
//' @export
// [[Rcpp::export]]
List dmy_summary_stats(const NumericVector& data,
                       double confidence_level,
                       bool na_rm) {
    
  try {
    // Input validation
    if (confidence_level <= 0 || confidence_level >= 1) {
      stop("confidence_level must be between 0 and 1");
    }
        
    NumericVector xs = na_rm ? na_omit(data) : data;
    validate_input(xs, "data");

    // --( R libs: stats functions )-------------------------------

    // Get R environment
    Environment base("package:base");
    Environment stats("package:stats");
    
    // Call R functions
    Function r_mean = base["mean"];
    Function r_sd = stats["sd"];
    Function r_var = stats["var"];
    Function r_quantile = stats["quantile"];

    // Execute R functions
    double mean_r_val = as<double>(r_mean(xs));
    double var_r_val = as<double>(r_var(xs));
    double sd_r_val = as<double>(r_sd(xs));
    NumericVector quantiles = r_quantile(xs, 
                                         NumericVector::create(0.25, 0.5, 0.75));
        

    // --( C libs: stats functions )-------------------------------

    // Basic statistics
    const auto n = static_cast<double>(xs.size());
    const double mean_val = mean(xs);
    const double var_val = var(xs);
    const double sd_val = safe_sqrt(var_val);
        
    // Confidence interval
    const double alpha = 1.0 - confidence_level;
    const double t_value = R::qt(1.0 - alpha/2.0, n - 1, 1, 0);
    const double margin_error = t_value * sd_val / std::sqrt(n);
        
    // --( named R list result )-------------------------------
    
    return List::create(
        Named("n") = n,
        Named("mean") = mean_r_val,
        Named("variance") = var_r_val,
        Named("sd") = sd_r_val,
        Named("mean.c") = mean_val,
        Named("variance.c") = var_val,
        Named("sd.c") = sd_val,
        Named("ci_lower") = mean_val - margin_error,
        Named("ci_upper") = mean_val + margin_error,
        Named("confidence_level") = confidence_level,
        Named("q25") = quantiles[0],
        Named("median") = quantiles[1],
        Named("q75") = quantiles[2]
            
                        );
        
  } catch (const std::exception& ex) {
    stop("Error in dmy_summary_stats: %s", ex.what());
  }
}

/*
 * =============================================================================
 * DATA TRANSFORMATION FUNCTIONS
 * =============================================================================
 */

//' Calculate a Summry Dataframme as a sum, by group colun
//'
//' Aggregate by sum value column bt group column
//' 
//' @param df An input dataframme
//' @param group_col keys column name
//' @param value_col values column name
//'
//' @return A two column dataframe with keys and valuue
//'
//' @examples
//' \dontrun{
//' data <- rnorm(100)
//' stats <- dmy_summary_stats(data)
//' }
//'
//' @export
// [[Rcpp::export]]
DataFrame dmy_dplyr_grouped_sum(DataFrame df, String group_col, String value_col) {
  // Extract columns
  CharacterVector groups = df[group_col];
  NumericVector values = df[value_col];
  
  // Create map for grouped sums
  std::unordered_map<std::string, double> group_sums;
  
  for (int i = 0; i < groups.size(); ++i) {
    if (CharacterVector::is_na(groups[i]) || NumericVector::is_na(values[i])) continue;
    
    std::string group = Rcpp::as<std::string>(groups[i]);
    group_sums[group] += values[i];
  }
  
  // Convert back to R vectors
  CharacterVector out_groups(group_sums.size());
  NumericVector out_sums(group_sums.size());
  
  size_t idx = 0;
  for (const auto& pair : group_sums) {
    out_groups[idx] = pair.first;
    out_sums[idx] = pair.second;
    ++idx;
  }
  
  return DataFrame::create(
      Named("group") = out_groups,
      Named("sum") = out_sums
                           );
}

//' Efficient Group Operations
//'
//' Performs group-wise operations on data frames efficiently in C++.
//'
//' @param data Data frame
//' @param group_col Name of the grouping column
//' @param value_col Name of the value column
//' @param operation Operation to perform ("mean", "sum", "count", "sd")
//'
//' @return Data frame with group results
//'
//' @export
// [[Rcpp::export]]
DataFrame dmy_group_op(const DataFrame& data,
                       const std::string& group_col,
                       const std::string& value_col,
                       const std::string& operation) {
    
  try {

    /*      
            Rcpp::Environment dplyr_ns = Rcpp::Environment::namespace_env("dplyr");
            Rcpp::Function mutate = dplyr_ns["mutate"];
    */    
      
    // Extract columns
    CharacterVector groups = data[group_col];
    NumericVector values = data[value_col];
        
    if (groups.size() != values.size()) {
      stop("Group and value columns must have the same length");
    }
        
    // Find unique groups
    CharacterVector unique_groups = unique(groups);
    std::vector<double> results(unique_groups.size());
        
    // Perform group operations
    for (int i = 0; i < unique_groups.size(); ++i) {
      std::string current_group = as<std::string>(unique_groups[i]);
      std::vector<double> group_values;
            
      // Collect values for current group
      for (int j = 0; j < groups.size(); ++j) {
        if (as<std::string>(groups[j]) == current_group) {
          if (!NumericVector::is_na(values[j])) {
            group_values.push_back(values[j]);
          }
        }
      }
            
      // Calculate result based on operation
      if (group_values.empty()) {
        results[i] = NA_REAL;
      } else if (operation == "mean") {
        results[i] = std::accumulate(group_values.begin(), group_values.end(), 0.0) / group_values.size();
      } else if (operation == "sum") {
        results[i] = std::accumulate(group_values.begin(), group_values.end(), 0.0);
      } else if (operation == "count") {
        results[i] = static_cast<double>(group_values.size());
      } else if (operation == "sd") {
        if (group_values.size() < 2) {
          results[i] = NA_REAL;
        } else {
          double mean_val = std::accumulate(group_values.begin(), group_values.end(), 0.0) / group_values.size();
          double sum_sq_diff = 0.0;
          for (double val : group_values) {
            sum_sq_diff += std::pow(val - mean_val, 2);
          }
          results[i] = std::sqrt(sum_sq_diff / (group_values.size() - 1));
        }
      } else {
        stop("Unknown operation: %s", operation.c_str());
      }
    }
        
    return DataFrame::create(
        Named(group_col) = unique_groups,
        Named("result") = NumericVector(results.begin(), results.end())
                             );
        
  } catch (const std::exception& e) {
    stop("Error in dummy_group_op: %s", e.what());
  }
}




/*
 * =============================================================================
 * LINEAR ALGEBRA WITH RcppArmadillo
 * =============================================================================
 */

//' Matrix Multiplication with RcppArmadillo
//'
//' Performs (parallel) matrix multiplication efficiently in C++.
//'
//' @param A an arma::mat matrix
//' @param B an arma::mat matrix (with rows(B) = cols(A))
//'
//' @return Matrix Product as arma::mat matrix
//'
//' @export
// [[Rcpp::export]]
arma::mat dmy_matrix_multiplication_arma(const arma::mat& A, const arma::mat& B) {
    // Check dimensions
    if (A.n_cols != B.n_rows) {
        stop("Incompatible matrix dimensions");
    }
    
    // Efficient matrix multiplication
    return A * B;
}

//' Matrix Multiplication with RcppArmadillo
//'
//' Performs (parallel) eigenvalues decomposition efficiently in C++.
//'
//' @param X an arma::mat square matrix
//'
//' @return A named list with eigenvaluues and eigenvectors (as arma types)
//'
//' @export
// [[Rcpp::export]]
Rcpp::List dmy_eigen_decomposition_arma(const arma::mat& X) {
    arma::vec eigenvalues;
    arma::mat eigenvectors;
    
    bool success = arma::eig_sym(eigenvalues, eigenvectors, X);
    
    if (!success) {
        stop("Eigenvalue decomposition failed");
    }
    
    return List::create(
        Named("values") = eigenvalues,
        Named("vectors") = eigenvectors
    );
}

/*
 * =============================================================================
 * LINEAR ALGEBRA WITH RcppEigen
 * =============================================================================
 */

using Eigen::Map;
using Eigen::MatrixXd;
using Eigen::VectorXd;


//' Matrix Multiplication with Transpose with RcppEigen
//'
//' Performs parallel Gram matrix \eqn{A^T * A}  computation efficiently in C++.
//'
//' @param A an Eigen matrix
//'
//' @return The prodoct of transposed matrix with itsself as Eigen Matrix
//'
//' @export
// [[Rcpp::export]]
Eigen::MatrixXd dmy_gram_matrix_eigen(const Eigen::Map<Eigen::MatrixXd>& A) {
    // Transpose and multiply
    return A.transpose() * A;
}


//' Linear Regression with RcppEigen
//'
//' Compute (parallel) linear regression via QR decomposition efficiently in C++.
//'
//' @param X an Eigen matrix
//' @param y an Eigen vector
//'
//' @return A Named list with linear regression coefficients and residuals
//'
//' @export
// [[Rcpp::export]]
List dmy_linear_regression_eigen(const Eigen::Map<Eigen::MatrixXd>& X,
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



/*
 * =============================================================================
 * DATA MANIPULATION FUNCTIONS (TIDYVERSE INTEGRATION)
 * =============================================================================
 */

// {[Rcpp::depends(dplyr)]}


//' Custom DatFrame Summarization
//'
//' Parallel Dataframe column summarization example in C++.
//'
//' @param df a Dataframe
//' @param column the name a Dataframe
//'
//' @return The sum of Datframe column
//'
//' @examples
//' \dontrun{
//'
//'  library(dplyr) 
//'   my_data <- tibble(x = 1:10, group = rep(c("A", "B"), each = 5)) 
//'   my_data %>% 
//'    group_by(group) %>% 
//'    summarise(custom_sum = dmy_df_custom_summarize(cur_data(),"x"))
//' 
//' }
//'
//' @export
// [[Rcpp::export]]
Rcpp::NumericVector dmy_df_custom_summarize(Rcpp::DataFrame df, Rcpp::String column) { 
  Rcpp::NumericVector x = df[column]; 
  double total = 0;
  // The pragma tells the compiler to parallelize this loop.
  // The reduction clause handles the `total` variable safely across threads.
#ifdef _OPENMP
#pragma omp parallel for reduction(+:total)
#endif
  for (R_xlen_t i = 0; i < x.size(); ++i) {
    total += x[i];
  }
  return Rcpp::NumericVector::create(total); 
} 


//' Custom DataFrame Moving Average
//'
//' Parallel vector moving average example in C++.
//'
//' @param x a numeric vector
//' @param n moving average window size
//'
//' @return A vector of moving averages (moviang average window reduced at edges)
//'
//' @examples
//' \dontrun{
//'
//' library(dplyr)
//' library(Rcpp)
//' 
//' # Assume the package is loaded, making rolling_average available
//' # sourceCpp("src/rolling_average.cpp") # for interactive testing
//' 
//' my_data <- tibble(
//'   group = rep(c("a", "b"), each = 10),
//'   value = rnorm(20)
//' )
//' 
//' my_data %>%
//'   group_by(group) %>%
//'   mutate(rolled_avg = dmy_df_rolling_average(value, n = 3))
//' 
//' }
//'
//' @export
// [[Rcpp::export]]
Rcpp::NumericVector dmy_df_rolling_average(Rcpp::NumericVector x, int n) {
    int len = x.size();
    Rcpp::NumericVector out(len);

  // The pragma tells the compiler to parallelize this loop.
  // The reduction clause handles the `total` variable safely across threads.
#ifdef _OPENMP
#pragma omp parallel for collapse(2) reduction(+:count, sum)
#endif
    for(int i = 0; i < len; ++i) {
        double sum = 0;
        int count = 0;
        for(int j = std::max(0, i - n + 1); j <= i; ++j) {
            sum += x[j];
            count++;
        }
        out[i] = sum / count;
    }
    return out;
}



//' Custom DataFrame Piped Transformation
//'
//' Parallel vector moving average example in C++.
//'
//' @param df an (implicit) dataframe with a "x" numeric columns
//'
//' @return A dataframe with a normalized transformed column
//'
//' @examples
//' \dontrun{
//'
//' library(dplyr)
//' library(Rcpp)
//'
//' df %>% 
//'   dmy_df_process_data() %>%
//'   filter(y > 0.1) %>%
//'   mutate(z = y * 2)
//' 
//' }
//'
//' @export
// [[Rcpp::export]]
Rcpp::DataFrame dmy_df_process_data(Rcpp::DataFrame df) {
  NumericVector x = df["x"];
  NumericVector y = exp(x) / sum(exp(x));
  return DataFrame::create(_["x"] = x, _["y"] = y);
}


//' Dummy Example of Tidyverse Funcion linkage fron C++
//'
//' Empty example for namespace environment resolution
//'
//' @return AA NULL value
//'
//' @export
// [[Rcpp::export]]
Rcpp::RObject dmy_df_call_dplyr_mutate() {
    Rcpp::Environment dplyr_ns = Rcpp::Environment::namespace_env("dplyr");
    Rcpp::Function mutate = dplyr_ns["mutate"];

    // Example usage (conceptual)
    // ... create a data frame and arguments ...
    // return mutate( ... );
    return R_NilValue; // Placeholder
}
