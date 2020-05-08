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

  expect_is(e$code, "xml_nodeset")
  expect_length(e$code, 3)

  expect_is(e$output, "xml_nodeset")
  expect_length(e$output, 1)

  expect_is(e$error, "xml_nodeset")
  expect_length(e$error, 2)

})

test_that("An error will be thrown if a file does not exist", {
  sunshine <- fs::path(lesson_fragment(), "_episodes", "sunshine.md")
  msg <- glue::glue("the file '{sunshine}' does not exist")
  expect_error(Episode$new(sunshine), msg)

})
