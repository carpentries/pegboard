test_that("stylesheet is properly escaped", {

  # copy the tinkr stylesheeet to a temporary file with a space
  tmp <- withr::local_tempfile(pattern = "file with space", fileext = ".xsl")
  tnk <- system.file("extdata", "xml2md_gfm.xsl", package = "tinkr")
  file.copy(tnk, tmp)
  file.copy(file.path(dirname(tnk), "xml2md.xsl"), file.path(dirname(tmp)))
  expect_identical(readLines(tmp), readLines(tnk))

  # load the test episode and confirm output
  scope <- fs::path(lesson_fragment(), "_episodes", "17-scope.md")
  e <- Episode$new(scope)
  x <- tinkr::to_md(e, stylesheet_path = sty)
  expect_length(x, 2)
  expect_type(x, "character")

  sty <- get_stylesheet(import = tmp)

  y <- tinkr::to_md(e, stylesheet_path = sty)
  expect_identical(x, y)

})

