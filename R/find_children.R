#' Detect the child files of an Episode object
#'
#' @description 
#'  - `find_children()` returns the _immediate_ children for any given Episode
#'    object. 
#'  - `trace_children()` is used _after processing_ in the context of a Lesson
#'     to trace the entire lineage from a source parent episode.
#'
#' @param parent an [Episode] or [tinkr::yarn] object (`trace_children()`
#'   requires an `Episode` object).
#' @param lsn a [Lesson] object that contains the `parent` and all its children.
#' @return a character vector of the absolute paths to child files.
#'
#' @details 
#'
#' It is possible to define [child
#' documents](https://bookdown.org/yihui/rmarkdown-cookbook/child-document.html)
#' in \pkg{knitr} documents by using the `child` attribute in code chunks. For
#' example, let's say we have a file called `episodes/parent.Rmd`:
#' 
#' ````markdown
#' This content is from _a child document_:
#' 
#' ```{r child = "files/the-child.Rmd"}
#' ```
#' `````
#'
#' where `files/the-child.Rmd` is relative to `episodes/parent.Rmd`
#'
#' The `find_children()` function will extract the immediate children from
#' a single [Episode] object (in this case, it will return
#' `/path/to/episodes/files/the-child.Rmd`), but it will not detect any further
#' descendants. To detect the entire lineage, the Episode must be read in the
#' context of a Lesson (or processed with [load_children()]). 
#'
#' This function is used during Episode initialisation to populate the 
#' `$children` element of the `Episode` object, which lists paths to the
#' known children for further processing.
#'
#' ## Tracing full lineages
#'
#' It is possible for a child document to have further children defined:
#'
#' ````markdown
#' This is the first child. The following content is from the grandchild:
#'
#' ```{r child = "the-grandchild.md"}
#' ```
#' ````
#' 
#' When an Episode is read _in the context of a Lesson_, the children are
#' processed with [load_children()] so that each file with children will have a
#' non-zero value of the `$children` element. We recurse through the `$children`
#' element in the [Lesson] object to exhaust the search for the children files.
#'
#' The `trace_children()` will return the entire lineage for a given _parent_
#' file. Which, in the case of the examples defined above would be:
#' `/path/to/episodes/parent.Rmd`, `/path/to/episodes/files/the-child.Rmd`,
#' and `/path/to/episodes/the-grandchild.md`. 
#'
#' ## NOTE
#'
#' For standard lessons, child files are written relative to the parent file. 
#' Usually, these child files will be in the `files` folder under their parent
#' folder. Overview lessons are a little different. For overview lessons (in
#' The Workbench, these are lessons which contain `overview: true` in
#' config.yaml), the child files may point to `files/child.md`, but in reality,
#' the child file is at the root of the lesson `../files/child.md`. We correct
#' for this by first checking that the child files exist and if they don't
#' defaulting to the top of the lesson. 
#'
#' @keywords internal
#' @rdname find_children
#' @examples
#' # needed for using internal functions: loading the namespace
#' pb <- asNamespace("pegboard")
#' # This example demonstrates a child document with another child document
#' # nested inside. First, we demonstrate how `find_children()` only returns
#' # the immediate children and then we demonstrate how the full lineage is
#' # extracted in the Lesson object.
#' #
#' # `find_children()` --------------------------------------------------------
#' ex <- lesson_fragment("sandpaper-fragment-with-child")
#' 
#' # The introduction has a single child file
#' intro <- tinkr::yarn$new(fs::path(ex, "episodes", "intro.Rmd"))
#' intro$head(21) # show the child file
#' pb$find_children(intro)
#' # this is identical to the `$children` element of an Episode object
#' ep <- Episode$new(fs::path(ex, "episodes", "intro.Rmd"))
#' ep$children
#' 
#' # Loading the child file reveals another child
#' child <- Episode$new(ep$children[[1]])
#' child$children
#' child$show()
#' 
#' # `trace_children()` -------------------------------------------------------
#' # In the context of the lesson, we can find all the descendants
#' lsn <- Lesson$new(ex, jekyll = FALSE)
#' pb$trace_children(ep, lsn)
#' # This is the same as using the method of the same name in the Lesson object
#' # using the path to the episode
#' lsn$trace_lineage(ep$path)
#' # show the children
#' purrr::walk(lsn$children, function(ep) {
#'     message("----", ep$path, "----")
#'     ep$show()
#'   }
#' )
find_children <- function(parent) {
  code_blocks <- get_code(parent$body, type = NULL, attr = NULL)
  children <- child_file_from_code_blocks(code_blocks)
  any_children <- length(children) > 0L
  if (any_children) {
    # create the absolute path to the children nodes
    abs_children <- fs::path_abs(children, start = fs::path_dir(parent$path))
    # NOTE: this is a kludge that we have to use for overview lessons.
    # if children do not exist, then put them in the path of the lesson, which
    # will contain a global folder maybe
    exists <- fs::file_exists(abs_children)
    if (any(!exists)) {
      abs_children[!exists] <- fs::path_abs(children[!exists],
        start = parent$lesson
      )
    }
    children <- abs_children
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
#' @rdname find_children
trace_children <- function(parent, lsn) {
  if (parent$has_children) {
    children <- purrr::map(lsn$children[parent$children], trace_children, lsn)
    children <- c(parent$path, purrr::list_c(children))
  } else {
    children <- parent$path
  }
  return(children)
}

#' Recursively Load Child Documents
#'
#' @description
#'
#' Process a list of [Episode] objects to do two things:
#'   1. recursively read in the child documents declared in the parent
#'      documents
#'   2. for each child, update the `$parent` and `$build_parent` elements 
#' 
#' @param parent an [Episode] object
#' @param child an [Episode] object
#' @param all_parents a list of [Episode] objects
#' @param all_children a list of [Episode] objects
#' @return a list of [Episode] objects from the children. If no children exist,
#'   then this is `NULL`. In the case of `add_parent()`, this is called for its
#'   side-effect to update the child object and it always returns `NULL`. 
#'
#' @details
#' 
#' When we want to build lessons, it's important to be able to find all of the
#' files that are necessary to build a particular file. If there is a modification in a child file, \pkg{sandpaper} needs to know that it should flag the parent
#' for rebuilding. To do this, we need two pieces of information:
#'
#' 1. The earliest ancestors of a given child file
#' 2. The full list of descendants of a given parent file
#'
#' Each Episode object only knows about itself, so it can only report its
#' immediate children, but not the children of children, or even its parent
#' (unless we explicitly tell it what its parent is). The [Lesson] object
#' contains the context of all of the Episodes and can provide this information.
#'
#' During Lesson object initialisation, the `load_children()` function is
#' called to process all source files for their children. This creates an 
#' empty list of children that is continuously appended to during the function
#' call. It then calls `read_children()` on each parent file, which will append
#' itself as a parent to any existing children in the `all_children` list, 
#' intitialize new [Episode] objects from the unread child files, and then
#' search those for children until there are no children left to read. 
#'
#' @keywords internal
#' @seealso [find_children()] for details on how child documents are discovered
#' @rdname load_children
#' @examples
#' # needed for using internal functions: loading the namespace
#' pb <- asNamespace("pegboard")
#' ex <- lesson_fragment("sandpaper-fragment-with-child")
#' lsn <- Lesson$new(ex, jekyll = FALSE)
#' children <- pb$load_children(lsn$episodes)
#'
#' # load_children will start from scratch, so it will produce new Episode files
#' identical(names(children), names(lsn$children))
#' purrr::map2(children, lsn$children, identical)
#' 
#' # read children takes in a list of children episodes and appends that list
#' # with the descendants
#'
#' # given a full list of children, it will return the same list
#' these_children <- pb$read_children(lsn$episodes[[1]], children)
#' purrr::map2(these_children, children, identical)
#' 
#' # given a partial list, it will append to it
#' new_children <- pb$read_children(lsn$episodes[[1]], children[1])
#' purrr::map2(new_children, children, identical)
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
#' @rdname load_children
read_children <- function(parent, all_children = list(), ...) {
  # if the parent has no children, return NULL. This is the exit condition
  no_children <- !parent$has_children
  if (no_children) {
    return(NULL)
  }
  # register existing parents with existing children
  existing <- intersect(parent$children, names(all_children))
  purrr::walk(all_children[existing], add_parent, parent)
  # If there are children, recursively load them and place them in a list
  for (child in parent$children) {
    # check if the child already exists in our list ---------------------
    known_children <- names(all_children)
    new_child <- !child %in% known_children
    if (new_child) {
      # read in the new child with a parent listed
      this_child <- Episode$new(child, parent = list(parent), ...)
    } else {
      # add the parent to the existing child
      this_child <- all_children[[child]]
    }

    # check if the child has any children that we know about ------------
    new_children <- setdiff(this_child$children, known_children)
    any_new_children <- length(new_children) > 0L
    if (any_new_children) {
      # generate a new list, but this will contain the objects from the 
      # original list that we can filter out and use to append
      additional_children <- read_children(this_child, all_children, ...)
      additional_children <- additional_children[new_children]
    } else {
      additional_children <- NULL
    }

    # make sure all children of this child have it as a parent -----------
    purrr::walk(all_children[this_child$children], add_parent, this_child)

    # append the all children list ---------------------------------------
    all_children <- c(
      all_children, # our existing list of children
      stats::setNames(list(this_child), child), # the current child 
      additional_children # children of the current child (which can be NULL)
    )
  }
  # only return the unique files
  return(all_children[unique(names(all_children))])
}

# update the `$parents` and `$build_parents` fields of a child object with the
# information from a parent object.
#' @rdname load_children
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

