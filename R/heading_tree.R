#' This constructs a data frame of headings for displaying to the user
#' via the CLI package.
#'
#' @param headings an object of class ``
heading_tree <- function(headings) {
  if (!requireNamespace("cli")) {
    return(headings)
  }

  hlevels <- as.integer(xml2::xml_attr(headings, "level"))
  hnames  <- xml2::xml_text(headings)
  hlabels <- vapply(hlevels, switch, character(1),
    `1` = "\033[2m#\033[22m",
    `2` = "\033[2m##\033[22m",
    `3` = "\033[2m###\033[22m",
    `4` = "\033[2m####\033[22m",
    `5` = "\033[2m#####\033[22m",
    `6` = "\033[2m######\033[22m" 
  )
  hnames  <- c("<LESSON>", paste(hlabels, hnames))
  hlevels <- c(0L, hlevels)
  htree   <- data.frame(
    heading = hnames,
    children = I(vector(mode = "list", length = length(hnames)))
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
  has_kids <- lengths(htree$children) != 0
  not_a_child <- !htree$heading %in% all_children
  htree$children[[1]] <- htree$heading[has_kids | not_a_child][-1]

  htree
}

