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
  msg <- glue::glue("directory must have \\(R\\)markdown files")
  expect_error(get_lesson(path = dd), msg)

  # The locked dir thing apparently doesn't work in windows
  testthat::skip_on_os("windows")
  expect_error(get_lesson("carpentries/lesson-example", path = locked_dir))

})

test_that("lessons can be read from local files", {

  frg <- get_lesson(path = lesson_fragment())

  expect_is(frg, "Lesson")
  expect_equal(
    names(frg$episodes),
    c("10-lunch.md", "12-for-loops.md", "14-looping-data-sets.md", "17-scope.md")
  )

})

test_that("lessons can be downloaded", {

  testthat::skip_if_offline()
  expect_length(fs::dir_ls(d), 0)
  expect_output(
    lex <- get_lesson("carpentries/lesson-example", path = d),
    "cloning into"
  )
  # the output is a Lesson object
  expect_is(lex, "Lesson")
  # the directory exists
  expect_true(fs::dir_exists(fs::path(d, "carpentries--lesson-example", "_episodes")))
  # The episodes in the object are accounted for
  episodes <- fs::dir_ls(fs::path(d, "carpentries--lesson-example", "_episodes"))
  expect_equal(episodes, unname(lex$files))

})

test_that("lessons are accessed without re-downloading", {

  testthat::skip_if_offline()

  # The lesson already exists in the directory
  expect_length(fs::dir_ls(d), 1)

  # Nothing will print because we are using the lesson we downloaded
  expect_silent(
    lex <- get_lesson("carpentries/lesson-example", path = d)
  )

  # the output is a Lesson object
  expect_is(lex, "Lesson")
  # the directory exists
  expect_true(fs::dir_exists(fs::path(d, "carpentries--lesson-example", "_episodes")))
  # The episodes in the object are accounted for
  episodes <- fs::dir_ls(fs::path(d, "carpentries--lesson-example", "_episodes"))
  expect_equal(episodes, unname(lex$files))


})

test_that("overwriting is possible", {
  testthat::skip_if_offline()

  expect_length(fs::dir_ls(d), 1)

  expect_output(
    lex <- get_lesson("carpentries/lesson-example", path = d, overwrite = TRUE),
    "cloning into"
  )

  # the output is a Lesson object
  expect_is(lex, "Lesson")
  # the directory exists
  expect_true(fs::dir_exists(fs::path(d, "carpentries--lesson-example", "_episodes")))
  # The episodes in the object are accounted for
  episodes <- fs::dir_ls(fs::path(d, "carpentries--lesson-example", "_episodes"))
  expect_equal(episodes, unname(lex$files))

})

test_that("Lesson methods work as expected", {

  testthat::skip_if_offline()

  # The lesson already exists in the directory
  expect_length(fs::dir_ls(d), 1)

  # Nothing will print because we are using the lesson we downloaded
  expect_silent(
    lex <- get_lesson("carpentries/lesson-example", path = d)
  )

  # $path ----------------------------------------------------------------------
  expect_equal(fs::path_file(fs::path_dir(lex$path)), fs::path_file(d))

  # $rmd------------------------------------------------------------------------
  expect_false(lex$rmd)

  # $files ---------------------------------------------------------------------
  episodes <- c(
    "01-design.md",
    "02-tooling.md",
    "03-organization.md",
    "04-formatting.md",
    "05-rmarkdown-example.md",
    "06-style-guide.md",
    "07-checking.md",
    "08-coffee.md",
    NULL # add NULL in case we need to rearrange or add things ;)
  )
  expect_length(lex$files, length(episodes))
  expect_named(lex$files, episodes)

  # $n_problems ----------------------------------------------------------------
  problems <- rep(0, 8)
  names(problems) <- episodes
  problems[4] <- 1
  expect_equal(lex$n_problems, problems)

  # $show_problems -------------------------------------------------------------
  ele <- xml2::xml_find_first(
    lex$episodes$`04-formatting.md`$body,
    ".//d1:paragraph[d1:text[text()='do_something']]"
  )
  prob_expect <- list(
    "04-formatting.md" = list(
      code = list(list(element = ele, reason = "orphan code tag"))
    )
  )
  expect_equal(lex$show_problems, prob_expect)

  # $blocks --------------------------------------------------------------------
  # No level three blocks
  expect_equal(sum(lengths(lex$blocks(level = 3))), 0)
  expect_equal(sum(lengths(lex$blocks(level = 2))), 1)

  # There are two solution blocks, but only one is nested (in rmarkdown example)
  n_solutions  <- c(0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L)
  names(n_solutions) <- episodes
  expect_equal(lengths(lex$blocks(".solution")), n_solutions)
  n_solutions[4] <- 0 # the formatting example is not nested
  expect_equal(lengths(lex$blocks(".solution", level = 2)), n_solutions)
  expect_identical(lex$blocks(".solution", level = 2), lex$blocks(level = 2))

  # All the blocktypes are in episode 04
  expect_equal(length(lex$blocks(".callout")$`04-formatting.md`), 3)
  expect_equal(length(lex$blocks(".objectives")$`04-formatting.md`), 1)
  expect_equal(length(lex$blocks(".challenge")$`04-formatting.md`), 1)
  expect_equal(length(lex$blocks(".prereq")$`04-formatting.md`), 1)
  expect_equal(length(lex$blocks(".checklist")$`04-formatting.md`), 1)
  expect_equal(length(lex$blocks(".solution")$`04-formatting.md`), 1)
  expect_equal(length(lex$blocks(".discussion")$`04-formatting.md`), 1)
  expect_equal(length(lex$blocks(".testimonial")$`04-formatting.md`), 1)
  expect_equal(length(lex$blocks(".keypoints")$`04-formatting.md`), 1)

  # $challenges ----------------------------------------------------------------
  n_challenges <- n_solutions
  n_challenges[4] <- 1
  expect_equal(lengths(lex$challenges()), n_challenges)

  # $solutions -----------------------------------------------------------------
  expect_equal(lengths(lex$solutions()), n_solutions)
  expect_equal(lex$blocks(".solution", level = 2)[[5]], lex$solutions()[[5]])

  # $thin ----------------------------------------------------------------------
  eps <- glue::glue_collapse(episodes[-(4:5)], sep = ', ', last = ', and ')
  expect_message(
    lex$thin(verbose = TRUE),
    glue::glue("Removing 6 episodes: {eps}")
  )

  # $episodes ------------------------------------------------------------------
  expect_named(lex$episodes, episodes[4:5])
  expect_is(lex$episodes[[1]], "Episode")
  expect_is(lex$episodes[[2]], "Episode")

})

test_that("Lessons with Rmd sources can be downloaded", {

  skip_if_offline()
  expect_false(fs::dir_exists(fs::path(d, "swcarpentry--r-novice-inflammation")))

  expect_output({
    expect_message(
      rni <- get_lesson("swcarpentry/r-novice-inflammation", path = d),
      "could not find _episodes/, using _episodes_rmd/ as the source",
      fixed = TRUE
    )},
    "cloning into"
  )

  expect_is(rni, "Lesson")
  expect_is(rni$episodes[[1]], "Episode")
  expect_true(rni$rmd)

})

test_that("Non-lessons will be downloaded but rejected", {

  skip_if_offline()

  expect_error(
    capture.output(get_lesson("zkamvar/notes-template", path = d)),
    "could not find either _episodes/ or _episodes_rmd/",
    fixed = TRUE
  )
})
