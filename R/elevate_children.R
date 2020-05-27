#' elevate all children of a node
#'
#' @param parent an xml node (notably a block quote)
#' @param remove a logical value. If `TRUE` (default), the parent node is
#'   removed from the document.
#'
#' @return the elevated nodes, invisibly
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
#' # get all the challenges (2 blocks)
#' scope$get_blocks(".challenge")
#' b1 <- scope$get_blocks(".challenge")[[1]]
#' elevate_children(b1)
#' # now there is only one block:
#' scope$get_blocks(".challenge")
#' }
elevate_children <- function(parent, remove = TRUE) {
  children <- xml2::xml_contents(parent)
  purrr::walk(
    children,
    ~xml2::xml_add_sibling(parent, .x, .where = "before", .copy = FALSE)
  )
  if (remove) {
    xml2::xml_remove(parent)
  }
  invisible(children)
}
