``` /// vim: set foldmethod=marker : ```
# ::{{{ #RCPP: Howto //
# Q:1 - Rcpp Usage Comprehensive Guide

<system> 

You are an experienced R programmer with extensive knowledge
of using Rcpp C++ sources in R packages. Your task is to provide a
comprehensive guide on Rcpp usage, adhering to CRAN requirements and
best practices.

</system>

Provide detailed information on the following topics, formatted in clear and well-structured (GFM) markdown:

1.  **C++11 Rcpp Sources Coding Style:**
    *   Explain the recommended coding style for C++11 Rcpp sources in R packages.
    *   Include examples of good and bad practices.

2.  **Rcpp Namespace Utility and Best Practices:**
    *   Describe the utility of the Rcpp namespace.
    *   Provide best practices for basic I/O, memory management, and exception handling using Rcpp.

3.  **RcppArmadillo and RcppEigen:**
    *   Describe RcppArmadillo and RcppEigen, including their purpose and benefits.
    *   Provide sample usage examples for both packages, demonstrating common operations.

4.  **Integration with Tidyverse Packages (e.g., dplyr):**
    *   Show how to integrate Rcpp code with tidyverse packages like dplyr for data frame manipulation.
    *   Provide code examples demonstrating this integration.

5.  **Integration with Standard OS Libraries (e.g., gsl - GNU Scientific Library):**
    *   Explain how to integrate Rcpp code with standard OS libraries like GSL.
    *   Describe package requirements for external library linkage and
        dependency specification in the package's DESCRIPTION file.

6.  **Best Practices for Roxygen2 Comments and Function Documentation:**
    *   Explain best practices for documenting Rcpp functions using Roxygen2 comments.
    *   Provide examples of well-documented functions.

7.  **R and C++ Function Calls in Rcpp Source:**
    *   Describe how to call other functions (R/C++) included in the
        package or in imported external packages from within Rcpp
        source code.
    *   Provide a sample of R and C++ function calls in Rcpp source.

8.  **Rebuild Operations:**
    *   Explain how to rebuild Rcpp functions, either directly or via standard `CMD check` or `build` R commands.

9.  **Code Unit Testing Support with 'testthat' Package:**
    *   Describe how to implement code unit testing for Rcpp functions using the 'testthat' package.
    *   Provide examples of test cases.

After the textual replay of the above points, provide the following:

1.  **Full Skeleton of a C++ Source:**
    *   Provide a complete skeleton of a C++ source file, adhering to CRAN coding style.
    *   Enable C++11 support.
    *   Include necessary headers for Rcpp, RcppArmadillo, RcppEigen, STL library, and GSL (GNU Scientific Library).

2.  **Roxygen2 Documentation and DESCRIPTION File Requisites:**
    *   Describe the requisites for Roxygen2 documentation in a package with Rcpp, RcppEigen, and GSL.
    *   Explain the necessary annotations for the DESCRIPTION file.

3.  **GitHub and GitLab Packaging Action Pipeline:**
    *   Prepare a packaging action pipeline for GitHub and GitLab that performs tests, checks, and binary builds of the package.
    *   Include a hypothetical remote FTP server (user/password taken
        from the environment) that can be used to upload the binary
        package if the build is successful.




# A:1 (Vertex)
> Rcpp Usage Comprehensive Guide


Here is a comprehensive guide to using Rcpp in R packages, covering
everything from coding style to deployment pipelines.

 ### 1. C++11 Rcpp Sources Coding Style 

 While CRAN doesn't enforce a strict C++ coding style, it's a best
 practice to adopt a clear and consistent one. A good approach is to
 follow the Google C++ Style Guide or a similar widely recognized
 standard, adapted for Rcpp's specifics.

 **Good Practices:** 

 *   **Naming:** Use `CamelCase` for classes and `snake_case` for variables and functions. 
 *   **Indentation:** Use 2 or 4 spaces for indentation, but be consistent. 
 *   **Comments:** Use `//` for single-line comments and `/* */` for multi-line comments. Document your code clearly. 
 *   **Includes:** Organize includes logically: system headers, then library headers, and finally your project's headers. 

 **Example of Good vs. Bad Practices:** 

 **Good:** 
 ```cpp 
 // Good: Clear, consistent, and commented 
 #include <Rcpp.h> 

 // [[Rcpp::export]] 
 Rcpp::NumericVector calculate_mean(Rcpp::NumericVector x) { 
  double total = 0; 
  for (int i = 0; i < x.size(); ++i) { 
  total += x[i]; 
  } 
  return Rcpp::NumericVector::create(total / x.size()); 
 } 
 ``` 

 **Bad:** 
 ```cpp 
 // Bad: Inconsistent formatting, poor naming, and no comments 
 #include <Rcpp.h> 
 using namespace Rcpp; 
 // [[Rcpp::export]] 
 NumericVector Mean(NumericVector Y){ 
 double T=0;for(int i=0;i<Y.size();++i){T+=Y[i];} 
 return NumericVector::create(T/Y.size());} 
 ``` 

 ### 2. Rcpp Namespace Utility and Best Practices 

 The `Rcpp` namespace provides a suite of classes and functions that
 facilitate the interaction between R and C++.

 *   **I/O:** Use `Rcpp::Rcout` for standard output and `Rcpp::Rcerr`
     for error output. Avoid using `std::cout` and `std::cerr` as they
     can interfere with R's I/O streams.
 *   **Memory Management:** Rcpp automatically handles memory
     management for objects passed between R and C++. For manual
     memory management, use `R_alloc` for temporary allocations that
     are automatically freed.
 *   **Exception Handling:** Use `Rcpp::stop()` to throw an exception
     that can be caught by R. This ensures a graceful exit and proper
     error handling within the R environment.

 ### 3. RcppArmadillo and RcppEigen 

 `RcppArmadillo` and `RcppEigen` are packages that integrate the
 Armadillo and Eigen C++ linear algebra libraries with R,
 respectively. They offer a more intuitive and efficient way to
 perform complex matrix operations.

 *   **RcppArmadillo:** Known for its user-friendly API, making it easy to translate R code into C++. 
 *   **RcppEigen:** Often provides better performance, especially for more complex linear algebra tasks. 

 **RcppArmadillo Example:** 
 ```cpp 
 #include <RcppArmadillo.h> 
 // [[Rcpp::depends(RcppArmadillo)]] 

 // [[Rcpp::export]] 
 arma::mat matrix_multiply(const arma::mat& A, const arma::mat& B) { 
  return A * B; 
 } 
 ``` 

 **RcppEigen Example:** 
 ```cpp 
 #include <RcppEigen.h> 
 // [[Rcpp::depends(RcppEigen)]] 

 // [[Rcpp::export]] 
 Eigen::MatrixXd matrix_multiply_eigen(const Eigen::MatrixXd& A, const Eigen::MatrixXd& B) { 
  return A * B; 
 } 
 ``` 

 ### 4. Integration with Tidyverse Packages (e.g., dplyr) 

 Integrating Rcpp with tidyverse packages like `dplyr` allows you to
 create highly efficient data manipulation pipelines. You can write
 performance-critical operations in C++ and seamlessly call them from
 within a `dplyr` workflow.

 **Example:** 
 ```cpp 
 #include <Rcpp.h> 

 // [[Rcpp::export]] 
 Rcpp::NumericVector custom_summarize(Rcpp::DataFrame df) { 
  Rcpp::NumericVector x = df["x"]; 
  double sum_val = 0; 
  for (int i = 0; i < x.size(); ++i) { 
  sum_val += x[i]; 
  } 
  return Rcpp::NumericVector::create(sum_val); 
 } 
 ``` 
 **R side:** 
 ```R 
 library(dplyr) 
 my_data <- tibble(x = 1:10, group = rep(c("A", "B"), each = 5)) 
 my_data %>% 
  group_by(group) %>% 
  summarise(custom_sum = custom_summarize(cur_data())) 
 ``` 

 ### 5. Integration with Standard OS Libraries (e.g., gsl - GNU Scientific Library) 

 Rcpp can be integrated with external libraries like the GNU
 Scientific Library (GSL) to leverage a vast collection of numerical
 routines. The `RcppGSL` package simplifies this by providing wrapper
 functions and handling the necessary linking.

 To link against GSL, your package's `DESCRIPTION` file must be correctly configured: 
 *   **SystemRequirements:** Specify the external library needed (e.g., `GNU GSL`). 
 *   **LinkingTo:** Add `RcppGSL` to this field. 

 ### 6. Best Practices for Roxygen2 Comments and Function Documentation 

 `Roxygen2` is the standard for documenting R packages, and it works seamlessly with Rcpp. 

 **Best Practices:** 

 *   Use `//'` for Roxygen comments in C++ files. 
 *   Document every function with `@param` for each parameter,
     `@return` for the return value, and `@export` to make the
     function available in R.
 *   Provide a clear and concise description of the function's purpose. 

 **Example:** 
 ```cpp 
 //' Calculate the sum of a numeric vector. 
 //' 
 //' @param x A numeric vector. 
 //' @return The sum of the elements in the vector. 
 //' @export 
 // [[Rcpp::export]] 
 double sum_vector(Rcpp::NumericVector x) { 
  return Rcpp::sum(x); 
 } 
 ``` 

 ### 7. R and C++ Function Calls in Rcpp Source 

 You can call R functions from C++ using `Rcpp::Function`. This is
 useful for accessing R's statistical functions or for
 callbacks. Similarly, you can call other C++ functions within the
 same package, which helps in modularizing your code.

 **Example:** 
 ```cpp 
 #include <Rcpp.h> 

 // [[Rcpp::export]] 
 double call_r_mean(Rcpp::NumericVector x) { 
  Rcpp::Function r_mean("mean"); 
  return Rcpp::as<double>(r_mean(x)); 
 } 
 ``` 

 ### 8. Rebuild Operations 

 To rebuild your Rcpp functions, you can use several methods: 

 *   **`Rcpp::sourceCpp()`:** Quickly compile and load a single C++
     file for testing and development.
 *   **`R CMD build` and `R CMD check`:** Standard R commands that
     will compile your C++ code as part of the package building and
     checking process.
 *   In RStudio, the "Build and Reload" button (Ctrl+Shift+B) automates this process. 

 ### 9. Code Unit Testing Support with 'testthat' Package 

 The `testthat` package is the go-to for unit testing in R, and it can
 be used to test your Rcpp functions. You can write tests that call
 your exported C++ functions and compare the results against expected
 values.

 **Example:** 
 ```R 
 # In tests/testthat/test-my_rcpp_functions.R 
 library(testthat) 
 library(yourPackageName) 
 
 test_that("sum_vector calculates the correct sum", { 
  expect_equal(sum_vector(c(1, 2, 3)), 6) 
 }) 
 ``` 

 ### Full Skeleton of a C++ Source 

 ```cpp 
 // [[Rcpp::plugins(cpp11)]] 
 
 #include <RcppArmadillo.h> 
 #include <RcppEigen.h> 
 #include <Rcpp.h> 
 #include <gsl/gsl_matrix.h> 
 #include <vector> 
 
 // [[Rcpp::depends(RcppArmadillo, RcppEigen, RcppGSL)]] 
 
 //' @title A sample Rcpp function 
 //' @description This is a sample function that demonstrates the use of Rcpp. 
 //' @param x A numeric vector. 
 //' @return The input vector multiplied by 2. 
 //' @export 
 // [[Rcpp::export]] 
 Rcpp::NumericVector my_cpp_function(Rcpp::NumericVector x) { 
  return x * 2; 
 } 
 ``` 

 ### Roxygen2 Documentation and DESCRIPTION File Requisites 

 For a package using Rcpp, RcppEigen, and GSL, your `DESCRIPTION` file should include: 

 ```yaml
 Package: myPackage 
 Type: Package 
 Title: My Awesome Package 
 Version: 0.1.0 
 Imports: Rcpp 
 LinkingTo: Rcpp, RcppEigen, RcppGSL 
 SystemRequirements: GNU GSL 
 ``` 

 Your Roxygen2 documentation should clearly document each function,
 its parameters, and what it returns, as shown in the examples above.

 ### GitHub and GitLab Packaging Action Pipeline 

 **GitHub Actions (`.github/workflows/R-CMD-check.yaml`):** 

 ```yaml 
 on: [push, pull_request] 

 name: R-CMD-check 

 jobs: 
  R-CMD-check: 
  runs-on: ${{ matrix.config.os }} 

  strategy: 
  matrix: 
  config: 
  - {os: macOS-latest, r: 'release'} 
  - {os: windows-latest, r: 'release'} 
  - {os: ubuntu-latest, r: 'devel', http-user-agent: 'release'} 
  - {os: ubuntu-latest, r: 'release'} 
  - {os: ubuntu-latest, r: 'oldrel-1'} 

  env: 
  GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }} 
  
  steps: 
  - uses: actions/checkout@v3 

  - uses: r-lib/actions/setup-r@v2 
  with: 
  r-version: ${{ matrix.config.r }} 
  http-user-agent: ${{ matrix.config.http-user-agent }} 
  use-public-rspm: true 
  
  - name: Install GSL 
  run: | 
  sudo apt-get update 
  sudo apt-get install -y libgsl-dev 
  
  - uses: r-lib/actions/setup-r-dependencies@v2 
  with: 
  extra-packages: any::rcmdcheck 
  needs: check 
  
  - uses: r-lib/actions/check-r-package@v2 
  
  - name: Upload binary package 
  if: success() 
  uses: actions/upload-artifact@v3 
  with: 
  name: package-binary 
  path: '*.Rcheck/ 
 ``` 

 **GitLab CI (`.gitlab-ci.yml`):** 

 ```yaml 
 image: rocker/tidyverse:latest 

 stages: 
  - build 
  - test 
  - deploy 

 before_script: 
  - apt-get update && apt-get install -y libgsl-dev 
  - R -e "install.packages(c('rcpp', 'devtools', 'testthat'))" 

 build: 
  stage: build 
  script: 
  - R CMD build . 
  artifacts: 
  paths: 
  - "*.tar.gz" 

 test: 
  stage: test 
  script: 
  - R CMD check --as-cran *.tar.gz 

 deploy_ftp: 
  stage: deploy 
  script: 
  - apt-get install -y lftp 
  - lftp -e "set ftp:ssl-allow no; put -O . $(ls *.tar.gz); bye" -u $FTP_USER,$FTP_PASSWORD $FTP_HOST 
  only: 
  - main 
 ```
 


