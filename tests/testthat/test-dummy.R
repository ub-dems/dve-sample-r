context("dummy-fun")

test_that("function exports works", {
  salutation <- dmy_hello()
  expect_that(salutation, equals("Hello World!"))
})

test_that("arg1 works", {
  salutation <- dmy_hello("Earth")
  expect_that(salutation, equals("Hello Earth!"))
})

test_that("arg2 works", {
  salutation <- dmy_hello("Moon", "'Night")
  expect_that(salutation, equals("'Night Moon!"))
})

test_that("module env", {
  rc <- dmy_p01_env_dump()
  expect_that(rc, equals(0))
})

