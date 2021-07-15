#' Validate Links in a markdown document
#'
#' This function will validate that links do not throw an error in markdown
#' documents. This will include links to images and will respect robots.txt for
#' websites.
#'
#' ## External links
#'
#' These links must start with a valid and secure protocol. This means that we
#' will enforce HTTPS over HTTP. Any link with HTTP will be flagged. Most
#' importantly, these links must not return an error code > 399.
#'
#' ## Cross-lesson links
#'
#' These links will have no protocol, but should resolve to the HTML version of
#' a page and have the correct capitalisation.
#'
#' ## Anchors (aka fragments)
#'
#' Anchors are located at the end of URLs that start with a `#` sign. These are
#' used to indicate a section of the documenation.
#' @param yrn a [tinkr::yarn] or [Episode] object.
#' @return a data frame containing the links, locations, and indicators if they
#' passed tests
validate_links <- function(yrn) {
  links <- yrn$links
  imgs  <- yrn$images
  urls <- c(xml2::xml_attr(links, "destination"), xml2::xml_attr(imgs, "destination"))
  url_table <- xml2::url_parse(urls)
  url_table$sourcepos <- c(get_linestart(links), get_linestart(imgs))
  url_table
}
