xml_to_md <- function(body, stylesheet = "xml2md_roxy.xsl") {
  stysh <- xml2::read_xml(get_stylesheet(stylesheet))
  xslt::xml_xslt(body, stysh)
}
