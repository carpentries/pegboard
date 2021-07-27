#' Validate Links in a markdown document
#'
#' This function will validate that links do not throw an error in markdown
#' documents. This will include links to images and will respect robots.txt for
#' websites.
#'
#' @details
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
#'
#' ## Alt-text (for images)
#'
#' All images must have associated alt-text. In pandoc, this is acheived by
#' writing the `alt` attribute in curly braces after the image: 
#' `![image caption](link){alt='alt text'}`
#'
#' ## Descriptive text
#'
#' All links must have descriptive text associated with them, which is 
#' beneficial for screen readers scanning the links on a page to not have a
#' list full of "link", "link", "link".
#'
#' @param yrn a [tinkr::yarn] or [Episode] object.
#' @param verbose if TRUE (default), messages will be printed as the validator works.
#' @return a data frame containing the links, locations, and indicators if they
#' passed tests
validate_links <- function(yrn, verbose = TRUE) {
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)

  link_table <- make_link_table(yrn)
  path <- basename(yrn$path)
  VLD <- c(
    enforce_https = TRUE,
    internal_okay = TRUE,
    all_reachable = TRUE,
    img_alt_text  = TRUE,
    descriptive   = TRUE,
    NULL
  )
  VLD["descriptive"]   <- validate_descriptive(link_table, path, verbose, has_cli)
  VLD["enforce_https"] <- validate_https(link_table, path, verbose, has_cli)
  VLD["img_alt_text"]  <- validate_alt_text(link_table, path, verbose, has_cli)
  VLD["internal_okay"] <- validate_internal_okay(yrn, link_table, verbose, has_cli)
  VLD
}


validate_known_rot <- function(lt, path, verbose = TRUE, cli = TRUE) {
  # There are some links that are notorious for link rot. In these cases, we 
  # should absolutely invalidate them.
  rotten <- c(
    # NOTE: Add new rotten URLs with their solutions here
    "exts.ggplot2.tidyverse.org/" = "(www.)?ggplot2-exts.org",
    NULL
  )
  res <- !any(matched <- vapply(rotten, grepl, logical(nrow(lt)), lt$server))
  if (verbose && !res) {
    bad_links <- lt$server[rowSums(res) > 0L]
  }
}

validate_descriptive <- function(lt, path, verbose = TRUE, cli = TRUE) {
  res <- !any(bad <- tolower(lt$text) %in% c("link", "this link", "a link"))
  if (verbose && !res) {
    just_link    <- lt[bad, , drop = FALSE]
    link_sources <- glue::glue("{path}:{just_link$sourcepos}")
    issue_warning("Link text should be more descriptive than {sQuote('link')}:
      {glue::glue_collapse(lnks, sep = '\n')}",
      cli,
      lnks = glue::glue("{sQuote(just_link$text)} ({link_sources})")
    )
  }
  res
}

