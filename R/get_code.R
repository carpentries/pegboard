#' Get code blocks from xml document
#'
#' @param body an xml document from a jekyll site
#' @param type a full or partial string of a code block attribute from Jekyll
#'   without parenthesis.
#' @param attr what attribute to query in search of code blocks. Default is
#'   @@ktag, which will search for "\{: \<type\>".
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
get_code <- function(body, type = ".language-", attr = "@ktag") {

  # TODO: the code blocks for pure Jekyll lessons and the Rmarkdown lessons
  # (python-novice-gapminder and r-novice-inflammation, respectively) will be
  # different, namely that the RMarkdown code blocks will have attributes
  # according to the RMarkdown specification while the Jekyll blocks will simply
  # be code blocks.

  # Namespace for the document is listed in the attributes
  ns <- attr(xml2::xml_ns(body), "names")[[1]]

  # Find the end of the challenge block ----------------------------------------
  block <- glue::glue(".//{ns}code_block")
  if (is.null(attr)) {
    challenge <- block
  } else if (is.null(type)) {
    challenge <- glue::glue("{block}[{attr}]")
  } else {
    type <- if (attr == "@ktag") glue::glue("{: <type>", .open = "<", .close = ">") else type
    predicate <- glue::glue("starts-with({attr},'{type}')")
    challenge <- glue::glue("{block}[{predicate}]")
  }

  # Combine and search ---------------------------------------------------------
  xml2::xml_find_all(body, challenge)

}
