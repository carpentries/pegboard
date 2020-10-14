move_yaml <- function(yaml, body, what = "questions", dovetail = TRUE) {
  NS <- xml2::xml_ns(body)[[1]]
  where <- if (what == "keypoints") length(xml2::xml_children(body)) else 1L
  if (dovetail) {
    to_insert <- prepare_yaml_packet(yaml, what, dovetail)
    xml2::xml_add_child(body,
      "code_block",
      to_insert,
      language = what,
      xmlns = NS,
      .where = where
    )
  } else {
    to_insert <- prepare_yaml_packet(yaml, what, dovetail)
    for (element in rev(to_insert)) {
      xml2::xml_add_child(body,
        element,
        xmlns = NS,
        .where = where
      )
    }
  }
  label_div_tags(body)
}

#' Create a new block node based on a list (derived from yaml)
#'
#' This assumes that your input is a flat list and is used to translate 
#' yaml-coded questions and keywords into blocks (for translation between 
#' jekyll carpentries lessons and the sandpaper lessons
#' 
#' @param yaml a list of character vectors
#' @param what the name of the item to transform
#' @param dovetail if `TRUE`, the output is presented as a dovetail block,
#'   otherwise, it is formatted as a div class chunk.
#' @return an xml document
#' @noRd
#' @keywords internal
#' @examples
#' l <- list(
#'   questions = c("what is this?", "who are you?"), 
#'   keywords  = c("klaatu", "verada", "necktie")
#' )
#' prepare_yaml_packet(l, "questions")
#' prepare_yaml_packet(l, "questions", dovetail = FALSE)
prepare_yaml_packet <- function(yaml, what = "questions", dovetail = TRUE) {
  yaml <- yaml[[what]]
  if (is.null(yaml)) {
    return(NULL)
  }
  if (dovetail) {
    to_insert <- paste(yaml, collapse = "\n#' - ")
    to_insert <- paste0("#' - ", to_insert, "\n")
  } else {
    to_insert <- paste(yaml, collapse = "\n - ")
    to_insert <- paste0(
      ":::::::::: ", what, "\n\n",
      "## ", capitalize(what), "\n\n",
      " - ", to_insert, "\n\n",
      "::::::::::::::::::::"
    )
    to_insert <- commonmark::markdown_xml(to_insert)
    to_insert <- xml2::read_xml(to_insert)
    to_insert <- xml2::xml_children(to_insert)
  }
  to_insert
}
