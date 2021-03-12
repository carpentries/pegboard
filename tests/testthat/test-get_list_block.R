scope <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
e     <- Episode$new(scope)
withr::defer(rm(e, scope))

test_that("get_list_block can fetch the YAML questions", {
 
  yml <- e$get_yaml()
  expect_equal(e$questions, yml[["questions"]])
  expect_equal(get_list_block(e, "questions", in_yaml = TRUE), yml[["questions"]])

})

test_that("get_list_block will throw a warning for unexpected types", {
 
  expect_warning(
    res <- get_list_block(e, "questions", in_yaml = FALSE),
    glue::glue("No section called {sQuote('questions')}")
  )
  expect_equal(res, character(0))

  expect_warning(
    res <- get_list_block(e, "hotdogs", in_yaml = FALSE),
    glue::glue("No section called {sQuote('hotdogs')}")
  )
  expect_equal(res, character(0))

})
