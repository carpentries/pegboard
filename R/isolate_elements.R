#' Isolate elements in an XML document by source position
#'
#' @param body an XML document
#' @param ... objects of class `xml_node` or `xml_nodeset` to be retained
#' @return This works by side-effect, but it returns the body, invisibly.
isolate_elements <- function(body, ...) {
  guts <- xml2::xml_children(body)
  all_pos <- xml2::xml_attr(guts, "sourcepos")
  element_list <- purrr::flatten(c(...))
  pos <- purrr::map_chr(element_list, xml2::xml_attr, "sourcepos")
  purrr::walk(guts[!all_pos %in% pos], xml2::xml_remove)
  invisible(body)
}

#' Trim div fences from output
#'
#' @param nodes an xml_nodeset whose first and last node are div fences
#' @return the nodeset without div fences
trim_fence <- function(nodes) {
  n <- length(nodes)
  if (n < 3) nodes else nodes[2:(n - 1)]
}
