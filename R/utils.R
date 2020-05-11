nodeprint <- function(x) {
  purrr::walk(x, ~cat(pretty_tag(.x), xml2::xml_text(.x), "\n"))
}

pretty_tag <- function(x, hl = function(x) crayon::bgYellow(crayon::black(x))) {
  nm <- glue::glue("<{xml2::xml_name(x)}>")
  glue::glue("\n{hl(nm)}:\n")
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