# A:1 (Gemini)
> Rcpp Programming Guide


Here is a comprehensive guide on Rcpp usage for R packages, adhering to CRAN requirements and best practices.

## 1. C++11 Rcpp Sources Coding Style

Adhering to a consistent coding style is crucial for readability and
maintainability, especially in a collaborative environment. While C++
has several established style guides (like Google's or Stroustrup's),
the key for R packages is consistency and clarity.

**Recommendations:**

*   **Naming Conventions:**
    *   Use `CamelCase` for function names and class names (e.g., `myFunction`, `MyClass`).
    *   Use `snake_case` for variable names (e.g., `my_variable`).
    *   Use `UPPER_SNAKE_CASE` for constants.
*   **Indentation and Braces:**
    *   Use 2 or 4 spaces for indentation, but be consistent.
    *   Place opening braces on the same line as the statement (`{`) and closing braces on a new line (`}`).
*   **Comments:**
    *   Use `//` for single-line comments and `/* ... */` for multi-line comments.
    *   Comment complex logic, but avoid commenting on obvious code.
*   **Header Guards:**
    *   Use `#pragma once` or traditional header guards (`#ifndef MY_HEADER_H ... #endif`) to prevent multiple inclusions.

**Good Practice Example:**

```cpp
// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>

//' A function to add two numbers.
//'
//' @param x An integer.
//' @param y An integer.
//' @return The sum of x and y.
//' @export
// [[Rcpp::export]]
int add_numbers(int x, int y) {
    int sum_result = x + y;
    return sum_result;
}
```

**Bad Practice Example:**

```cpp
#include <Rcpp.h>
//No C++11 plugin enabled

// No Roxygen documentation
int add(int A, int B){ // Inconsistent bracing and capitalization
double res = A+B; // Unnecessary type conversion
return res;} // Crowded return statement
```

## 2. Rcpp Namespace Utility and Best Practices

The `Rcpp` namespace is the heart of Rcpp, providing the bridge between R and C++.

*   **Utility:** It contains classes that map R objects to C++ objects
    (e.g., `NumericVector`, `DataFrame`, `Function`) and functions
    that allow interaction with the R environment.
*   **Basic I/O:** For printing to the R console, use `Rcpp::Rcout <<
    "message";` instead of `std::cout`. For warnings and errors, use
    `Rcpp::warning("message");` and `Rcpp::stop("message");`.
*   **Memory Management:** Rcpp handles memory management
    automatically for its objects through RAII (Resource Acquisition
    Is Initialization). When an Rcpp object goes out of scope, the
    memory for the corresponding R object is released. You generally
    do not need to manually allocate or deallocate memory for Rcpp
    objects.
*   **Exception Handling:** C++ exceptions are automatically caught by
    Rcpp and converted into R errors. This means you can use
    `try-catch` blocks in your C++ code, and any uncaught exceptions
    will be properly handled by R.

**Best Practice:**

```cpp
#include <Rcpp.h>

// [[Rcpp::export]]
void process_data(Rcpp::NumericVector data) {
    try {
        if (data.size() == 0) {
            Rcpp::stop("Input data cannot be empty.");
        }
        // ... processing logic ...
        Rcpp::Rcout << "Processing complete." << std::endl;
    } catch (std::exception &ex) {
        Rcpp::warning("An exception occurred: %s", ex.what());
    }
}
```

## 3. RcppArmadillo and RcppEigen

These packages provide high-performance linear algebra libraries for C++, seamlessly integrated with R.

*   **RcppArmadillo:**
    *   **Purpose:** Provides the Armadillo C++ library, which offers a high-level syntax for linear algebra, similar to MATLAB.
    *   **Benefits:** User-friendly syntax, good performance, and extensive documentation. It's often easier to learn for those new to C++ linear algebra.
*   **RcppEigen:**
    *   **Purpose:** Provides the Eigen C++ library, another powerful template library for linear algebra.
    *   **Benefits:** Excellent performance, especially for small to medium-sized matrices, and a flexible API. It is widely used in high-performance computing.

**RcppArmadillo Example:**

```cpp
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::export]]
arma::mat invert_matrix_arma(const arma::mat& A) {
    return arma::inv(A);
}
```

**RcppEigen Example:**

```cpp
// [[Rcpp::depends(RcppEigen)]]
#include <RcppEigen.h>

// [[Rcpp::export]]
Eigen::MatrixXd invert_matrix_eigen(const Eigen::MatrixXd& A) {
    return A.inverse();
}
```

## 4. Integration with Tidyverse Packages (e.g., dplyr)

You can integrate Rcpp with tidyverse packages by creating functions
in C++ that can be called within a `dplyr` pipeline. This is often
done for performance-critical operations.

**Example:** Let's create a C++ function to compute a rolling average and use it with `dplyr`.

**C++ Code (`src/rolling_average.cpp`):**

