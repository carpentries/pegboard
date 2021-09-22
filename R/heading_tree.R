#' This constructs a data frame of headings for displaying to the user
#' via the CLI package.
#'
#' @param headings a table of headings that contains headings with the text of
#'   the heading, the level and the position
#' @return a data frame with two columns:
#'  - heading: the text of the heading with ATX header levels prepended
#'  - children: a column of lists indicating the immediate children of the 
#'    heading. This is used to display a fancy tree from the cli package. 
#' @noRd
heading_tree <- function(htab, lname = NULL, suffix = NULL) {

  lname   <- if (is.null(lname)) "<EPISODE>" else dQuote(lname)
  hnames  <- c(lname, htab$heading)
  hlevels <- c(1L, htab$level)
  hlabels <- vapply(hlevels, switch, character(1),
    `1` = "#",
    `2` = "##",
    `3` = "###",
    `4` = "####",
    `5` = "#####",
    `6` = "######" 
  )
  hlevels[1] <- 0L
  hlabels[1] <- "# Episode:"
  hnames <- paste(hlabels, hnames)
  htree <- data.frame(
    heading  = hnames,
    children = I(vector(mode = "list", length = length(hnames))),
    labels   = paste(hnames, suffix),
    level    = hlevels,
    stringsAsFactors = FALSE
  )

  n <- nrow(htree)

  for (heading in seq(n)) {
    parent_level <- hlevels[heading]
    child <- heading + 1L
    if (child <= n) {
      child_level <- hlevels[child]
    }
    # Logical vector for subsetting that contains all the immediate children
    # of a parent node.
    child_ids <- logical(n)
    while (child_level > parent_level && child <= n) {
      # collect children
      child_ids[child] <- TRUE
      child <- child + 1L
      # When the next child is actually a grandchild,
      # we skip it for the next iteration.
      if (child > n) {
        break
      }
      if (hlevels[child] > child_level) {
        child <- child + 1L
      }
      child_level <- hlevels[child]
    }
    htree$children[[heading]] <- hnames[child_ids]
  }

  # Final trimming. The top root must only contain immediate children
  all_children <- unique(unlist(htree$children[-1], use.names = FALSE))
  has_kids     <- lengths(htree$children) != 0
  not_a_child  <- !htree$heading %in% all_children
  htree$children[[1]] <- htree$heading[has_kids | not_a_child][-1]

  htree
}

label_duplicates <- function(htree, cli = FALSE) {

  get_duplicated <- function(i) duplicated(i) | duplicated(i, fromLast = TRUE)
  the_clones <- lapply(htree$children, get_duplicated)
  has_twins <- vapply(the_clones, any, logical(1))

  dtree <- htree$labels
  for (i in which(has_twins)) {
    this_level     <- htree$level[i]
    the_children   <- htree$level == this_level + if (this_level == 0L) 2L else 1L
    the_duplicated <- the_children & get_duplicated(htree$heading)
    dtree          <- append_labels(
      l = dtree,
      i = the_duplicated,
      e = if (cli) cli::style_inverse("(duplicated)") else "(duplicated)",
      cli = FALSE
    )
    # This part is needed to fix a feature in CLI that assumes unordered data
    # 
    # If there is a child of a duplicated node, CLI does not know where to put
    # that child and will not print it.
    #
    # Here, we are adding the number of children to the heading so that CLI can
    # identify it as unique entity and respect its children.
    these_headings <- htree$heading[the_duplicated]
    these_children <- htree$children[[i]][the_clones[[i]]]
    if (identical(these_headings, these_children)) {
      grandchildren <- lengths(htree$children[the_duplicated])
      new_ids       <- paste(these_headings, grandchildren)
      htree$heading[the_duplicated]        <- new_ids
      htree$children[[i]][the_clones[[i]]] <- new_ids
    }
  }
  htree$labels <- dtree
  list(test = !any(has_twins), tree = htree)
}


