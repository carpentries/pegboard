#' Get all headings in the XML document
#'
#' @param body an XML document
#'
#' @return an object of class `xml_nodeset` with all the headings in the
#'  document.
#' @noRd
get_headings <- function(body) {
  ns <- NS(body)
  xml2::xml_find_all(body, glue::glue(".//{ns}heading"))
}


#' Validate headings
#' 
#' This will validate the following aspects of all headings:
#'
#'  - first heading starts at level 2 (`first_heading_is_second_level`)
#'  - greater than level 1 (`all_are_greater_than_first_level`)
#'  - increse sequentially (e.g. no jumps from 2 to 4) (`all_are_sequential`)
#'  - have names (`all_have_names`)
#'  - unique in their own hierarchy (`all_are_unique`)
#'
#' @note This is an internal function implemented for the [Episode] and [Lesson]
#'   classes. 
#' @param headings an object of xml_nodelist.
#' @param message if `TRUE` (default), a message will be issued for each error,
#'   otherwise, they will be silent.
#' @return a logical vector of length five summarizing the results of the
#'   five aspects listed above: `TRUE` for valid headings and `FALSE` for
#'   invalid headings.
#' @keywords internal
validate_headings <- function(headings, lesson = NULL, message = TRUE) {
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)
  # no headings means that we don't need to check this
  VAL <- c(
    first_heading_is_second_level = TRUE,
    all_are_greater_than_first_level = TRUE,
    all_are_sequential = TRUE,
    all_have_names = TRUE,
    all_are_unique = TRUE
  )
  if (length(headings) == 0) {
    return(VAL)
  }

  hlevels <- as.integer(xml2::xml_attr(headings, "level"))
  hlabels <- character(length(headings))
  hnames  <- xml2::xml_text(headings)
  no_challenge <- hnames[!c("challenge", "solution") %in% trimws(tolower(hnames))]


  # Begin validation procedures ------------------------------------------------
  ## Second is First ----
  VAL["first_heading_is_second_level"] <- hlevels[[1]] == 2
  if (message && !VAL["first_heading_is_second_level"]) {
    issue_warning("
      The first heading must be level 2 (It is currently level {lev[[1]]}).", 
      cli = has_cli,
      lev = hlevels
    )
    err <- "(must be level 2)"
    hlabels[1] <- if (has_cli) cli::style_inverse(err) else err
  }

  ## No Firsts ----
  VAL["all_are_greater_than_first_level"] <- all(greater_than_first_level <- hlevels > 1)
  if (message && !VAL["all_are_greater_than_first_level"]) {
    issue_warning("First level headings are not allowed.", cli = has_cli)
    hlabels <- append_labels(l = hlabels, i = !greater_than_first_level, 
      e = "(first level heading)", cli = has_cli)
  }

  ## Sequence is okay ----
  VAL["all_are_sequential"] <- all(are_sequential <- diff(hlevels) < 2)
  if (message && !VAL["all_are_sequential"]) {
    issue_warning("All headings must be sequential.", has_cli)

    hlabels <- append_labels(l = hlabels, i = !c(TRUE, are_sequential), 
      e = "(non-sequential heading jump)", cli = has_cli)
  }

  # Headings all have names ---
  VAL["all_have_names"] <- all(have_names <- hnames != "")
  if (message && !VAL["all_have_names"]) {
    issue_warning("All headings must be named.", cli = has_cli)

    hlabels <- append_labels(l = hlabels, i = !have_names, 
      e = "(no name)", cli = has_cli)
  }

  # Heading uniqueness ----
  htree     <- heading_tree(headings, lesson, suffix = c("", hlabels))
  any_duplicates <- label_duplicates(htree, cli = has_cli)
  VAL["all_are_unique"] <- any_duplicates$test
  htree <- any_duplicates$tree
  if (!has_cli) {
    pad <- vapply(htree$level, function(i) {
      paste(rep("-", i), collapse = "")
    }, character(1))
    dtree <- paste0(pad, htree$label)
  }

  if (message && !VAL["all_are_unique"]) {
    issue_warning("All headings must have unique IDs.", cli = has_cli)
  }
  if (message && any(!VAL)) {
    if (has_cli) {
      cli::cli_rule("Heading structure")
      cli::cat_print(cli::tree(htree, trim = TRUE))
      cli::cli_rule()
    } else {
      message(paste(dtree, collapse = "\n"))
    }
  }
  VAL
}


validate_heading_sequential <- function(hd, path, verbose = TRUE, cli = TRUE) {
  are_sequential <- diff(hd$level) < 2
  res <- all(are_sequential)
  bad <- !c(TRUE, are_sequential)
  if (verbose && !res) {
    bh <- hd[bad, , drop = FALSE]
    link_sources <- line_report(
      msg = glue::glue("(level {bh$level}) {sQuote(bh$heading)} [non-sequential heading jump]"),
      path = path,
      pos = bh$pos,
      sep = " "
    )
    issue_warning("Child headings must be sequential.
      <https://webaim.org/techniques/semanticstructure/#headings>
      {lnks}", cli, lnks = link_sources)
  }
  bad
}

