#' Create a table for headings
#'
#' @param headings an `xml_nodeset` object with text and "level" attributes
#' @param offest the offset for the yaml header (artifact of {tinkr}), defaults
#'   to 5L, which is for the two fences plus title, teaching, and exercises.
#' @return a data frame with three columns:
#'
#'   - heading the text of the heading
#'   - level the heading level
#'   - pos the position of the heading in the document
#' @keywords internal
#' @examples
#' path <- file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
#' loop <- Episode$new(path)
#' pegboard:::make_heading_table(loop$headings, offset = length(loop$yaml))
make_heading_table <- function(headings, offset = 5L) {
  data.frame(
    heading = xml2::xml_text(headings),
    level   = as.integer(xml2::xml_attr(headings, "level")),
    pos     = purrr::map_int(headings, get_linestart) + offset,
    stringsAsFactors = FALSE
  )
}

