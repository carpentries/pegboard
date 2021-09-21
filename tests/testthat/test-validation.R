vh   <- Episode$new(test_path("examples/validation-headings.md"))
cats <- Episode$new(test_path("examples/image-test.md"))
link <- Episode$new(test_path("examples/link-test.md"))
loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
withr::defer(rm(list = c("vh", "loop", "cats", "link")))

test_that("invalid headings can be caught without the reporters", {
  expect_silent(res <- vh$validate_headings(verbose = FALSE))
  expect_false(all(res))
})

test_that("invalid alt text can be caught without reporters", {
  expect_silent(res <- cats$validate_links(verbose = FALSE))
  expect_false(res["img_alt_text"])
})


test_that("headings reporters will work without CLI", {

  withr::local_options(list("pegboard.no-cli" = TRUE))
  expect_snapshot(expect_false(all(vh$validate_headings())))
  expect_snapshot(expect_equal(sum(loop$validate_headings()), 4L))

})

test_that("links reporters will work without CLI", {

  withr::local_options(list("pegboard.no-cli" = TRUE))
  expect_snapshot(expect_false(all(cats$validate_links())))
  expect_snapshot(expect_equal(sum(loop$validate_links()), 4L))
  expect_snapshot(expect_equal(sum(link$validate_links()), 2L))

})

if (requireNamespace("cli", quietly = TRUE)) {
  cli::test_that_cli("headings reporters will work", {
    expect_snapshot(expect_false(all(vh$validate_headings())))
  })

  cli::test_that_cli("duplicate headings reporting works", {
    expect_snapshot(expect_equal(sum(loop$validate_headings()), 4L))
  })

  cli::test_that_cli("links reporters will work", {
    expect_snapshot(expect_false(all(cats$validate_links())))
    expect_snapshot(expect_equal(sum(link$validate_links()), 2L))
  })
}

test_that("links reporters will work on CI", {

  withr::local_envvar(list(CI = "true"))
  expect_snapshot(expect_equal(sum(link$validate_links()), 2L))

})
