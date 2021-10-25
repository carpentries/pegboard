#' Add alt text to images when transforming from jekyll to sandpaper
#'
#' @param images a xml_nodeset of image nodes
#' @return the images, invisibly with a new alt attribute and text removed
make_pandoc_alt <- function(images) {
  alt <- xml2::xml_text(images)
  has_attrs <- xml2::xml_find_lgl(images, 
    "boolean(self::*[following-sibling::*[1][starts-with(text(), '{')]])")
  to_append <- alt[has_attrs]
  to_create <- alt[!has_attrs]
  if (length(to_append)) {
    nodes <- xml2::xml_find_first(images[has_attrs],
      "self::*/following-sibling::*[1]")
    txt <- xml2::xml_text(nodes)
    subbed <- purrr::map2_chr(to_append, txt, 
      ~sub("[{][:]? ?", glue::glue("{alt=^shQuote(.x)$ ",
        .open = "^", .close = "$"), .y))
    xml2::xml_set_text(nodes, subbed)
  }
  if (length(to_create)) {
    itc <- images[!has_attrs]
    new_alt <- glue::glue("<text>{alt=^shQuote(to_create)$}</text>",
      .open = "^", .close = "$")
    new_nodes <- make_text_nodes(new_alt)
    purrr::walk2(itc, new_nodes, add_node_siblings, 
      where = "after", remove = FALSE)
    xml2::xml_set_attr(itc, "alt", to_create)
    # any text nodes should be removed
    xml2::xml_remove(xml2::xml_children(itc))
  }
  invisible(images)
}
