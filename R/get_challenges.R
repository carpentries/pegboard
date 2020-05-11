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
}
