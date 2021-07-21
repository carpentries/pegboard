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
#' @param verbose if TRUE (default), messages will be printed as the validator works.
#' @return a data frame containing the links, locations, and indicators if they
#' passed tests
validate_links <- function(yrn, verbose = TRUE) {
  link_table <- make_link_table(yrn)
  path <- basename(yrn$path)
  VLD <- c(
    enforce_https = TRUE,
    internal_okay = TRUE,
    all_reachable = TRUE,
    img_alt_text  = TRUE,
    NULL
  )
  # Enforce all links do not use http. This one is pretty straightforward to
  # check. 
  VLD["enforce_https"] <- validate_https(link_table, path)
  VLD["img_alt_text"]  <- validate_alt_text(link_table, path)
  VLD
}

# validate_internal_okay <- function(lt, path) {
#   res <- !any(has_http <- lt$scheme == "http")
#   if (!res) {
#     with_http    <- lt[lt$scheme, , drop = FALSE]
#     link_sources <- glue::glue("{path}:{with_http$sourcepos}")
#     issue_warning("Links must use HTTPS, not HTTP:
#       {glue::glue_collapse(lnks)}",
#     lnks = glue::glue("{with_http$orig} ({link_sources})")
#    )
#   }
#   res
# }


validate_https <- function(lt, path) {
  res <- !any(has_http <- lt$scheme == "http")
  if (!res) {
    with_http    <- lt[lt$scheme, , drop = FALSE]
    link_sources <- glue::glue("{path}:{with_http$sourcepos}")
    issue_warning("Links must use HTTPS, not HTTP:
      {glue::glue_collapse(lnks)}",
    lnks = glue::glue("{with_http$orig} ({link_sources})")
   )
  }
  res
}


validate_alt_text <- function(lt, path) {
  img <- lt$type %in% c("image", "img")
  alt_text <- lt$alt[img]
  res <- !any(is.na(alt_text) | alt_text == "")
  if (!res) {
    img_sources <- glue::glue("{path}:{lt$sourcepos[img]}")
    issue_warning("Images need alt-text
      {imgs}",
      imgs = glue::glue_collapse(img_sources, "\n")
    )
  }
  res
}

