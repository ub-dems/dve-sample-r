rm(list=ls())
devtools::load_all(".") 

require(dvesimpler)

v <- function(...) cat(sprintf(...), "\n", sep=' ', file=stderr())
s <- function(...) do.call(paste,as.list(c(..., sep=", ")))

scall <- function (){
  c(
    dummy_hello(),
    dummy_hello("Earth"),
    dummy_hello("Moon", "'Night")
  )
}

vcall <- function (){
  dummy_hello(c(
    "Mars",
    "Venus"
  ))
}

main <- function(){ 
  v("scall: %s", s(scall()))
  v("vcall: %s", s(vcall()))
  0
}

main()
