#' Gather solutions from the XML body of a carpentries lesson
#'
#' This will search an XML document for a solution marker and extract all of
#' the block quotes that are ancestral to that marker so that we can extract the
#' solution blockquotes from the carpentries lessons.
#'
#' @param body the XML body of a carpentries lesson (an xml2 object)
#' @param type the type of element containing the solutions "block" is the
#'   default and will search for all of the blockquotes with liquid/kramdown
#'   markup, "div" will search for all div tags with class of solution, and
#'   "chunk" will search for all of code chunks with the engine of solution.
#' @param parent the outer block containing the solution. Default is a challenge
#'   block, but it could also be a discussion block.
#' @export
#' @note 
#'  - the `parent` parameter is only valid for the "block" (default) type
#'  - the "chunk" type has the limitation that solutions are embedded within
#'    their respective blocks, so counting the number of solution elements via
#'    this method may an undercount
#'
#' @return 
#'  - type = "block" (default) an xml nodelist of blockquotes
#'  - type = "div" a list of xml nodelists
#'  - type = "chunk" an xml nodelist of code blocks
#'
#' @examples
#' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
#' get_solutions(loop$body, "block")
#' get_solutions(loop$unblock()$body, "div")
#' loop$reset()
#' get_solutions(loop$use_dovetail()$unblock()$body, "chunk")
get_solutions <- function(body, type = c("block", "div", "chunk"), parent = NULL) {

  type <- tolower(type[[1]])
  type <- match.arg(type, c("block", "div", "chunk"))
  if (type != "block") {
    out <- switch(type,
      div = get_divs(body, "solution"),
      chunk = xml2::xml_find_all(
        body, 
        ".//*[@language='solution' or contains(text(), '@solution')]"
      )
    )
    return(out)
  }
  # Namespace for the document is listed in the attributes
  ns <- attr(xml2::xml_ns(body), "names")[[1]]

  # convenience namespace aliases
  bq <- glue::glue("{ns}:block_quote")

  parent_tag <- block_type(ns = ns, type = parent)
  solution_tag <- block_type(ns = ns, type = ".solution")

  # Finding blocks that are missing tags
  #   1. The block starts with a Solution
  solution_head <- glue::glue("{ns}:text[starts-with(text(),'Solu')]")
  has_header    <- glue::glue("[{ns}:heading[{solution_head}] ")
  #   2. and does not have a solution tag
  no_solution_tag  <- "and not(@ktag)]"
  # Find and tag
  notags <- glue::glue(".//{bq}{parent_tag}/{bq}{has_header}{no_solution_tag}")
  all_head_no_tail <- xml2::xml_find_all(body, notags)
  xml2::xml_attr(all_head_no_tail, "ktag") <- "{: .solution}"

  # The solution will be in a challenge blockquote and either start with
  # "Solution" or have the solution tag.
  solution <- glue::glue(".//{bq}{parent_tag}/{bq}{solution_tag}")
  safe_xml <- purrr::possibly(xml2::xml_find_all, otherwise = solution)
  safe_xml(body, solution)
}