```cpp
// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>

// [[Rcpp::export]]
Rcpp::NumericVector rolling_average(Rcpp::NumericVector x, int n) {
    int len = x.size();
    Rcpp::NumericVector out(len);

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
```

**R Code:**

```R
library(dplyr)
library(Rcpp)

# Assume the package is loaded, making rolling_average available
# sourceCpp("src/rolling_average.cpp") # for interactive testing

my_data <- tibble(
  group = rep(c("a", "b"), each = 10),
  value = rnorm(20)
)

my_data %>%
  group_by(group) %>%
  mutate(rolled_avg = rolling_average(value, n = 3))
```

## 5. Integration with Standard OS Libraries (e.g., gsl - GNU Scientific Library)

To use external libraries like GSL, you need to configure your package to link against them.

**Package Requirements:**

1.  **`DESCRIPTION` File:** You must declare the dependency.
```yaml
  LinkingTo: Rcpp, RcppArmadillo, RcppEigen
  SystemRequirements: GSL (>= 2.0)
```
2.  **`src/Makevars` and `src/Makevars.win`:** You need to tell the compiler where to find the GSL headers and libraries.

    **`src/Makevars.win` (for Windows):** This is more complex as it
    often requires bundling the library or providing instructions for
    the user to install it. For R versions 4.2 and newer, you can
    often install libraries via `rtools`.

    **`src/Makevars` (for Linux/macOS):**

    ```makefile
PKG_CPPFLAGS = `gsl-config --cflags`
PKG_LIBS = `gsl-config --libs`
    ```

**Example C++ Code:**

```cpp
// [[Rcpp::depends(RcppGSL)]] // RcppGSL can simplify things
#include <Rcpp.h>
#include <gsl/gsl_sf_bessel.h>

// [[Rcpp::export]]
double bessel_function_gsl(double x) {
    return gsl_sf_bessel_J0(x);
}
```

## 6. Best Practices for Roxygen2 Comments and Function Documentation

Roxygen2 comments are essential for creating user-friendly documentation.

**Best Practices:**

*   **Header:** Start with a concise title.
*   **Description:** Add a more detailed description of what the function does.
*   **Parameters (`@param`):** Describe each parameter, its type, and its purpose.
*   **Return Value (`@return`):** Describe what the function returns.
*   **`@export` Tag:** This makes the function available to R users.
*   **`@examples` Tag:** Provide runnable examples.
*   **`@seealso` Tag:** Link to related functions.
*   **`@keywords` Tag:** (Optional) Add keywords for indexing.

**Well-Documented Function Example:**

```cpp
//' Calculate the Inverse of a Matrix using Armadillo
//'
//' This function computes the inverse of a square matrix using the
//' RcppArmadillo library. It provides a direct interface to Armadillo's
//' `inv()` function.
//'
//' @param A A numeric square matrix.
//' @return A numeric matrix that is the inverse of `A`.
//' @seealso \code{\link[base]{solve}}
//' @examples
//' A <- matrix(c(1, 2, 3, 4), nrow = 2)
//' try({
//'   inv_A <- invert_matrix_arma(A)
//'   print(inv_A)
//' })
//' @export
// [[Rcpp::export]]
arma::mat invert_matrix_arma(const arma::mat& A) {
    if (A.n_rows != A.n_cols) {
        Rcpp::stop("Input matrix must be square.");
    }
    return arma::inv(A);
}
```

## 7. R and C++ Function Calls in Rcpp Source

You can call other R and C++ functions from your Rcpp code.

**Calling another C++ function in the same package:**

Simply define the function in a header file and include it.

**`src/my_helpers.h`**
```cpp
#ifndef MY_HELPERS_H
#define MY_HELPERS_H

double internal_calculation(double x);

#endif
```
**`src/my_helpers.cpp`**
```cpp
#include "my_helpers.h"

double internal_calculation(double x) {
    return x * x;
}
```
**`src/main.cpp`**
```cpp
#include <Rcpp.h>
#include "my_helpers.h"

// [[Rcpp::export]]
double public_function(double val) {
    return internal_calculation(val);
}
```

**Calling an R function from Rcpp:**

1.  **Get the function:** Use `Rcpp::Function` to get the R function.
2.  **Call it:** Execute it like a C++ function.

```cpp
#include <Rcpp.h>

// [[Rcpp::export]]
Rcpp::NumericVector call_r_function(Rcpp::NumericVector x) {
    Rcpp::Function r_mean("mean");
    return r_mean(x);
}
```

**Calling a function from another R package:**

Specify the package namespace when getting the function.

```cpp
#include <Rcpp.h>

// [[Rcpp::export]]
Rcpp::RObject call_dplyr_mutate() {
    Rcpp::Environment dplyr_ns = Rcpp::Environment::namespace_env("dplyr");
    Rcpp::Function mutate = dplyr_ns["mutate"];

    // Example usage (conceptual)
    // ... create a data frame and arguments ...
    // return mutate( ... );
    return R_NilValue; // Placeholder
}
```

## 8. Rebuild Operations

*   **`Rcpp::sourceCpp()`:** For interactive development, this function compiles and sources a single C++ file.
*   **`devtools::load_all()`:** During package development, this will automatically recompile any changed C++ files.
*   **`R CMD INSTALL` or `devtools::install()`:** This builds and installs the entire package, compiling all C++ source code.
*   **`R CMD check` or `devtools::check()`:** This also recompiles the C++ code as part of the checking process.

The most common and recommended workflow during development is to use `devtools::load_all()` to incrementally recompile changes.

## 9. Code Unit Testing Support with 'testthat' Package

`testthat` is the standard for unit testing in R, and it works seamlessly with Rcpp.

1.  **Setup:** Use `usethis::use_testthat()`. This creates the `tests/testthat/` directory and a `tests/testthat.R` file.
2.  **Create Test Files:** Add files like `tests/testthat/test-my_rcpp_functions.R`.
3.  **Write Tests:** Use `test_that()` blocks to organize
    tests. Inside these, use `expect_*()` functions to check your C++
    function's behavior.

**Example Test File (`tests/testthat/test-add_numbers.R`):**

```R
library(testthat)
# Assuming the package is named 'myPackage'
library(myPackage)

context("Test add_numbers C++ function")

test_that("add_numbers works with positive integers", {
  expect_equal(add_numbers(2, 3), 5)
})

test_that("add_numbers works with zero", {
  expect_equal(add_numbers(5, 0), 5)
})

test_that("add_numbers works with negative numbers", {
  expect_equal(add_numbers(-1, -5), -6)
})

test_that("add_numbers handles data types correctly", {
  expect_type(add_numbers(1, 2), "integer")
})
```

---

## Full Skeleton of a C++ Source

Here is a full skeleton of a C++ source file (`src/my_cpp_functions.cpp`) with best practices.

```cpp
// Enable C++11
// [[Rcpp::plugins(cpp11)]]

// Dependencies
// [[Rcpp::depends(RcppArmadillo, RcppEigen, RcppGSL)]]

// Standard Library Headers
#include <iostream>
#include <vector>

// Rcpp Headers
#include <Rcpp.h>
#include <RcppArmadillo.h>
#include <RcppEigen.h>

// GSL Headers (assuming RcppGSL is used or linked properly)
#include <gsl/gsl_sf_bessel.h>

// Internal Helper Functions (not exported to R)
namespace {
    double internal_helper_function(double x) {
        return x + 1.0;
    }
}

//' @title A C++ function using Armadillo
//' @description This function demonstrates basic Armadillo usage.
//' @param M A numeric matrix.
//' @return The transpose of the matrix.
//' @export
// [[Rcpp::export]]
arma::mat my_arma_function(arma::mat M) {
    return M.t();
}

//' @title A C++ function using Eigen
//' @description This function demonstrates basic Eigen usage.
//' @param A A numeric matrix.
//' @return The inverse of the matrix.
//' @export
// [[Rcpp::export]]
Eigen::MatrixXd my_eigen_function(Eigen::MatrixXd A) {
    return A.inverse();
}

//' @title A C++ function using GSL
//' @description This function calls a GSL special function.
//' @param x A numeric value.
//' @return The J0 Bessel function of x.
//' @export
// [[Rcpp::export]]
double my_gsl_function(double x) {
    return gsl_sf_bessel_J0(x);
}

//' @title A C++ function calling an R function
//' @description Demonstrates how to call an R function from C++.
//' @param vec A numeric vector.
//' @return The standard deviation calculated by R's `sd()` function.
//' @export
// [[Rcpp::export]]
double call_r_sd(Rcpp::NumericVector vec) {
    Rcpp::Function r_sd("sd");
    Rcpp::NumericVector result = r_sd(vec);
    return result[0];
}
```

## Roxygen2 Documentation and DESCRIPTION File Requisites

**Roxygen2 Documentation:**

As shown in the skeleton above, every exported C++ function should have a Roxygen2 block directly above its signature. The C++ code is parsed by `Rcpp::compileAttributes()`, which generates the necessary R wrapper code and `.Rd` documentation files.

**DESCRIPTION File:**

```yaml
Package: MyPackageName
Type: Package
Title: An Example Rcpp Package
Version: 0.1.0
Author: Your Name
Maintainer: Your Name <your.email@example.com>
Description: A package to demonstrate Rcpp, RcppArmadillo, RcppEigen, and GSL integration.
License: GPL-3
Encoding: UTF-8
LazyData: true
RoxygenNote: 7.2.3
Imports:
    Rcpp (>= 1.0.0)
LinkingTo:
    Rcpp,
    RcppArmadillo,
    RcppEigen,
    RcppGSL
SystemRequirements: GSL (>= 2.0)
Depends:
    R (>= 3.5.0)
```

**Key Points:**

