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


test_that("a keypoints section without a list will throw a warning", {
  e$add_md("::: keypoints\n no body but u\n:::\n", where = 4)
  e$label_divs()
  wrn <- paste(sQuote('keypoints'), "section does not contain a list")
  expect_warning(keys <- get_list_block(e, "keypoints", in_yaml = FALSE), wrn)
})

test_that("two keypoints sections will prefer the last one", {
  e$move_keypoints()
  e$label_divs()
  expect_length(e$get_divs("keypoints"), 2L)
  keys <- e$keypoints
  expect_length(keys, 3L)
  expect_match(keys, "^Use ")
})
