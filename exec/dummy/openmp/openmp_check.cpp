// [[Rcpp::plugins(cpp17)]]
// [[Rcpp::plugins(openmp)]]

#include <Rcpp.h>
#ifdef _OPENMP
#include <omp.h>
#endif

// [[Rcpp::export]]
Rcpp::List openmp_test() {
#ifdef _OPENMP
  int max_threads = omp_get_max_threads();
  
  #pragma omp parallel
  {
    #pragma omp master
    {
      Rcpp::Rcout << "OpenMP available with " << omp_get_num_threads() 
                  << " threads\n";
    }
  }
  
  return Rcpp::List::create(
    Rcpp::Named("openmp_enabled") = true,
    Rcpp::Named("max_threads") = max_threads,
    Rcpp::Named("version") = _OPENMP
  );
#else
  return Rcpp::List::create(
    Rcpp::Named("openmp_enabled") = false,
    Rcpp::Named("message") = "OpenMP not available"
  );
#endif
}
