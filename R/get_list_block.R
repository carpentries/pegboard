get_list_block <- function(self, type = "questions", in_yaml = TRUE) {
  q <- NULL
  # Try the yaml first
  if (in_yaml) {
    yaml <- self$get_yaml()
    q <- yaml[[type]]
  } 

  # Try the code blocks next
  if (is.null(q)) {
    ns <- NS(self$body)
    xpath <- ".//{ns}:code_block[@info='{{{type}}}' or @language='{type}']"
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
    q <- get_divs(self$label_divs()$body, type)[[1]]
    q <- xml_to_md(q[xml2::xml_name(q) == "list"])
    q <- trimws(gsub("\n?- ", "\n", q))
    q <- strsplit(q, "\n")[[1]] 
  }
  return(trimws(q))
}
