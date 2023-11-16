#' Throw a validation report as a single message
#'
#' Collapse a variable number of validation reports into a single message that
#' can be formatted for the CLI or GitHub.
#'
#' @param VAL `[data.frame]` a validation report derived from one of the
#'   `validate` functions.
#' @return NULL, invisibly. This is used for it's side-effect of formatting and
#'   issuing messages via [issue_warning()].
#' @export
#' @details One of the key features of {pegboard} is the ability to parse and
#' validate markdown elements. These functions provide a standard way of
#' creating the reports that are for the user based on whether or not they are
#' on the CLI or on GitHub. The prerequisites of these functions are the input
#' data frame (generated from the actual validation function) and an internal
#' set of known templating vectors that contain templates for each test to show
#' the actual error along with general information that can help correct the
#' error (see below).
#'
#'
#' ## Input Data Frame
#' 
#' The validations are initially reported in a data frame that has the
#' following properties: 
#'  - one row per element
#'  - columns that indicate the parsed attributes of the element, source
#'    file, source position, and the actual element XML node object.
#'  - boolean columns that indicate the tests for each element, used with
#'    [collect_labels()] to add a "labels" column to the data.
#'
#' ## Templating vectors
#'
#' These vectors come in two forms `[thing]_tests` and `[thing]_info` (e.g.
#' for [validate_links()], we have `link_tests` and `link_info`). These are
#' named vectors that match the boolean columns of the data frame produced
#' by the validation function. The `[thing]_tests` vector contains templates
#' that describes the error and shows the text that caused the error. The 
#' `[thing]_info` contains general information about how to address that
#' particular error. For example, one common link error is that a link is not
#' descriptive (e.g. the link text says "click here"). The column in the `VAL`
#' data frame that contains the result of this test is called "descriptive", so
#' if we look at the values from the link info and tests vectors:
#'
#' ```{r}
#' link_info["descriptive"]
#' link_tests["descriptive"]
#' ```
#'
#' If the `throw_*_warnings()` functions detect any errors, they will use the
#' info and tests vectors to construct a composite message.
#'
#' ## Process
#'
#' The `throw_*_warnings()` functions all do the same basic procedure (and
#' indeed could be consolidated into a single function in the future)
#'
#'  1. pass data to [collect_labels()], which will parse the `[thing]_tests`
#'     templating vector and label each failing element in `VAL` with the
#'     appropriate failure message
#'  2. gather the source information for each failure
#'  3. pass failures with the `[thing]_info` elements that matched the unique
#'     failures to  [issue_warning()] 
#' @seealso
#'   [validate_links()], [validate_divs()], and [validate_headings()] for
#'   input sources for these functions. 
#' @rdname throw_warnings
throw_heading_warnings <- function(VAL) {
  if (length(VAL) == 0 || nrow(VAL) == 0) {
    return(invisible(NULL))
  }
  VAL <- collect_labels(VAL, cli = FALSE, heading_tests)
  err <- VAL[VAL$labels != '', ]
  # No errors throw no warnings
  if (nrow(err) == 0) {
    return(invisible(NULL))
  }
  
  reports <- line_report(msg = err$labels, err$path, err$pos, sep = " ")
  failed <- !apply(err[names(heading_tests)], MARGIN = 2, all)
  issue_warning(what = "headings",
    url = "https://webaim.org/techniques/semanticstructure/#headings",
    cli = has_cli(), 
    n = nrow(err), 
    N = nrow(VAL), 
    infos = heading_info[failed], 
    reports = reports)
}

#' @rdname throw_warnings
throw_div_warnings <- function(VAL) {
  if (length(VAL) == 0 || nrow(VAL) == 0) {
    return(invisible(NULL))
  }
  VAL <- collect_labels(VAL, cli = FALSE, div_tests)
  err <- VAL[VAL$labels != '', ]
  # No errors throw no warnings
  if (nrow(err) == 0) {
    return(invisible(NULL))
  }
  
  reports <- line_report(msg = err$labels, err$path, err$pos, sep = " ")
  failed <- !apply(err[names(div_tests)], MARGIN = 2, all)
  issue_warning(what = "fenced divs",
    cli = has_cli(), 
    n = nrow(err), 
    N = nrow(VAL), 
    infos = div_info[failed], 
    reports = reports)
}

#' @rdname throw_warnings
throw_link_warnings <- function(VAL) {
  if (length(VAL) == 0 || nrow(VAL) == 0) {
    return(invisible(NULL))
  }
  VAL <- VAL[!VAL$anchor, , drop = FALSE]
  VAL <- collect_labels(VAL, cli = FALSE, link_tests)
  err <- VAL[VAL$labels != '', ]
  # No errors throw no warnings
  if (nrow(err) == 0) {
    return(invisible(NULL))
  }
  
  reports <- line_report(msg = err$labels, err$filepath, err$sourcepos, sep = " ")
  failed <- !apply(err[names(link_tests)], MARGIN = 2, all)
  types <- paste0(unique(sub("img", "image", err$type)), "s")
  issue_warning(what = paste(types, collapse = " and "),
    cli = has_cli(), 
    n = nrow(err), 
    N = nrow(VAL), 
    infos = link_info[failed], 
    reports = reports)
}

#' @param VAL a data frame containing the results of tests
#' @param cli indicator to use the cli package to format warnings
#' @param msg (collect_labels) a named vector of messages to provide for each test
#' @noRd
collect_labels <- function(VAL, cli = FALSE, msg = heading_tests) {
  labels <- character(nrow(VAL))
  for (test in names(msg)) {
    index <- VAL[[test]]
    this_msg <- glue::glue_data(VAL[!index, , drop = FALSE], msg[[test]])
    labels <- label_failures(labels, index, this_msg, cli)
  }
  VAL[["labels"]] <- labels
  VAL
}

label_failures <- function(labels, test, msg, cli) {
  failed_tests <- length(test) && any(!test)
  if (failed_tests) {
    return(append_labels(l = labels, i = !test, e = msg, cli = cli))
  } else {
    return(labels)
  }
}

