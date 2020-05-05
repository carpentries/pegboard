#' Gather challenges from the XML body of a carpentries lesson
#'
#' This will search an XML document for a challenge marker and extract all of
#' the block quotes that are ancestral to that marker so that we can extract the
#' challenge blockquotes from the carpentries lessons.
#'
#' @param body the XML body of a carpentries lesson (an xml2 object)
#' @param list \[boolean\] if `TRUE`, the result will be converted to
#'   a list via [xml2::as_list()]. A `FALSE` (default) value will keep it as an xml object.
#'
#' @return a list or xml object.
get_challenges <- function(body, as_list = FALSE) {
  # Setting up the XPATH search string
  challenge <- "d1:text[text()='{: .challenge}']"       # Find the end of the challenge block
  axis      <- "ancestor-or-self"                       # Then look behind at all of the ancestors
  ancestor  <- "d1:block_quote"                         # That are blockquotes
  predicate <- "d1:heading/d1:text[not(contains(text(),'Solution'))]" # But exclude the Solution blocks (because they are included anyways)

  challenge_string <- glue::glue(".//{challenge}/{axis}::{ancestor}[{predicate}]")
  examples <- xml2::xml_find_all(body, challenge_string)
  if (as_list) {
    examples <- xml2::as_list(examples)
  }
  examples
}
