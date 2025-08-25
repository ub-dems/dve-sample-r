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

---------------------------------------------------------------------
## Q4.2

With a stripped down example, with just Rcpp and RcppEigen I sttill get the warning, but the package chect is succesful. Whai is not sure now is if the vectorization suppo (SIMD) is enabled or not in RcppEigen C++ templates.

the warning:
```
RcppEigen/include/Eigen/src/Core/arch/SSE/PacketMath.h:46:40: warning: ignoring attributes on template argument ‘__m128i’ [-Wignored-attributes]
    typedef eigen_packet_wrapper<__m128i, 0> Packet4i;
```

My current compilation environment is defined in two files:

* `./src/Makevars`

```make
PKG_CPPFLAGS = -I../inst/include/ -DSTRICT_R_HEADERS
PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS) $(GSL_CFLAGS)
PKG_LIBS = $(SHLIB_OPENMP_CXXFLAGS) $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)
```

* `~/.R/Makevars`

```make
CXXFLAGS = -g -O2 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -g
CXXFLAGS += -march=native
```

Aside the `devtools::check()` NOTE about non portable compiler option `-march=native` the compilation is successful.


## A4.2

Perfect — thanks for clarifying. Let’s step through what this means and how to check whether SIMD is actually active in your RcppEigen builds.

---

## 1. Why you still see the warning

```
warning: ignoring attributes on template argument ‘__m128i’ [-Wignored-attributes]
```

This is **just GCC 13+ being noisy**: Eigen typedefs a packet type like

```cpp
typedef eigen_packet_wrapper<__m128i, 0> Packet4i;
```

and GCC emits the “ignored attributes” chatter. It **does not disable SIMD**. Unless your compilation turns warnings into errors (`-Werror`), it’s harmless.

---

## 2. How Eigen decides on SIMD

Eigen checks macros such as:

* `__SSE2__`, `__SSE3__`, `__SSE4_1__`
* `__AVX__`, `__AVX2__`
* `__FMA__`

Your `~/.R/Makevars` line

```make
CXXFLAGS += -march=native
```

makes `g++` emit all `__AVX*`/`__SSE*` macros supported by your CPU at **compile time**.
→ So yes, Eigen will pick up the right SIMD level.

If you remove `-march=native`, you’ll only get the baseline SSE2 (on x86\_64 GCC that’s always available).

---

## 3. How to verify SIMD is enabled

### 3.a At compile time (preprocessor test)

Drop this into a test `.cpp` file:

```cpp
#include <RcppEigen.h>
#include <iostream>

// [[Rcpp::export]]
void eigen_vectorization_info() {
#ifdef EIGEN_VECTORIZE
  Rcpp::Rcout << "Eigen vectorization ENABLED\n";
#else
  Rcpp::Rcout << "Eigen vectorization DISABLED\n";
#endif

#ifdef __AVX2__
  Rcpp::Rcout << "Compiler AVX2 enabled\n";
#endif
#ifdef __AVX__
  Rcpp::Rcout << "Compiler AVX enabled\n";
#endif
#ifdef __SSE4_2__
  Rcpp::Rcout << "Compiler SSE4.2 enabled\n";
#endif
#ifdef __SSE2__
  Rcpp::Rcout << "Compiler SSE2 enabled\n";
#endif
}
```

Build + run in R:

```r
eigen_vectorization_info()
```

### 3.b At runtime (Eigen built-in query)

Eigen has runtime flags (from `Eigen::SimdInstructionSetsInUse()` in recent versions):

```cpp
#include <RcppEigen.h>

// [[Rcpp::export]]
std::string eigen_runtime_info() {
  return Eigen::SimdInstructionSetsInUse();
}
```

This returns a string like `"AVX, SSE2, FMA"`.

---

## 4. CRAN vs. local development

* **Local builds**: You can keep `~/.R/Makevars` with `-march=native`
  to maximize SIMD.
* **Package submission**: CRAN checks run on a variety of CPUs; you
  **must not hard-wire** `-march=native` (or `-mavx2`, etc.) in
  `src/Makevars`. That’s why you keep `src/Makevars` portable, and
  only add CPU-specific flags in your developer `~/.R/Makevars`.

So:
✔ CRAN build = baseline (SSE2).
✔ Your dev build = full native vectorization.

---

## 5. TL;DR

