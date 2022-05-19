
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

  divs <- xml2::xml_find_all(ex$body, ".//html_block[contains(text(), 'div')]")
  expect_length(divs, 5)
  pegboard:::clean_div_tags(ex$body)
  divs <- xml2::xml_find_all(ex$body, ".//html_block[contains(text(), 'div')]")
  expect_length(divs, 8)
  tinkr::to_md(ex, ff)
  exc <- paste(readLines(ff), collapse = "\n")
  expect_match(exc, "<div class='challenge'>\n\n## Challenge", fixed = TRUE)
  expect_match(exc, "</div>\n\n<div class='solution'>", fixed = TRUE)
  expect_match(exc, "</div>\n\n</div>", fixed = TRUE)
  expect_match(exc, "<div class='solution'>\n\n```{r}\nIt's", fixed = TRUE)

})

test_that("label_div_tags() will clean clustered divs", {

  ex <- tinkr::to_xml(file.path(test_path(), "examples", "div-cluster.txt"), sourcepos = TRUE)

  divs <- xml2::xml_find_all(ex$body, ".//html_block[contains(text(), 'div')]")
  expect_length(divs, 5)
  label_div_tags(ex$body)
  dvs <- get_divs(ex$body)
  expect_length(dvs, 8 / 2) # 8 html tags are 4 pairs of div tags
  expect_length(dvs[[2]], 3) 
  expect_length(dvs[[3]], 5)

})

test_that("label_div_tags() will clean clustered pandoc divs", {

  ex <- tinkr::to_xml(file.path(test_path(), "examples", "pandoc-div.txt"), sourcepos = TRUE)

  divs <- xml2::xml_find_all(ex$body, ".//html_block[contains(text(), 'div')]")
  expect_length(divs, 0)
  divs <- xml2::xml_find_all(ex$body, ".//text[contains(text(), ':::')]")
  expect_length(divs, 11)
  label_div_tags(ex$body)
  dvs <- get_divs(ex$body)
  expect_length(dvs, 10 / 2) # 10 html tags are 5 pairs of div tags
  expect_length(get_divs(ex$body, "challenge"), 1L)
  expect_length(get_divs(ex$body, "callout"), 1L)
  expect_length(get_divs(ex$body, "solution"), 2L)
  expect_length(get_divs(ex$body, "good"), 1L)
  tinkr::to_md(ex, ff)
  exc <- paste(readLines(ff), collapse = "\n")
  expect_match(exc, "::::::: challenge\n\n## Challenge", fixed = TRUE)
  expect_match(exc, "::::\n::: solution :::", fixed = TRUE)
  expect_match(exc, ":::::\n:::::", fixed = TRUE)
  expect_match(exc, "::::: solution ::::\n\n```{r}\nIt's", fixed = TRUE)

})


test_that("label_div_tags() will throw an error if there are missing tags", {

  ci <- Sys.getenv("CI")
  withr::defer(Sys.setenv(CI = ci))

  Sys.setenv(CI = "")
  ex <- tinkr::yarn$new(file.path(test_path(), "examples", "mismatched-div.txt"), sourcepos = TRUE)
  suppressMessages({
  expect_error(label_div_tags(ex), "mismatched-div.txt:5\t| tag: challenge, fixed = TRUE")
  Sys.setenv(CI = "true")
  expect_error(label_div_tags(ex), "::warning file=.+?mismatched-div[.]txt,line=5::check for the corresponding close tag")
  })

})

if (requireNamespace("cli", quietly = TRUE)) {

  cli::test_that_cli("div CLI messages work", {
    Sys.setenv(CI = "")
    ex <- tinkr::yarn$new(file.path(test_path(), "examples", "mismatched-div.txt"), sourcepos = TRUE)
    expect_snapshot(expect_error(label_div_tags(ex)))
  })

}

test_that("a mix of div tags can be read", {


  ex <- tinkr::to_xml(file.path(test_path(), "examples", "div-mix.txt"), sourcepos = TRUE)

  divs <- xml2::xml_find_all(ex$body, ".//html_block[contains(text(), 'div')]")
  expect_length(divs, 5)
  divs <- xml2::xml_find_all(ex$body, ".//text[contains(text(), ':::')]")
  expect_length(divs, 6)
  # TODO: fix me. Parsing div tags and pandoc tags must be equal. 
  label_div_tags(ex$body)
  dvs <- get_divs(ex$body)
  expect_length(dvs, 12 / 2)
  expect_length(get_divs(ex$body, "challenge"), 1L)
  expect_named(get_divs(ex$body, "challenge"), "div-1-challenge")
  expect_length(get_divs(ex$body, "solution"), 2L)
  expect_named(get_divs(ex$body, "solution"), c("div-2-solution", "div-3-solution"))
  expect_length(get_divs(ex$body, "callout"), 1L)
  expect_named(get_divs(ex$body, "callout"), "div-4-callout")
  expect_length(get_divs(ex$body, "discussion"), 1L)
  expect_named(get_divs(ex$body, "discussion"), "div-5-discussion")
  expect_length(get_divs(ex$body, "good"), 1L)
  expect_named(get_divs(ex$body, "good"), "div-6-good")
  tinkr::to_md(ex, ff)
  exc <- paste(readLines(ff), collapse = "\n")
  expect_match(exc, "<div class='challenge'>\n\n## Challenge", fixed = TRUE)
  expect_match(exc, ":::\n\n<div class='solution'>", fixed = TRUE)

})


test_that("a bare block quote will be left alone when converting to divs", {

  tmp <- tempfile()
  withr::local_file(tmp)
  txt <- glue::glue("# h1

    > This is a block quote
    
    > This is a callout
    {: .callout}", .open = "^", .close = "$")

  writeLines(txt, tmp)

  e <- Episode$new(tmp)
  expect_length(e$get_blocks(), 2)
  expect_length(e$unblock()$get_blocks(), 1)
  expect_length(e$get_divs(), 1)

})











