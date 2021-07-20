imt <- Episode$new(test_path("examples", "image-test.md"))

test_that("images are not processed through the active binding or by default", {
  expect_length(imt$images, 8L)
  expect_length(imt$get_images(), 8L)
  expect_true(all(is.na(xml2::xml_attr(imt$images, "alt"))))
})


test_that("images that are processed retain alt attributes", {
  expect_length(imt$get_images(TRUE), 9L)
  # HTML blocks are unprocessed here
  expect_equal(sum(is.na(xml2::xml_attr(imt$images, "alt"))), 4L)
})
