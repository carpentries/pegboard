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


#' Validate heading 
#' 
#' @param headings an object of xml_nodelist. 
#' @param message if `TRUE` (default), a message will be issued for each error,
#'   otherwise, they will be silent.
#' @return a boolean, `TRUE` if the headings are valid and `FALSE` if they are 
#'   invalid
#' @noRd
validate_headings <- function(headings, message = TRUE) {
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
  hnames  <- xml2::xml_text(headings)
  no_challenge <- hnames[!c("challenge", "solution") %in% trimws(tolower(hnames))]


  # Begin validation procedures ------------------------------------------------
  ## Second is First ----
  VAL["first_heading_is_second_level"] <- hlevels[[1]] == 2
  if (message && !VAL["first_heading_is_second_level"]) {
    issue_warning("
      The first heading must be a second level (##) heading. (It is currently level {lev[[1]]})", 
      lev = hlevels
    )
  }

  ## No Firsts ----
  VAL["all_are_greater_than_first_level"] <- all(greater_than_first_level <- hlevels > 1)
  if (message && !VAL["all_are_greater_than_first_level"]) {
    issue_warning("
      First level headings are not allowed (the title is the first level heading).
      The following heading{?s} {?is/are} first level: 
      {names[bad]}", 
      names = paste("#", hnames), 
      bad = !greater_than_first_level
    )
  }

  ## Sequence is okay ----
  VAL["all_are_sequential"] <- all(are_sequential <- diff(hlevels) < 2)
  if (message && !VAL["all_are_sequential"]) {
    issue_warning("All headings must be sequential")
  }

  # Headings all have names ---
  VAL["all_have_names"] <- all(have_names <- hnames != "")
  if (message && !VAL["all_have_names"]) {
    issue_warning("All headings must be named")
  }

  # Heading uniqueness ----
  htree <- heading_tree(headings)
  are_not_unique <- vapply(htree$children, function(i) any(duplicated(i)), logical(1))
  VAL["all_are_unique"] <- !any(are_not_unique)

  if (message && !VAL["all_are_unique"]) {
    dupes <- htree$children[are_not_unique]
    if (requireNamespace("cli", quietly = TRUE)) {
      htree$label <- htree$heading
      htree$trimmed <- paste(htree$heading, cli::style_inverse("<- (duplicated)"))
      dtree <- cli::tree(htree, trim = TRUE)
    } else {
      dtree <- dupes$heading
    }
    issue_warning("All headings must have unique IDs
      The following headings are duplicated:
      {dtree}",
      dtree = paste(dtree, collapse = "\n")
    )
  }
  VAL
}

issue_warning <- function(msg, ...) {
  l <- list(...)
  for (i in names(l)) {
    assign(i, l[[i]])
  }
  if (requireNamespace("cli", quietly = TRUE)) {
    cli::cli_alert_warning(msg)
  } else {
    warning(glue::glue(msg))
  }
}


