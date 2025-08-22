``` /// vim: set foldmethod=marker : ```
# ::{{{ #RCPP: Howto //
# Q:4 - RcppEigen OpenMP and SIMD support

<system>

You are an expert R developer, specializing in R packages that utilize
Rcpp and RcppEigen for C++ integration. You possess deep knowledge of
C++ template metaprogramming, Eigen library internals, and R package
build processes. 

Your task is to analyze a given C++ compilation error within an R
package context and provide a step-by-step solution to resolve the
issue.

</system>


You are developing an R package that depends on Rcpp and RcppEigen for
C++ support. You are encountering the C++ compilation issue, described below.

The DESCRIPTION file includes Rcpp and RcppEigen in `Depends` and
`LinkingTo` sections.

The compiler warning, that causes compilation failure in this
(repeated several times):

<warning>
```text
RcppEigen/include/Eigen/src/Core/CoreEvaluators.h:1071:54: 
warning: ignoring attributes on template argument Eigen::internal::packet_traits<double>::type’ {aka ‘__m128d’} [-Wignored-attributes]
    1071 |     PacketAlignment = unpacket_traits<PacketScalar>:: alignment,
                                                                                                               ~~~~~~~~
```
</warning>

The function code that triggers RccEigen usage is this:

<cplusplus-code>

```cpp
// [[Rcpp::interfaces(r,cpp)]] Enable C++11 support
// [[Rcpp::plugins(cpp11)]] [[Rcpp::plugins(openmp)]]

// Declare dependencies
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::depends(RcppEigen)]]

// Rcpp dependencies
#include <RcppArmadillo.h>
#include <Rcpp.h>
#include <RcppEigen.h>

#ifdef _OPENMP
#include <omp.h>
#endif

// Use namespaces
using namespace Rcpp;
using namespace std;

using Eigen::Map;
using Eigen::MatrixXd;
using Eigen::VectorXd;


// [[Rcpp::export]]
Eigen::MatrixXd dmy_gram_matrix_eigen(const Eigen::Map<Eigen::MatrixXd>& A) {
    // Transpose and multiply
    return A.transpose() * A;
}
```
</cplusplus-code>


<runtime-env>
The build environment runs in a "rootless" podman container, based on "Rocker Project" R image, with this version info:

- Base Rocker Docker Image: rocker/geospatial:4.4.3
- Operating System: Ubuntu 24.04.1 LTS
- R version: 4.4.3
- gcc compiler version: GNU gcc 13.3
- Rcpp version: 1.1.0
- RcppArmadillo version: 14.6.0-1
- RcppEigen version: 0.3.4.0.2

The Container host Runtime:

- Platform: Microsoft Azure
- CPU: 8-core AMD EPYC 7V12 (-MCP-)
- GPU: NVIDIA TU104GL [Tesla T4] driver: nvidia v: 575.57.08
- OS: Xubuntu 24.04.3 LTS (Noble Numbat)
- Kernel:  6.11.0-1018-azure (x86_64)
- Podman version: 4.9.3

</runtime-env>



The C/C++ package compilation environment is specified by 

<build-env src='src/Makevars'>
```make

SHLIB_OPENMP_CXXFLAGS_SIMD = -msse2 -msse3 -msse4.1 -msse4.2 -mavx -mavx2

PKG_CPPFLAGS = -I../inst/include/ -DSTRICT_R_HEADERS

PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS) $(SHLIB_OPENMP_CXXFLAGS_SIMD)
PKG_LIBS = $(SHLIB_OPENMP_CXXFLAGS) $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)

```
</build-env>



Follow these steps to resolve the compilation issue:

1.  **Analyze the Error:** Understand that the `[-Wignored-attributes]` warning indicates a potential conflict between Eigen's alignment requirements for vectorized operations (using `__m128d` which is related to SSE instructions) and the compiler's handling of these attributes within template arguments.

2.  **Check Compiler Flags:**
    *   Ensure that your `Makevars` or `Makevars.win` file (depending on your operating system) contains appropriate compiler flags for enabling SSE and other relevant instruction sets.  Example flags might include `-msse2`, `-msse3`, `-mavx`, etc.  The specific flags depend on your target architecture and the Eigen version.
    *   Verify that the flags are correctly passed to both the compiler and linker.

