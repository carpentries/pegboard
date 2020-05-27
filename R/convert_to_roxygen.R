#' Convert a given block quote to roxygen template
#'
#' @param block a block quote element
#' @param token the token to use to indicate markdown text over code
#'
#' @return the block, converted to a code block
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' frg <- Lesson$new(lesson_fragment())
#' blo <- frg$episodes$`14-looping-data-sets.md`$get_blocks()[[2]]
#' convert_to_roxygen(blo)
#' }
convert_to_roxygen <- function(block, token = "#'") {
  # Thoughts on this:
  #
  # xslt::xml_xslt(thing, stylesheet) acts on a document and will parse the
  # markdown text FO FREE. The only catch is that it needs a document, but we
  # can simply just copy the document and remove all the elements but what we
  # want to act on.
  #
  # steps:
  #
  # 1. copy document
  ns  <- NS(block)
  cpy <- xml2::xml_new_root(xml2::xml_root(block))

  # 2. remove all but the block we are focusing on
  isolate_kram_blocks(
    cpy,
    glue::glue("[@sourcepos='{xml2::xml_attr(block, 'sourcepos')}']")
  )

  # 3. Tag the first child as a solution
  sln <- glue::glue(".//<ns>:block_quote[@ktag='{: .solution}']",
    .open  = "<",
    .close = ">"
  )
  stags <- xml2::xml_find_all(cpy, glue::glue("{sln}/descendant::*[1]"))
  if (length(stags) > 0) {
    purrr::walk(stags, xml2::xml_set_attr, "xygen", "solution")
  }

  # 4. Tag the first sibling as a  challenge
  ctags <- xml2::xml_find_all(cpy, glue::glue("{sln}/following-sibling::*[1]"))
  if (length(ctags) > 0) {
    purrr::walk(ctags, xml2::xml_set_attr, "xygen", "challenge")
  }

  # 5. elevate the children in the document (removing block quotes)
  purrr::walk(xml2::xml_find_all(cpy, sln), elevate_children)
  elevate_children(xml2::xml_children(cpy))

  # 6. parse the document with xslt
  stysh <- xml2::read_xml(get_stylesheet("xml2md_roxy.xsl"))

  to_comment <- glue::glue(".//{ns}:*[parent::{ns}:document]")
  not_code   <- glue::glue("[not(ancestor-or-self::{ns}:code_block)]")
  nblks     <- xml2::xml_find_all(cpy, glue::glue("{to_comment}{not_code}"))
  xml2::xml_set_attr(nblks, "comment", token)

  txt <- xslt::xml_xslt(cpy, stysh)
  txt <- gsub(glue::glue("{token} {token}"), token, txt, fixed = TRUE)
  # fix closing code fences
  txt <- gsub(glue::glue("```\\n{splinter(token)}"), token, txt)
  # fix code fence before code
  txt <- gsub("\\n\\n?```(?!$)", "\n#+\\1", txt, perl = TRUE)
  # fix all remaing code fences
  txt <- gsub("```(\\n?)", glue::glue("{token}"), txt)
  # add challenge roxygen tag
  block_type <- gsub("[{: .}]", "", xml2::xml_attr(block, "ktag"))
  txt <- glue::glue("{token} @{block_type}\n{txt}")

  # 7. rename the challenge node to be a code_block
  xml2::xml_set_name(block, "code_block")
  xml2::xml_set_attr(block, "info", block_type)
  # 8. remove the children of that node
  xml2::xml_remove(xml2::xml_children(block))
  # 9. add the parsed text as the text of the challenge code block
  xml2::xml_set_text(block, txt)
  invisible(block)
}