validate_internal_okay <- function(yrn, lt = NULL, verbose = TRUE, cli = TRUE) {
  if (is.null(lt)) {
    lt <- make_link_table(yrn)
  }
  headings   <- xml2::xml_text(yrn$headings)
  path       <- basename(yrn$path)
  internal   <- lt$server == "" & lt$scheme == "" & is.na(lt$port) & lt$user == ""
  cross_page <- internal & lt$path != ""
  in_page    <- internal & lt$path == "" & lt$fragment != ""
  res <- TRUE
  if (any(in_page)) {
    our_headings <- clean_headings(headings)
    no_match <- !lt$fragment %in% our_headings
    res <- res & !any(in_page & no_match)
  } else {
    no_match <- FALSE
  }
  if (any(cross_page)) {
    no_file <- !test_file_existence(lt$path, fs::path_dir(yrn$path))
    is_anchor <- purrr::map_lgl(lt$path %in% lt$rel, identical, TRUE)
    res <- res & !any(cross_page & no_file)
  }
  if (verbose && !res) {
    if (any(in_page & no_match)) {
      bad_fragment <- lt[in_page & no_match, , drop = FALSE]
      link_sources <- glue::glue("{path}:{bad_fragment$sourcepos}")
      issue_warning("The following anchors do not exist in the file:
        {glue::glue_collapse(lnks, sep = '\n')}", 
        cli,
        lnks = glue::glue("{bad_fragment$orig} ({link_sources})")
      )
    }
    if (any(cross_page & is_anchor)) {
      a <- lt[cross_page & is_anchor, , drop = FALSE]
      link_sources <- glue::glue("{path}:{a$sourcepos}")
      link_fmt <- glue::glue("[{a$text}]({a$orig}) -> [{a$text}][{a$orig}]")
      issue_warning("Relative links that are incorrectly formatted:
        {glue::glue_collapse(lnks, sep = '\n')}", 
        cli,
        lnks = glue::glue("{link_fmt} ({link_sources})")
      )
    }
    if (any(cross_page & no_file & !is_anchor)) {
      bad_files <- lt[cross_page & no_file & !is_anchor, , drop = FALSE]
      link_sources <- glue::glue("{path}:{bad_files$sourcepos}")
      issue_warning("These files do not exist in the lesson:
        {glue::glue_collapse(lnks, sep = '\n')}", 
        cli,
        lnks = glue::glue("{bad_files$orig} ({link_sources})")
      )
    }
  }
  res
}

test_file_existence <- function(paths, home) {
  # Add home path, assuming that we can link out from the episode and it will
  # link back to something real
  call_me_maybe  <- fs::path_norm(fs::path(home, paths))
  # Catch the folders and the images
  exists_organic <- fs::file_exists(call_me_maybe)
  # Catch markdown files to be translated to HTML
  exists_md      <- fs::file_exists(fs::path_ext_set(call_me_maybe, "md"))
  # Catch R Markdown files to be translated to HTML
  exists_rmd     <- fs::file_exists(fs::path_ext_set(call_me_maybe, "Rmd"))
  # Return the winners
  exists_organic | exists_md | exists_rmd
}

clean_headings <- function(headings) {
  anchor_regex <- ".*[[:space:]][{].*(<?#)([^[:space:]]+).*[}]"
  anchor_swapped <- gsub(anchor_regex, "\\2", headings, perl = TRUE)
  no_curlies     <- gsub("([{].+?[}]) ?$", "", anchor_swapped)
  emoji_eliminated <- gsub("(<?:)[_a-z0-9]+(?=:) ?", "", 
    no_curlies, perl = TRUE)
  lower_dash <- gsub("[[:punct:][:space:]]+", "-", tolower(emoji_eliminated))
  trim_dash <- gsub("[-]$", "", gsub("^[-]", "", lower_dash))
  gsub("\\.", "-", make.unique(trim_dash))
}

validate_https <- function(lt, path, verbose = TRUE, cli = TRUE) {
  res <- !any(has_http <- lt$scheme == "http")
  if (verbose && !res) {
    link_sources <- glue::glue("{path}:{lt$sourcepos[has_http]}")
    issue_warning("Links must use HTTPS, not HTTP:
      {glue::glue_collapse(lnks, sep = '\n')}",
      cli,
      lnks = glue::glue("{lt$orig[has_http]} ({link_sources})")
    )
  }
  res
}


validate_alt_text <- function(lt, path, verbose = TRUE, cli = TRUE) {
  img <- lt$type %in% c("image", "img")
  res <- !any(no_alt <- img & (is.na(lt$alt) | lt$alt == ""))
  if (verbose && !res) {
    img_sources <- glue::glue("{lt$orig[no_alt]} ({path}:{lt$sourcepos[no_alt]})")
    issue_warning("Images need alt-text:
      {imgs}",
      cli,
      imgs = glue::glue_collapse(img_sources, "\n")
    )
  }
  res
}