* The warning is cosmetic; SIMD is still enabled.
* `-march=native` in your `~/.R/Makevars` ensures Eigen sees the right `__AVX*` macros.
* CRAN NOTE about non-portable flags is expected; remove them from `src/Makevars`.
* You can **prove SIMD** is on by adding the little test functions above.

---

👉 Do you want me to draft a minimal `configure`/`configure.ac`
snippet so your package can **automatically detect CPU features at
build time** and conditionally add SIMD flags (CRAN-compliant,
optional, user-controlled)? That would let you get native
vectorization locally, but still pass CRAN cleanly.

---------------------------------------------------------------------
## Q4.3

in RcppEigen code i found the following interesting sources:

- RcppEigen/include/Eigen/src/Core/util/DisableStupidWarnings.h
- RcppEigen/include/Eigen/src/Core/util/ConfigureVectorization.h
- RcppEigen/include/Eigen/src/Core/arch/SSE/PacketMath.h

where I found some interesting code fragments:

in `DisableStupidWarnings.h`

```cpp
#elif defined __GNUC__

  // #if (!defined(EIGEN_PERMANENTLY_DISABLE_STUPID_WARNINGS)) &&  (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6))
  //   #pragma GCC diagnostic push
  // #endif
  // // g++ warns about local variables shadowing member functions, which is too strict
  // #pragma GCC diagnostic ignored "-Wshadow"
  // #if __GNUC__ == 4 && __GNUC_MINOR__ < 8
  //   // Until g++-4.7 there are warnings when comparing unsigned int vs 0, even in templated functions:
  //   #pragma GCC diagnostic ignored "-Wtype-limits"
  // #endif
  // #if __GNUC__>=6
  //   #pragma GCC diagnostic ignored "-Wignored-attributes"
  // #endif
  // #if __GNUC__==7
  //   // See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=89325
  //   #pragma GCC diagnostic ignored "-Wattributes"
  // #endif
#endif
```

in `ConfigureVectorization.h`

```cpp
/* EIGEN_ALIGN_TO_BOUNDARY(n) forces data to be n-byte aligned. This is used to satisfy SIMD requirements.
 * However, we do that EVEN if vectorization (EIGEN_VECTORIZE) is disabled,
 * so that vectorization doesn't affect binary compatibility.
 *
 * If we made alignment depend on whether or not EIGEN_VECTORIZE is defined, it would be impossible to link
 * vectorized and non-vectorized code.
 * 
 * FIXME: this code can be cleaned up once we switch to proper C++11 only.
 */
```


in `PacketMath.h`

```cpp
#if ((defined EIGEN_VECTORIZE_AVX) && (EIGEN_COMP_GNUC_STRICT || EIGEN_COMP_MINGW) && (__GXX_ABI_VERSION < 1004)) || EIGEN_OS_QNX
// With GCC's default ABI version, a __m128 or __m256 are the same types and therefore we cannot
// have overloads for both types without linking error.
// One solution is to increase ABI version using -fabi-version=4 (or greater).
// Otherwise, we workaround this inconvenience by wrapping 128bit types into the following helper
// structure:
typedef eigen_packet_wrapper<__m128>  Packet4f;
typedef eigen_packet_wrapper<__m128d> Packet2d; 
#else
typedef __m128  Packet4f;
typedef __m128d Packet2d;
#endif
```

can you elaborate:
- why the warning that is supposed to be suppressed is still there
- thereason why typedef reports the warning
- in addition, some advice in coesistence of RcppArmadillo and RcppEigen in theparated souces but in the same package


## A4.3

Excellent digging — those three files are exactly where the puzzle pieces fit together. Let’s break this down carefully.

---

## 1. Why the warning isn’t suppressed

You noticed in `DisableStupidWarnings.h`:

```cpp
// #if __GNUC__>=6
//   #pragma GCC diagnostic ignored "-Wignored-attributes"
// #endif
```

That **line is commented out** in the version shipped in
RcppEigen/Eigen.

* In Eigen upstream, this was once active, but they later disabled it
  because suppressing warnings *globally* could hide important
  attribute mistakes in user code.
* RcppEigen simply carries the upstream Eigen with minimal patching.

So in your build:

* GCC 13 still warns on `__m128`/`__m128d` template use.
* Eigen would have suppressed it if that pragma were active, but since
  it’s commented, the warning leaks out.