*   **`Imports`:** You must import `Rcpp`.
*   **`LinkingTo`:** This is crucial. It tells R where to find the header files for the other C++ libraries at compile time.
*   **`SystemRequirements`:** This informs users (and automated
    systems) about external non-R dependencies. It doesn't install
    them but provides a human-readable note.

## GitHub and GitLab Packaging Action Pipeline

Here are example CI/CD pipelines for GitHub Actions and GitLab CI.

### GitHub Actions

Create the file `.github/workflows/R-CMD-check.yaml`:

```yaml
# Workflow for building and checking an R package
#
# This workflow runs the standard R checks on a package but also shows
# how to upload the built package to a hypothetical FTP server.

name: R-CMD-check

on:
  push:
    branches:
      - main
      - master
  pull_request:
    branches:
      - main
      - master

jobs:
  R-CMD-check:
    runs-on: ${{ matrix.config.os }}

    name: ${{ matrix.config.os }} (${{ matrix.config.r }})

    strategy:
      fail-fast: false
      matrix:
        config:
          - {os: macOS-latest,   r: 'release'}
          - {os: windows-latest, r: 'release'}
          - {os: ubuntu-latest,  r: 'devel', http-user-agent: 'release'}
          - {os: ubuntu-latest,  r: 'release'}
          - {os: ubuntu-latest,  r: 'oldrel-1'}

    env:
      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
      R_KEEP_PKG_SOURCE: yes
      FTP_USER: ${{ secrets.FTP_USER }}
      FTP_PASSWORD: ${{ secrets.FTP_PASSWORD }}

    steps:
      - uses: actions/checkout@v3

      - uses: r-lib/actions/setup-pandoc@v2

      - uses: r-lib/actions/setup-r@v2
        with:
          r-version: ${{ matrix.config.r }}
          http-user-agent: ${{ matrix.config.http-user-agent }}
          use-public-rspm: true

      - name: Install GSL (Linux)
        if: runner.os == 'Linux'
        run: sudo apt-get update && sudo apt-get install -y libgsl-dev

      - name: Install GSL (macOS)
        if: runner.os == 'macOS'
        run: brew install gsl

      - name: Install GSL (Windows)
        if: runner.os == 'Windows'
        run: pacman -S --noconfirm mingw-w64-x86_64-gsl

      - uses: r-lib/actions/setup-r-dependencies@v2
        with:
          extra-packages: any::rcmdcheck
          needs: check

      - name: Check package
        id: check
        uses: r-lib/actions/check-r-package@v2
        with:
          upload-snapshots: true

      - name: Build binary package
        if: success()
        run: |
          install.packages("devtools")
          devtools::build(binary = TRUE)
        shell: Rscript {0}

      - name: Upload binary package to FTP
        if: success()
        uses: SamKirkland/FTP-Deploy-Action@4.3.3
        with:
          server: ftp.example.com
          username: ${{ env.FTP_USER }}
          password: ${{ env.FTP_PASSWORD }}
          local-dir: ./
          # Find the built binary file (extension varies by OS)
          # This is a simplified approach; a more robust script might be needed.
          state-name: ${{ steps.check.outputs.package-tarball }}
```
**Notes for GitHub Actions:**
*   You need to add `FTP_USER` and `FTP_PASSWORD` to your repository's secrets under `Settings > Secrets and variables > Actions`.
*   The `FTP-Deploy-Action` is a third-party action.

### GitLab CI/CD

Create the file `.gitlab-ci.yml` in the root of your repository.

```yaml
# .gitlab-ci.yml
# This pipeline checks an R package and uploads a binary to FTP.

image: rocker/verse:latest

variables:
  # FTP_USER and FTP_PASSWORD should be configured in GitLab's
  # CI/CD settings -> variables (masked and protected)
  FTP_SERVER: ftp.example.com

stages:
  - test
  - build
  - deploy

before_script:
  - apt-get update && apt-get install -y libgsl-dev lftp
  - R -e 'install.packages(c("rcmdcheck", "devtools", "Rcpp", "RcppArmadillo", "RcppEigen", "RcppGSL"))'

test:
  stage: test
  script:
    - rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")

build_binary:
  stage: build
  script:
    - R -e 'devtools::build(binary = TRUE)'
  artifacts:
    paths:
      - "*.zip" # Or *.tgz depending on the OS
    expire_in: 1 week

deploy_ftp:
  stage: deploy
  script:
    # Find the binary package file created in the build stage
    - BINARY_FILE=$(ls *.zip 2>/dev/null || ls *.tgz 2>/dev/null)
    - |
      if [ -z "$BINARY_FILE" ]; then
        echo "Binary package file not found!"
        exit 1
      fi
    - echo "Uploading $BINARY_FILE to $FTP_SERVER"
    - lftp -u "$FTP_USER,$FTP_PASSWORD" $FTP_SERVER -e "set ftp:ssl-allow no; put $BINARY_FILE; quit"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"' # Only deploy from the main branch
  needs:
    - job: build_binary
      artifacts: true
```
**Notes for GitLab CI:**
*   Add `FTP_USER` and `FTP_PASSWORD` as protected and masked variables in your project's `Settings > CI/CD > Variables`.
*   This example uses the `rocker/verse` Docker image, which comes
    with many R packages pre-installed. You may need to adjust the
    `before_script` depending on your exact needs.


# A:1 (Claude)
> > Comprehensive Rcpp Guide for R Packages

* See: [Rcpp-HOWTO-claude-v4.md (sonnet 4.0)](Rcpp-HOWTO-claude-v4.md)


# A:1 (ChatGPT)
> Rcpp usage guide

Here is a comprehensive guide to **Rcpp usage in R packages**, following CRAN compliance and best practices.

---

> 🧠 Guide to Rcpp Usage in R Packages

## 1. **C++11 Rcpp Sources Coding Style**

### ✅ Recommended Style

* Follow Google C++ Style Guide adapted for Rcpp.
* Use `camelCase` for function names and `snake_case` for variables.
* Brace on the same line: `if (cond) {`
* Proper indentation (2 or 4 spaces).
* Prefer `auto` when type is obvious.
* Avoid `using namespace std;` or `Rcpp;` in headers.

### ✅ Good Practice

```cpp
// [[Rcpp::export]]
int sumVec(Rcpp::IntegerVector x) {
  int total = 0;
  for (int i = 0; i < x.size(); ++i) {
    total += x[i];
  }
  return total;
}
```

### ❌ Bad Practice

```cpp
// [[Rcpp::export]]
int sumvec(Rcpp::IntegerVector x){
int total=0;
for(int i=0;i<x.size();i++){
total+=x[i];}
return total;}
```

---

## 2. **Rcpp Namespace Utility and Best Practices**

### 🌟 Utility

* `Rcpp::` wraps native R types for seamless C++ use.
* Provides data structures (e.g., `NumericVector`, `List`) and helper macros like `RCPP_MODULE`.

### ✅ Best Practices

* Use `Rcpp::Named()` for named list output.
* Always handle exceptions with `try-catch`.
* Avoid raw pointers; prefer STL containers or Rcpp equivalents.

### ✨ Example

```cpp
// [[Rcpp::export]]
Rcpp::List stats(Rcpp::NumericVector x) {
  double mean = Rcpp::mean(x);
  double sd = Rcpp::sd(x);
  return Rcpp::List::create(Rcpp::Named("mean") = mean,
                            Rcpp::Named("sd") = sd);
}
```

---

## 3. **RcppArmadillo and RcppEigen**

### 🔧 Purpose

* **RcppArmadillo**: Linear algebra using Armadillo (efficient C++ matrix library).
* **RcppEigen**: Interfaces with Eigen, another high-performance matrix library.

### ✅ RcppArmadillo Example

```cpp
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
arma::mat matMult(arma::mat A, arma::mat B) {
  return A * B;
}
```

### ✅ RcppEigen Example

```cpp
#include <RcppEigen.h>
// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::export]]
Eigen::MatrixXd matMultEigen(Eigen::MatrixXd A, Eigen::MatrixXd B) {
  return A * B;
}
```

---

## 4. **Integration with Tidyverse Packages (e.g., dplyr)**

Rcpp functions can interoperate with tidyverse by using `dplyr::mutate()` with `.data` as input.

### ✅ Example

```r
library(Rcpp)
library(dplyr)

cppFunction('
NumericVector square(NumericVector x) {
  return x * x;
}
')

df <- tibble(x = 1:5)
df %>% mutate(x2 = square(x))
```

---

## 5. **Integration with Standard OS Libraries (e.g., GSL)**

### 🔧 Steps

* Install GSL system-wide.
* Add compiler flags via `Makevars` or `Makevars.win`.

### 🔗 `DESCRIPTION`:

```yaml
LinkingTo: Rcpp, RcppGSL
SystemRequirements: GNU Scientific Library (GSL)
```

### ✅ Example

```cpp
#include <RcppGSL.h>
#include <gsl/gsl_sf_bessel.h>

// [[Rcpp::depends(RcppGSL)]]
// [[Rcpp::export]]
double besselJ0(double x) {
  return gsl_sf_bessel_J0(x);
}
```

---

## 6. **Best Practices for Roxygen2 Comments**

### 📝 Guidelines

* Always use `@export` for R-visible functions.
* Use `@param`, `@return`, `@examples`.

### ✅ Example

```cpp
//' Compute sum of vector
//'
//' @param x Numeric vector.
//' @return Sum of elements.
//' @examples
//' cpp_sum(c(1, 2, 3))
// [[Rcpp::export]]
double cpp_sum(Rcpp::NumericVector x) {
  return sum(x);
}
```

---

## 7. **Calling Other Functions in Rcpp**

### 🔁 C++ to C++ (internal function)