3.  **Eigen Version Compatibility:**
    *   Confirm that the version of Eigen being used by RcppEigen is compatible with your compiler and system architecture.  Older versions of Eigen might have issues with newer compilers or instruction sets.
    *   Consider updating RcppEigen to the latest version, as it typically includes fixes for compatibility issues.  You can update RcppEigen by updating the Rcpp package.

4.  **Code Adjustments (If Necessary):**
    *   If the warning persists, you might need to adjust your C++ code to avoid alignment issues.  However, in this simple example, it's unlikely.  More complex Eigen code involving custom data structures or memory allocation might require careful attention to alignment.
    *   As a test, try disabling vectorization in Eigen to see if the warning disappears (though this will reduce performance).  You can do this by defining `EIGEN_DONT_VECTORIZE` before including Eigen headers.  If this resolves the warning, it strongly suggests an alignment issue.

5.  **Suppress the Warning (Use as a Last Resort):**
    *   As a last resort, you can try to suppress the warning using compiler-specific pragmas or attributes.  However, this is generally not recommended, as it might mask an underlying problem.  If you choose this approach, be sure to thoroughly understand the implications.

6.  **Inspect `RcppEigenConfig.cmake`:**
    *   Examine the `RcppEigenConfig.cmake` file (usually found within the RcppEigen package installation directory) to see how Eigen is being configured.  This file might contain clues about the compiler flags and Eigen version being used.

7.  **Provide Specific `Makevars` Example:**
    *   Based on the above analysis, provide a concrete example of what the `Makevars` file should contain to address the issue.  This should include the necessary compiler flags.  Consider different operating systems (Linux/macOS vs. Windows).

8.  **Explain Potential Causes:**
    *   Summarize the most likely causes of the warning, such as mismatched compiler flags, Eigen version incompatibilities, or underlying alignment issues.

9.  **Describe the correct configuration in order to enable OpenMP/SIMD support in C++ code using RcppEigen template library:**
    *   Focus on Makevars settings in strict CRAN package compliance.
    *   Provide a C++ pair of code examples for a tensor (outer) product of two vectors in both cases:
        - efficent Rcpp only implementation with correct `#pragma omp` for parallel ececution with SIMD optinization
        - RcppEigen based alternative implementation

Provide a detailed, step-by-step solution, including specific code
examples and configuration file modifications. Explain the reasoning
behind each step.


# A:3 (ChatGPT)
> Eigen compilation warning fix

Great question—this is a classic “Eigen + modern GCC + over-eager SIMD
flags” situation. Below is a practical, step-by-step path that fixes
the build *and* leaves you with a CRAN-friendly OpenMP/SIMD setup plus
two clean outer-product implementations.

---

# 1) What the warning really means

```
warning: ignoring attributes on template argument ‘Eigen::internal::packet_traits<double>::type’ {aka ‘__m128d’} [-Wignored-attributes]
```

* Eigen picks a *packet type* for vectorization (for doubles, SSE ⇒
  `__m128d`, AVX ⇒ `__m256d`, …).
* GCC 13 warns that the alignment/vector-size attributes attached to
  that packet type are being ignored when the type is used as a
  template argument deep inside Eigen
  (e.g. `unpacket_traits<PacketScalar>`).
* Functionally harmless, but it *can* fail your build if `-Werror`
  (globally or for that warning) is in effect anywhere in your
  toolchain. The message *does not* indicate a correctness bug in your
  code.

Why you’re seeing `__m128d` despite `-mavx2`: either AVX is disabled
by Eigen (policy/macros), or your flags aren’t actually reaching the
compilation of that TU, or Eigen chooses SSE for that code path. In
any case, the warning is independent of correctness.

---

# 2) First fix the translation unit (headers & attributes)

For the file that only uses Eigen, don’t pull Armadillo in—keep
translation units “single-backend” to avoid cross-library macro side
effects.

**Before (your snippet):**

```cpp
#include <RcppArmadillo.h>
#include <Rcpp.h>
#include <RcppEigen.h>
```

**After (Eigen-only TU):**

```cpp
// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::depends(RcppEigen)]]

#include <RcppEigen.h>
#ifdef _OPENMP
  #include <omp.h>
#endif

using Eigen::Map;
using Eigen::MatrixXd;

// [[Rcpp::export]]
Eigen::MatrixXd dmy_gram_matrix_eigen(const Map<const MatrixXd>& A) {
    return A.transpose() * A;
}
```

Notes:

