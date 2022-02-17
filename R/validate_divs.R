#' Validate Callout Blocks for sandpaper episodes
#' 
#'
#' The Carpentries Workbench uses [pandoc fenced
#' divs](https://pandoc.org/MANUAL.html#extension-fenced_divs) to create special
#' blocks within the lesson for learners and instructors to provide breaks in
#' the narrative flow for focus on specific tasks or caveats. These fenced divs
#' look something like this:
#'
#' ```markdown
#' ::: callout
#' 
#' ### Hello!
#' 
#' This is a callout block
#'
#' :::
#' ```
#'
#' Lessons created with The Carpentries Workbench are expected to have the
#' following fenced divs:
#'
#'  - objectives (top)
#'  - questions (top)
#'  - keypoints (bottom)
#'
#' The following fenced divs can occur in the lesson, but are not required:
#'
#'  - prereq
#'  - callout
#'  - challenge
#'  - solution (nested inside challenge)
#'  - hint (nested inside challenge)
#'  - discussion
#'  - checklist
#'  - testimonial
#'
#' Any other div names will produce structure in the resulting DOM, but they 
#' will not have any special visual styling.
#'
#' @inheritParams validate_links
#' @return a data frame with the following columns:
#'  - div: the type of div
#'  - label: the label of the div
#'  - line: the line number of the div label
#'  - is_known: a logical value if the div is a known type (`TRUE`) or not (`FALSE`)
validate_divs <- function(yrn) {
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)
  VAL <- make_div_table(yrn)
  if (length(VAL) == 0L || is.null(VAL)) {
    return(invisible(NULL))
  }
  VAL <- div_is_known(VAL)
  VAL
}

#' @rdname validate_divs
div_is_known <- function(div_table) {
  div_table$is_known <- div_table$div %in% KNOWN_DIVS
  div_table
}
#' @rdname validate_divs
#' @export
KNOWN_DIVS <- c(
  "callout",
  "objectives",
  "questions",
  "challenge",
  "prereq",
  "checklist",
  "solution",
  "hint",
  "discussion",
  "testimonial",
  "keypoints",
  "instructor"
)

#' @rdname validate_divs
#' @export
div_tests <- c(
  is_known = "[unknown div] {div}",
  NULL
)

#' @rdname validate_divs
#' @export
div_info <- c(
  is_known = paste("The Carpentries Workbench knows the following div types",
    paste(KNOWN_DIVS, collapse = ", ")),
  NULL
)
