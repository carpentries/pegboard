# Setup: create a temporary directory to burn down later
d <- fs::file_temp()
fs::dir_create(d)

# Burn it to the ground when we done.
withr::defer({
  fs::dir_delete(d)
})


test_that("errors are okay", {

  dd         <- fs::file_temp()
  locked_dir <- fs::file_temp("locked")

  fs::dir_create(dd, "_episodes")
  fs::dir_create(locked_dir, mode = "u=r,go=r")
  withr::defer({
    fs::dir_delete(dd)
    fs::dir_delete(locked_dir)
  })

  expect_error(get_lesson(), "please provide a lesson")
  expect_error(get_lesson(path = dd), "The _episodes directory must have markdown files")
  expect_error(get_lesson("swcarpentry/python-novice-gapminder", path = locked_dir))

})

test_that("lessons can be downloaded", {
  testthat::skip_if_offline()

  expect_length(fs::dir_ls(d), 0)

  expect_output(
    png <- get_lesson("swcarpentry/python-novice-gapminder", path = d),
    "cloning into"
  )

  # the directory exists
  expect_true(fs::dir_exists(fs::path(d, "swcarpentry--python-novice-gapminder", "_episodes")))

  episodes <- fs::dir_ls(fs::path(d, "swcarpentry--python-novice-gapminder", "_episodes"))

  expect_equal(episodes, names(png))

})

test_that("lessons are accessed without re-downloading", {
  testthat::skip_if_offline()

  expect_length(fs::dir_ls(d), 1)

  expect_silent(
    png <- get_lesson("swcarpentry/python-novice-gapminder", path = d)
  )

  # the directory exists
  expect_true(fs::dir_exists(fs::path(d, "swcarpentry--python-novice-gapminder", "_episodes")))

  episodes <- fs::dir_ls(fs::path(d, "swcarpentry--python-novice-gapminder", "_episodes"))

  expect_equal(episodes, names(png))


})

test_that("overwriting is possible", {
  testthat::skip_if_offline()

  expect_length(fs::dir_ls(d), 1)

  expect_output(
    png <- get_lesson("swcarpentry/python-novice-gapminder", path = d, overwrite = TRUE),
    "cloning into"
  )

  # the directory exists
  expect_true(fs::dir_exists(fs::path(d, "swcarpentry--python-novice-gapminder", "_episodes")))

  episodes <- fs::dir_ls(fs::path(d, "swcarpentry--python-novice-gapminder", "_episodes"))

  expect_equal(episodes, names(png))

})

test_that("lessons can be read from local files", {

  frg <- get_lesson(path = lesson_fragment())

  expect_length(frg, 3)
  expect_equal(
    fs::path_file(names(frg)),
    c("10-lunch.md", "14-looping-data-sets.md", "17-scope.md")
  )

})
