test_that("Episodes can be created and are valid", {

  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)

  expect_s3_class(e, "Episode")
  expect_s3_class(e$body, "xml_document")
  expect_equal(e$path, scope)
  expect_equal(e$name, fs::path_file(scope))
  expect_equal(e$lesson, lesson_fragment())

  expect_s3_class(e$challenges, "xml_nodeset")
  expect_length(e$challenges, 2)
  expect_identical(e$challenges, e$get_blocks())

  expect_length(e$get_blocks(".discussion"), 0L)

  expect_s3_class(e$code, "xml_nodeset")
  expect_length(e$code, 6)

  expect_s3_class(e$output, "xml_nodeset")
  expect_length(e$output, 1)

  expect_s3_class(e$error, "xml_nodeset")
  expect_length(e$error, 2)

  expect_s3_class(e$tags, "xml_nodeset")
  expect_length(e$tags, 8)
  expect_match(xml2::xml_text(e$tags), "^[{][:] [.][-a-z]+?[}]$")


})


test_that("$confirm_sandpaper() does not error on mismatched divs", {
  e <- Episode$new(test_path("examples", "mismatched-div.txt"), 
    process_tags = FALSE, fix_links = FALSE, fix_liquid = FALSE)
  suppressMessages({
    expect_message(e$confirm_sandpaper(), 
      "Section (div) tags for mismatched-div.txt will not be labelled",
      fixed = TRUE
    )
  })
  expect_s3_class(e, "Episode")
})

test_that("handouts can be created", {

  e <- Episode$new(test_path("examples", "handout.Rmd"), 
    process_tags = FALSE, fix_links = FALSE, fix_liquid = FALSE)
  e$confirm_sandpaper()
  expect_length(e$solutions, 2)
  # handout by itself returns the text
  expect_snapshot(cat(e$handout()))
  # the object is not affected by this
  expect_length(e$solutions, 2)
  expect_snapshot(cat(e$handout(solution = TRUE)))
  rmd <- fs::file_temp(ext = "Rmd")
  out <- fs::file_temp(ext = "R")
  withr::local_file(c(rmd, out))
  
  # handout with a file returns the original Episode object
  expect_false(fs::file_exists(rmd))
  # The object is still not affected by the handout
  expect_length(e$handout(rmd)$solutions, 2)
  expect_true(fs::file_exists(rmd))
  expect_snapshot(cat(tinkr::yarn$new(rmd)$show(), sep = "\n"))

  if (requireNamespace("knitr", quietly = TRUE)) {
    expect_false(fs::file_exists(out))
    knitr::purl(rmd, out, documentation = 2, quiet = TRUE)
    expected <- c("v <- rnorm(10)", 
      "the_sum <- 0", 
      "for (i in v) {\n    the_sum <- the_sum + i\n}", 
      "the_mean <- the_sum/length(v)"
    )
    expect_true(fs::file_exists(out))
    expected <- c("v <- rnorm(10)", 
      "the_sum <- 0", 
      "for (i in v) {\n    the_sum <- the_sum + i\n}", 
      "the_mean <- the_sum/length(v)"
    )
    expect_equal(as.character(parse(out)), expected)
  }

})


test_that("Episodes can be reset if needed", {

  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)

  # If we edit a part of the XML, the object itself will be modified
  expect_equal(xml2::xml_text(e$tags[1]), "{: .language-python}")
  expect_equal(xml2::xml_set_attr(xml2::xml_parent(e$tags[1]), "ktag", "{: .source}"), "{: .source}")
  expect_equal(xml2::xml_text(e$tags[1]), "{: .source}")

  # When we use $reset(), then everything goes back to the initial state
  expect_equal(xml2::xml_text(e$reset()$tags[1]), "{: .language-python}")

})

