#' Add alt text to images when transforming from jekyll to sandpaper
#'
#' @param images a xml_nodeset of image nodes
#' @return the images, invisibly with a new alt attribute and text removed
make_pandoc_alt <- function(images) {
  alt <- xml2::xml_text(images)
  new_alt <- glue::glue("<text>{alt=^shQuote(alt)$}</text>",
    .open = "^", .close = "$")
  new_nodes <- make_text_nodes(new_alt)
  purrr::walk2(images, new_nodes, add_node_siblings, where = "after", remove = FALSE)
  xml2::xml_set_attr(images, "alt", alt)
  # any text nodes should be removed
  xml2::xml_remove(xml2::xml_children(images))
  invisible(images)
}