```cpp
double helper(double x) {
  return x * x;
}

// [[Rcpp::export]]
double useHelper(double x) {
  return helper(x);
}
```

### 🔁 R call from C++

```cpp
// [[Rcpp::export]]
SEXP call_r_fun(SEXP x) {
  Rcpp::Function f("log");
  return f(x);
}
```

---

## 8. **Rebuild Operations**

### 🔄 Options:

* Rebuild with `Rcpp::compileAttributes()`.
* Rebuild package:

```sh
R CMD build mypkg
R CMD check mypkg_*.tar.gz
```

---

## 9. **Unit Testing with `testthat`**

### ✅ Setup

* Add `testthat` to `Suggests` in `DESCRIPTION`.
* Enable in `tests/testthat.R`.

### ✅ Example Test

```r
test_that("cpp_sum works", {
  expect_equal(cpp_sum(c(1, 2, 3)), 6)
})
```

---

## 🔧 Full Skeleton of a C++ Source File

```cpp
// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include <RcppArmadillo.h>
#include <RcppEigen.h>
#include <gsl/gsl_sf_bessel.h>
#include <vector>
#include <string>

// [[Rcpp::depends(RcppArmadillo, RcppEigen, RcppGSL)]]
// [[Rcpp::export]]
Rcpp::List example_function(Rcpp::NumericVector x) {
  arma::vec ax(x.begin(), x.size(), false);
  Eigen::VectorXd ex = Eigen::Map<Eigen::VectorXd>(x.begin(), x.size());
  double bessel_val = gsl_sf_bessel_J0(x[0]);

  return Rcpp::List::create(
    Rcpp::Named("arma_sum") = arma::sum(ax),
    Rcpp::Named("eigen_sum") = ex.sum(),
    Rcpp::Named("bessel_j0") = bessel_val
  );
}
```

---

## 🧾 Roxygen2 + DESCRIPTION Requirements

### ✅ Roxygen Tags

* `@useDynLib yourpackage, .registration=TRUE`
* `@importFrom Rcpp sourceCpp`
* `@import Rcpp`

### ✅ DESCRIPTION

```r
Imports: Rcpp
LinkingTo: Rcpp, RcppArmadillo, RcppEigen, RcppGSL
SystemRequirements: GNU Scientific Library (GSL)
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.2.3
```

---

## 🔄 GitHub/GitLab CI Pipeline (R CMD Check + Binary Upload)

### ✅ GitHub Actions `.github/workflows/R-CMD-check.yml`

```yaml
name: R-CMD-check

on:
  push:
  pull_request:

jobs:
  R-CMD-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: r-lib/actions/setup-r@v2
      - uses: r-lib/actions/setup-r-dependencies@v2
        with:
          extra-packages: any::rcmdcheck
      - name: Check
        run: R CMD check --as-cran .
      - name: Build Binary
        run: R CMD INSTALL --build .
      - name: Upload to FTP
        if: success()
        env:
          FTP_USER: ${{ secrets.FTP_USER }}
          FTP_PASS: ${{ secrets.FTP_PASS }}
        run: |
          curl -T *.tar.gz ftp://ftp.example.com/path/ \
            --user "$FTP_USER:$FTP_PASS"
```

### ✅ GitLab `.gitlab-ci.yml`

```yaml
check:
  image: rocker/r-ver:4.3.0
  script:
    - R -e 'rcmdcheck::rcmdcheck(args = "--as-cran")'
    - R CMD INSTALL --build .
    - curl -T *.tar.gz ftp://ftp.example.com/path/ --user $FTP_USER:$FTP_PASS
```

---

Let me know if you need a sample working package layout or help uploading to CRAN.




# A:1 (DeepSeek)
> Comprehensive Guide to Using Rcpp in R Packages


#### 1. **C++11 Rcpp Sources Coding Style**
**Recommendations:**
- **Naming:** Use `snake_case` for functions/variables, `CamelCase` for classes
- **Indentation:** 2 spaces (CRAN-compliant)
- **Braces:** Always include `{}`, even for single-line blocks
- **Headers:** Order includes as: Rcpp, STL, external libraries
- **Comments:** Use `//` for single-line, `/* */` for multi-line

**Good Practice:**
```cpp
#include <Rcpp.h>
using namespace Rcpp;

// Calculate vector mean
// [[Rcpp::export]]
double calculate_mean(NumericVector x) {
  double total = 0.0;
  for (int i = 0; i < x.size(); ++i) {
    total += x[i];
  }
  return total / x.size();
}
```

**Bad Practice:**
```cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double mean(NumericVector x){  // No spaces, poor naming
double t=0;                   // Single-letter variable
for(int i=0;i<x.size();i++) t+=x[i];  // No braces
return t/x.size();}
```

---

#### 2. **Rcpp Namespace Utility and Best Practices**
**Key Utilities:**
- `Rcpp::NumericVector`, `Rcpp::DataFrame`: R data structures
- `Rcpp::stop()`: Exception handling
- `Rcpp::Rcout`: Output redirection

**Best Practices:**
```cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
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
```

---

#### 3. **RcppArmadillo and RcppEigen**
**RcppArmadillo:** 
- Linear algebra with MATLAB-like syntax
```cpp
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat arma_matrix_mult(arma::mat A, arma::mat B) {
  return A * B;
}
```

**RcppEigen:**
- Template-based linear algebra
```cpp
#include <RcppEigen.h>
// [[Rcpp::depends(RcppEigen)]]

// [[Rcpp::export]]
Eigen::MatrixXd eigen_matrix_mult(Eigen::MatrixXd A, Eigen::MatrixXd B) {
  return A * B;
}
```

---

#### 4. **Integration with Tidyverse Packages**
**Approach:** Return `DataFrame` for dplyr piping
```cpp
// [[Rcpp::export]]
DataFrame process_data(DataFrame df) {
  NumericVector x = df["x"];
  NumericVector y = exp(x) / sum(exp(x));
  return DataFrame::create(_["x"] = x, _["y"] = y);
}
```

**R Usage:**
```r
library(dplyr)
df %>% 
  process_data() %>%
  filter(y > 0.1) %>%
  mutate(z = y * 2)
```

---

#### 5. **Integration with OS Libraries (GSL)**
**Implementation:**
1. Add to `DESCRIPTION`:
   ```
   SystemRequirements: GNU GSL
   LinkingTo: Rcpp
   ```
2. Create `src/Makevars`:
   ```make
   PKG_LIBS = `$(R_HOME)/bin/Rscript -e "Rcpp:::LdFlags()"` -lgsl -lgslcblas
   ```

**C++ Example:**
```cpp
#include <gsl/gsl_sf_bessel.h>
#include <Rcpp.h>

// [[Rcpp::export]]
NumericVector gsl_bessel_j0(NumericVector x) {
  NumericVector y(x.size());
  for(int i=0; i<x.size(); i++) {
    y[i] = gsl_sf_bessel_J0(x[i]);
  }
  return y;
}
```

---

#### 6. **Roxygen2 Documentation Best Practices**
**C++ File Example:**
```cpp
//' Compute Euclidean distance matrix
//'
//' @param x Numeric matrix (n x p)
//' @return n x n distance matrix
//' @examples
//' dist_matrix(as.matrix(iris[,1:2]))
//' @export
// [[Rcpp::export]]
NumericMatrix dist_matrix(NumericMatrix x) {
  // ... implementation ...
}
```

---

#### 7. **R and C++ Function Calls**
**Calling R Functions:**
```cpp
// [[Rcpp::export]]
NumericVector rnorm_rcpp(int n) {
  Function rnorm("rnorm");
  return rnorm(n, _["mean"] = 0, _["sd"] = 1);
}
```

**Calling C++ Functions:**
```cpp
double internal_helper(double x) { return x*x; }

// [[Rcpp::export]]
NumericVector square_vec(NumericVector x) {
  NumericVector y(x.size());
  for(int i=0; i<x.size(); i++) {
    y[i] = internal_helper(x[i]);
  }
  return y;
}
```

---

#### 8. **Rebuild Operations**
**Commands:**
```bash
# Full rebuild
R CMD INSTALL --preclean --clean .

# Partial rebuild (devtools)
devtools::load_all()  # During development
devtools::document()  # Update documentation
```

---

#### 9. **Unit Testing with testthat**
**Test File (`tests/testthat/test-rcpp.R`):**
```r
test_that("Matrix multiplication works", {
  A <- matrix(1:4, ncol=2)
  B <- matrix(c(1,0,0,1), ncol=2)
  expect_equal(arma_matrix_mult(A, B), A)
})

test_that("Error handling works", {
  expect_error(safe_divide(1:3, 1:2))
})
```

---

### Supplemental Materials

#### 1. **C++ Source Skeleton**
```cpp
// mypackage/src/rcpp_functions.cpp

// Enable C++11
// [[Rcpp::plugins(cpp11)]]

// Dependencies
// [[Rcpp::depends(RcppArmadillo, RcppEigen)]]

#include <Rcpp.h>
#include <RcppArmadillo.h>
#include <RcppEigen.h>
#include <vector>
#include <gsl/gsl_math.h>

using namespace Rcpp;

//' @title Sample Function
//' @description Demonstrates multiple library usage
//' @param x NumericVector input
//' @return List with transformed outputs
//' @export
// [[Rcpp::export]]
List sample_function(NumericVector x) {
  // Rcpp operation
  double rcpp_mean = mean(x);
  
  // Armadillo operation
  arma::vec arma_x = as<arma::vec>(x);
  double arma_var = arma::var(arma_x);
  
  // Eigen operation
  Eigen::VectorXd eigen_x = as<Eigen::VectorXd>(x);
  double eigen_norm = eigen_x.norm();
  
  // GSL operation
  double gsl_result = gsl_hypot(3, 4);  // 5.0
  
  return List::create(
    Named("mean") = rcpp_mean,
    Named("variance") = arma_var,
    Named("norm") = eigen_norm,
    Named("gsl_hypot") = gsl_result
  );
}
```

