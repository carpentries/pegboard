

frg_path <- fs::path(test_path(), "lesson-fragment")
frg      <- get_lesson(path = frg_path)
expected <- c("10-lunch.md", "14-looping-data-sets.md", "17-scope.md")
frg_nms  <- fs::path(fs::path_abs(frg_path), "_episodes", expected)

test_that("get_challenges() returns the right number of block quotes", {
  expect_length(get_challenges(frg[[frg_nms[1]]]$body), 0)
  expect_length(get_challenges(frg[[frg_nms[2]]]$body), 3)
  expect_length(get_challenges(frg[[frg_nms[3]]]$body), 2)
})

test_that("get_challenges() will return a list", {
  expect_is(get_challenges(frg[[frg_nms[1]]]$body), "xml_nodeset")
  expect_is(get_challenges(frg[[frg_nms[1]]]$body, as_list = TRUE), "list")
})
