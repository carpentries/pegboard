
test_that("markdown images will process alt text appropriately", {
  imgs <- c(
    "![image1](a.png){width='20%'}", 
    "![image2](b.png){alt='text\nalt' width='20%'}", 
    "![image3](c.png){ width='31%' alt='something long and proseful' style='border-radius: \"50%\"'}", 
    "![",
    "image4 with a longer caption", 
    "](d.png){ width='31%'",
    "alt='attributes on separate lines'",
    "style='border-radius: \"25%\"'}",
    "![image5](e.png)", 
    "![The {pegboard} package](pegboard.png){width='49%'",
    "alt='The logo for the {pegboard} package, which",
    "appears as a little workshop with a pegboard on the wall'}",
    "text")
  txt <- paste(imgs, collapse = "\n")
  
  xml <- xml2::read_xml(commonmark::markdown_xml(txt))
  ns  <- tinkr::md_ns()
  images <- xml2::xml_find_all(xml, ".//md:image", ns = ns)
  process_images(images, ns)
  expected_alts <- c(NA_character_, 
    "text alt", 
    "something long and proseful", 
    "attributes on separate lines",
    NA_character_,
  "The logo for the {pegboard} package, which appears as a little workshop with a pegboard on the wall")
  expect_equal(xml2::xml_attr(images, "alt"), expected_alts)
})

