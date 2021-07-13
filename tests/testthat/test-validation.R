vh <- Episode$new(test_path("examples/validation-headings.md"))
withr::defer(rm("vh"))

test_that("invalid headings can be caught without the reporters", {
  expect_silent(res <- vh$validate_headings(verbose = FALSE))
  expect_false(res)
})

if (requireNamespace("cli", quietly = TRUE)) {
  cli::test_that_cli("reporters will work", {
    expect_snapshot(expect_false(vh$validate_headings()))
  })
}
