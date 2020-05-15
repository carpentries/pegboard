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
  level  <- 0L
  while (parent_name != "document") {
    level <- level + 1L
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
    ~xml2::xml_add_sibling(parent, .x, .where = "before", .copy = FALSE)
  )
  if (remove) {
    xml2::xml_remove(parent)
  }
  invisible(children)
}

# Get a character vector of the namespace
NS <- function(x) attr(xml2::xml_ns(x), "names")[[1]]


#' Check if a node is after another node
#'
#' @param body an XML node
#' @param thing the name of the XML node for the node to be after,
#'   defaults to "code_block"
#'
#' @return a single boolean value indicating if the node has a
#'   single sibling that is a code block
#' @keywords internal
#'
after_thing <- function(body, thing = "code_block") {
  ns <- NS(body)
  xml2::xml_find_lgl(
    body,
    glue::glue("boolean(.//preceding-sibling::{ns}:{thing})")
  )
}

#' test if the children of a given nodeset are kramdown blocks
#'
#' @param krams a nodeset
#'
#' @return a boolean vector equal to the length of the nodeset
#' @keywords internal
are_blocks <- function(krams) {
  tags <- c(
    "contains(text(),'callout}')",
    "contains(text(),'objectives}')",
    "contains(text(),'challenge}')",
    "contains(text(),'prereq}')",
    "contains(text(),'checklist}')",
    "contains(text(),'solution}')",
    "contains(text(),'discussion}')",
    "contains(text(),'testimonial}')",
    "contains(text(),'keypoints}')",
    NULL
  )
  tags <- glue::glue_collapse(tags, sep = " or ")

  purrr::map_lgl(
    krams,
    ~any(xml2::xml_find_lgl(xml2::xml_children(.x), glue::glue("boolean({tags})")))
  )
}
