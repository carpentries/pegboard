test_that("get_challenges() returns the right number of block quotes", {
  frg_path <- lesson_fragment()
  frg      <- get_lesson(path = frg_path)
  expected <- c("10-lunch.md", "14-looping-data-sets.md", "17-scope.md")
  frg_nms  <- fs::path(frg_path, "_episodes", expected)

  expected <- list(
    get_challenges(frg[[frg_nms[1]]]$body),
    get_challenges(frg[[frg_nms[2]]]$body),
    get_challenges(frg[[frg_nms[3]]]$body)
  )
  names(expected) <- frg_nms
  expect_equal(process_lesson(frg), expected)
})
