test_that("null pipe will shortcut evaluation", {
  expect_equal("a" %||% stop("error"), "a")
  expect_error(NULL %||% stop("this is an error"), "this is an error")
})

