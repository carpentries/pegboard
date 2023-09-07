
frg_path <- lesson_fragment()
frg      <- Lesson$new(path = frg_path, rmd = FALSE)

test_that("Lesson class will fail if given a bad path", {

  nopath <- fs::path(tempdir(), "does", "not", "exist")
  err <- glue::glue("the directory '{nopath}' does not exist or is not a directory")
  expect_error(Lesson$new(path = nopath), err)

})

test_that("styles-based lessons can not read in built files", {
  expect_message(frg$load_built(), "Only lessons using sandpaper can load built files")
})


test_that("Sandpaper lessons can be read", {
  snd <- Lesson$new(path = lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
  expect_s3_class(snd, "Lesson")
  expect_named(snd$episodes, "intro.Rmd")
  expect_s3_class(snd$episodes[[1]], "Episode")
  expect_null(snd$built)
  expect_s3_class(snd$extra[[1]], "Episode")
  expect_false(snd$overview)
})

test_that("Sandpaper lessons with incomplete conversions will throw an error", {
  tmp <- withr::local_tempdir()

  test_dir <- fs::path(tmp, "ohno")
  fs::dir_copy(lesson_fragment("sandpaper-fragment"), test_dir)
  fs::dir_copy(fs::path(frg_path, "_episodes"), test_dir)
  fs::file_copy(fs::path(frg_path, "_config.yml"), test_dir)
    
  expect_error(Lesson$new(path = test_dir, jekyll = FALSE), 
    "config files in the lesson.+?_config.yml")
})


test_that("Jekyll workshop overview lessons with no episodes can be read", {
  tmp <- withr::local_tempdir()

  # the key is that they end with -workshop
  test_dir <- fs::path(tmp, "jekyll-test-workshop")
  fs::dir_copy(frg_path, test_dir)
  fs::dir_delete(fs::path(test_dir, "_episodes"))
  # We are expecting this to _not fail_
  expect_failure(expect_error({
    lsn <- Lesson$new(path = test_dir, jekyll = TRUE)
  }))
  expect_true(lsn$overview)
  # the lesson should have an empty episode slot
  expect_null(lsn$episodes)
  lnks <- lsn$validate_links()

  expect_s3_class(lnks, "data.frame")
  expect_equal(nrow(lnks), 0L)
})

test_that("Jekyll workshop overview lessons with episodes can be read (but won't be overview)", {
  tmp <- withr::local_tempdir()

  # the key is that they end with -workshop
  test_dir <- fs::path(tmp, "jekyll-test-workshop")
  fs::dir_copy(frg_path, test_dir)
  # We are expecting this to _not fail_
  expect_failure(expect_error({
    lsn <- Lesson$new(path = test_dir, jekyll = TRUE)
  }))

  expect_false(lsn$overview)
  # the episodes should still exist for an overview lesson
  expect_type(lsn$episodes, "list")
  expect_length(lsn$episodes, 4L)
  expect_s3_class(lsn$episodes[[1]], "Episode")

  # the lesson should throw warnings about the missing files in the lesson
  # fragment demo because the episodes will still exist.
  suppressMessages(expect_message(lnks <- lsn$validate_links(), "missing file"))

  expect_s3_class(lnks, "data.frame")
  expect_equal(nrow(lnks), 14L)
})

test_that("Sandpaper workshop overview lessons with no episodes can be read", {
  tmp <- withr::local_tempdir()

  # the key is that they end with -workshop
  test_dir <- fs::path(tmp, "sandpaper-test-workshop")
  fs::dir_copy(lesson_fragment("sandpaper-fragment"), test_dir)
  fs::dir_delete(fs::path(test_dir, "episodes"))
  cat("\noverview: true\n", 
    file = fs::path(test_dir, "config.yaml"), append = TRUE)
  # We are expecting this to _not fail_
  expect_failure(expect_error({
    lsn <- Lesson$new(path = test_dir, jekyll = FALSE)
  }))
  # the lesson should have an empty episode slot
  expect_null(lsn$episodes)
  expect_true(lsn$overview)

  # the setup page should throw warnings about two HTTP links
  suppressMessages(expect_message(lnks <- lsn$validate_links(), "HTTPS"))

  expect_s3_class(lnks, "data.frame")
  expect_equal(nrow(lnks), 2L)
})


if (requireNamespace("cli")) {
  cli::test_that_cli("Sandpaper Lessons can be validated", {
    snd <- Lesson$new(path = lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
    withr::local_envvar(list(CI = 'true'))
    expect_snapshot(vhead <- snd$validate_headings())
    expect_equal(nrow(vhead), 8L)
    expect_snapshot(vlink <- snd$validate_links())
    expect_equal(nrow(vlink), 3L)
  })
}

test_that("Sandpaper Lessons can be _quietly_ validated", {
  snd <- Lesson$new(path = lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
  suppressMessages({
  expect_message(vhead <- snd$validate_headings(verbose = FALSE), NA)
  expect_message(vlink <- snd$validate_links(), "There were errors in 2/3 links")
  })
})

test_that("Sandpaper lessons have getter and summary methods", {
  snd <- Lesson$new(path = lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
  # sandpaper lessons will have their divs pre-labeled.
  expect_length(snd$challenges()[[1]], 1L)
  expect_length(snd$solutions()[[1]], 2L)
  expect_null(snd$get())
  expect_length(snd$get("headings")[[1]], 6L)
  expect_length(snd$get("code", TRUE)[[1]], 3L)
  expect_length(snd$get("links")[[1]], 1L)
  expect_length(snd$get("images")[[1]], 0L)
  withr::local_options(list(width = 200))
  # summary for all files can exist
  expect_snapshot(snd$summary(TRUE))
  # summary for episodes can exist
  expect_snapshot(snd$summary())
})


test_that("Sandpaper lessons can read in built files", {

  snd <- Lesson$new(path = lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
  snd$load_built()
  withr::local_options(list(width = 200))
  expect_snapshot(snd$summary(TRUE))
  expect_snapshot(snd$summary("built"))

})


test_that("Sandpaper lessons will throw a warning for $load_built()", {
  lf <- lesson_fragment("sandpaper-fragment")
  withr::defer({
    fs::file_move(
      fs::path(lf, "site", "tliub"),
      fs::path(lf, "site", "built")
    )
  })
  fs::file_move(
    fs::path(lf, "site", "built"),
    fs::path(lf, "site", "tliub")
  )
  snd <- Lesson$new(path = lf, jekyll = FALSE)
  expect_message(snd$load_built(),
    "No files built. Run `sandpaper\\:\\:build_lesson\\(\\)` to build.")
  expect_null(snd$built)
})



test_that("Sandpaper lessons can create handouts", {

  # handout can have solution and no solution
  snd <- Lesson$new(path = lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
  expect_snapshot(cat(snd$handout()))
  expect_snapshot(cat(snd$handout(solution = TRUE)))
  tmp <- fs::file_temp(ext = "Rmd")
  # handout can write to a file
  expect_false(fs::file_exists(tmp))
  expect_length(snd$handout(tmp, solution = TRUE)$solutions, 1L)
  expect_true(fs::file_exists(tmp))
  # the handout can be read by tinkr
  expect_snapshot(writeLines(readLines(tmp)))
  expect_snapshot(parse(tmp))

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
  expect_false(frg$overview)

})

if (requireNamespace("cli")) {
  cli::test_that_cli("Lessons can be validated", {
    withr::local_envvar(list(CI = 'true'))
    expect_snapshot(vhead <- frg$validate_headings())
    expect_equal(nrow(vhead), 37L)
    expect_snapshot(vlink <- frg$validate_links())
    expect_equal(nrow(vlink), 14L)
  })
}

test_that("Lessons can be _quietly_ validated", {
  suppressMessages({
  expect_message(vhead <- frg$validate_headings(verbose = FALSE), "There were errors in 13/37 headings")
  expect_message(vlink <- frg$validate_links(), "There were errors in 4/14 links")
  })
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
