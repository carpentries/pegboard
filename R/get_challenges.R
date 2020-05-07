#' Gather challenges from the XML body of a carpentries lesson
#'
#' This will search an XML document for a challenge marker and extract all of
#' the block quotes that are ancestral to that marker so that we can extract the
#' challenge blockquotes from the carpentries lessons.
#'
#' @param body the XML body of a carpentries lesson (an xml2 object)
#' @param as_list \[boolean\] if `TRUE`, the result will be converted to
#'   a list via [xml2::as_list()]. A `FALSE` (default) value will keep it as an
#'   xml object.
#' @export
#'
#' @return a list or xml object.
#'
#' @examples
#' frg <- get_lesson(path = lesson_fragment())
#' get_challenges(frg[[2]]$body)
get_challenges <- function(body, as_list = FALSE) {

  # Namespace for the document is listed in the attributes
  ns <- attr(xml2::xml_ns(body), "names")[[1]]

  # Find the end of the challenge block ----------------------------------------
  challenge <- glue::glue("<ns>:text[text()='{: .challenge}']",
    .open = "<",
    .close = ">"
  )

  # Then look behind at all of the ancestors -----------------------------------
  axis <- "ancestor-or-self"

  # That are blockquotes -------------------------------------------------------
  ancestor <- glue::glue("{ns}:block_quote")

  # But exclude the Solution blocks (because they are included anyways) --------
  predicate <- glue::glue(
    "{ns}:heading/{ns}:text[not(contains(text(),'Solution'))]"
  )


  # Combine and search ---------------------------------------------------------
  challenge_string <- glue::glue(
    ".//{challenge}/{axis}::{ancestor}[{predicate}]"
  )

  examples <- xml2::xml_find_all(body, challenge_string)

  if (as_list) {
    examples <- xml2::as_list(examples)
  }

  examples
}
