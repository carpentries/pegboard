#' Isolate all blocks within a document that have a kramdown tag
#'
#' @param body an xml document
#' @param predicate an XPath conditional statement in square brackets or an
#'   empty string. This can be used to filter on such attributes such as line
#'   number.
#'
#' @return the modified body, invisibly
#' @keywords internal
isolate_kram_blocks <- function(body, predicate = "") {
  ns <- NS(body)
  kblock <- glue::glue("{ns}block_quote[@ktag]{predicate}")
  txt <- xml2::xml_find_all(
    body,
    glue::glue(".//text()[not(ancestor-or-self::{kblock})]")
  )
  parents <- xml2::xml_parents(txt)
  parents <- parents[xml2::xml_name(parents) != "document"]
  xml2::xml_remove(parents)
  invisible(body)
}