test_that("the write() method works", {

  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)
  tm <- gsub(" ", "-", as.character(Sys.time()))
  expect_error(
    e$write(path = fs::path_temp(tm)),
    glue::glue("{tm}' does not exist"),
    fixed = TRUE
  )
  expect_message(
    e$write(),
    "Creating temporary directory"
  )
  d <- fs::dir_create(fs::file_temp())
  # Burn it to the ground when we done.
  withr::defer({
    fs::dir_delete(d)
  })

  # Writing under normal circumstances work
  expect_length(fs::dir_ls(d), 0L)
  expect_silent(e$write(d))
  expect_equal(fs::path_file(fs::dir_ls(d)), e$name)
  f <- readLines(fs::dir_ls(d))
  f <- f[f != '']
  expect_equal(f[length(f)], "{: .challenge}")

  # Writing after modification works
  expect_silent(
    e$
      write(d)$
      write(d, format = "xml")$
      write(d, format = "html")
  )
  expect_error(
    e$write(d, format = "fmt"),
    "format = 'fmt' is not a valid option",
    fixed = TRUE
  )
  nam <- fs::path_ext_remove(e$name)
  nms <- glue::glue("{nam}.{c('md', 'xml', 'html')}")
  expect_setequal(fs::path_file(fs::dir_ls(d)), nms)
  f <- readLines(fs::path(d, e$name))
  f <- f[f != '']
  expect_equal(f[length(f)], "{: .challenge}")
  expect_equal(f[length(f) - 1], "> {: .error}")

})

test_that("isolate_blocks() method works as expected", {
  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)

  d <- fs::dir_create(fs::file_temp())
  # Burn it to the ground when we done.
  withr::defer({
    fs::dir_delete(d)
  })

  # Starts off with 9 elements
  expect_equal(xml2::xml_length(e$body), 9)
  # ends up with 2 elements
  expect_equal(xml2::xml_length(e$isolate_blocks()$body), 2)
  # can be reset
  expect_equal(xml2::xml_length(e$reset()$isolate_blocks()$reset()$body), 9)

  expect_silent(e$isolate_blocks()$write(d))
  expect_true(fs::file_exists(fs::path(d, e$name)))

  f <- readLines(fs::path(d, e$name))
  f <- f[f != '']
  expect_equal(f[length(f)], "{: .challenge}")
  expect_equal(f[length(f) - 1], "> {: .error}")

  # The first thing in the episode is a block quote
  expect_true(grepl("^>", f[length(e$yaml) + 2]))
  # There are only 50 lines beyond the yaml
  expect_equal(length(f[-seq(length(e$yaml))]), 50)

})

test_that("yaml items can be moved to the text (with dovetail)", {

  scope <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(scope)
  yml <- e$get_yaml()
  expect_equal(e$questions, yml[["questions"]])
  n_code_blocks <- length(e$code)
  expect_named(yml, c("title", "teaching", "exercises", "questions", "objectives", "keypoints"))
  expect_false(length(xml2::xml_find_all(e$body, ".//d1:code_block[@info='{questions}']")) > 0)

  e$use_dovetail() # Using dovetail

  e$move_questions()
  expect_equal(n_code_blocks + 2L, length(e$code))
  expect_equal(e$questions, yml[["questions"]])

  # The question block is moved to the top
  expect_equal(xml2::xml_attr(e$code[2], "language"), "questions")
  # question block is removed from yaml
  yml <- e$get_yaml()
  expect_equal(e$objectives, yml[["objectives"]])
  expect_named(yml, c("title", "teaching", "exercises", "objectives", "keypoints"))

  e$move_objectives()
  expect_equal(n_code_blocks + 3L, length(e$code))
  expect_equal(e$objectives, yml[["objectives"]])
  expect_equal(xml2::xml_attr(e$code[2], "language"), "objectives")
  yml <- e$get_yaml()
  expect_equal(e$keypoints, yml[["keypoints"]])
  expect_named(yml, c("title", "teaching", "exercises", "keypoints"))

  e$move_keypoints()
  expect_equal(n_code_blocks + 4L, length(e$code))
  expect_equal(e$keypoints, yml[["keypoints"]])
  expect_equal(xml2::xml_attr(e$code[2], "language"), "objectives")
  expect_equal(xml2::xml_attr(e$code[length(e$code)], "language"), "keypoints")
  yml <- e$get_yaml()
  expect_named(yml, c("title", "teaching", "exercises"))

})