---

#### 2. **DESCRIPTION Requisites**
```yaml
Package: mypackage
Title: My R Package
Version: 0.1.0
Imports: 
    Rcpp (>= 1.0.7)
LinkingTo: 
    Rcpp,
    RcppArmadillo,
    RcppEigen
SystemRequirements: 
    GNU GSL (>= 2.7),
    C++11
```

---

#### 3. **CI/CD Pipeline Templates**

**GitHub Action (.github/workflows/rcpp-ci.yml):**
```yaml
name: R-CMD-Check

on: [push, pull_request]

jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        
    steps:
    - uses: actions/checkout@v2
      
    - name: Set up R
      uses: r-lib/actions/setup-r@v1
      
    - name: Install dependencies
      run: |
        sudo apt-get install -y libgsl-dev  # Linux only
        R -e "install.packages(c('devtools', 'rcmdcheck'))"
        R -e "devtools::install_deps(dependencies=TRUE)"
        
    - name: Build and check
      run: R CMD build . && R CMD check *.tar.gz --as-cran
      
    - name: Upload binary
      if: success() && matrix.os == 'ubuntu-latest'
      env:
        FTP_USER: ${{ secrets.FTP_USER }}
        FTP_PASS: ${{ secrets.FTP_PASS }}
      run: |
        curl -T mypackage*.tar.gz \
          -u $FTP_USER:$FTP_PASS \
          ftp://myftpserver.com/packages/
```

**GitLab CI (.gitlab-ci.yml):**
```yaml
image: rocker/r-ver:4.3.0

stages:
  - build
  - deploy

variables:
  GIT_SUBMODULE_STRATEGY: recursive

before_script:
  - apt-get update -qq && apt-get install -y libgsl-dev
  - R -e "install.packages(c('devtools', 'rcmdcheck'))"
  - R -e "devtools::install_deps()"

build:
  stage: build
  script:
    - R CMD build .
    - R CMD check *.tar.gz --as-cran

deploy:
  stage: deploy
  only:
    - main
  script:
    - curl -T mypackage*.tar.gz 
      -u $FTP_USER:$FTP_PASSWORD 
      ftp://myftpserver.com/packages/
```

---

This guide provides a comprehensive overview of Rcpp best practices, CRAN compliance, and modern development workflows. Always validate with `R CMD check --as-cran` before submission.

# A:1 (Kimi)
> Comprehensive Guide to Rcpp Usage in R Packages

## 1. C++11 Rcpp Sources Coding Style

### Recommended Coding Style

The recommended coding style for C++11 Rcpp sources follows the [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html) with R-specific adaptations:

#### Good Practices:
```cpp
// Good: Clear naming, proper spacing, const correctness
namespace mypackage {

double compute_sum(const Rcpp::NumericVector& x) {
  double total = 0.0;
  for (size_t i = 0; i < x.size(); ++i) {
    total += x[i];
  }
  return total;
}

} // namespace mypackage
```

#### Bad Practices:
```cpp
// Bad: Poor naming, magic numbers, no const correctness
double computeSum(Rcpp::NumericVector x){
double total=0;
for(int i=0;i<x.size();i++){
total+=x[i];
}
return total;
}
```

### Key Style Guidelines:
- **Naming**: Use `snake_case` for variables/functions, `PascalCase` for classes
- **Indentation**: 2 spaces (no tabs)
- **Line length**: Maximum 80 characters
- **Headers**: Include guards using `#pragma once`
- **Namespaces**: Always wrap code in a package-specific namespace

## 2. Rcpp Namespace Utility and Best Practices

### Namespace Utility
The Rcpp namespace provides:
- Seamless R/C++ data type conversion
- Memory management through R's garbage collector
- Exception handling bridging R errors and C++ exceptions

### Best Practices

#### Basic I/O:
```cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List safe_io_example(NumericVector x) {
  // Input validation
  if (x.size() == 0) {
    Rcpp::stop("Input vector cannot be empty");
  }
  
  // Rcpp::Rcout for C++ output to R console
  Rcpp::Rcout << "Processing vector of length " << x.size() << std::endl;
  
  return List::create(
    Named("mean") = Rcpp::mean(x),
    Named("sum") = Rcpp::sum(x)
  );
}
```

#### Memory Management:
```cpp
// [[Rcpp::export]]
IntegerVector memory_efficient_resize(IntegerVector x, int new_size) {
  // Rcpp automatically manages memory through R's GC
  IntegerVector result(new_size);
  
  // Efficient copy with bounds checking
  std::copy(x.begin(), 
            x.begin() + std::min(x.size(), static_cast<R_xlen_t>(new_size)),
            result.begin());
  
  return result;
}
```

#### Exception Handling:
```cpp
// [[Rcpp::export]]
double safe_division(double a, double b) {
  try {
    if (b == 0.0) {
      throw std::runtime_error("Division by zero");
    }
    return a / b;
  } catch (const std::exception& e) {
    Rcpp::stop("Error in division: " + std::string(e.what()));
  }
}
```

## 3. RcppArmadillo and RcppEigen

### RcppArmadillo
Purpose: Provides seamless integration between R and Armadillo C++ linear algebra library.

Benefits:
- High-performance linear algebra operations
- MATLAB-like syntax
- Automatic memory management

#### Sample Usage:
```cpp
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::export]]
arma::mat arma_multiply(const arma::mat& A, const arma::mat& B) {
  // Matrix multiplication
  return A * B;
}

// [[Rcpp::export]]
List arma_eigen(const arma::mat& X) {
  arma::vec eigenvals;
  arma::mat eigenvecs;
  
  bool success = arma::eig_sym(eigenvals, eigenvecs, X);
  
  return List::create(
    Named("values") = eigenvals,
    Named("vectors") = eigenvecs,
    Named("success") = success
  );
}
```

### RcppEigen
Purpose: Integration with Eigen C++ template library for linear algebra.

Benefits:
- Expression templates for optimized performance
- Header-only library
- Advanced linear algebra operations

#### Sample Usage:
```cpp
// [[Rcpp::depends(RcppEigen)]]
#include <RcppEigen.h>

// [[Rcpp::export]]
Eigen::MatrixXd eigen_solve(const Eigen::Map<Eigen::MatrixXd>& A,
                           const Eigen::Map<Eigen::VectorXd>& b) {
  // Solve linear system Ax = b
  return A.colPivHouseholderQr().solve(b);
}

// [[Rcpp::export]]
double eigen_determinant(const Eigen::Map<Eigen::MatrixXd>& M) {
  return M.determinant();
}
```

## 4. Integration with Tidyverse Packages

### Integration with dplyr

```cpp
// [[Rcpp::export]]
DataFrame rcpp_dplyr_grouped_sum(DataFrame df, String group_col, String value_col) {
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
```

### R Usage Example:
```r
library(dplyr)
library(Rcpp)

# Assuming the above C++ function is compiled
result <- rcpp_dplyr_grouped_sum(mtcars, "cyl", "mpg")
```

## 5. Integration with Standard OS Libraries (GSL)

### GSL Integration

```cpp
// [[Rcpp::depends(RcppGSL)]]
#include <RcppGSL.h>
#include <gsl/gsl_sf_gamma.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

// [[Rcpp::export]]
NumericVector gsl_gamma_values(NumericVector x) {
  int n = x.size();
  NumericVector result(n);
  
  for (int i = 0; i < n; ++i) {
    result[i] = gsl_sf_gamma(x[i]);
  }
  
  return result;
}

// [[Rcpp::export]]
NumericVector gsl_rnorm(int n, double mu, double sigma) {
  gsl_rng* r = gsl_rng_alloc(gsl_rng_mt19937);
  gsl_rng_set(r, std::time(nullptr));
  
  NumericVector result(n);
  for (int i = 0; i < n; ++i) {
    result[i] = mu + gsl_ran_gaussian(r, sigma);
  }
  
  gsl_rng_free(r);
  return result;
}
```

### Package Requirements for GSL

In `DESCRIPTION`:
```yaml
SystemRequirements: GNU GSL
LinkingTo: RcppGSL
```

In `Makevars`:
```makefile
PKG_CPPFLAGS = $(GSL_CFLAGS)
PKG_LIBS = $(GSL_LIBS)
```

## 6. Best Practices for Roxygen2 Comments

```cpp
//' Compute the Euclidean distance between two vectors
//'
//' This function calculates the Euclidean distance between two numeric vectors
//' of equal length.
//'
//' @param x A numeric vector
//' @param y A numeric vector of same length as x
//' @return The Euclidean distance between x and y
//' @examples
//' x <- c(1, 2, 3)
//' y <- c(4, 5, 6)
//' euclidean_distance(x, y)
//' @export
// [[Rcpp::export]]
double euclidean_distance(const NumericVector& x, const NumericVector& y) {
  if (x.size() != y.size()) {
    Rcpp::stop("Vectors must be of equal length");
  }
  
  double sum = 0.0;
  for (int i = 0; i < x.size(); ++i) {
    sum += pow(x[i] - y[i], 2);
  }
  
  return sqrt(sum);
}
```

## 7. R and C++ Function Calls

### Calling R Functions from Rcpp

```cpp
// [[Rcpp::export]]
List call_r_function(NumericVector x) {
  // Get R's sd function
  Rcpp::Environment stats("package:stats");
  Rcpp::Function sd_fun = stats["sd"];
  
  // Call the function
  double std_dev = Rcpp::as<double>(sd_fun(x));
  
  // Call another C++ function
  double mean_val = Rcpp::mean(x);
  
  return List::create(
    Named("mean") = mean_val,
    Named("sd") = std_dev
  );
}
```