* `#include <RcppEigen.h>` already includes `<Rcpp.h>`. No need to
  include `<Rcpp.h>` separately.
* Keep Armadillo in the package if other TUs need it—just not in this
  TU.

---

# 3) Make your **Makevars** portable (CRAN-friendly) and correct

Avoid hard-wiring `-mavx`, `-mavx2`, etc. on CRAN: those can produce
illegal-instruction crashes on CPUs lacking those features. Let Eigen
choose the best it can for the baseline; use optional, local overrides
only for your own builds.

### `src/Makevars` (Linux/macOS)

```make
## Header search + safe Eigen definitions
PKG_CPPFLAGS = -I../inst/include -DSTRICT_R_HEADERS -DEIGEN_MPL2_ONLY

## OpenMP: compile & link (GCC/Clang use same flag for both)
PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS)
PKG_LIBS    = $(SHLIB_OPENMP_CXXFLAGS) $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)

## Optional: if *and only if* your CI/toolchain promotes this warning to error,
## keep the warning but prevent build failure:
# PKG_CXXFLAGS += -Wno-error=ignored-attributes
## Or, to suppress it entirely (not recommended unless necessary):
# PKG_CXXFLAGS += -Wno-ignored-attributes
```

### `src/Makevars.win` (Windows)

```make
PKG_CPPFLAGS = -I../inst/include -DSTRICT_R_HEADERS -DEIGEN_MPL2_ONLY
PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS)
PKG_LIBS    = $(SHLIB_OPENMP_CXXFLAGS)
```

**Why this helps**

* Removes risky global `-m{avx,avx2,...}` (CRAN compliance + runtime safety).
* Ensures OpenMP flags reach both compile and link.
* Keeps Eigen portable and lets it pick the best available vectorization.
* If some environment injects `-Werror`, the targeted `-Wno-error=ignored-attributes` avoids masking other, useful warnings.

> If you *really* want AVX2 locally, do it in `~/.R/Makevars` (developer machine or container), not in the package’s `src/Makevars`:

```make
# ~/.R/Makevars (developer-only)
CXXFLAGS += -march=native
# or, if you insist:
# CXXFLAGS += -mavx2 -mfma
```

---

# 4) DESCRIPTION: prefer `Imports` + `LinkingTo` (not `Depends`) for headers

For compiled packages using Rcpp\* headers:

```text
Imports: Rcpp
LinkingTo: Rcpp, RcppEigen, RcppArmadillo
```

Use `Depends:` only if you need to attach their namespaces on load (rare).

---

# 5) Version sanity

You’re on:

* RcppEigen 0.3.4.0.2 (Eigen 3.4.x)
* GCC 13.3
  This combo is generally fine. If the warning persists and annoys you, updating to the latest **RcppEigen** on CRAN can help (there have been small cleanups addressing newer GCC warnings). But you shouldn’t need to for correctness.

---

# 6) If you want to *prove* it’s vectorization-related

Temporarily add (for a single TU) before including Eigen:

```cpp
#define EIGEN_DONT_VECTORIZE
#include <RcppEigen.h>
```

If the warning disappears, it’s the GCC 13 attribute noise around
packet types—as expected. Revert this macro afterwards so you keep
SIMD.

(Advanced alternative knobs if you ever fight true alignment
issues—not your case here: `-DEIGEN_MAX_ALIGN_BYTES=32`,
`-DEIGEN_DONT_ALIGN_STATICALLY`, or
`-DEIGEN_DISABLE_UNALIGNED_ARRAY_ASSERT`.)

---

# 7) Concrete, corrected **Makevars** examples

### Portable default (recommended)

```make
PKG_CPPFLAGS = -I../inst/include -DSTRICT_R_HEADERS -DEIGEN_MPL2_ONLY
PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS)
PKG_LIBS    = $(SHLIB_OPENMP_CXXFLAGS) $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)
```

### Same, but “do not fail build on that Eigen/GCC attribute warning”

```make
PKG_CPPFLAGS = -I../inst/include -DSTRICT_R_HEADERS -DEIGEN_MPL2_ONLY
PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS) -Wno-error=ignored-attributes
PKG_LIBS    = $(SHLIB_OPENMP_CXXFLAGS) $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)
```

*(Keep the `-Wno-error=ignored-attributes` only if your toolchain injects `-Werror`.)*

---

# 8) Likely causes recap