test_that("yaml items can be moved to the text (no dovetail)", {

  scope <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(scope)
  yml <- e$get_yaml()
  expect_equal(e$questions, yml[["questions"]])
  n_code_blocks <- length(e$code)
  expect_named(yml, c("title", "teaching", "exercises", "questions", "objectives", "keypoints"))
  expect_false(length(xml2::xml_find_all(e$body, ".//d1:code_block[@info='{questions}']")) > 0)
  expect_length(xml2::xml_find_all(e$body, ".//d1:html_block"), 2)
  expect_equal(length(e$get_divs()), 0)

  e$move_questions()
  expect_equal(length(e$get_divs()), 1)
  expect_equal(n_code_blocks, length(e$code))
  expect_equal(e$questions, yml[["questions"]])

  expect_moved_yaml(e, "questions", 1L)

  # question block is removed from yaml
  yml <- e$get_yaml()
  expect_equal(e$objectives, yml[["objectives"]])
  expect_named(yml, c("title", "teaching", "exercises", "objectives", "keypoints"))

  e$move_objectives()
  expect_equal(length(e$get_divs()), 2)
  expect_equal(n_code_blocks, length(e$code))
  expect_equal(e$objectives, yml[["objectives"]])
  
  expect_moved_yaml(e, "objectives", 1L)

  yml <- e$get_yaml()
  expect_equal(e$keypoints, yml[["keypoints"]])
  expect_named(yml, c("title", "teaching", "exercises", "keypoints"))

  e$move_keypoints()$label_divs()
  expect_equal(length(e$get_divs()), 3)
  expect_equal(n_code_blocks, length(e$code))
  expect_equal(e$keypoints, yml$keypoints) 
  
  expect_moved_yaml(e, "keypoints", 3L)

  yml <- e$get_yaml()
  expect_named(yml, c("title", "teaching", "exercises"))

})

test_that("blocks can be converted to div blocks", {


  loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(loop)
  tags <- c(
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .language-python}",
    "{: .language-python}"
  )
  challenge_tags         <- tags
  challenge_tags[9:11]   <- NA
  language_tags          <- rep(NA_character_, length(tags))

  expect_length(e$get_blocks(level = 0), 6)
  expect_length(xml2::xml_find_all(e$body, ".//d1:html_block"), 2)

  expect_length(e$code, 11)
  expect_identical(xml2::xml_attr(e$code, "ktag"), tags)
  expect_length(e$reset()$unblock()$code, 11)
  # no blocks
  expect_length(e$reset()$unblock()$get_blocks(), 0)
  # div tags, though
  expect_length(xml2::xml_find_all(e$reset()$unblock()$body, ".//d1:html_block"), 2)# + (6 * 2))
  expect_identical(xml2::xml_attr(e$reset()$unblock()$code, "ktag"), tags)
  expect_identical(xml2::xml_attr(e$reset()$unblock()$code, "language"), language_tags)

  expect_length(e$get_divs(), 3 + 3)
  expect_length(e$solutions, 3)
  expect_length(e$challenges, 3)

  html <- xml2::xml_find_all(e$reset()$unblock()$body, ".//d1:html_block")
  html <- xml2::xml_text(html)
  expect_length(html, 2)
  expect_match(html, "img")
  ub <- e$reset()$unblock()$body
  divs <- xml2::xml_find_all(ub, "./pb:dtag", get_ns(ub))
  divs <- xml2::xml_attr(divs, "label")
  expect_match(divs[c(1, 5, 9)], "challenge")
  expect_match(divs[c(2, 6, 10)], "solution")

  cb <- xml2::xml_text(e$reset()$unblock()$code[11])
  # All lines will either start with code or comment, but none will start with
  # a roxygen comment
  expect_match(strsplit(cb, "\n")[[1]], "^([#][^'+]|import|fig|for|    |plt)")

  # A solution block will exist
  expect_failure(expect_match(cb, "[@]solution"))
  expect_failure(expect_match(cb, "[@]challenge"))

  # code is presented unmodified

  # final challenge block is one code block
  expect_match(cb, xml2::xml_text(e$reset()$code[11]), fixed = TRUE)

})

