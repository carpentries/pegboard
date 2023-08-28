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

`%||%` <- function(a, b) if (is.null(a)) b else a

#' @param node a node determined to be a text representation of a link
#'   destination
#' @return 
#'  - `get_link_fragments()`: the preceding three or four nodes, which will be
#'  the text of the link or the alt text of the image.
#' @rdname fix_links
find_between_nodes <- function(a, b, include = TRUE) {
  the_parent <- xml2::xml_parent(a)
  if (!identical(the_parent, xml2::xml_parent(b))) {
    # we cannot return a space between nodes on different levels
    return(xml2::xml_missing())
  }
  the_children <- xml2::xml_children(the_parent)
  # find the node in question by testing for identity since they represent the
  # same object, they will be identical. 
  ida <- which(purrr::map_lgl(the_children, identical, a))
  idb <- which(purrr::map_lgl(the_children, identical, b))
  # test for image with endsWith because they may have an inline image.
  the_children[seq(ida, idb)]
}


has_cli <- function() {
  is.null(getOption("pegboard.no-cli")) && requireNamespace("cli", quietly = TRUE)
}

stack_rows <- function(res) {
  if (requireNamespace("dplyr", quietly = TRUE)) {
    res <- dplyr::bind_rows(res, .id = "episodes")
  } else {
    res <- do.call(rbind, res)
  }
}

find_code_type <- function(code, type) {
  unprocessed_type <- grepl(type, xml2::xml_attr(code, "info"))
  processed_type <- grepl(type, xml2::xml_attr(code, "language"))
  code[unprocessed_type | processed_type]
}

stop_if_no_path <- function(path) {
  if (!fs::dir_exists(path)) {
    msg <- "the directory '{path}' does not exist or is not a directory"
    stop(glue::glue(msg), call. = FALSE)
  }
}

sort_files_by_cfg <- function(the_files, cfg, the_dir = "episodes") {
  the_names <- fs::path_file(the_files)
  names(the_files) <- the_names
  cfg_order <- cfg[[the_dir]]
  if (!is.null(cfg_order)) {
    # sort the files by the order in the config file. 
    # This will discard any draft episodes, but also avoid errors with 
    # Episodes in the CFG that do not exist.
    the_order <- intersect(cfg_order, the_names)
    the_files <- the_files[the_order]
  }
  return(the_files)
}

#' Process Markdown files in a directory into Episode objects
#'
#' @param src \[character\] the path to a folder containing markdown episodes
#' @param cfg \[list\] a parsed config file that can be used to specify the
#'   order of the files with a key that matches the folder name.
#' @param sandpaper \[logical\] if `TRUE`, the episodes are expected to be
#'   processed with {sandpaper} and will have the `$confirm_sandpaper()` method
#'   triggered. 
#' @param ... methods passed to the [Episode] initializer
#' @return a list of [Episode] objects
#' @keywords internal
read_markdown_files <- function(src, cfg = list(), sandpaper = TRUE, ...) {

  # Grabbing ONLY the markdown files (there are other sources of detritus)
  src_exists <- fs::dir_exists(src)
  if (src_exists) {
    the_files <- fs::dir_ls(src, glob = "*md")
  } else {
    the_files <- character(0)
  }
  # we still need to determine if this is an overview lesson. If it is, then
  # it is okay that a particular directory does not exist
  config_exists <- length(cfg) > 0
  if (config_exists) {
    the_dir <- fs::path_file(src)
    # determine if it is an overview page (and thus there are no episodes)
    not_overview <- !identical(cfg[["overview"]], TRUE)
    # sort by the order in the config file
    the_files <- sort_files_by_cfg(the_files, cfg, the_dir)
  } else {
    # If we enter here, there is no config; it's not an overview lesson
    not_overview <- TRUE
  }

  no_markdown <- length(the_files) == 0L
  no_files_but_that_is_okay <- !not_overview && no_markdown

  if (no_files_but_that_is_okay) {
    return(NULL)
  }

  if (not_overview && no_markdown) {
    msg <- glue::glue("The {src} directory must have (R)markdown files")
    stop(msg, call. = FALSE)
  }

  objects <- purrr::map(the_files, Episode$new, ...)

  if (sandpaper) {
    purrr::walk(objects, ~.x$confirm_sandpaper())
  }

  # Names of the objects will be the filename, not the basename
  names(objects) <- fs::path_file(the_files)
  return(objects)
}

