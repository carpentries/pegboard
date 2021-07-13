vh <- Episode$new(test_path("examples/validation-headings.md"))
withr::defer(rm("vh"))

test_that("invalid headings can be caught without the reporters", {
  expect_silent(res <- vh$validate_headings(verbose = FALSE))
  expect_false(res)
})

test_that("reporters will work", {
  expect_false(vh$validate_headings())
})
