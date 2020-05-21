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

# nocov start
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

#' @examples
#' frg <- Lesson$new(lesson_fragment())
#' blo <- frg$episodes$`14-looping-data-sets.md`$get_blocks()[[2]]
#' roxy_challenge(blo)
convert_to_roxygen <- function(block, remove = TRUE, token = "#| ") {
  # Thoughts on this:
  #
  # xslt::xml_xslt(thing, stylesheet) acts on a document and will parse the
  # markdown text FO FREE. The only catch is that it needs a document, but we
  # can simply just copy the document and remove all the elements but what we
  # want to act on.
  #
  # steps:
  #
  # 1. copy document
  # 2. remove all but the block we are focusing on
  ns  <- NS(block)
  cpy <- xml2::xml_new_root(xml2::xml_root(block))
  isolate_kram_blocks(cpy, glue::glue("[@sourcepos='{xml2::xml_attr(block, 'sourcepos')}']"))
  # 3. elevate the children in the document (removing block quotes)
  solutions <- elevate_children(
    xml2::xml_find_all(cpy, ".//*[@ktag='{: .solution}']")
  )
  if (sum(xml2::xml_length(solutions)) > 0) {
    xml2::xml_set_attr(solutions[[1]],                 "soln", "start")
    xml2::xml_set_attr(solutions[[length(solutions)]], "soln", "end")
  }
  # 4. parse the document with xslt
  stysh <- xml2::read_xml(get_stylesheet("xml2md_roxy.xsl"))
  elevate_children(xml2::xml_children(cpy))

  to_comment <- glue::glue(".//{ns}:*[parent::{ns}:document]")
  not_code   <- glue::glue("[not(ancestor-or-self::{ns}:code_block)]")
  nblks <- xml2::xml_find_all(cpy, glue::glue("{to_comment}{not_code}"))
  xml2::xml_set_attr(nblks, "comment", token)

  txt <- xslt::xml_xslt(cpy, stysh)
  txt <- gsub(glue::glue("{token}{token}"), token, txt, fixed = TRUE)
  splinter <- function(x) {
    paste0("[", glue::glue_collapse(strsplit(glue::glue("{x}"), "")[[1]], sep = "]["), "]")
  }
  txt <- gsub(glue::glue("```\\n{splinter(token)}"), token, txt)
  txt <- gsub("\\n\\n?```(?!(\\n(?>\\@)|$))", "\n#+\\1", txt, perl = TRUE)
  txt <- gsub("```(\\n?)", glue::glue("{token}"), txt)
  block_type <- gsub("[{: .}]", "", xml2::xml_attr(block, "ktag"))
  txt <- glue::glue("{token}@{block_type}\n{txt}")

  # 5. rename the challenge node to be a code_block
  xml2::xml_set_name(block, "code_block")
  xml2::xml_set_attr(block, "info", block_type)
  # 6. remove the children of that node
  xml2::xml_remove(xml2::xml_children(block))
  # 7. add the parsed text as the text of the challenge code block
  xml2::xml_set_text(block, txt)
  invisible(block)
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



isolate_kram_blocks <- function(body, predicate = "") {
  ns <- NS(body)
  kblock <- glue::glue("{ns}:block_quote[@ktag]{predicate}")
  txt <- xml2::xml_find_all(
    body,
    glue::glue(".//text()[not(ancestor-or-self::{kblock})]")
  )
  parents <- xml2::xml_parents(txt)
  parents <- parents[xml2::xml_name(parents) != "document"]
  xml2::xml_remove(parents)
  invisible(body)
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

