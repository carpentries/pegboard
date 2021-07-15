#' This constructs a data frame of headings for displaying to the user
#' via the CLI package.
#'
#' @param headings an object of class `xml_nodelist`
#' @return a data frame with two columns:
#'  - heading: the text of the heading with ATX header levels prepended
#'  - children: a column of lists indicating the immediate children of the 
#'    heading. This is used to display a fancy tree from the cli package. 
#' @noRd
heading_tree <- function(headings) {
  if (!requireNamespace("cli")) {
    return(headings)
  }

  hlevels <- as.integer(xml2::xml_attr(headings, "level"))
  hnames  <- xml2::xml_text(headings)
  hlabels <- vapply(hlevels, switch, character(1),
    `1` = "#",
    `2` = "##",
    `3` = "###",
    `4` = "####",
    `5` = "#####",
    `6` = "######" 
  )
  hnames  <- c("<LESSON>", paste(hlabels, hnames))
  hlevels <- c(0L, hlevels)
  htree   <- data.frame(
    heading = hnames,
    children = I(vector(mode = "list", length = length(hnames))),
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
  has_kids <- lengths(htree$children) != 0
  not_a_child <- !htree$heading %in% all_children
  htree$children[[1]] <- htree$heading[has_kids | not_a_child][-1]

  htree
}

