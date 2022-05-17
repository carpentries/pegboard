#' Add alt text to images when transforming from jekyll to sandpaper
#'
#' @param images a xml_nodeset of image nodes
#' @return the images, invisibly with a new alt attribute and text removed
make_pandoc_alt <- function(images) {
  alt <- xml2::xml_text(images)
  # There is reason to have alt="" in HTML to indicate a decorative image. 
  # In the case for our lessons, this was never specified and also it's
  # difficult to properly express alt="" in markdown syntax.
  #
  # Thus:
  # ![text](img) // has alt text
  # ![](img) // NO alt text
  # ![ ](img) // decorative
  has_alt <- alt != ""
  no_url <- !grepl("https?[:][/][/]", alt)
  has_attrs <- xml2::xml_find_lgl(images, 
    "boolean(self::*[following-sibling::*[1][starts-with(text(), '{')]])")

  # Add alt text to images that already has attributes
  append_these <- has_attrs & has_alt & no_url
  to_append <- alt[append_these]
  if (length(to_append)) {
    imgs  <- images[append_these]
    nodes <- xml2::xml_find_first(imgs, "self::*/following-sibling::*[1]")
    txt <- xml2::xml_text(nodes)
    subbed <- purrr::map2_chr(to_append, txt, 
      ~sub("[{][:]? ?", glue::glue("{alt=^shQuote(trimws(.x))$ ",
        .open = "^", .close = "$"), .y))
    # set the postfix tag 
    xml2::xml_set_text(nodes, subbed)
    # set the attribute
    xml2::xml_set_attr(imgs, "alt", to_append)
    # remove previous caption text
    xml2::xml_remove(xml2::xml_children(imgs))
  }

  # Create a new alt text attribute
  create_these <- !has_attrs & has_alt & no_url
  to_create <- trimws(alt[create_these])
  if (length(to_create)) {
    itc <- images[create_these]
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