test_that("blocks can be converted to code blocks with dovetail", {


  loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
  e <- Episode$new(loop)
  tags <- c(
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .output}",
    "{: .language-python}",
    "{: .language-python}",
    "{: .language-python}"
  )
  challenge_tags         <- tags
  challenge_tags[9:11]   <- NA
  challenge_tags         <- c(NA, challenge_tags)
  language_tags          <- tags
  language_tags[-(9:11)] <- NA
  language_tags[9:11]    <- "challenge"
  language_tags          <- c("r", language_tags)

  expect_length(e$get_blocks(), 3)

  expect_length(e$code, 11)
  expect_identical(xml2::xml_attr(e$code, "ktag"), tags)
  expect_length(e$reset()$unblock()$get_blocks(), 0)
  expect_length(e$reset()$use_dovetail()$unblock()$code, 12)
  expect_identical(xml2::xml_attr(e$reset()$use_dovetail()$unblock()$code, "ktag"), challenge_tags)
  expect_identical(xml2::xml_attr(e$reset()$use_dovetail()$unblock()$code, "language"), language_tags)

  cb <- xml2::xml_text(e$reset()$use_dovetail()$unblock()$code[12])
  # All lines will either start with code or comment
  expect_match(strsplit(cb, "\n")[[1]], "^([#]['+]|import|fig|for|    |plt)")

  # A solution block will exist
  expect_match(cb, "[@]solution")
  expect_failure(expect_match(cb, "[@]challenge"))

  # code is presented unmodified

  # final challenge block is one code block
  expect_match(cb, xml2::xml_text(e$reset()$code[11]), fixed = TRUE)

  # middle challenge block is two code blocks
  expect_match(
    xml2::xml_text(e$reset()$use_dovetail()$unblock()$code[11]),
    xml2::xml_text(e$reset()$code[10]),
    fixed = TRUE
  )

  expect_match(
    xml2::xml_text(e$reset()$use_dovetail()$unblock()$code[11]),
    xml2::xml_text(e$reset()$code[9]),
    fixed = TRUE
  )

})

test_that("challenges with multiple solution blocks will be rendered appropriately", {

  floop <- fs::path(lesson_fragment(), "_episodes", "12-for-loops.md")
  e     <- Episode$new(floop)
  expect_length(e$challenges, 7)
  expect_length(e$solutions, 10)
  chlng <- e$challenges[4]
  # The challenge is a block quote
  expect_true(xml2::xml_find_lgl(chlng, "boolean(self::d1:block_quote)"))
  sltns <- xml2::xml_find_all(chlng, ".//d1:block_quote[@ktag='{: .solution}']")
  # There should be four solutions within this single challenge
  expect_length(sltns, 4)
  e$unblock()
  # The challenge is now empty
  expect_true(xml2::xml_find_lgl(chlng, "boolean(self::d1:block_quote)"))
  expect_equal(xml2::xml_text(chlng), "")

  # the accessors still register challenges and solutions
  expect_length(e$challenges, 7)
  expect_length(e$solutions, 10)

  # This process works for non-challenge blocks
  e$reset()
  chlng <- e$challenges[4]
  xml2::xml_attr(chlng, "ktag") <- "{: .callout}"
  e$unblock()
  # the accessors still register challenges and solutions
  expect_length(e$challenges, 6)
  expect_length(e$solutions, 10)
  expect_length(e$get_divs("callout"), 1)

})

