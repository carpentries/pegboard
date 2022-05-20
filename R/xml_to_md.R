#' Convert xml to markdown 
#'
#' @param body an xml document
#' @param stylesheet the name of a stylesheet passed to `get_stylesheet`
#' @return a character vector of length 1
#' @keywords internal
#' @examples
#' cha <- pegboard:::make_div("challenge")
#' sol <- pegboard:::make_div("solution")
#' xml2::xml_add_child(cha, xml2::xml_child(sol, 1), .where =  1)
#' xml2::xml_add_child(cha, xml2::xml_child(sol, 2), .where = 2)
#' cat(pegboard:::xml_to_md(cha))
xml_to_md <- function(body, stylesheet = "xml2md_roxy.xsl") {
  stysh <- xml2::read_xml(get_stylesheet(stylesheet))
  is_fragment <- xml2::xml_name(body) != "document" ||
    xml2::xml_name(xml2::xml_parent(body)) != ""
  if (is_fragment) {
    d <- xml2::read_xml(commonmark::markdown_xml(""))
    purrr::walk(body, ~xml2::xml_add_child(d, .x))
    body <- d
  } else {
    xml2::xml_set_attr(body, "xmlns", "http://commonmark.org/xml/1.0")
  }
  xslt::xml_xslt(copy_xml(body), stysh)
}
