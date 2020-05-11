nodeprint <- function(x) {
  purrr::walk(x, ~cat("\n<", xml2::xml_name(.x), ">\n", xml2::xml_text(.x), "\n"))
}

block_type <- function(ns, type = NULL, start = "[", end = "]") {

  p   <- glue::glue("{ns}:paragraph")
  txt <- glue::glue("{ns}:text")

  if (is.null(type)) {
    res <- ""
  } else {
    res <- glue::glue("<start>descendant::<p>/<txt>[text()='{: <type>}']<end>",
      .open  = "<",
      .close = ">"
    )
  }
  res
}
