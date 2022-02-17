vh   <- Episode$new(test_path("examples/validation-headings.md"))
dv   <- Episode$new(test_path("examples/validation-divs.md"))
cats <- Episode$new(test_path("examples/image-test.md"))
link <- Episode$new(test_path("examples/link-test.md"))
loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
withr::defer(rm(list = c("vh", "loop", "cats", "link", "dv")))


test_that("invalid divs will be caught", {
  suppressMessages({
    expect_message(res <- dv$validate_divs(),
      "There were errors in 1/5 fenced divs")
  })
  expect_equal(sum(res$is_known), 4)
})

test_that("invalid headings can be caught without the reporters", {
  suppressMessages({
    expect_message(res <- vh$validate_headings(verbose = FALSE), 
      "There were errors in 5/7 headings")
  })
  expect_equal(sum(res$first_heading_is_second_level), 6)
  expect_equal(sum(res$greater_than_first_level), 6)
  expect_equal(sum(res$are_sequential), 6)
  expect_equal(sum(res$have_names), 6)
  expect_equal(sum(res$are_unique), 5)
})

test_that("invalid alt text can be caught without reporters", {
  expect_silent(res <- cats$validate_links(warn = FALSE))
  expect_equal(sum(res$enforce_https), 9)
  expect_equal(sum(res$internal_anchor), 9)
  expect_equal(sum(res$internal_file), 9)
  expect_equal(sum(res$internal_well_formed), 9)
  expect_equal(sum(res$all_reachable), 9)
  expect_equal(sum(res$img_alt_text), 7)
  expect_equal(sum(res$descriptive), 9)
  expect_equal(sum(res$link_length), 9)
})


test_that("headings reporters will work without CLI", {

  withr::local_options(list("pegboard.no-cli" = TRUE))
  expect_snapshot(res <- vh$validate_headings())
  expect_equal(sum(res$first_heading_is_second_level), 6)
  expect_equal(sum(res$greater_than_first_level), 6)
  expect_equal(sum(res$are_sequential), 6)
  expect_equal(sum(res$have_names), 6)
  expect_equal(sum(res$are_unique), 5)

  expect_snapshot(res <- loop$validate_headings())
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 10)
  expect_equal(sum(res$first_heading_is_second_level), 10)
  expect_equal(sum(res$greater_than_first_level), 10)
  expect_equal(sum(res$are_sequential), 10)
  expect_equal(sum(res$have_names), 10)
  expect_equal(sum(res$are_unique), 7)

})

test_that("headings reporters will work on CI", {

  withr::local_envvar(list(CI = "true"))
  expect_snapshot(res <- vh$validate_headings())
  expect_equal(sum(res$first_heading_is_second_level), 6)
  expect_equal(sum(res$greater_than_first_level), 6)
  expect_equal(sum(res$are_sequential), 6)
  expect_equal(sum(res$have_names), 6)
  expect_equal(sum(res$are_unique), 5)

  expect_snapshot(res <- loop$validate_headings())
  expect_equal(nrow(res), 10)
  expect_equal(sum(res$first_heading_is_second_level), 10)
  expect_equal(sum(res$greater_than_first_level), 10)
  expect_equal(sum(res$are_sequential), 10)
  expect_equal(sum(res$have_names), 10)
  expect_equal(sum(res$are_unique), 7)

})

test_that("links reporters will work without CLI", {

  withr::local_options(list("pegboard.no-cli" = TRUE))
  expect_snapshot(cats$validate_links())
  expect_snapshot(loop$validate_links())
  expect_snapshot(link$validate_links())

})

if (requireNamespace("cli", quietly = TRUE)) {

  cli::test_that_cli("headings reporters will work", {
    expect_snapshot(res <- vh$validate_headings())
    expect_equal(sum(res$first_heading_is_second_level), 6)
    expect_equal(sum(res$greater_than_first_level), 6)
    expect_equal(sum(res$are_sequential), 6)
    expect_equal(sum(res$have_names), 6)
    expect_equal(sum(res$are_unique), 5)
  })


  cli::test_that_cli("links reporters will work", {
    expect_snapshot(cats$validate_links())
    expect_snapshot(link$validate_links())
  })
}

test_that("links reporters will work on CI", {

  withr::local_envvar(list(CI = "true"))
  expect_snapshot(link$validate_links())

})

test_that("div reporters will work on CI", {

  withr::local_envvar(list(CI = "true"))
  expect_snapshot(dv$validate_divs())

})
