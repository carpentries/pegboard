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

# trace the lineage of a source file and return a recursive list of children
# files. This assumes that the lesson has been set up to process children
trace_children <- function(child, lsn) {
  if (child$has_children) {
    children <- purrr::map(lsn$children[child$children], trace_children, lsn)
    children <- c(child$path, purrr::list_c(children))
  } else {
    children <- child$path
  }
  return(children)
}

# Loop through a list of parent Episode objects and return a list of Episode
# objects that represent their children. If there are no children, this is NULL
load_children <- function(all_parents) {
  have_children <- purrr::map_lgl(all_parents, "has_children")
  # if there are any children, we need to account for those.
  if (any(have_children)) {
    the_children <- list()
    for (parent in all_parents[have_children]) {
      the_children <- read_children(parent, the_children)
    }
  } else {
    the_children <- NULL
  }
  return(the_children)
}

# Read in and/or update all recursive child files for a given parent
read_children <- function(parent, all_children = list(), ...) {
  # if the parent has no children, return NULL. This is the exit condition
  no_children <- !parent$has_children
  if (no_children) {
    return(NULL)
  }
  # register existing parents
  existing <- intersect(parent$children, names(all_children))
  purrr::walk(all_children[existing], add_parent, parent)
  # If there are children, recursively load them and place them in a list 
  for (child in parent$children) {
    # place the child in a list and name it
    known_children <- names(all_children)
    new_child <- !child %in% known_children
    if (new_child) {
      this_child <- Episode$new(child, parent = list(parent), ...)
    } else {
      this_child <- all_children[[child]]
      # Add the parent and build_parent for the child
      add_parent(this_child, parent)
    }
    new_children <- setdiff(this_child$children, known_children)
    any_new_children <- length(new_children) > 0L
    if (any_new_children) {
      # generate a new list, but this will contain the objects from the original
      # list that we can filter out and use to append
      additional_children <- read_children(this_child, all_children, ...)
      additional_children <- additional_children[new_children]
    } else {
      additional_children <- NULL
    }
    purrr::walk(all_children[this_child$children], add_parent, this_child)
    all_children <- c(all_children, 
      stats::setNames(list(this_child), child), 
      additional_children)
  }
  # only return the unique files
  return(all_children[unique(names(all_children))])
}

# update the `$parents` and `$build_parents` fields of a child object with the
# information from a parent object.
add_parent <- function(child, parent) {
  if (length(parent) == 0L) {
    return(invisible(NULL))
  }
  child$parents <- union(child$parents, parent$path)
  parent_is_build_parent <- length(parent$build_parents) == 0L
  # define the build parent which is going to be the furthest ancestors.
  if (parent_is_build_parent) {
    # if the parent has no build parents, then the parent is the build_parent
    new_parents <- parent$path
  } else {
    # if the parent has build parents, then the we pass down the build_parent
    new_parents <- parent$build_parents
  }
  # it is possible for a child to have multiple build parents, so we append here
  child$build_parents <- union(child$build_parents, new_parents)
  return(invisible(NULL))
} 


