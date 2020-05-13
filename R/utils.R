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

#' elevate all children of a node
#'
#' @param parent an xml node (notably a block quote)
#' @param remove a logical value. If `TRUE` (default), the parent node is
#'   removed from the document.
#'
#' @return the elevated nodes, invisibly
#' @export
#'
#' @examples
#' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
#' # get all the challenges (2 blocks)
#' scope$get_blocks(".challenge")
#' b1 <- scope$get_blocks(".challenge")[[1]]
#' elevate_children(b1)
#' # now there is only one block:
#' scope$get_blocks(".challenge")
elevate_children <- function(parent, remove = TRUE) {
  children <- xml2::xml_contents(parent)
  purrr::walk(
    children,
    ~xml2::xml_add_sibling(parent, .x, .where = "before")
  )
  if (remove) {
    xml2::xml_remove(parent)
  }
  invisible(children)
}