#' Remove spaces in relative links with liquid variables
#'
#' Liquid has a syntax that wraps variables in double moustache braces that may
#' or may not have spaces within the moustaches. For example, to get the link
#' of the page root, you would use {{ page.root }} to make it more readable.
#' However, this violates the expectation of the commonmark parser and makes it
#' think “oh, this is just ordinary text”. 
#' 
#' This function fixes the issue by removing the spaces within the braces. 
#'
#' @param path path to an MD file
#' @param encoding encoding of the text, defaults to UTF-8
fix_liquid_relative_link <- function(path, encoding = "UTF-8") {
  f <- readLines(path, encoding = encoding)
  # Find all similar to:
  #
  # [match1]: {{ match2 }}match3
  reliquid_link <- "(^\\[.+?\\]: )\\{\\{ (.+?) \\}\\}(.*)$"
  # replace everything and place in a textConnection
  textConnection(gsub(reliquid_link, "\\1{{\\2}}\\3", f, perl = TRUE))
}

# Get a character vector of the namespace
NS <- function(x, generic = TRUE) {
  if (generic) {
    res <- attr(xml2::xml_ns(x), "names")[[1]]
  } else {
    res <- attr(get_ns(x), "names")[[1]]
  }
  paste0(res, ":")
}

get_ns <- function(body) {
  structure(
    c(tinkr::md_ns(), pb = "http://carpentries.org/pegboard/"),
    class = "xml_namespace"
  )
}


capitalize <- function(x) `substring<-`(x, 1, 1, toupper(substring(x, 1, 1)))

# generate xpath syntax for a block type
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

# stolen from {tinkr}
make_text_nodes <- function(txt) {
  # We are hijacking commonmark here to produce an XML markdown document with
  # a single element: {paste(txt, collapse = ''). This gets passed to glue where
  # it is expanded into nodes that we can read in via {xml2}, strip the
  # namespace, and extract all nodes below
  doc <- glue::glue(commonmark::markdown_xml("{paste(txt, collapse = '')}"))
  nodes <- xml2::xml_ns_strip(xml2::read_xml(doc))
  xml2::xml_find_all(nodes, ".//paragraph/text/*")
}


#' Retrieve the setup chunk if it exists, create one and insert it at the head 
#' of the document if it does not
#' @param body an xml node
#' @return an xml node containing the setup chunk
#' @noRd
#' @keywords internal
get_setup_chunk <- function(body) {
  ns <- get_ns(body)
  query <- "./md:code_block[1][@language='r' and (@name='setup' or @include='FALSE')]"
  setup <- xml2::xml_find_first(body, query, ns)

  # No setup chunk from Jekyll site
  if (inherits(setup, "xml_missing")) {
    setup <- xml2::xml_child(body)
  } else {
    return(setup)
  }
  comment <- "# Generated with {pegboard}"

  # Check if we've already generated one 
  if (!grepl(comment, xml2::xml_text(setup), fixed = TRUE)) {
    # Add the code block as a child
    xml2::xml_add_child(body,
      "code_block",
      paste0(comment, "\n"),
      language = "r",
      name     = "setup",
      include  = "FALSE",
      xmlns    = xml2::xml_ns(body)[[1]],
      .where   = 0L
    )
    # Grab it and go
    setup <- xml2::xml_child(body)
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
    glue::glue(".//preceding-sibling::{ns}{thing}[1]")
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
    "contains(text(),'.callout')",
    "contains(text(),'.objectives')",
    "contains(text(),'.challenge')",
    "contains(text(),'.prereq')",
    "contains(text(),'.checklist')",
    "contains(text(),'.solution')",
    "contains(text(),'.discussion')",
    "contains(text(),'.testimonial')",
    "contains(text(),'.keypoints')",
    "contains(text(),'.questions')",
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
    glue::glue("preceding-sibling::{ns}block_quote[1]")
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
    glue::glue("boolean(following-sibling::{ns}paragraph/{ns}text[{predicate}])")
  )
}

# Shamelessly taken from base so that I can use tinkr internals.
`%:%` <- function (pkg, name) {
  pkg <- as.character(substitute(pkg))
  name <- as.character(substitute(name))
  get(name, envir = asNamespace(pkg), inherits = FALSE)
}

