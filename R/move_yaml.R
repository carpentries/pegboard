move_yaml <- function(yaml, body, what = "questions") {
  to_insert <- make_div_child(yaml, what)
  if (what == "keypoints") {
    # insert at end
    xml2::xml_add_child(body, to_insert)
  } else {
    # insert at top
    xml2::xml_add_child(body, to_insert, .where = 1)
  }
  the_nodes <- xml2::xml_find_all(body, ".//node()")
  # adding a child automatically adds "xmlns:xml = http://www.w3.org/XML/1998/namespace"
  # but this happens to mess up the code blocks, so this gets rid of them
  xml2::xml_set_attr(the_nodes, "xmlns:xml", NULL)
}

block_node <- function(yaml, what) {

  header <- glue::glue("```{<what>}\n#' - ", .open = "<", .close = ">")
  mdlist <- paste0(header, paste(yaml[[what]], collapse = "\n#' - "), "\n```")
  x <- xml2::read_xml(commonmark::markdown_xml(mdlist, smart = TRUE))

}

make_div_child <- function(yaml, what) {
  ln <- block_node(yaml, what)
  xml2::xml_child(ln)
}

