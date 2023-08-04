
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


test_that("HTML images in comments do not error", {
  # see https://github.com/carpentries/pegboard/issues/130

  tmp <- withr::local_tempfile()

  all_comment <- r"{
  some text and 

  <!-- <img src='whoops.png'> -->
  }"
  writeLines(all_comment, tmp)
  ep <- pegboard::Episode$new(tmp)
  res <- ep$validate_links(warn = FALSE)
  expect_null(res)
})


test_that("HTML images surrounded by comments are processed. ", {

  tmp <- withr::local_tempfile()

  some_comment<- r"{
There is only one HTML image here and it will be processed.
NOTE: each comment block is parsed as an individual HTML block,
and the numbers in this example help us understand that fact.

<!-- <img src='whoops.png'> ONE -->
<!-- <img src='whoops.png'> 
       <img src='whoops.png'> 
   TWO
   -->
   <!-- <img src='whoops.png'> THREE -->
  <img src='okay.png'> <!-- <img src='whoops.png'> -->

  <!-- <img src='whoops.png'> FOUR -->
  }"
  writeLines(some_comment, tmp)
  ep <- pegboard::Episode$new(tmp)
  res <- ep$validate_links(warn = FALSE)
  expect_equal(nrow(res), 1L)
  # There are four HTML blocks 
  blocks <- xml2::xml_find_all(ep$body, ".//md:html_block", ns = ep$ns)
  expect_length(blocks, 4L)
  # when we extract the number elements, they are what we expect.
  expect_equal(gsub("[^A-Z]", "", xml2::xml_text(blocks)), 
    c("ONE", "TWO", "THREE", "FOUR"))

})



