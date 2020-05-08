#' Get code blocks from xml document
#'
#' @param body an xml document from a jekyll site
#' @param type a full or partial string of a code block attribute from Jekyll
#'   without parenthesis.
#'
#' @details This uses the XPath function `fn:starts-with()` to  search for the
#'   code block and automatically includes the opening brace, so regular
#'   expressions are not allowed. This is used by the `$code`, `$output`, and
#'   `$error` elements of the [Episode] class.
#'
#' @return an xml nodeset object
#' @export
#'
#' @examples
#'
#' e <- Episode$new(fs::path(lesson_fragment(), "_episodes", "17-scope.md"))
#'
#' get_code(e$body)
#' get_code(e$body, ".output")
#' get_code(e$body, ".error")
get_code <- function(body, type = ".language-") {

  # TODO: the code blocks for pure Jekyll lessons and the Rmarkdown lessons
  # (python-novice-gapminder and r-novice-inflammation, respectively) will be
  # different, namely that the RMarkdown code blocks will have attributes
  # according to the RMarkdown specification while the Jekyll blocks will simply
  # be code blocks.

  # Namespace for the document is listed in the attributes
  ns <- attr(xml2::xml_ns(body), "names")[[1]]

  # Find the end of the challenge block ----------------------------------------
  predicate <- glue::glue("<ns>:text[starts-with(text(),'{: <type>')]",
    .open = "<",
    .close = ">"
  )
  challenge <- glue::glue("{ns}:paragraph[{predicate}]")

  axis <- "preceding-sibling"

  # Combine and search ---------------------------------------------------------
  challenge_string <- glue::glue(".//{challenge}/{axis}::{ns}:code_block[1]")

  xml2::xml_find_all(body, challenge_string)

}
