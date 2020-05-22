test_that("Episodes can be created and are valid", {

  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)

  expect_is(e, "Episode")
  expect_is(e$body, "xml_document")
  expect_equal(e$path, scope)
  expect_equal(e$name, fs::path_file(scope))
  expect_equal(e$lesson, lesson_fragment())

  expect_is(e$challenges, "xml_nodeset")
  expect_length(e$challenges, 2)
  expect_identical(e$challenges, e$get_blocks())

  expect_length(e$get_blocks(".discussion"), 0L)

  expect_is(e$code, "xml_nodeset")
  expect_length(e$code, 6)

  expect_is(e$output, "xml_nodeset")
  expect_length(e$output, 1)

  expect_is(e$error, "xml_nodeset")
  expect_length(e$error, 2)

  expect_is(e$tags, "xml_nodeset")
  expect_length(e$tags, 8)
  expect_match(xml2::xml_text(e$tags), "^[{][:] [.][-a-z]+?[}]$")


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

test_that("blocks can be converted to code blocks", {

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
  challenge_tags <- tags
  challenge_tags[9:11] <- "{: .challenge}"
  expect_length(e$get_blocks(), 3)

  expect_length(e$code, 11)
  expect_identical(xml2::xml_attr(e$code, "ktag"), tags)
  expect_length(e$reset()$unblock()$get_blocks(), 0)
  expect_length(e$reset()$unblock()$code, 11)
  expect_identical(xml2::xml_attr(e$reset()$unblock()$code, "ktag"), challenge_tags)

  cb <- xml2::xml_text(e$reset()$unblock()$code[11])
  # All lines will either start with code or comment
  expect_match(strsplit(cb, "\n")[[1]], "^([#]['+]|import|fig|for|    |plt)")

  # A solution block will exist
  expect_match(cb, "[@]solution")
  expect_match(cb, "[@]challenge")

  # code is presented unmodified

  # final challenge block is one code block
  expect_match(cb, xml2::xml_text(e$reset()$code[11]), fixed = TRUE)

  # middle challenge block is two code blocks
  expect_match(
    xml2::xml_text(e$reset()$unblock()$code[10]),
    xml2::xml_text(e$reset()$code[10]),
    fixed = TRUE
  )

  expect_match(
    xml2::xml_text(e$reset()$unblock()$code[10]),
    xml2::xml_text(e$reset()$code[9]),
    fixed = TRUE
  )

})


test_that("An episode can be cloned deeply", {

  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)
  ec <- e$clone()
  ed <- e$clone(deep = TRUE)

  expect_equal(e, ec)
  expect_equal(e, ed)

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
