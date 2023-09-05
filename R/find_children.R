find_children <- function(ep) {
  code_blocks <- get_code(ep$body, type = NULL, attr = NULL)
  children <- child_file_from_code_blocks(code_blocks)
  any_children <- length(children) > 0L
  if (any_children) {
    # create the absolute path to the children nodes
    children <- fs::path_abs(children, fs::path_dir(ep$path))
  }
  return(children)
}
# get the child file from code block if it exists
child_file_from_code_blocks <- function(nodes) {
  use_children <- xml2::xml_has_attr(nodes, "child")
  if (any(use_children)) {
    nodes <- nodes[use_children]
    res <- gsub("[\"']", "", xml2::xml_attr(nodes, "child"))
  } else {
    character(0)
  }
}
