get_stylesheet <- function() {
  tink <- system.file("extdata", "xml2md_gfm.xsl", package = "tinkr")
  ours <- system.file("stylesheets", "xml2md_gfm_kramdown.xsl", package = "up2code")
  styl <- xml2::read_xml(ours)
  href <- xml2::xml_child(styl, search = 1)
  xml2::xml_set_attr(href, "href", tink)
  f <- fs::file_temp()
  xml2::write_xml(styl, f)
  f
}
