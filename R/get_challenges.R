#' Gather challenges from the XML body of a carpentries lesson
#'
#' This will search an XML document for a challenge marker and extract all of
#' the block quotes that are ancestral to that marker so that we can extract the
#' challenge blockquotes from the carpentries lessons.
#'
#' @param body the XML body of a carpentries lesson (an xml2 object)
#' @param type the type of element containing the challenges "block" is the
#'   default and will search for all of the blockquotes with liquid/kramdown
#'   markup, "div" will search for all div tags with class of challenge, and
#'   "chunk" will search for all of code chunks with the engine of challenge.
#' @export
#'
#' @return an xml object.
#'
#' @examples
#' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
#' get_challenges(loop$body, "block")
#' get_challenges(loop$unblock()$body, "div")
#' loop$reset()
#' get_challenges(loop$use_dovetail()$unblock()$body, "chunk")
get_challenges <- function(body, type = c("block", "div", "chunk")) {
  type <- tolower(type)
  type <- match.arg(type, c("block", "div", "chunk"))
  switch(type,
    block = get_blocks(body, type = ".challenge", level = 1L),
    div   = get_divs(body, "challenge"),
    chunk = xml2::xml_find_all(body, "*[@language='challenge']")
  )
}
