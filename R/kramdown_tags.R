#' Find all kramdown tags within the document
#'
#' @param body an XML document
#'
#' @return an XML nodeset with all the kramdown tags
#' @keywords internal
kramdown_tags <- function(body) {
  # Namespace for the document is listed in the attributes
  ns <- NS(body)
  srch <- glue::glue(".//<ns>:paragraph[<ns>:text[starts-with(text(), '{:')]]",
    .open  = "<",
    .close = ">"
  )
  xml2::xml_find_all(body, srch)
}

#' Place kramdown tags in the correct part of the document
#'
#' Kramdown is a bit weird in that it uses tags that trail elements like code
#' blocks or block quotes. If these follow block quotes, commonmark will parse
#' them being part of that block quote. This is not problematic per-se until you
#' run into a common situation in the Carpentries' curriculum: nested block
#' quotes
#'
#' ```
#' > # Challenge 1
#' >
#' > Some text here
#' >
#' > > # Solution 1
#' > >
#' > > ~~~
#' > > print("hello world!")
#' > > ~~~
#' > > {: .language-pyton}
#' > {: .solution}
#' {: .challenge}
#' ```
#'
#' When this is parsed with commonmark, the three tags at the end are parsed as
#' being part of the 2nd-level block quote:
#'
#' ```
#' ...
#' > > ~~~
#' > > {: .language-pyton}
#' > > {: .solution}
#' > > {: .challenge}
#' ```
#'
#' This function will force these text nodes into their respective blocks
#'
#'
#' @note There is a better way of doing this by just adding the kramdown tags
#' as attributes of the blocks and adding a style sheet conditional that looks
#' for these attributes and appends them to the end of the blocks. The same
#' could be said for code blocks.
#'
#' @param para a paragraph text node containing the kramdown tags
#'
#' @return the modified paragraph text node
#' @keywords internal
fix_kramdown_tag <- function(para) {

  parents      <- xml2::xml_parents(para)
  parent_names <- xml2::xml_name(parents)

  ns <- NS(xml2::xml_root(parents))

  # only working in block quotes
  if (all(parent_names != "block_quote")) {
    return(invisible(parents))
  }

  parents <- parents[parent_names == "block_quote"]

  children <- xml2::xml_children(para)
  nc <- length(children)

  # Find out which children are tags

  are_tags <- which(
    xml2::xml_find_lgl(
      children,
      "boolean(starts-with(text(), '{:'))"
    )
  )

  # exclude the first tag if it's after a code block
  after_code <- after_thing(para, "code_block")
  are_tags <- if (after_code) are_tags[-1] else are_tags


  if (sum(are_tags) < length(parents)) {
    stop("not enough parents")
  }

  this_node <- para

  for (tag in seq_along(are_tags)) {

    # Grab the correct parent from the list
    the_parent <- parents[tag]

    # copy the current node (this_node) to be the sibling of the parent node
    next_node <- xml2::xml_add_sibling(the_parent, this_node, ns, .where = "after")[[1]]

    # remove the irrelevant children of the current node
    the_children <- xml2::xml_children(this_node)
    purrr::walk(seq(3, length(the_children)), ~xml2::xml_remove(the_children[[.x]]))

    # remove the old children of this node
    these_children <- xml2::xml_children(next_node)
    purrr::walk(1:2, ~xml2::xml_remove(these_children[[.x]]))

    # The next node is now this node
    this_node <- next_node
  }

  return(para)

}

kramdown_attribute <- function(tags) {

  parents      <- xml2::xml_parents(tags)
  parent_names <- xml2::xml_name(parents)

  ns <- NS(xml2::xml_root(parents))

  # only working in block quotes
  if (all(parent_names != "block_quote")) {
    return(invisible(parents))
  }

  parents <- parents[parent_names == "block_quote"]

  children <- xml2::xml_children(tags)
  nc <- length(children)

  # Find out which children are tags

  are_tags <- which(
    xml2::xml_find_lgl(
      children,
      "boolean(starts-with(text(), '{:'))"
    )
  )

  # exclude the first tag if it's after a code block
  after_code <- after_thing(tags, "code_block")
  are_tags <- if (after_code) are_tags[-1] else are_tags


  if (sum(are_tags) < length(parents)) {
    stop("not enough parents")
  }

  this_node <- tags


  for (tag in seq_along(are_tags)) {

    # Grab the correct parent from the list
    the_parent <- parents[tag]
    this_tag   <- xml2::xml_text(children[are_tags[tag]])
    xml2::xml_attr(the_parent, "ktag") <-this_tag

  }
  xml2::xml_remove(children[are_tags])

  return(tags)

}
