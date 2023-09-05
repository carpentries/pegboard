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

read_children <- function(parent, ...) {
  # if the parent has no children, return NULL. This is the exit condition
  no_children <- !parent$has_children
  if (no_children) {
    return(NULL)
  }
  # If there are children, recursively load them and place them in a list 
  res <- list()
  for (child in parent$children) {
    # place the child in a list and name it
    this_child <- list(Episode$new(child, parent = parent$path, ...))
    names(this_child) <- child
    children <- read_children(this_child[[child]], ...)
    # if there are any children, we need to append them to the list
    if (length(children) > 0L) {
      this_child <- c(this_child, children)
    }
    res <- c(res, this_child)
  }
  # only return the unique files
  return(res[unique(names(res))])
}
