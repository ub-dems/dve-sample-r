context("ioutils")


dd_user  <- "inst/extdata/ext/sim-rs.def/test/session-1/out"
dd_local <- "inst/extdata/ext/sim-rs.loc/test/session-1/out"
dd_share <- "inst/extdata/ext/sim-rs.net/test/session-1/out"

out_path <- function(filename) { io_path(dd_share, filename) }

test_that("path creation", {
  #browser()
  fullpath <- out_path("test-one")
  datapath <- find_path(dd_share)
  expect_true(startsWith(fullpath, datapath))
  expect_true(file.exists(datapath))
})

