get_stylesheet <- function(sheet = "xml2md_gfm_kramdown.xsl") {
  tink <- system.file("extdata", "xml2md_gfm.xsl", package = "tinkr")
  ours <- system.file("stylesheets", sheet, package = "up2code")
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
