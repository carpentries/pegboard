#' Gather challenges from the XML body of a carpentries lesson
#'
#' This will search an XML document for a challenge marker and extract all of
#' the block quotes that are ancestral to that marker so that we can extract the
#' challenge blockquotes from the carpentries lessons.
#'
#' @param body the XML body of a carpentries lesson (an xml2 object)
#' @export
#'
#' @return an xml object.
#'
#' @examples
#' frg <- Lesson$new(lesson_fragment())
#' get_challenges(frg$episodes[["17-scope.md"]]$body)
get_challenges <- function(body) {

  get_blocks(body, type = ".challenge", level = 1L)
  # # Namespace for the document is listed in the attributes
  # ns <- attr(xml2::xml_ns(body), "names")[[1]]
  #
  #
  # # Find the end of the challenge block ----------------------------------------
  # challenge <- glue::glue("<ns>:text[text()='{: .challenge}']",
  #   .open = "<",
  #   .close = ">"
  # )
  #
  # # Then look behind at all of the ancestors -----------------------------------
  # axis <- "ancestor-or-self"
  #
  # # That are blockquotes -------------------------------------------------------
  # ancestor <- glue::glue("{ns}:block_quote")
  #
  # # But exclude the Solution blocks (because they are included anyways) --------
  # predicate <- glue::glue(
  #   "{ns}:heading/{ns}:text[not(starts-with(text(),'Solution'))]"
  # )
  #
  #
  # # Combine and search ---------------------------------------------------------
  # challenge_string <- glue::glue(
  #   ".//{challenge}/{axis}::{ancestor}[{predicate}]"
  # )
  #
  # xml2::xml_find_all(body, challenge_string)
}
