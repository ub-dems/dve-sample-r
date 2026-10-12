# R layout

Apply when `project.layout = 'R'`. R runs **only inside the Podman container**.

| Path                    | Role                                                  |
|-------------------------|-------------------------------------------------------|
| `R/`                    | R package functions                                   |
| `exec/`                 | R executable scripts                                  |
| `etc/R/Makevars`        | Mapped as `~/.R/Makevars` inside containers           |
| `man/`                  | Auto-generated R documentation — **never edit**       |
| `vignettes/`            | R vignettes (`knitr`)                                 |
| `tests/testthat/`       | `testthat` unit tests                                 |
| `renv/`, `renv.lock`    | `renv` configuration / lock (explicit commits only)   |
| `DESCRIPTION`           | R package description                                 |
| `inst/extdata/ext/`     | Local datasets (git-ignored)                          |
| `src/` (if present)     | C/C++ for Rcpp; `RcppExports.*` are generated         |

Placement rules:

- New function → `R/<topic>.R` with roxygen2 comments; regenerate `man/` and `NAMESPACE`, never hand-edit them.
- New test for `R/foo.R` → `tests/testthat/test-foo.R`.
- Command-line scripts → `exec/`.
