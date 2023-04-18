#' Convert xml to markdown 
#'
#' @param body an xml document
#' @param stylesheet the name of a stylesheet passed to `get_stylesheet`
#' @param newlines a logical indicating that newlines (aka softbreaks) should
#'   be inserted between elements (defaults to `FALSE`, meaning that no
#'   separator will be added between elements).
#' @return a character vector of length 1
#' @keywords internal
#' @examples
#' cha <- pegboard:::make_div("challenge")
#' sol <- pegboard:::make_div("solution")
#' xml2::xml_add_child(cha, xml2::xml_child(sol, 1), .where =  1)
#' xml2::xml_add_child(cha, xml2::xml_child(sol, 2), .where = 2)
#' cat(pegboard:::xml_to_md(cha))
xml_to_md <- function(body, stylesheet = "xml2md_gfm_kramdown.xsl", newlines = FALSE) {
  stysh <- xml2::read_xml(get_stylesheet(stylesheet))
  is_fragment <- !inherits(body, "xml_document")
  if (is_fragment) {
    d <- xml2::read_xml(commonmark::markdown_xml(""))
    purrr::walk(body, function(x, new){
      xml2::xml_add_child(d, x)
      if (new) {
        xml2::xml_add_child(d, "softbreak")
      }
    }, new = newlines)
    body <- d
  } 
  body <- xml2::read_xml(as.character(body))
  xslt::xml_xslt(body, stysh)
}
