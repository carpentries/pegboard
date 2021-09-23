throw_header_warnings <- function(VAL) {
  has_cli <- is.null(getOption("pegboard.no-cli")) &&
    requireNamespace("cli", quietly = TRUE)
  VAL <- collect_labels(VAL, cli = FALSE, heading_tests)
  err <- VAL[VAL$label != '', ]
  # No errors throw no warnings
  if (nrow(err) == 0) {
    return(invisible(NULL))
  }
  
  reports <- line_report(msg = err$label, err$path, err$pos, sep = " ")
  failed <- !apply(err[names(heading_tests)], MARGIN = 2, all)
  infos <- paste("-", heading_info[failed], collapse = "\n")
  issue_warning("There were errors in {n}/{N} headings

    {infos}
    <https://webaim.org/techniques/semanticstructure/#headings>

    {reports}", cli = has_cli, n = nrow(err), N = nrow(VAL), infos = infos, reports = reports)
}
}

#' @param VAL a data frame containing the results of tests
#' @param cli indicator to use the cli package to format warnings
#' @param msg (collect_labels) a named vector of messages to provide for each test
#' @noRd
collect_labels <- function(VAL, cli = FALSE, msg = heading_tests) {
  labels <- character(nrow(VAL))
  for (test in names(msg)) {
    labels <- label_failures(labels, VAL[[test]], msg[[test]], cli)
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

