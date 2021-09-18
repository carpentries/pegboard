#' Extract list elements from a block
#'
#' @param self an Episode object
#' @param type the type of block/div to extract the list from
#' @param in_yaml indicator if the elements are in the YAML header (`TRUE`, 
#'   default for styles version 9 lessons) or if they are in the body of the
#'   lesson (`FALSE`, for sandpaper lessons).
#' @return a character vector
#' @keywords internal
get_list_block <- function(self, type = "questions", in_yaml = TRUE) {
  q <- NULL
  # Try the yaml first
  if (in_yaml) {
    yaml <- self$get_yaml()
    q <- yaml[[type]]
  } 

  # Try the code blocks next (for dovetail lessons)
  # TODO: remove this if we determine that {dovetail} is an impossibility
  if (is.null(q)) {
    ns <- NS(self$body)
    xpath <- ".//{ns}code_block[@info='{{{type}}}' or @language='{type}']"
    xpath <- glue::glue(xpath)
    q <- xml2::xml_find_first(self$body, xpath)
  } else {
    return(q)
  }
  # If they produce something, parse, otherwise, try the divs
  if (length(q) > 0) {
    # removing all prefix content
    txt <- gsub("\n?#' ?-?", "\n", xml2::xml_text(q), perl = TRUE)
    # removing header
    txt <- gsub("## .+?\n", "", txt, perl = TRUE)
    # replacing all double newlines with single newlines
    txt <- trimws(gsub("\n{2,}", "\n", txt, perl = TRUE))
    # splitting into individual elements
    q <- strsplit(txt, "\n")[[1]]
  } else {
    # In order to get the divs, we must first ensure that they are labelled
    q <- get_divs(self$body, type)
    if (length(q)) {
      q <- q[[1]]
    } else {
      warning(glue::glue("No section called {sQuote(type)}"), call. = FALSE)
      return(character(0))
    }
    q <- xml_to_md(q[xml2::xml_name(q) == "list"])
    q <- trimws(gsub("\n?- ", "\n", q))
    q <- strsplit(q, "\n")[[1]] 
  }
  return(trimws(q))
}
