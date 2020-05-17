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
  expect_length(e$code, 3)

  expect_is(e$output, "xml_nodeset")
  expect_length(e$output, 1)

  expect_is(e$error, "xml_nodeset")
  expect_length(e$error, 2)

  expect_is(e$tags, "xml_nodeset")
  expect_length(e$tags, 8)



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

})

test_that("An error will be thrown if a file does not exist", {

  sunshine <- fs::path(lesson_fragment(), "_episodes", "sunshine.md")
  msg <- glue::glue("the file '{sunshine}' does not exist")
  expect_error(Episode$new(sunshine), msg)

})