**→ That’s why you still see `[-Wignored-attributes]` despite Eigen
having a mechanism for it.**

---

## 2. Why the `typedef` reports the warning

In `PacketMath.h`:

```cpp
typedef __m128d Packet2d;
```

or, under the ABI workaround path:

```cpp
typedef eigen_packet_wrapper<__m128d, 0> Packet2d;
```

The problem is how GCC applies attributes to “special” intrinsic
vector types like `__m128d`:

* Intrinsics like `__m128`, `__m128d`, `__m256d` are compiler-provided
  vector types with **hardcoded alignment** (e.g. 16 or 32 bytes).
* Eigen wraps them in structs (`eigen_packet_wrapper`) or aliases them
  directly to select packet types.
* When used inside templates (e.g. `unpacket_traits<PacketScalar>`),
  GCC 13+ warns: *“ignoring attributes on template argument …”*
  because alignment attributes attached to those vector types don’t
  propagate in template parameters.

So: the warning is triggered at the `typedef` because that’s the first
place `__m128d` (or wrapped type) becomes a concrete type argument in
a template. It’s a GCC quirk, not a bug in Eigen.

---

## 3. Coexistence of **RcppArmadillo** and **RcppEigen**

This is a real-world concern: mixing Armadillo and Eigen headers in
the same package.

### 3.a Risks

* **Macro conflicts**: both Armadillo and Eigen sometimes define their
  own `restrict` macros, alignment helpers, etc. Including both in the
  same translation unit (TU) can lead to strange errors.
* **Different alignment strategies**: Armadillo is built on
  BLAS/LAPACK and may not care about custom packet types, whereas
  Eigen uses aggressive template specialization.
* **Compile times**: pulling both sets of headers into one TU makes
  compiles slower and errors noisier.

### 3.b Best practice

* **Split by TU**:

  * For functions that only need Eigen, put them in `src/eigen_*.cpp`
    and include only `<RcppEigen.h>`.
  * For Armadillo functions, use `src/arma_*.cpp` with
    `<RcppArmadillo.h>`.
* **Namespace hygiene**: never `using namespace Eigen;` in a file that
  also includes `<armadillo>`. Keep usage qualified
  (`Eigen::MatrixXd`).
* **Public API**: export functions at the Rcpp level (via `//
  [[Rcpp::export]]`), not at the C++ type level. That way, you can
  freely mix Eigen and Armadillo internally but expose only plain
  `NumericMatrix`/`NumericVector` to R if you want to avoid coupling R
  API to a specific backend.

### 3.c Example

`arma_ops.cpp`:

```cpp
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat arma_gram(const arma::mat& A) {
  return A.t() * A;
}
```

`eigen_ops.cpp`:

```cpp
#include <RcppEigen.h>
// [[Rcpp::depends(RcppEigen)]]

// [[Rcpp::export]]
Eigen::MatrixXd eigen_gram(const Eigen::Map<Eigen::MatrixXd>& A) {
  return A.transpose() * A;
}
```

Both live in the same package, but are compiled separately, so no symbol clash.

---

## 4. Advice going forward

* The warnings (`-Wignored-attributes`) are **benign**, just cosmetic noise from GCC 13+.
* If they irritate you in CI, you can add to your `src/Makevars`:

  ```make
  PKG_CXXFLAGS += -Wno-ignored-attributes
  ```

  (or `-Wno-error=ignored-attributes` if your CI uses `-Werror`).
* Keep Armadillo and Eigen code in **separate TUs** to avoid header
  interaction.
* At the R level, you can expose a consistent API regardless of
  backend. For instance, an `outer_product()` that dispatches
  internally to Eigen or Armadillo.

---

✅ So:

* **Why still warned?** Because Eigen’s pragma suppression is
  commented out for GCC ≥6.
* **Why typedef triggers it?** GCC issues the warning whenever
  intrinsic vector types like `__m128d` appear as template arguments,
  which happens in the typedefs.
* **Armadillo + Eigen coexistence?** Split into separate source files,
  never include both in one TU, and expose results at the Rcpp
  boundary.

---

Would you like me to show you a **minimal package skeleton** that
demonstrates both backends coexisting cleanly (with one TU per backend
and a shared R interface)? That way you’d have a “gold standard”
template to build on.


# ::}}} \\ %4.
