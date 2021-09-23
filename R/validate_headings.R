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
#' @param title the title of the document
#' @param offset the number of lines to offset the position (equal to the size
#'   of the yaml header).
#' @return a list with two elements:
#'   1. a data frame that contains the results of [make_heading_table()] and
#'      logical columns for each test where `FALSE` indicates a failed test for
#'      a given heading.
#'   2. a data frame that can be printed as a tree with `show_heading_tree()`
#' @keywords internal
#' @rdname validate_headings
validate_headings <- function(headings, title = NULL, offset = 5L) {
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)
  # no headings means that we don't need to check this
  if (length(headings) == 0) {
    return(NULL)
  }

  htab <- make_heading_table(headings, offset)
  VAL  <- htab
  VAL[names(heading_tests)] <- TRUE

  VAL <- headings_first_heading_is_second_level(VAL)
  VAL <- headings_greater_than_first_level(VAL)
  VAL <- headings_are_sequential(VAL)
  VAL <- headings_have_names(VAL)

  # Test for unique headings ---------------
  # 
  # This is a bit more involved because we have to consider the heading level
  # (e.g. a level 2 heading is not the same as a level 3 heading, even though
  # they may have the same name.
  VAL   <- collect_labels(VAL, cli = has_cli)
  htree <- heading_tree(htab, title, suffix = c("", VAL$labels))
  any_duplicates <- label_duplicates(htree, cli = has_cli)
  VAL$are_unique <- any_duplicates$test[-1]
  htree <- any_duplicates$tree
  return(list(results = VAL[names(VAL) != "labels"], tree = htree))
}

#' @rdname validate_headings
#' @param tree a data frame produced via `validate_headings()`
show_heading_tree <- function(tree) {
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)
  if (has_cli) {
    cli::cli_rule("Heading structure")
    cli::cat_print(cli::tree(tree, trim = TRUE))
    cli::cli_rule()
  } else {
    pad <- vapply(tree$level, function(i) {
      paste(rep("-", i), collapse = "")
    }, character(1))
    dtree <- paste0(pad, tree$label)
    message(paste(dtree, collapse = "\n"))
  }
}

#' @rdname validate_headings
heading_tests <- c(
  first_heading_is_second_level = "(must be level 2)",
  greater_than_first_level = "(first level heading)",
  are_sequential = "(non-sequential heading jump)",
  have_names = "(no name)",
  are_unique = "(duplicated)",
  NULL
)

heading_info <- c(
  first_heading_is_second_level = "First heading must be level 2",
  greater_than_first_level = "Level 1 headings are not allowed",
  are_sequential = "Headings must be sequential",
  have_names = "Headings must be named",
  are_unique = "Headings must be unique",
  NULL
)

#' @rdname validate_headings
#' @param VAL a data frame that contains the results of [make_heading_table()]
#'   and logical columns that match the name of the test.
headings_first_heading_is_second_level <- function(VAL) {
  VAL$first_heading_is_second_level[[1]] <- VAL$level[[1]] == 2
  VAL
}

#' @rdname validate_headings
headings_greater_than_first_level <- function(VAL) {
  VAL$greater_than_first_level <- VAL$level > 1L
  VAL
}

#' @rdname validate_headings
headings_are_sequential <- function(VAL) {
  are_sequential <- diff(VAL$level) < 2
  VAL$are_sequential <- c(TRUE, are_sequential)
  VAL
}

#' @rdname validate_headings
headings_have_names <- function(VAL) {
  VAL$have_names <- trimws(VAL$heading) != ""
  VAL
}

#' @rdname validate_headings
headings_are_unique <- function(VAL) {
  VAL$are_unique[-1] <- VAL$level[-1] > 1L
  VAL
}
