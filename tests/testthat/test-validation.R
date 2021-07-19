vh   <- Episode$new(test_path("examples/validation-headings.md"))
loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
withr::defer(rm(list = c("vh", "loop")))

test_that("invalid headings can be caught without the reporters", {
  expect_silent(res <- vh$validate_headings(verbose = FALSE))
  expect_false(all(res))
})

test_that("reporters will work without CLI", {
  withr::with_options(list("pegboard.no-cli" = TRUE), {
    expect_snapshot(expect_false(all(vh$validate_headings())))
    expect_snapshot(expect_equal(sum(loop$validate_headings()), 4L))
  })
})

if (requireNamespace("cli", quietly = TRUE)) {
  cli::test_that_cli("reporters will work", {
    expect_snapshot(expect_false(all(vh$validate_headings())))
  })

  cli::test_that_cli("duplciate reporting works", {
    expect_snapshot(expect_equal(sum(loop$validate_headings()), 4L))
  })
}

