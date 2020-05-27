# nocov start
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

element_df <- function(node) {
  children <- xml2::xml_children(node)
  start <- get_linestart(children[[1]]) - 1L
  data.frame(
    node  = xml2::xml_name(children),
    start = get_linestart(children) - start,
    end   = get_lineend(children) - start
  )
}
# nocov end

block_type <- function(ns, type = NULL, start = "[", end = "]") {

  if (is.null(type)) {
    res <- ""
  } else {
    res <- glue::glue("<start>@ktag='{: <type>}'<end>",
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



splinter <- function(x) {
  chars      <- strsplit(x, "")[[1]]
  char_class <- glue::glue_collapse(chars, sep = "][")
  glue::glue("[{char_class}]")
}


# Get a character vector of the namespace
NS <- function(x) attr(xml2::xml_ns(x), "names")[[1]]

# Get the position of an element
get_pos <- function(x, e = 1) {
  as.integer(
    gsub(
      "^(\\d+?):(\\d+?)[-](\\d+?):(\\d)+?$",
      glue::glue("\\{e}"),
      xml2::xml_attr(x, "sourcepos")
    )
  )
}

# helpers for get_pos
get_linestart <- function(x) get_pos(x, e = 1)
get_colstart  <- function(x) get_pos(x, e = 2)
get_lineend   <- function(x) get_pos(x, e = 3)
get_colend    <- function(x) get_pos(x, e = 4)

# check if two elements are adjacent
are_adjacent <- function(first = xml2::xml_missing(), second = first) {
  !inherits(first,  "xml_missing") &&
  !inherits(second, "xml_missing") &&
  get_lineend(first) + 1 == get_linestart(second)
}

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
  tng <- xml2::xml_find_first(
    body,
    glue::glue(".//preceding-sibling::{ns}:{thing}[1]")
  )

  # Returns TRUE if the last line of the thing is adjacent to the first line of
  # the tags
  are_adjacent(tng, body)
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


get_sibling_block <- function(tags) {

  # There are situations where the tags are parsed outside of the block quotes
  # In this case, we look behind our tag and test if it appears right after
  # the block. Note that this result has to be a nodeset
  ns <- NS(tags)
  block <- xml2::xml_find_all(
    tags,
    glue::glue("preceding-sibling::{ns}:block_quote[1]")
  )

  if (are_adjacent(block[[1]], tags)) {
    return(block)
  } else {
    return(xml2::xml_missing())
  }
}

challenge_is_sibling <- function(node) {
  ns <- NS(node)
  predicate <- "text()='{: .challenge}'"
  xml2::xml_find_lgl(
    node,
    glue::glue("boolean(following-sibling::{ns}:paragraph/{ns}:text[{predicate}])")
  )
}

