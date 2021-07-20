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
  link_table <- make_link_table(yrn)
  path <- basename(yrn$path)
  VLD <- c(
    enforce_https = TRUE,
    all_reachable = TRUE,
    img_alt_text  = TRUE,
    NULL
  )
  # Enforce all links do not use http. This one is pretty straightforward to
  # check. 
  VLD["enforce_https"] <- !any(has_http <- link_table$scheme == "http")
  if (!VLD["enforce_https"]) {
    with_http <- link_table[link_table$scheme, , drop = FALSE]
    link_sources <- glue::glue("{path}:{with_http$sourcepos}")
    issue_warning("Links must use HTTPS, not HTTP:
      {lnks}",
    lnks = glue::glue("{with_http$orig} ({link_sources})")
   )
  }
  VLD["img_alt_text"] <- validate_alt_text(link_table, path)
  VLD
}

validate_alt_text <- function(lt, path) {
  img <- lt$type == "image"
  res <- !any(no_alt_text <- lt$text[lt$type == "image"])
  if (!res) {
    img_sources <- glue::glue("{path}:{lt$sourcepos[img]}")
    issue_warning("Images need alt-text
      {imgs}",
      imgs = img_sources
    )
  }
  res

}

#' Create a table of parsed URLs from a single Episode object. 
#'
#' @param yrn an Episode class object
#' @return a data frame containing the following columns:
#' - scheme The scheme for the URL (http, https, mailto, ftp, etc...)
#' - server The first part of the URL (e.g. doi.org or github.com)
#' - port the port number if it exists (note: liquid tags produce weird ports)
#' - user associated with port, usually blank
#' - path path to the page in question
#' - query anything after a "?" in a URL
#' - fragment navigation within a page; anything after "#" in a URL
#' - orig the original, unparsed URL
#' - text the text associated with the URL
#' - title the title (if any) of the URL
#' - type the type of URL (image or link)
#' - rel if it's a relative URL, the name of the anchor, otherwise NA.
#' - anchor logical if the URL is an anchor
#' - sourcepos the source position in the file
#' @export
#' @examples
#' loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
#' make_link_table(Episode$new(loop))
make_link_table <- function(yrn) {

  yml_lines <- length(yrn$yaml)
  # Combining nodesets forces these to be lists, meaning that we have to use
  # mappers here.
  limg      <- c(yrn$links, yrn$images)
  urls      <- purrr::map_chr(limg, xml2::xml_attr, "destination")
  url_table <- xml2::url_parse(urls)

  url_table$orig      <- urls
  url_table$text      <- purrr::map_chr(limg, xml2::xml_text)
  url_table$title     <- purrr::map_chr(limg, xml2::xml_attr, "title")
  url_table$type      <- purrr::map_chr(limg, xml2::xml_name)
  url_table$rel       <- purrr::map_chr(limg, xml2::xml_attr, "rel")
  url_table$anchor    <- !is.na(purrr::map_chr(limg, xml2::xml_attr, "anchor"))
  url_table$sourcepos <- purrr::map_int(limg, get_linestart) + yml_lines

  url_table
}
