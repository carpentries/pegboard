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
#' @examples
#' l <- Lesson$new(lesson_fragment())
#' e <- l$episodes[[3]]
#' # Our headings validators run a series of tests on headings and return a data
#' # frame with information about the headings along with the results of the
#' # tests
#' v <- pegboard:::validate_headings(e$headings, e$get_yaml()$title, length(e$yaml))
#' names(v)
#' v$results
#' v$results$path <- fs::path_rel(e$path, e$lesson)
#' # The validator does not produce any warnings or messages, but this data
#' # frame can be passed on to other functions that will throw them for us. We
#' # have a function that will throw a warning/message for each heading that
#' # fails the tests. These messages are controlled by `heading_tests` and 
#' # `heading_info`.
#' pegboard:::heading_tests
#' pegboard:::heading_info
#' pegboard:::throw_heading_warnings(v$results)
#' # Because the headings are best understood in tree form we have a utility
#' # that will print the heading tree with the associated errors:
#' pegboard:::show_heading_tree(v$tree)
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
#' @export
heading_tests <- c(
  first_heading_is_second_level = "(must be level 2)",
  greater_than_first_level = "(first level heading)",
  are_sequential = "(non-sequential heading jump)",
  have_names = "(no name)",
  are_unique = "(duplicated)",
  NULL
)

#' @rdname validate_headings
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
