
test_that("markdown images will process alt text appropriately", {
  txt <- "![image1](a.png){width='20%'}\n![image2](b.png){alt='text\nalt' width='40%'}\n![image3](c.png)\ntext"
  
  xml <- xml2::read_xml(commonmark::markdown_xml(txt))
  ns  <- tinkr::md_ns()
  images <- xml2::xml_find_all(xml, ".//md:image", ns = ns)
  process_images(images, ns)
  expected_alts <- c(NA_character_, "text alt", NA_character_)
  expect_equal(xml2::xml_attr(images, "alt"), expected_alts)
})

