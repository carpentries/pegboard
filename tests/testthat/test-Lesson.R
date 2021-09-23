
frg_path <- lesson_fragment()
frg      <- Lesson$new(path = frg_path, rmd = FALSE)

test_that("Lesson class will fail if given a bad path", {

  nopath <- fs::path(tempdir(), "does", "not", "exist")
  err <- glue::glue("the directory '{nopath}' does not exist or is not a directory")
  expect_error(Lesson$new(path = nopath), err)

})

test_that("Sandpaper lessons can be read", {
  snd <- Lesson$new(path = lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
  expect_s3_class(snd, "Lesson")
  expect_named(snd$episodes, "intro.Rmd")
  # sandpaper lessons will have their divs pre-labeled.
  expect_length(snd$challenges()[[1]], 1L)
  expect_length(snd$solutions()[[1]], 2L)
})

test_that("Lesson class contains the right stuff", {

  expect_s3_class(frg, "Lesson")
  expect_length(frg$episodes, 4)
  expect_s3_class(frg$episodes[[1]], "Episode")
  expect_s3_class(frg$episodes[[2]], "Episode")
  expect_s3_class(frg$episodes[[3]], "Episode")
  expect_s3_class(frg$episodes[[4]], "Episode")
  expect_true(all(purrr::map_lgl(frg$files, fs::file_exists)))
  expect_equal(names(frg$episodes), unname(purrr::map_chr(frg$episodes, "name")))
  expect_equal(frg$path, unique(purrr::map_chr(frg$episodes, "lesson")))
  expect_equal(frg$n_problems, c("10-lunch.md" = 0, "12-for-loops.md" = 0, "14-looping-data-sets.md" = 0, "17-scope.md" = 0))
  expect_length(frg$show_problems, 0)

})

if (requireNamespace("cli")) {
  cli::test_that_cli("Lessons can be validated", {
    withr::local_envvar(list(CI = 'true'))
    expect_snapshot(vhead <- frg$validate_headings())
    expect_equal(nrow(vhead), 37L)
    expect_snapshot(vlink <- frg$validate_links())
    expect_equal(nrow(vlink), 13L)
  })
}

test_that("Lessons can be _quietly_ validated", {
  expect_message(vhead <- frg$validate_headings(verbose = FALSE), "There were errors in 13/37 headings")
  expect_message(vlink <- frg$validate_links(), "There were errors in 3/13 links")
})

test_that("Lesson class can get the challenges", {


  expected <- c("10-lunch.md" = 0, "12-for-loops.md" = 7, "14-looping-data-sets.md" = 3, "17-scope.md" = 2)
  chal <- frg$challenges()
  expect_length(chal, 4)
  expect_equal(lengths(chal), expected)
  expect_s3_class(chal[["17-scope.md"]], "xml_nodeset")

})

test_that("Lesson class can get challenge graphs", {

  # The number of nodes is equal to the contents + fenceposts
  n <- sum(purrr::map_int(
    frg$challenges()[-1],
    ~length(xml2::xml_contents(.x)) + length(.x)
  ))
  chal <- frg$challenges(graph = TRUE, recurse = FALSE)
  expect_s3_class(chal, "data.frame")
  expect_named(chal, c("Episode", "Block", "from", "to", "pos", "level"))
  expect_equal(nrow(chal), n)
  # all of the elements should be top level
  expect_equal(sum(chal$level), n)
  chalr <- frg$challenges(graph = TRUE, recurse = TRUE)
  expect_s3_class(chalr, "data.frame")
  expect_named(chalr, c("Episode", "Block", "from", "to", "pos", "level"))
  expect_gt(nrow(chalr), n)

})

test_that("Lesson class can get the solutions", {


  expected <- c("10-lunch.md" = 0, "12-for-loops.md" = 10, "14-looping-data-sets.md" = 3, "17-scope.md" = 0)
  chal <- frg$solutions()
  expect_length(chal, 4)
  expect_equal(lengths(chal), expected)
  expect_s3_class(chal[["14-looping-data-sets.md"]], "xml_nodeset")

})

test_that("Lessons can isolate code", {

  frg2 <- frg$clone(deep = TRUE)
  expect_equal(xml2::xml_length(frg2$episodes[[1]]$body), 2)
  expect_equal(xml2::xml_length(frg2$isolate_blocks()$episodes[[1]]$body), 0)
  # The deep cloning does not affect the original data
  expect_equal(xml2::xml_length(frg$episodes[[1]]$body), 2)

})

test_that("Lesson class can remove episodes with $thin()", {

  frg2 <- frg$clone(deep = TRUE)

  expect_length(frg2$episodes, 4)
  expect_message(frg2$thin(), "Removing 1 episode: 10-lunch.md", fixed = TRUE)
  expect_length(frg2$episodes, 3)
  expect_named(frg2$episodes, c("12-for-loops.md", "14-looping-data-sets.md", "17-scope.md"))
  expect_message(frg2$thin(), "Nothing to remove!")
  # resetting is possible
  expect_message(frg2$reset()$thin(), "Removing 1 episode: 10-lunch.md", fixed = TRUE)

  expect_length(frg$episodes, 4)
  expect_silent(frg$thin(verbose = FALSE))
  expect_length(frg$episodes, 3)
  expect_named(frg$episodes, c("12-for-loops.md", "14-looping-data-sets.md", "17-scope.md"))
  expect_message(frg2$thin(), "Nothing to remove!")
  expect_silent(frg$thin(verbose = FALSE))


})
