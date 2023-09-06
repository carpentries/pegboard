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

read_children <- function(parent, all_children = list(), ...) {
  # if the parent has no children, return NULL. This is the exit condition
  no_children <- !parent$has_children
  if (no_children) {
    return(NULL)
  }
  # register existing parents
  existing <- intersect(parent$children, names(all_children))
  purrr::walk(all_children[existing], add_parent, parent$path)

  # get new children
  new_children <- setdiff(parent$children, names(all_children))

  # If there are children, recursively load them and place them in a list 
  for (child in new_children) {
    # place the child in a list and name it
    this_child <- list(Episode$new(child, parent = parent$path, ...))
    names(this_child) <- child
    # recurse to check for children of this child
    children <- read_children(this_child[[child]], ...)
    # if there are any children, we need to append them to the list
    if (length(children) > 0L) {
      # find the existing children
      existing <- intersect(names(children), names(all_children))
      # append the parents
      purrr::walk(all_children[existing], add_parent, 
        parent = this_child[[child]]$path)
      # discard the new children
      children[existing] <- NULL
      this_child <- c(this_child, children)
    }
    all_children <- c(all_children, this_child)
  }
  # only return the unique files
  return(all_children)
}

add_parent <- function(child, parent_path) {
  child$parents <- c(child$parents, parent_path)
} 


