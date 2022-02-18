throw_heading_warnings <- function(VAL) {
  if (length(VAL) == 0 || nrow(VAL) == 0) {
    return(invisible(NULL))
  }
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)
  VAL <- collect_labels(VAL, cli = FALSE, heading_tests)
  err <- VAL[VAL$labels != '', ]
  # No errors throw no warnings
  if (nrow(err) == 0) {
    return(invisible(NULL))
  }
  
  reports <- line_report(msg = err$labels, err$path, err$pos, sep = " ")
  failed <- !apply(err[names(heading_tests)], MARGIN = 2, all)
  infos <- paste("-", heading_info[failed], collapse = "\n")
  issue_warning("There were errors in {n}/{N} headings

    {infos}
    <https://webaim.org/techniques/semanticstructure/#headings>

    {reports}", cli = has_cli, n = nrow(err), N = nrow(VAL), infos = infos, reports = reports)
}

throw_div_warnings <- function(VAL) {
  if (length(VAL) == 0 || nrow(VAL) == 0) {
    return(invisible(NULL))
  }
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)
  VAL <- collect_labels(VAL, cli = FALSE, div_tests)
  err <- VAL[VAL$labels != '', ]
  # No errors throw no warnings
  if (nrow(err) == 0) {
    return(invisible(NULL))
  }
  
  reports <- line_report(msg = err$labels, err$path, err$pos, sep = " ")
  failed <- !apply(err[names(div_tests)], MARGIN = 2, all)
  infos <- paste("-", div_info[failed], collapse = "\n")
  issue_warning("There were errors in {n}/{N} fenced divs

    {infos}

    {reports}", cli = has_cli, n = nrow(err), N = nrow(VAL), 
    infos = infos, reports = reports)
}

throw_link_warnings <- function(VAL) {
  if (length(VAL) == 0 || nrow(VAL) == 0) {
    return(invisible(NULL))
  }
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)
  VAL <- collect_labels(VAL, cli = FALSE, link_tests)
  err <- VAL[VAL$labels != '', ]
  # No errors throw no warnings
  if (nrow(err) == 0) {
    return(invisible(NULL))
  }
  
  reports <- line_report(msg = err$labels, err$filepath, err$sourcepos, sep = " ")
  failed <- !apply(err[names(link_tests)], MARGIN = 2, all)
  infos <- paste("-", link_info[failed], collapse = "\n")
  issue_warning("There were errors in {n}/{N} links

    {infos}

    {reports}", cli = has_cli, n = nrow(err), N = nrow(VAL), infos = infos, reports = reports)
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

