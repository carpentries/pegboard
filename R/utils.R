nodeprint <- function(x) {
  purrr::walk(x, ~cat("\n<", xml_name(.x), ">\n", xml_text(.x), "\n"))
}
