
ff <- tempfile()
withr::defer({
  unlink(ff)
})


test_that("div pairs are uniquely labelled", {
  nodes <- c(
  "<div class='1'>", 
    "<div class='2'>" , 
    "</div>", 
    "<div class='2'>", 
      "<div class='3'>", 
      "</div>", 
    "</div>", 
  "</div>")
  out <- pegboard:::find_div_pairs(nodes)
  expect_equal(out, c(1, 2, 2, 3, 4, 4, 3, 1))
  out <- pegboard:::find_div_pairs(c(nodes, nodes))
  expect_equal(out, c(
      1, 2, 2, 3, 4, 4, 3, 1,
      5, 6, 6, 7, 8, 8, 7, 5
    ))
  out <- pegboard:::find_div_pairs(nodes[c(1, 3)])
  expect_equal(out, c(1, 1))
  nodes <- c(
  ":::: hey", 
    "::: ho" , 
    "::::", 
    "::: ho", 
      "::: hello", 
      ":::", 
    "::::::", 
  "::::::")
  out <- pegboard:::find_div_pairs(nodes)
  expect_equal(out, c(1, 2, 2, 3, 4, 4, 3, 1))
  out <- pegboard:::find_div_pairs(c(nodes, nodes))
  expect_equal(out, c(
      1, 2, 2, 3, 4, 4, 3, 1,
      5, 6, 6, 7, 8, 8, 7, 5
    ))
  out <- pegboard:::find_div_pairs(nodes[c(1, 3)])
  expect_equal(out, c(1, 1))
})

test_that("clustered divs can be cleaned", {

  ex <- tinkr::to_xml(file.path(test_path(), "examples", "div-cluster.txt"))

  divs <- xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
  expect_length(divs, 5)
  pegboard:::clean_div_tags(ex$body)
  divs <- xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
  expect_length(divs, 8)
  tinkr::to_md(ex, ff)
  exc <- paste(readLines(ff), collapse = "\n")
  expect_match(exc, "<div class='challenge'>\n\n## Challenge", fixed = TRUE)
  expect_match(exc, "</div>\n\n<div class='solution'>", fixed = TRUE)
  expect_match(exc, "</div>\n\n</div>", fixed = TRUE)
  expect_match(exc, "<div class='solution'>\n\n```{r}\nIt's", fixed = TRUE)

})

test_that("label_div_tags() will clean clustered divs", {

  ex <- tinkr::to_xml(file.path(test_path(), "examples", "div-cluster.txt"))

  divs <- xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
  expect_length(divs, 5)
  label_div_tags(ex$body)
  dvs <- get_divs(ex$body)
  expect_length(dvs, 8 / 2) # 8 html tags are 4 pairs of div tags
  expect_length(dvs[[2]], 1) 
  expect_length(dvs[[3]], 3)

})

test_that("label_div_tags() will clean clustered pandoc divs", {

  skip("Work still needs to be done here")

  ex <- tinkr::to_xml(file.path(test_path(), "examples", "pandoc-div.txt"))

  divs <- xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
  expect_length(divs, 0)
  divs <- xml2::xml_find_all(ex$body, ".//d1:text[contains(text(), ':::')]")
  expect_length(divs, 9)
  label_div_tags(ex$body, pandoc = TRUE)
  dvs <- get_divs(ex$body)
  expect_length(dvs, 8 / 2) # 8 html tags are 4 pairs of div tags
  expect_length(dvs[[2]], 1) 
  expect_length(dvs[[3]], 3)

})
