#' Create an xml document that contains two html_block elements 
#' that contain div tags. 
#'
#' @param what the class of block
#' @return an xml document with commonmark namespace
#' @keywords internal
#' @examples
#' cha <- pegboard:::make_div("challenge")
#' cha
#' cat(pegboard:::xml_to_md(cha))
make_div <- function(what) {
  div <- glue::glue('<div class="{what}">\n\n</div>')
  div <- commonmark::markdown_xml(div)
  xml2::read_xml(div)
}


#' Replace a blockquote with a div tag
#'
#' This modifies a document to replace a blockquote element with a div element
#'
#' @param block a blockquote element
#' @return the children of the element, invisibly
#' @keywords internal
#' @examples
#' frg <- Lesson$new(lesson_fragment())
#' lop <- frg$episodes$`14-looping-data-sets.md`
#' xml2::xml_find_all(lop$body, ".//d1:html_block")
#' lop$get_blocks(level = 1)
#' lop$get_blocks(level = 2)
#' purrr::walk(lop$get_blocks(level = 2), pegboard:::replace_with_div)
#' purrr::walk(lop$get_blocks(level = 1), pegboard:::replace_with_div)
#' lop$get_blocks()
#' xml2::xml_find_all(lop$body, ".//d1:html_block")
replace_with_div <- function(block) {
  # Grab the type of block and filter out markup
  type <- gsub("[{:}.]", "", xml2::xml_attr(block, "ktag"))
  # make a div tag
  div   <- make_div(type)
  open  <- xml2::xml_child(div, 1)
  close <- xml2::xml_child(div, 2)
  # adding a tag because that allows us to check if it's accurate. 
  # nine digits should give us enough entropy in any given lesson.
  tag <- as.integer(stats::runif(1) * 10 ^ 9)
  xml2::xml_set_attr(open, "dtag", tag)
  xml2::xml_set_attr(close, "dtag", tag)
  xml2::xml_add_sibling(block, open, .where = "before")
  xml2::xml_add_sibling(block, close, .where = "after")
  elevate_children(block)
}


#' Get paired div blocks 
#' 
#' @param body an xml document
#' @return a list of nodesets
#' @keywords internal
get_divs <- function(body) {
  
  nodes <- xml2::xml_children(body)
  tags  <- xml2::xml_attr(nodes, "dtag")
  open  <- !duplicated(tags) & !is.na(tags)
  seq_vec <- function(i) seq(i[1], i[2])
  purrr::map(tags[open], ~nodes[seq_vec(which(tags == .x))])

}
