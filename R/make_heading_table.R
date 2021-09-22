make_heading_table <- function(yrn) {
  yml_lines <- length(yrn$yaml)
  headings <- get_headings(yrn$body)
  data.frame(
    heading = xml2::xml_text(headings),
    level   = as.integer(xml2::xml_attr(headings, "level")),
    pos     = purrr::map_int(headings, get_linestart) + yml_lines,
    stringsAsFactors = FALSE
  )
}