* **Crossed SIMD flags**: Forcing `-mavx2`/SSE flags in `src/Makevars`
  on CRAN is unsafe and can confuse Eigen’s compile-time dispatch.
* **Header soup**: Pulling both Armadillo and Eigen headers into the
  same TU can introduce macro side effects; keep them separate unless
  truly necessary.
* **GCC 13+ chatter**: The warning is a benign GCC 13 diagnostic in
  Eigen’s template internals. It becomes a *build failure only if
  `-Werror` is active*.

---

# 9) OpenMP/SIMD: correct configuration + two outer-product implementations

## 9.a Rcpp-only, OpenMP + SIMD outer product (portable & fast)

```cpp
// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::depends(Rcpp)]]
#include <Rcpp.h>
#ifdef _OPENMP
  #include <omp.h>
#endif
using namespace Rcpp;

#ifndef RESTRICT
  #if defined(__GNUC__) || defined(__clang__)
    #define RESTRICT __restrict__
  #else
    #define RESTRICT
  #endif
#endif

// [[Rcpp::export]]
NumericMatrix outer_omp_simd(NumericVector x, NumericVector y) {
  const R_xlen_t n = x.size();
  const R_xlen_t m = y.size();
  NumericMatrix out(n, m);

  const double* RESTRICT px = REAL(x);
  const double* RESTRICT py = REAL(y);
  double* RESTRICT pout = REAL(out);

  // Parallelize rows; SIMD within the inner loop
  #ifdef _OPENMP
  #pragma omp parallel for schedule(static)
  #endif
  for (R_xlen_t i = 0; i < n; ++i) {
    const double xi = px[i];
    double* row = pout + i * m;

    #if defined(__GNUC__) || defined(__clang__)
    #pragma omp simd
    #endif
    for (R_xlen_t j = 0; j < m; ++j) {
      row[j] = xi * py[j];
    }
  }
  return out;
}
```

**Why it’s good**

* Uses OpenMP to split rows across threads; inner loop marked `simd` to encourage vectorization.
* No non-portable CPU feature flags baked into the package.
* Works on CRAN (OpenMP is conditionally used depending on toolchain support).

## 9.b RcppEigen alternative (simple & expressive)

```cpp
// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::depends(RcppEigen)]]
#include <RcppEigen.h>
#ifdef _OPENMP
  #include <omp.h>
#endif

using Eigen::Map;
using Eigen::VectorXd;
using Eigen::RowVectorXd;
using Eigen::MatrixXd;

// [[Rcpp::export]]
MatrixXd outer_eigen(const Map<const VectorXd>& x,
                     const Map<const VectorXd>& y) {
  const Eigen::Index n = x.size();
  const Eigen::Index m = y.size();

  MatrixXd out(n, m);
  RowVectorXd yT = y.transpose();           // broadcastable row vector

  // Parallelize by rows; each row is a scaled copy of y^T
  #ifdef _OPENMP
  #pragma omp parallel for schedule(static)
  #endif
  for (Eigen::Index i = 0; i < n; ++i) {
    out.row(i).noalias() = x(i) * yT;
  }
  return out;
}
```

**Notes**

* Eigen’s internal vectorization kicks in (SSE/AVX as available)
  without you forcing `-m` flags.
* `noalias()` avoids temporary accumulation and lets Eigen pick
  efficient kernels.

---

# 10) (Optional) Where to peek for Eigen config

If you’re curious how `RcppEigen` configures Eigen for your platform, inspect the installed package (paths vary):

* `system.file("include/Eigen/src/Core/util/Macros.h", package = "RcppEigen")`
* `system.file("cmake", "RcppEigenConfig.cmake", package = "RcppEigen")`

Look for `EIGEN_VECTORIZE_*` macros and alignment limits; but you don’t need to change them for this fix.

---

## TL;DR action list

1. **Split headers per TU**: in the Eigen TU, include only `<RcppEigen.h>`.
2. **Use the portable `src/Makevars`** above (no global `-mavx*`).
3. If your environment injects `-Werror`, add
   `PKG_CXXFLAGS += -Wno-error=ignored-attributes`.
4. (Optional) Update **RcppEigen** to the latest CRAN release.
5. Keep the provided outer-product implementations; they’re OpenMP/SIMD-ready and CRAN-friendly.

That should eliminate the build failure and keep performance solid without tripping CRAN policies.


# ::}}} \\ %4.
