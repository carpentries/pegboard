#' Convert liquid code blocks to commonmark code blocks
#'
#' Liquid code blocks are generally codified by 
#'
#' ~~~
#' print("code goes " + "here")
#' ~~~
#' {: .language-python}
#'
#' However, there is a simpler syntax that we can use:
#'
#' ```python
#' print("code goes " + "here")
#' ```
#'
#' This will take in a code block and convert it so that it will no longer use
#' the liquid tag (which we have added as a "ktag" attribute for "kramdown" tag)
#'
#' @param block a code block
#' @param make_rmd if `TRUE`, the language will be wrapped in curly braces to
#'   be evaluated by RMarkdown
#' @return the node, invisibly.
#' @export
#' @examples
#'
#' frg1 <- Lesson$new(lesson_fragment())
#' frg2 <- frg1$clone(deep = TRUE)
#' py1  <- get_code(frg1$episodes[["17-scope.md"]]$body, ".language")
#' py2  <- get_code(frg2$episodes[["17-scope.md"]]$body, ".language")
#' py1
#' invisible(lapply(py1, liquid_to_commonmark, make_rmd = FALSE))
#' invisible(lapply(py2, liquid_to_commonmark, make_rmd = TRUE))
#' py1
#' py2
liquid_to_commonmark <- function(block, make_rmd = FALSE) {
  lang <- xml2::xml_attr(block, "ktag")
  info <- xml2::xml_attr(block, "info")
  pos  <- xml2::xml_attr(block, "sourcepos")

  if (is.na(lang) && grepl("^{[a-z]+?", info)) {
    # This has already been converted
    return(block)
  }

  # if blocks will start with {: .language-, trim it out
  # otherwise, trim the first five characters and ensure 
  # that they are not processed as RMD blocks
  start    <- if (grepl("language", lang, fixed = TRUE)) 14 else 5
  lang     <- substring(lang, start, nchar(lang) - 1L)
  make_rmd <- make_rmd && start == 14 
  new_info <- if (make_rmd) "{lang}-chunk-{pos}" else "{lang}{info}"
  info     <- if (all(is.na(info))) "" else paste(",", info)

  xml2::xml_set_attr(block, "ktag", NULL)
  if (make_rmd) {
    xml2::xml_set_attr(block, "language", lang)
    xml2::xml_set_attr(block, "name", glue::glue(new_info))
  } else {
    xml2::xml_set_attr(block, "info", glue::glue(new_info))
  }
  invisible(block)
}
