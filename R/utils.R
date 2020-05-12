nodeprint <- function(x) {
  purrr::walk(x, ~cat(pretty_tag(.x), xml2::xml_text(.x), "\n"))
}

pretty_tag <- function(x, hl = NULL) {
  if (is.null(hl) && requireNamespace("crayon", quietly = TRUE)) {
    hl <- function(x) crayon::bgYellow(crayon::black(x))
  } else {
    hl <- function(x) x
  }
  nm <- glue::glue("<{xml2::xml_name(x)}>")
  glue::glue("\n{hl(nm)}:\n")
}

block_type <- function(ns, type = NULL, start = "[", end = "]") {

  p   <- glue::glue("{ns}:paragraph")
  txt <- glue::glue("{ns}:text")

  if (is.null(type)) {
    res <- ""
  } else {
    res <- glue::glue("<start>descendant::<p>/<txt>[text()='{: <type>}']<end>",
      .open  = "<",
      .close = ">"
    )
  }
  res
}


#' Find the level of the current node releative to the document
#'
#' @param node an XML node object
#'
#' @return a number indicating how nested the current node is. 0 represents the
#'   document itself, 1 represents all child elements of the document, etc.
#'
#' @keywords internal
find_node_level <- function(node) {
  parent_name <- ""
  level  <- 0
  while (parent_name != "document") {
    level <- level + 1
    node <- xml2::xml_parent(node)
    parent_name <- xml2::xml_name(node)
  }
  level
}
