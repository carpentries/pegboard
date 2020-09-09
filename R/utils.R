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

# Get a character vector of the namespace
NS <- function(x) attr(xml2::xml_ns(x), "names")[[1]]

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

xml_new_paragraph <- function(text = "", ns, tag = TRUE) {
  text <- if (tag) glue::glue("<text>{text}</text>") else text
  pgp <- glue::glue(
    "<document><paragraph>{text}</paragraph></document>"
  )
  pgp <- xml2::read_xml(pgp)
  xml2::xml_set_attr(pgp, "xmlns", ns)
  xml2::xml_child(pgp, 1)
}

xml_slip_in <- function(body, to_insert, where = length(xml2::xml_children(body))) {

  xml2::xml_add_child(body, to_insert, .where = where)

  the_nodes <- xml2::xml_find_all(body, ".//node()")
  # adding a child automatically adds "xmlns:xml = http://www.w3.org/XML/1998/namespace"
  # but this happens to mess up the code blocks, so this gets rid of them
  xml2::xml_set_attr(the_nodes, "xmlns:xml", NULL)

}

#' Create a new block node based on a list (derived from yaml)
#'
#' This assumes that your input is a flat list and is used to translate 
#' yaml-coded questions and keywords into blocks (for translation between 
#' jekyll carpentries lessons and the sandpaper lessons
#' 
#' @param yaml a list of character vectors
#' @param what the name of the item to transform
#' @param dovetail if `TRUE`, the output is presented as a dovetail block,
#'   otherwise, it is formatted as a div class chunk.
#' @return an xml document
#' @noRd
#' @keywords internal
#' @examples
#' l <- list(
#'   questions = c("what is this?", "who are you?"), 
#'   keywords  = c("klaatu", "verada", "necktie")
#' )
#' xml_list_chunk(l, "questions")
xml_list_chunk <- function(yaml, what, dovetail = TRUE) {
  if (dovetail) {
    item   <- "\n#' - "
    header <- glue::glue("```{<what>}<item>", .open = "<", .close = ">")
    tailer <- "\n```"
  } else {
    item   <- "\n - "
    header <- glue::glue("<div class='{what}' markdown='1'>\n{item}")
    tailer <- "\n\n</div>"
  }
  mdlist <- paste0(header, paste(yaml[[what]], collapse = item), tailer)
  xml2::read_xml(commonmark::markdown_xml(mdlist, smart = TRUE, extensions = TRUE))
}

#' Retrieve the setup chunk if it exists, create one and insert it at the head 
#' of the document if it does not
#' @param body an xml node
#' @return an xml node containing the setup chunk
#' @noRd
#' @keywords internal
get_setup_chunk <- function(body) {
  query <- "./d1:code_block[1][@language='r' and @include='FALSE']"
  setup <- xml2::xml_find_first(body, query)

  # No setup chunk from Jekyll site
  if (inherits(setup, "xml_missing")) {
    setup <- xml2::xml_child(body)
  }

  # Check if we've already generated one 
  if (!grepl("Generated with {pegboard}", xml2::xml_text(setup), fixed = TRUE)) {
    setup <- "<document><code_block language='r' name='setup' include='FALSE'></code_block></document>"
    setup <- xml2::xml_child(xml2::read_xml(setup))
    xml2::xml_set_text(setup, "# Generated via {pegboard}")
    xml_slip_in(body, setup, where = 0L)
    setup <- xml2::xml_child(body)
    xml2::xml_set_namespace(setup, prefix = NS(body), uri = xml2::xml_ns(body)[[1]])
  }
  setup
}

splinter <- function(x) {
  chars      <- strsplit(x, "")[[1]]
  char_class <- glue::glue_collapse(chars, sep = "][")
  glue::glue("[{char_class}]")
}


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
    "contains(text(),'questions}')",
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

# Shamelessly taken from base so that I can use tinkr internals.
`%:%` <- function (pkg, name) {
  pkg <- as.character(substitute(pkg))
  name <- as.character(substitute(name))
  get(name, envir = asNamespace(pkg), inherits = FALSE)
}