### Calling C++ Functions from Rcpp

```cpp
// Helper function (not exported)
double internal_helper(const NumericVector& x) {
  return Rcpp::sum(x * x);
}

// [[Rcpp::export]]
double use_helper(NumericVector x) {
  return internal_helper(x);
}
```

## 8. Rebuild Operations

### Rebuilding Rcpp Functions

```r
# Method 1: Direct compilation
Rcpp::sourceCpp("src/my_functions.cpp")

# Method 2: Package development
devtools::load_all()  # Recompiles and loads

# Method 3: Standard R commands
R CMD build mypackage
R CMD check mypackage.tar.gz

# Method 4: Using devtools
devtools::check()
devtools::build()
devtools::install()
```

## 9. Code Unit Testing with testthat

### Test File Structure (`tests/testthat/test-rcpp.R`):

```r
test_that("Euclidean distance works correctly", {
  # Test basic functionality
  x <- c(0, 0)
  y <- c(3, 4)
  expect_equal(euclidean_distance(x, y), 5)
  
  # Test with negative values
  x <- c(-1, -1)
  y <- c(2, 3)
  expect_equal(euclidean_distance(x, y), 5)
  
  # Test error handling
  expect_error(euclidean_distance(c(1, 2), c(1, 2, 3)))
})

test_that("Gamma function integration works", {
  # Test GSL integration
  x <- seq(1, 5, by = 0.5)
  result <- gsl_gamma_values(x)
  expected <- gamma(x)
  expect_equal(result, expected, tolerance = 1e-10)
})
```

## Full C++ Source Skeleton

```cpp
// #pragma once
#ifndef MYPACKAGE_UTILS_HPP
#define MYPACKAGE_UTILS_HPP

// Enable C++11
// [[Rcpp::plugins(cpp11)]]

// Rcpp headers
#include <Rcpp.h>

// Additional Rcpp packages
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::depends(RcppEigen)]]
#include <RcppEigen.h>

// [[Rcpp::depends(RcppGSL)]]
#include <RcppGSL.h>

// Standard library headers
#include <vector>
#include <algorithm>
#include <cmath>
#include <memory>
#include <unordered_map>

// GSL headers
#include <gsl/gsl_sf_gamma.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <gsl/gsl_statistics.h>

// Package namespace
namespace mypackage {

// Forward declarations
double internal_helper(const Rcpp::NumericVector& x);
arma::mat arma_operations(const arma::mat& A);

// Main exported function
//' Main computation function
//'
//' @param x Input matrix
//' @param y Input vector
//' @return List containing results
// [[Rcpp::export]]
Rcpp::List main_computation(const Rcpp::NumericMatrix& x,
                           const Rcpp::NumericVector& y) {
  try {
    // Validate inputs
    if (x.nrow() != y.size()) {
      Rcpp::stop("Matrix rows must match vector length");
    }
    
    // Convert to Armadillo
    arma::mat X = Rcpp::as<arma::mat>(x);
    arma::vec Y = Rcpp::as<arma::vec>(y);
    
    // Perform operations
    arma::mat XtX = X.t() * X;
    arma::vec beta = arma::solve(XtX, X.t() * Y);
    
    // Eigen operations
    Eigen::Map<Eigen::MatrixXd> eigen_X(Rcpp::as<Eigen::Map<Eigen::MatrixXd>>(x));
    Eigen::VectorXd eigen_Y = Rcpp::as<Eigen::VectorXd>(y);
    
    // Return results
    return Rcpp::List::create(
      Rcpp::Named("beta") = beta,
      Rcpp::Named("determinant") = arma::det(XtX),
      Rcpp::Named("eigen_values") = Rcpp::eigen_values(XtX)
    );
    
  } catch (const std::exception& e) {
    Rcpp::stop("Error in computation: " + std::string(e.what()));
  }
}

} // namespace mypackage

#endif // MYPACKAGE_UTILS_HPP
```

## Roxygen2 Documentation and DESCRIPTION Requisites

### DESCRIPTION File:
```yaml
Package: mypackage
Type: Package
Title: Advanced Rcpp Package with Multiple Dependencies
Version: 1.0.0
Authors@R: c(
    person("John", "Doe", email = "john@example.com", role = c("aut", "cre"))
  )
Description: A comprehensive Rcpp package demonstrating integration with
    Armadillo, Eigen, and GSL libraries.
License: GPL (>= 3)
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.2.3
Depends: 
    R (>= 4.0.0)
Imports:
    Rcpp (>= 1.0.10),
    dplyr
LinkingTo:
    Rcpp,
    RcppArmadillo,
    RcppEigen,
    RcppGSL
SystemRequirements: GNU GSL, C++11
Suggests:
    testthat (>= 3.0.0)
Config/testthat/edition: 3
```

### NAMESPACE File (auto-generated):
```r
# Generated by roxygen2: do not edit by hand

exportPattern("^[[:alpha:]]+")
importFrom(Rcpp, evalCpp)
useDynLib(mypackage, .registration = TRUE)
```

## GitHub/GitLab Packaging Action Pipeline

### GitHub Actions (.github/workflows/R-CMD-check.yaml):

```yaml
name: R-CMD-check

on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]

jobs:
  R-CMD-check:
    runs-on: ${{ matrix.config.os }}
    
    name: ${{ matrix.config.os }} (${{ matrix.config.r }})
    
    strategy:
      fail-fast: false
      matrix:
        config:
          - {os: ubuntu-latest,   r: 'release'}
          - {os: macOS-latest,   r: 'release'}
          - {os: windows-latest, r: 'release'}
    
    env:
      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
      R_KEEP_PKG_SOURCE: yes
      FTP_USER: ${{ secrets.FTP_USER }}
      FTP_PASSWORD: ${{ secrets.FTP_PASSWORD }}
      FTP_SERVER: ftp.example.com
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: r-lib/actions/setup-pandoc@v2
      
      - uses: r-lib/actions/setup-r@v2
        with:
          r-version: ${{ matrix.config.r }}
          http-user-agent: ${{ matrix.config.http-user-agent }}
          use-public-rspm: true
      
      - name: Install system dependencies (Ubuntu)
        if: runner.os == 'Linux'
        run: |
          sudo apt-get update -y
          sudo apt-get install -y libgsl-dev
      
      - name: Install system dependencies (macOS)
        if: runner.os == 'macOS'
        run: |
          brew install gsl
      
      - name: Install dependencies
        uses: r-lib/actions/setup-r-dependencies@v2
        with:
          extra-packages: any::rcmdcheck
      
      - name: Check
        uses: r-lib/actions/check-r-package@v2
        with:
          upload-snapshots: true
      
      - name: Build binary package
        run: |
          R CMD build .
          PKG_FILE=$(ls -t *.tar.gz | head -n 1)
          echo "PKG_FILE=$PKG_FILE" >> $GITHUB_ENV
      
      - name: Upload to FTP (if successful)
        if: success() && matrix.config.os == 'ubuntu-latest'
        run: |
          sudo apt-get install -y lftp
          lftp -u $FTP_USER,$FTP_PASSWORD $FTP_SERVER <<EOF
          set ftp:ssl-allow no
          cd /packages
          put ${{ env.PKG_FILE }}
          bye
          EOF
```

### GitLab CI (.gitlab-ci.yml):

```yaml
stages:
  - test
  - build
  - deploy

variables:
  _R_CHECK_FORCE_SUGGESTS_: "FALSE"
  FTP_USER: "$FTP_USER"
  FTP_PASSWORD: "$FTP_PASSWORD"
  FTP_SERVER: "ftp.example.com"

test:
  stage: test
  image: rocker/r-base:latest
  before_script:
    - apt-get update -y
    - apt-get install -y libgsl-dev libcurl4-openssl-dev libssl-dev
  script:
    - R -e "install.packages(c('devtools', 'testthat', 'Rcpp', 'RcppArmadillo', 'RcppEigen', 'RcppGSL'))"
    - R -e "devtools::check()"

build:
  stage: build
  image: rocker/r-base:latest
  only:
    - main
  script:
    - apt-get update -y
    - apt-get install -y libgsl-dev
    - R CMD build .
    - PKG_FILE=$(ls -t *.tar.gz | head -n 1)
    - echo "Built $PKG_FILE"
  artifacts:
    paths:
      - "*.tar.gz"

deploy:
  stage: deploy
  image: alpine:latest
  only:
    - main
  dependencies:
    - build
  script:
    - apk add --no-cache lftp
    - PKG_FILE=$(ls -t *.tar.gz | head -n 1)
    - lftp -u $FTP_USER,$FTP_PASSWORD $FTP_SERVER -e "set ftp:ssl-allow no; cd /packages; put $PKG_FILE; bye"
```

This comprehensive guide provides all necessary information for developing, documenting, testing, and deploying R packages with Rcpp, including integration with major C++ libraries and continuous integration workflows.

# A:1 (Diffusion)
> ...

# A:1 (LeChat)
> ...

# A:1 (Perplexity)
> Rcpp Guide for R Packages

## 1. C++11 Rcpp Sources Coding Style

### Recommended Coding Style

