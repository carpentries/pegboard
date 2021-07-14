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
  if (length(headings) == 0) {
    return(TRUE)
  }

  hlevels <- as.integer(xml2::xml_attr(headings, "level"))
  hnames  <- xml2::xml_text(headings)
  no_challenge <- hnames[!c("challenge", "solution") %in% trimws(tolower(hnames))]

  VAL <- TRUE

  # Begin validation procedures ------------------------------------------------
  ## Second is First ----
  first_heading_is_second_level <- hlevels[[1]] == 2
  if (message && !first_heading_is_second_level) {
    issue_warning("
      The first heading must be a second level (##) heading. (It is currently level {lev[[1]]})", 
      lev = hlevels
    )
  }
  VAL <- VAL && first_heading_is_second_level

  ## No Firsts ----
  ID <- all(are_greater_than_first_level <- hlevels > 1)
  if (message && !ID) {
    issue_warning("
      First level headings are not allowed (the title is the first level heading).
      The following heading{?s} {?is/are} first level: 
      {names[bad]}", 
      names = paste("#", hnames), 
      bad = !are_greater_than_first_level
    )
  }
  VAL <- VAL && ID

  ## Sequence is okay ----
  ID <- all(are_sequential <- diff(hlevels) < 2)
  if (message && !ID) {
    issue_warning("All headings must be sequential")
  }

  VAL <- VAL && ID
  # Heading text VALation
  ID <- all(have_names <- hnames != "")
  if (message && !ID) {
    issue_warning("All headings must be named")
  }
  VAL <- VAL && ID
  # TODO: implement this for the hierarchy
  htree <- heading_tree(headings)
  are_not_unique <- vapply(htree$children, function(i) any(duplicated(i)), logical(1))
  if (message && any(are_not_unique)) {
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
  VAL <- VAL && !any(are_not_unique)

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


