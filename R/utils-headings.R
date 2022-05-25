#' Get all headings in the XML document
#'
#' @param body an XML document
#'
#' @return an object of class `xml_nodeset` with all the headings in the
#'  document.
#' @rdname heading_utils
get_headings <- function(body) {
  ns <- NS(body)
  xml2::xml_find_all(body, glue::glue(".//{ns}heading"))
}

#' @rdname heading_utils
#' @param tree a data frame produced via [validate_headings()]
show_heading_tree <- function(tree) {
  if (has_cli()) {
    cli::cli_rule("Heading structure")
    cli::cat_print(cli::tree(tree, trim = TRUE))
    cli::cli_rule()
  } else {
    pad <- vapply(tree$level, function(i) {
      paste(rep("-", i), collapse = "")
    }, character(1))
    dtree <- paste0(pad, tree$label)
    pb_message(paste(dtree, collapse = "\n"))
  }
}