- **Indentation:** Use 4 spaces, not tabs.
- **File Names:** Use `.cpp` for source files.
- **Headers:** Always include ``, and only include other headers as needed.
- **Namespaces:** Prefer `Rcpp::` prefix instead of `using namespace Rcpp;` to avoid namespace pollution.
- **Bracing and Alignment:** Place braces on the same line. Align control statements and use clear, readable formatting.
- **Variable Naming:** Use `snake_case` or `camelCase` consistently.
- **Auto:** Use `auto` wisely to improve clarity but not to hide types unnecessarily (a C++11 feature).
- **Return Types:** Use explicit return types for functions.
- **Initialization:** Use brace `{}` initialization where possible (C++11 feature).
- **Comments:** Prefer block (`// ...`) or Doxygen-style comments for documentation.

#### Example: Good Practice

```cpp
#include 

// [[Rcpp::export]]
int sum_cpp(const std::vector& x) {
    int total = 0;
    for (const auto& value : x) {
        total += value;
    }
    return total;
}
```

#### Example: Bad Practice

```cpp
#include
using namespace Rcpp;
int sum_cpp(vector x){
int total=0;for(int i=0;i
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
arma::mat mat_mult(const arma::mat& A, const arma::mat& B) {
    return A * B;
}
```

### RcppEigen

- **Purpose:** Interface to Eigen library, providing big and small dense/sparse matrix computations[^3][^4].
- **Benefits:** Fast, powerful, elegant syntax, and advanced solvers.

#### Example

```cpp
#include 
// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::export]]
Eigen::VectorXd get_eigenvalues(Eigen::MatrixXd M) {
    Eigen::SelfAdjointEigenSolver es(M);
    return es.eigenvalues();
}
```

## 4. Integration with Tidyverse Packages (e.g., dplyr)

- **Usage:** Use `Rcpp::DataFrame`, `NumericVector` and connect with dplyr-processed data[^5].
- **Dependency:** Add `// [[Rcpp::depends(dplyr)]]` in the source and corresponding entries in the DESCRIPTION.

#### Example

```cpp
#include 
// [[Rcpp::depends(dplyr)]]
// [[Rcpp::export]]
Rcpp::DataFrame add_one(Rcpp::DataFrame df) {
    Rcpp::NumericVector x = df["x"];
    x = x + 1;
    df["x"] = x;
    return df;
}
```
Used in R after dplyr mutate/select, or inside a dplyr pipeline using `do()`.

## 5. Integration with Standard OS Libraries (e.g., GSL)

- **Integration:** Use `` etc. in your C++ files. For smoother R interfacing, use RcppGSL[^6][^7].
- **DESCRIPTION requirements:**
    - `LinkingTo: Rcpp, RcppGSL`
    - `SystemRequirements: GNU GSL`
- **Linkage:** Configure `src/Makevars` using `gsl-config --cflags` and `--libs` or use `configure.ac` for portability[^8][^9].

#### Example

```cpp
#include 
#include 
// [[Rcpp::export]]
double gsl_bessel0(double x) {
    return gsl_sf_bessel_J0(x);
}
```

## 6. Best Practices for Roxygen2 Comments and Function Documentation

- **Place above function, before `// [[Rcpp::export]]`.**
- **Include:** Title, description, parameters, return, examples, and `@export`.
- **Document all argument types and units.**

#### Example

```cpp
//' Sum elements of a vector
//'
//' Computes the sum of the supplied numeric vector.
//' @param x A numeric vector.
//' @return Numeric scalar. The sum of \code{x}.
//' @examples
//' sum_cpp(c(1, 2, 3))
//' @export
// [[Rcpp::export]]
double sum_cpp(Rcpp::NumericVector x) {
    return std::accumulate(x.begin(), x.end(), 0.0);
}
```

## 7. R and C++ Function Calls in Rcpp Source

- **C++ Function From Package:** Include in same or another `.cpp` source. Declare its prototype.
- **External R Function:** Use `Rcpp::Function`.

#### Example: Calling an R function

```cpp
// [[Rcpp::export]]
Rcpp::NumericVector call_mean(Rcpp::NumericVector x) {
    Rcpp::Function mean("mean");
    return mean(x);
}
```

#### Example: C++ function calling another C++ function

```cpp
double helper(double x) { return x * 2; }

// [[Rcpp::export]]
double use_helper(double x) { return helper(x); }
```

## 8. Rebuild Operations

- **Re-compile in R:** `devtools::load_all()` or `Rcpp::compileAttributes()`, or touch source and run.
- **Command line:** `R CMD build .`, `R CMD check --as-cran .`
- **RStudio:** Use "Build & Reload".

## 9. Code Unit Testing Support with 'testthat'

- **Put test files in `tests/testthat/` directory.**
- **Call exported Rcpp functions in test files as for R functions[^10].**

#### Example

```R
test_that("sum_cpp works for a numeric vector", {
    expect_equal(sum_cpp(c(1,2,3,4)), 10)
    expect_error(sum_cpp(NULL))
})
```

# 1. Full Skeleton of a C++ Source

```cpp
// Enable C++11
// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::depends(RcppGSL)]]
// [[Rcpp::depends(dplyr)]]

#include 
#include 
#include 
#include 
#include 
#include 
#include 

// [[Rcpp::export]]
double example_function(Rcpp::NumericVector x) {
    // Use Rcpp and STL idioms
    return std::accumulate(x.begin(), x.end(), 0.0);
}
```

# 2. Roxygen2 Documentation and DESCRIPTION File Requisites

**Roxygen2:**
- Add `@useDynLib , .registration = TRUE` in your main package R file.
- Add `@importFrom Rcpp sourceCpp` and document all parameters and return values[^11][^12].

**DESCRIPTION File:**
```yaml
Imports: Rcpp (>= 1.0.0), dplyr
LinkingTo: Rcpp, RcppArmadillo, RcppEigen, RcppGSL
SystemRequirements: GNU GSL
Suggests: testthat
```

# 3. GitHub and GitLab Packaging Action Pipeline

Here is a minimal **GitHub Actions** workflow and a conceptually similar **GitLab CI** pipeline. Both run R CMD check and, if successful, upload the built package to a remote FTP server using provided environment variables.

## GitHub Actions: `.github/workflows/R-CMD-check.yaml`

```yaml
name: R-CMD-check

on: [push, pull_request]

jobs:
  R-CMD-check:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4
    - uses: r-lib/actions/setup-r@v2
    - name: Install dependencies
      run: |
        install.packages(c('devtools', 'Rcpp', 'RcppArmadillo', 'RcppEigen', 'RcppGSL', 'dplyr', 'testthat'))
    - name: Check
      run: R CMD check --as-cran .
    - name: Build
      run: R CMD build .
    - name: Upload to FTP
      if: success()
      run: |
        curl -T *.tar.gz -u "${{ secrets.FTP_USER }}:${{ secrets.FTP_PASSWORD }}" "ftp://${{ secrets.FTP_HOST }}/upload/"
```

## GitLab CI: `.gitlab-ci.yml`

```yaml
stages:
  - build
  - upload

build_package:
  image: r-base:latest
  script:
    - apt-get update && apt-get install -y libgsl-dev libcurl4-openssl-dev
    - Rscript -e 'install.packages(c("devtools", "Rcpp", "RcppArmadillo", "RcppEigen", "RcppGSL", "dplyr", "testthat"))'
    - R CMD check --as-cran .
    - R CMD build .

upload_ftp:
  stage: upload
  script:
    - apt-get update && apt-get install -y curl
    - curl -T *.tar.gz -u "$FTP_USER:$FTP_PASSWORD" "ftp://$FTP_HOST/upload/"
  only:
    - master
  dependencies:
    - build_package
  when: on_success
```

**(Set `FTP_USER`, `FTP_PASSWORD`, `FTP_HOST` in repository secrets/variables.)**

This guide presents a comprehensive set of up-to-date best practices for using Rcpp and its ecosystem with C++11, armadillo, eigen, dplyr, external libraries like GSL, and robust packaging/testing workflows that conform to CRAN standards[^13][^1][^14][^3][^5][^6][^11][^2][^7][^12].

[^1]: https://cran.r-project.org/package=Rcpp
[^2]: https://www.geeksforgeeks.org/r-language/rcpparmadillo-package-in-r/
[^3]: https://github.com/RcppCore/RcppEigen
[^4]: https://www.r-bloggers.com/2012/03/an-rcppeigen-example/
[^5]: https://stackoverflow.com/questions/50828119/ordering-dataframe-using-rcpp-dplyr
[^6]: https://cran.r-project.org/package=RcppGSL
[^7]: https://eddelbuettel.r-universe.dev/RcppGSL
[^8]: https://cran.r-project.org/web/packages/RcppGSL/vignettes/RcppGSL-intro.pdf
[^9]: https://stackoverflow.com/questions/21094740/linking-rcpp-to-interp2d-gsl-type-library
[^10]: https://www.r-bloggers.com/2020/06/testing-rcpp-packages/
[^11]: https://gallery.rcpp.org/articles/documenting-rcpp-packages/
[^12]: https://knausb.github.io/2017/09/a-minimal-rcpp-and-roxygen2-package/
[^13]: https://cran.r-project.org/package=Rcpp/vignettes/Rcpp-FAQ.pdf
[^14]: https://mfasiolo.github.io/sc2-2019/rcpp_advanced_i/2_rcpparmadillo/
[^15]: https://stackoverflow.com/questions/28262324/c11-with-r-and-rcpp-supported-by-cran-policies
[^16]: https://gallery.rcpp.org/articles/rcpp-and-c++11-c++14-c++17/
[^17]: https://gallery.rcpp.org/articles/first-steps-with-C++11/
[^18]: https://cran.r-project.org/package=Rcpp/vignettes/Rcpp-modules.pdf
[^19]: https://stackoverflow.com/questions/48225516/memory-error-when-running-my-c-code-w-rcpp-rcpparmadillo-cant-identify-exa
[^20]: https://cran.r-project.org/web/packages/fastverse/readme/README.html

# ::}}} \\ %1.

