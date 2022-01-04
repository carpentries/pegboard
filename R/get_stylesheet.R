get_stylesheet <- function(sheet = "xml2md_gfm_kramdown.xsl") {
  tink <- system.file("extdata", "xml2md_gfm.xsl", package = "tinkr")
  tink <- xml2::url_escape(tink)
  ours <- system.file("stylesheets", sheet, package = "pegboard")
  styl <- readLines(ours)
  styl <- sub(
    'import href="FIXME"',
    glue::glue('import href="{tink}"'),
    styl,
    fixed = TRUE
  )
  f <- fs::file_temp()
  writeLines(styl, f)
  f
}
