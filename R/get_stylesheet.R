get_stylesheet <- function(sheet = "xml2md_gfm_kramdown.xsl") {
  tink <- system.file("extdata", "xml2md_gfm.xsl", package = "tinkr")
  ours <- system.file("stylesheets", sheet, package = "up2code")
  styl <- xml2::read_xml(ours)
  href <- xml2::xml_find_first(styl, ".//xsl:import")
  xml2::xml_set_attr(href, "href", tink)
  f <- fs::file_temp()
  xml2::write_xml(styl, f)
  f
}
