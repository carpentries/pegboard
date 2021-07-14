

frg_path <- lesson_fragment()
frg      <- Lesson$new(path = frg_path, rmd = FALSE)
expected <- c("10-lunch.md", "14-looping-data-sets.md", "17-scope.md")
lexpected <- c(0, 3, 2)
names(lexpected) <- expected

test_that("get_challenges() returns the right number of block quotes", {
  expect_length(get_challenges(frg$episodes[[expected[1]]]$body), 0)
  expect_length(get_challenges(frg$episodes[[expected[2]]]$body), 3)
  expect_length(get_challenges(frg$episodes[[expected[3]]]$body), 2)

})

test_that("get_challenges() returns a", {
  expect_s3_class(get_challenges(frg$episodes[[expected[1]]]$body), "xml_nodeset")
})
