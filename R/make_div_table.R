#' Create a table of divs in an episode
#'
#' @inheritParams validate_links
#' @return a data frame with the following columns:
#'  - path: path to the file, relative to the lesson
#'  - div: the type of div
#'  - pb_label: the label of the div
#'  - line: the line number of the div label
make_div_table <- function(yrn) {
  yml_lines <- length(yrn$yaml)
  these_divs <- yrn$label_divs()$get_divs()
  labels <- names(these_divs)
  path <- fs::path_rel(yrn$path, yrn$lesson)
  div_type <- sub("div[-][0-9]+?[-]", "", labels)
  data.frame(
    path = rep(path, length(labels)),
    div = div_type,
    pb_label = labels,
    pos = purrr::map_int(these_divs, ~get_linestart(.x[[1]])) + yml_lines
  )
}
