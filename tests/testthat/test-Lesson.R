
frg_path <- lesson_fragment()
frg      <- Lesson$new(path = frg_path, rmd = FALSE)

test_that("Lesson class will fail if given a bad path", {

  nopath <- fs::path(tempdir(), "does", "not", "exist")
  err <- glue::glue("the directory '{nopath}' does not exist or is not a directory")
  expect_error(Lesson$new(path = nopath), err)

})

test_that("Lesson class contains the right stuff", {

  expect_is(frg, "Lesson")
  expect_length(frg$episodes, 3)
  expect_is(frg$episodes[[1]], "Episode")
  expect_is(frg$episodes[[2]], "Episode")
  expect_is(frg$episodes[[3]], "Episode")
  expect_true(all(purrr::map_lgl(frg$files, fs::file_exists)))
  expect_equal(names(frg$episodes), unname(purrr::map_chr(frg$episodes, "name")))
  expect_equal(frg$path, unique(purrr::map_chr(frg$episodes, "lesson")))

})

test_that("Lesson class can get the challenges", {


  expected <- c("10-lunch.md" = 0, "14-looping-data-sets.md" = 3, "17-scope.md" = 2)
  chal <- frg$challenges()
  expect_length(chal, 3)
  expect_equal(lengths(chal), expected)
  expect_is(chal[["17-scope.md"]], "xml_nodeset")

})

test_that("Lesson class can get the solutions", {


  expected <- c("10-lunch.md" = 0, "14-looping-data-sets.md" = 3, "17-scope.md" = 0)
  chal <- frg$solutions()
  expect_length(chal, 3)
  expect_equal(lengths(chal), expected)
  expect_is(chal[["14-looping-data-sets.md"]], "xml_nodeset")

})
test_that("Lesson class can remove episodes with $thin()", {

  frg2 <- frg$clone(deep = TRUE)

  expect_length(frg2$episodes, 3)
  expect_message(frg2$thin(), "Removing 1 episode: 10-lunch.md", fixed = TRUE)
  expect_length(frg2$episodes, 2)
  expect_named(frg2$episodes, c("14-looping-data-sets.md", "17-scope.md"))
  expect_message(frg2$thin(), "Nothing to remove!")

  expect_length(frg$episodes, 3)
  expect_silent(frg$thin(verbose = FALSE))
  expect_length(frg$episodes, 2)
  expect_named(frg$episodes, c("14-looping-data-sets.md", "17-scope.md"))
  expect_message(frg2$thin(), "Nothing to remove!")
  expect_silent(frg$thin(verbose = FALSE))


})