test_that("dovetail with multiple solution blocks will be rendered appropriately", {

  floop <- fs::path(lesson_fragment(), "_episodes", "12-for-loops.md")
  e     <- Episode$new(floop)
  expect_length(e$challenges, 7)
  expect_length(e$solutions, 10)
  chlng <- e$challenges[4]
  # The challenge is a block quote
  expect_true(xml2::xml_find_lgl(chlng, "boolean(self::d1:block_quote)"))
  sltns <- xml2::xml_find_all(chlng, ".//d1:block_quote[@ktag='{: .solution}']")
  # There should be four solutions within this single challenge
  expect_length(sltns, 4)
  e$use_dovetail()$unblock()
  # The challenge is now a code block
  expect_false(xml2::xml_find_lgl(chlng, "boolean(self::d1:block_quote)"))
  expect_true(xml2::xml_find_lgl(chlng, "boolean(self::d1:code_block)"))
  expect_match(xml2::xml_text(chlng), "## Practice Accumulating")
  expect_match(xml2::xml_text(chlng), "@solution Solution")
  expect_match(xml2::xml_text(chlng), "ZNK: this is a test")
  expect_match(xml2::xml_text(chlng), "ZNK: test two")

  # There will be four solution blocks and four challenge blocks
  ctxt <- strsplit(xml2::xml_text(chlng), "\n")[[1]]
  expect_equal(sum(grepl("@solution", ctxt)), 4)
  expect_equal(sum(grepl("@challenge", ctxt)), 0)
  expect_equal(sum(grepl("@end", ctxt)), 4)

  # This process works for non-challenge blocks
  e$reset()
  chlng <- e$challenges[4]
  xml2::xml_attr(chlng, "ktag") <- "{: .callout}"
  e$use_dovetail()$unblock()
  expect_true(xml2::xml_find_lgl(chlng, "boolean(self::d1:code_block)"))
  expect_match(xml2::xml_text(chlng), "## Practice Accumulating")
  expect_match(xml2::xml_text(chlng), "@solution Solution")
  expect_match(xml2::xml_text(chlng), "ZNK: this is a test")
  expect_match(xml2::xml_text(chlng), "ZNK: test two")
  ctxt <- strsplit(xml2::xml_text(chlng), "\n")[[1]]
  expect_equal(sum(grepl("@solution", ctxt)), 4)
  expect_equal(sum(grepl("@challenge", ctxt)), 0)
  expect_equal(sum(grepl("@callout", ctxt)), 0)
  expect_equal(sum(grepl("@end", ctxt)), 4)

  # This works if the first part is not a level2 heading
  e$reset()
  chlng <- e$challenges[4]
  xml2::xml_attr(chlng, "ktag") <- "{: .callout}"
  chead <- xml2::xml_find_first(chlng, ".//d1:heading")
  xml2::xml_attr(chead, "level") <- '3'
  e$use_dovetail()$unblock()
  expect_true(xml2::xml_find_lgl(chlng, "boolean(self::d1:code_block)"))
  expect_match(xml2::xml_text(chlng), "### Practice Accumulating")
  expect_match(xml2::xml_text(chlng), "@solution Solution")
  expect_match(xml2::xml_text(chlng), "ZNK: this is a test")
  expect_match(xml2::xml_text(chlng), "ZNK: test two")
  ctxt <- strsplit(xml2::xml_text(chlng), "\n")[[1]]
  expect_equal(sum(grepl("@solution", ctxt)), 4)
  expect_equal(sum(grepl("@challenge", ctxt)), 0)
  expect_equal(sum(grepl("@callout", ctxt)), 0)
  expect_equal(sum(grepl("@end", ctxt)), 4)


})


test_that("questions can be retrieved reliably from any source", {

  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)
  answers <- c("How do function calls actually work?", 
    "How can I determine where errors occurred?")
  expect_equal(e$questions, answers)
  expect_equal(e$move_questions()$questions, answers)
  e <- Episode$new(scope)
  expect_equal(e$use_dovetail()$move_questions()$questions, answers)

})

test_that("An episode can be cloned deeply", {

  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)
  ec <- e$clone()
  ed <- e$clone(deep = TRUE)

  expect_setequal(names(e), names(ec))
  expect_equal(e$body, ec$body)
  expect_setequal(names(e), names(ed))
  expect_equal(e$body, ed$body)

  expect_identical(xml2::as_list(e$body), xml2::as_list(ed$body))
  expect_identical(xml2::as_list(ec$body), xml2::as_list(ed$body))

  expect_equal(xml2::xml_text(e$tags[1]), "{: .language-python}")
  expect_equal(xml2::xml_text(ec$tags[1]), "{: .language-python}")
  expect_equal(xml2::xml_text(ed$tags[1]), "{: .language-python}")

  # modifying the original does not affect the deep clone
  expect_equal(xml2::xml_set_attr(xml2::xml_parent(e$tags[1]), "ktag", "{: .source}"), "{: .source}")
  expect_equal(xml2::xml_text(e$tags[1]), "{: .source}")
  expect_equal(xml2::xml_text(ec$tags[1]), "{: .source}")
  expect_equal(xml2::xml_text(ed$tags[1]), "{: .language-python}")

})

test_that("An error will be thrown if a file does not exist", {

  sunshine <- fs::path(lesson_fragment(), "_episodes", "sunshine.md")
  msg <- glue::glue("the file '{sunshine}' does not exist")
  expect_error(Episode$new(sunshine), msg)

})


test_that("An error will be thrown if a file does not exist", {

  sunshine <- fs::path(lesson_fragment(), "_episodes", "sunshine.md")
  msg <- glue::glue("the file '{sunshine}' does not exist")
  expect_error(Episode$new(sunshine), msg)

})
