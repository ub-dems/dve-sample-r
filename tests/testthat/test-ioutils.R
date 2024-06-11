context("ioutils")

fn_path  <- function() { return("test/session-1/out") }

dd_def <- function(filename) { def_path(name=filename, path=fn_path()) }
dd_loc <- function(filename) { loc_path(name=filename, path=fn_path()) }
dd_net <- function(filename) { net_path(name=filename, path=fn_path()) }

dd_tmp <- function(filename) { tmp_path(name=filename) }
dd_log <- function(filename) { log_path(name=filename) }

dd_out <- dd_net


ex_root  <- "inst/extdata/ext"
ex_home  <- "inst/extdata/ext/dve-ds.def/test/session-1/out"
ex_local <- "inst/extdata/ext/dve-ds.loc/test/session-1/out"
ex_share <- "inst/extdata/ext/dve-ds.net/test/session-1/out"

ex_temp <- "temp"
ex_logs <- "logs"

test_that("base path", {
  skip_if(is_skip_mode(),"skip on mode")
  basepath <- find_path(ex_root)
  cat("\n\n@[base path check]\n")
  print(basepath)
  cat("\n")
  expect_true(file.exists(basepath))
})

test_that("home path creation", {
  skip_if(is_skip_mode(),"skip on mode")
  #browser()
  fullpath <- dd_def("d/test-one")
  datapath <- find_path(ex_home)
  cat("\n\n@[home path creation]\n")
  print(fullpath)
  print(datapath)
  cat("\n")
  expect_true(startsWith(fullpath, datapath))
  expect_true(file.exists(datapath))
})

test_that("local path creation", {
  skip_if(is_skip_mode(),"skip on mode")
  fullpath <- dd_loc("l/test-one")
  datapath <- find_path(ex_local)
  cat("\n\n@[local path creation]\n")
  print(fullpath)
  print(datapath)
  cat("\n")
  expect_true(startsWith(fullpath, datapath))
  expect_true(file.exists(datapath))
})

test_that("share path creation", {
  skip_if(is_skip_mode(),"skip on mode")
  fullpath <- dd_net("n/test-one")
  datapath <- find_path(ex_share)
  cat("\n\n@[share path creation]\n")
  print(fullpath)
  print(datapath)
  cat("\n")
  expect_true(startsWith(fullpath, datapath))
  expect_true(file.exists(datapath))
})

test_that("temp path creation", {
  skip_if(is_skip_mode(),"skip on mode")
  fullpath <- dd_tmp("t/tmp-one")
  datapath <- find_path(ex_temp)
  cat("\n\n@[temp path creation]\n")
  print(fullpath)
  print(datapath)
  cat("\n")
  expect_true(startsWith(fullpath, datapath))
  expect_true(file.exists(datapath))
})

test_that("logs path creation", {
  skip_if(is_skip_mode(),"skip on mode")
  fullpath <- dd_log("v/log-one")
  datapath <- find_path(ex_logs)
  cat("\n\n@[logs path creation]\n")
  print(fullpath)
  print(datapath)
  cat("\n")
  expect_true(startsWith(fullpath, datapath))
  expect_true(file.exists(datapath))
})

