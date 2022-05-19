
test_that("make_pandoc_alt() converts alt text good", {

  txt <- paste(c("![has alt text](img1.png)", 
      "",
   "![](needs-alt.png)", "",
   "![ ](decorative.png)", "",
   "![has alt text](img2.png){: .class}", "",
   "![Is actually a caption https://example.com](actually-caption.png)", "",
   NULL), collapse = "\n")
  f <- textConnection(txt)
  body <- tinkr::to_xml(f)$body
  ns <- tinkr::md_ns()
  images <- xml2::xml_find_all(body, ".//image", ns = ns)
  make_pandoc_alt(images)
  # Alt text is expected only when nodes indicate that it is expected
  expect_equal(xml2::xml_attr(images, "alt"), 
    c("has alt text", NA, "", "has alt text", NA))
  # captions are not present (because we did not previously have ways to 
  # incorporate captions
  expect_equal(xml2::xml_text(images),
    c(rep("", 4), "Is actually a caption https://example.com"))
})

