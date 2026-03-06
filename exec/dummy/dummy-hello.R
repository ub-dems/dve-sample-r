#!/usr/bin/env Rscript

##
# runner script example
#

devtools::load_all(".")

v <- function(...) cat(sprintf(...), "\n", sep = " ", file = stderr())
s <- function(...) do.call(paste, as.list(c(..., sep = ", ")))

scall <- function () {
  c(
    dmy_hello(),
    dmy_hello("Earth"),
    dmy_hello("Moon", "'Night")
  )
}

vcall <- function () {
  dmy_hello(c(
    "Mars",
    "Venus"
  ))
}

task <- function() {
  v("scall: %s", s(scall()))
  v("vcall: %s", s(vcall()))
  0
}


main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  print("#> start: %s", paste(args,sep = " "))
  print("#? args: %s", paste(commandArgs(),sep = ", "))
  rc <- 0
  print(elapsed <- system.time({
    rc <- task()
  }))
  print("#< end(%d): %s", rc, summary(elapsed))
  rc
}

main()
