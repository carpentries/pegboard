# The following functions have been borrowed from {tinkr}
# Add siblings to a node
add_node_siblings <- function(node, nodes, where = "after", remove = TRUE) {
  # if there is a single node, then we need only add it
  if (inherits(nodes, "xml_node")) {
    xml2::xml_add_sibling(node, nodes, .where = where)
  } else {
    purrr::walk(rev(nodes), ~xml2::xml_add_sibling(node, .x, .where = where))
  }
  if (remove) xml2::xml_remove(node)
}

make_text_nodes <- function(txt) {
  # We are hijacking commonmark here to produce an XML markdown document with
  # a single element: {paste(txt, collapse = ''). This gets passed to glue where
  # it is expanded into nodes that we can read in via {xml2}, strip the 
  # namespace, and extract all nodes below
  doc <- glue::glue(commonmark::markdown_xml("{paste(txt, collapse = '')}")) 
  nodes <- xml2::xml_ns_strip(xml2::read_xml(doc))
  xml2::xml_find_all(nodes, ".//paragraph/text/*")
}

