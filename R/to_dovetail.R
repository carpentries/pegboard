#' Convert a given block quote to dovetail template
#'
#' The {dovetail} package allows people to write block quotes as code blocks
#' formatted in {roxygen2} syntax. This internal function takes a block quote
#' element, elevates all the child elements, converts the block quote to a code
#' block and uses a custom xslt stylesheet to render the children of the block
#' to roxygen-formatted text and code.
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
#' to_dovetail(blo)
#' cat(xml2::xml_text(blo))
#' }
to_dovetail <- function(block, token = "#'") {
  # Thoughts on this:
  #
  # xslt::xml_xslt(thing, stylesheet) acts on a document and will parse the
  # markdown text FO FREE. The only catch is that it needs a document, but we
  # can simply just copy the document and remove all the elements but what we
  # want to act on.
  #
  # steps:
  #
  # 1. copy document and process Rmd code blocks
  ns  <- NS(block)
  block_type <- gsub("[{}: .]", "", xml2::xml_attr(block, "ktag"))
  copy_xml <- "tinkr" %:% "copy_xml"
  cpy <- copy_xml(xml2::xml_root(block))
  rcd <- xml2::xml_find_all(cpy, glue::glue(".//{ns}code_block[@language]"))
  purrr::walk(rcd, "tinkr" %:% "to_info")


  # 2. remove all but the block we are focusing on
  isolate_kram_blocks(
    cpy,
    glue::glue("[@sourcepos='{xml2::xml_attr(block, 'sourcepos')}']")
  )

  # 3. Tag the first child as a solution
  sln <- glue::glue(".//<ns>block_quote[@ktag='{: .solution}']",
    .open  = "<",
    .close = ">"
  )
  stags <- xml2::xml_find_all(cpy, glue::glue("{sln}/descendant::*[1]"))
  if (length(stags) > 0) {
    purrr::walk(stags, xml2::xml_set_attr, "xygen", "solution")
  }

  # 4. Tag the first sibling as an end tag
  ctags <- xml2::xml_find_all(cpy, glue::glue("{sln}/following-sibling::*[1]"))
  if (length(ctags) > 0) {
    purrr::walk(ctags, xml2::xml_set_attr, "xygen", "end")
  }

  # 5. elevate the children in the document (removing block quotes)
  purrr::walk(xml2::xml_find_all(cpy, sln), elevate_children)
  elevate_children(xml2::xml_children(cpy))


  # 6. Add tokens as comment attribute
  # Find code blocks that are tagged with xygen tags.
  #
  # This will address the situation where the challenge is only a code block
  # # #' @solution
  # #'
  # #' ## Solution
  # #+
  # total = 0
  # for word in ["red", "green", "blue"]:
  #     total = total + len(word)
  # print(total)
  # #'
  # #' @challenge
  # #+
  # # List of word lengths: ["red", "green", "blue"] => [3, 5, 4]
  # lengths = ____
  # for word in ["red", "green", "blue"]:
  #     lengths.____(____)
  # print(lengths)
  # #'
  # #' @solution
  # #'
  # #' ## Solution
  # #+
  # lengths = []
  # for word in ["red", "green", "blue"]:
  #     lengths.append(len(word))
  # print(lengths)
  # #'
  # Because we don't comment code blocks with the token, we have to add a dummy
  # paragraph before the code block
  oxy_code <- xml2::xml_find_all(cpy, glue::glue(".//{ns}code_block[@xygen]"))
  if (length(oxy_code) > 0) {
    oxy_tags <- glue::glue("@{xml2::xml_attr(oxy_code, 'xygen')}")
    oxy_tags <- purrr::map(oxy_tags, xml_new_paragraph, xml2::xml_ns(cpy))
    # add the paragraphs before the code blocks
    purrr::walk2(
      .x = oxy_code,
      .y = oxy_tags,
      xml2::xml_add_sibling,
      .where = "before"
    )
    # remove the tag from the code block
    purrr::walk(oxy_code, xml2::xml_set_attr, "xygen", NULL)
  }
  # parent is the document
  to_comment <- glue::glue(".//{ns}*[parent::{ns}document]")
  # but skip code blocks
  not_code   <- glue::glue("[not(ancestor-or-self::{ns}code_block)]")
  nblks      <- xml2::xml_find_all(cpy, glue::glue("{to_comment}{not_code}"))
  # set the token as the comment attribute
  xml2::xml_set_attr(nblks, "comment", token)

  # 7. parse the document with xslt
  txt <- xml_to_md(cpy, "xml2md_roxy.xsl")
  # replace all duplicated tokens
  txt <- gsub(glue::glue("{token} {token}"), token, txt, fixed = TRUE)
  # fix opening code fences
  txt <- gsub("\n\n```", "\n#' \n#' ```", txt)
  # fix closing code fenes
  txt <- gsub("\n```", "\n#' ```", txt)

  # 8. rename the challenge node to be a code_block
  xml2::xml_set_name(block, "code_block")
  xml2::xml_set_attr(block, "language", block_type)
  srcpos <- xml2::xml_attr(block, "sourcepos")
  xml2::xml_set_attr(block, "name", glue::glue('"{srcpos}"'))
  xml2::xml_set_attr(block, "ktag", NULL)

  # 9. remove the children of that node
  xml2::xml_remove(xml2::xml_children(block))
  # 10. add the parsed text as the text of the challenge code block
  xml2::xml_set_text(block, txt)
  invisible(block)
}
