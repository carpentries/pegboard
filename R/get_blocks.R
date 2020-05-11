#' Gather blocks from the XML body of a carpentries lesson
#'
#' This will search an XML document for `block_quotes` with the specified type
#' and level and extract them into a nodeset.
#'
#' @param body the XML body of a carpentries lesson (an xml2 object)
#' @param type the type of block quote in the Jekyll syntax like ".challenge",
#'   ".discussion", or ".solution"
#' @param level the level of the block within the document. Defaults to `1`,
#'   which represents all of the block_quotes are not nested within any other
#'   block quotes. Increase the nubmer to increase the level of nesting.
#'
#' @export
#'
#' @return an xml nodeset object with each element representing a blockquote
#'   that matched the input criteria.
#'
#' @note At the moment, blocks are returned at the specified level. If you
#'   select `type = ".solution", level = 1`, you will receive blocks that
#'   *contain* solution blocks even though these blocks are almost always nested
#'   within other blocks.
#'
#' @examples
#' frg <- Lesson$new(lesson_fragment())
#' # Find all the blocks in the
#' get_blocks(frg$episodes[["17-scope.md"]]$body)
get_blocks <- function(body, type = NULL, level = 1) {

  # Namespace for the document is listed in the attributes
  ns <- attr(xml2::xml_ns(body), "names")[[1]]

  # Gather all block quotes with increasing nesting levels
  BLOCK_QUOTE <- glue::glue("{ns}:block_quote")
  IS_TYPE     <- block_type(ns = ns, type = type)
  # "chip off the ol' block"
  OL_BLOCK    <- glue::glue("ancestor::{BLOCK_QUOTE}")
  LEVEL       <- glue::glue(switch(level,
    # Level 1: not nested in another block
    "1" = "[ not({OL_BLOCK}) ]",
    # Level 2: nested in one block, but not another
    "2" = "[ {OL_BLOCK}[not({OL_BLOCK})] ]",
    # Level 3: nested within two blocks (not expected)
    "3" = "[ {OL_BLOCK}[{OL_BLOCK}[not({OL_BLOCK})]] ]"
  ))

  # Now we can search with the two predicates.
  BLOCKS <- glue::glue(".//{BLOCK_QUOTE}{LEVEL}{IS_TYPE}")

  xml2::xml_find_all(body, BLOCKS)
}
