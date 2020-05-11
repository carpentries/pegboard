#' Gather solutions from the XML body of a carpentries lesson
#'
#' This will search an XML document for a solution marker and extract all of
#' the block quotes that are ancestral to that marker so that we can extract the
#' solution blockquotes from the carpentries lessons.
#'
#' @param body the XML body of a carpentries lesson (an xml2 object)
#' @param parent the outer block containing the solution. Default is a challenge
#' block, but it could also be a discussion block.
#' @export
#'
#' @return an xml object.
#'
#' @examples
#' frg <- Lesson$new(lesson_fragment())
#' get_solutions(frg$episodes[["17-scope.md"]]$body)
get_solutions <- function(body, parent = NULL) {

  # Namespace for the document is listed in the attributes
  ns <- attr(xml2::xml_ns(body), "names")[[1]]

  # convenience namespace aliases
  bq <- glue::glue("{ns}:block_quote")

  parent_tag <- block_type(ns = ns, type = parent)

  # Two-part predicate:
  #   1. The block either starts with a Solution
  solution_head <- glue::glue("{ns}:text[starts-with(text(),'Solution')]")
  has_header    <- glue::glue("[{ns}:heading[{solution_head}] ")
  #   2. or it ends with a solution tag.
  solution_tag  <- block_type(ns = ns, type = ".solution", start = "| ")


  # The solution will be in a challenge blockquote and either start with
  # "Solution" or have the solution tag.
  solution <- glue::glue(".//{bq}{parent_tag}/{bq}{has_header}{solution_tag}")
  safe_xml <- purrr::possibly(xml2::xml_find_all, otherwise = solution)
  safe_xml(body, solution)
}
