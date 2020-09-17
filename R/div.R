#' Create an xml document that contains two html_block elements 
#' that contain div tags. 
#'
#' @param what the class of block
#' @return an xml document with commonmark namespace
#' @keywords internal
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [make_pairs()] for connecting open and closing tags
#' [get_div_levels()] for documenting the level of div tags
#' @examples
#' cha <- pegboard:::make_div("challenge")
#' cha
#' cat(pegboard:::xml_to_md(cha))
make_div <- function(what) {
  div <- glue::glue('<div class="{what}">\n\n</div>')
  div <- commonmark::markdown_xml(div)
  xml2::read_xml(div)
}


#' Replace a blockquote with a div tag
#'
#' This modifies a document to replace a blockquote element with a div element
#'
#' @param block a blockquote element
#' @return the children of the element, invisibly
#' @keywords internal div
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [make_pairs()] for connecting open and closing tags
#' [get_div_levels()] for documenting the level of div tags
#' @examples
#' frg <- Lesson$new(lesson_fragment())
#' lop <- frg$episodes$`14-looping-data-sets.md`
#' xml2::xml_find_all(lop$body, ".//d1:html_block")
#' lop$get_blocks(level = 1)
#' lop$get_blocks(level = 2)
#' purrr::walk(lop$get_blocks(level = 2), pegboard:::replace_with_div)
#' purrr::walk(lop$get_blocks(level = 1), pegboard:::replace_with_div)
#' lop$get_blocks()
#' xml2::xml_find_all(lop$body, ".//d1:html_block")
#' # add tags
#' pegboard:::label_div_tags(lop$body)
#' xml2::xml_find_all(lop$body, ".//d1:html_block")
replace_with_div <- function(block) {
  # Grab the type of block and filter out markup
  type <- gsub("[{:}.]", "", xml2::xml_attr(block, "ktag"))
  # make a div tag
  div   <- make_div(type)
  open  <- xml2::xml_child(div, 1)
  close <- xml2::xml_child(div, 2)
  xml2::xml_add_sibling(block, open, .where = "before")
  xml2::xml_add_sibling(block, close, .where = "after")
  elevate_children(block)
}


#' Get paired div blocks 
#' 
#' @details
#' The strategy behind this is to :
#'
#'  1. find all `dtag` elements, which will necessarily be <html_block> elements
#'     containing div tags
#'  2. grab the first tag of each pair
#'  3. filter on div tag class (type)
#'  4. grab all elements between the tags
#'
#' @param body an xml document
#' @param type the type of div to return
#' @return a list of nodesets
#' @keywords internal div
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [make_pairs()] for connecting open and closing tags
#' [get_div_levels()] for documenting the level of div tags
#' @examples
#' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
#' loop$body # a full document with block quotes and code blocks, etc
#' loop$unblock() # removing blockquotes and replacing with div tags
#' pegboard:::get_divs(loop$body, 'challenge') # all challenge blocks
#' pegboard:::get_divs(loop$body, 'solution') # all solution blocks
get_divs <- function(body, type = NULL){
  ns    <- NS(body)
  # 1. Find tags
  nodes <- xml2::xml_find_all(body, ".//@dtag")
  tags  <- xml2::xml_text(nodes)
  # 2. Get the first tag of each pair
  utags <- !duplicated(tags)
  # 3. Find div classes
  prent <- xml2::xml_parent(nodes)
  prent <- xml2::xml_text(prent)
  types <- if (is.null(type)) TRUE else grepl(type, prent)
  # 4. Extract nodes between tags
  valid <- utags & types
  res   <- purrr::map(tags[valid], find_between_tags, body, ns)
  names(res) <- glue::glue("{tags}-{get_div_class(prent)}")[valid]
  res
}

#' Find nodes between two nodes with a given dtag
#'
#' @param tag an integer representing a unique dtag attribute
#' @param body an xml document
#' @param ns the namespace from the body
#' @return a nodeset between tags that have the dtag attribute matching `tag`
#' @keywords internal div
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [make_pairs()] for connecting open and closing tags
#' [get_div_levels()] for documenting the level of div tags
#' @examples
#' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
#' loop$body # a full document with block quotes and code blocks, etc
#' loop$unblock() # removing blockquotes and replacing with div tags
#' # find all the div tags
#' tags <- xml2::xml_text(xml2::xml_find_all(loop$body, ".//@dtag"))
#' tags
#' # grab the contents of the first div tag
#' pegboard:::find_between_tags(tags, loop$body, pegboard:::NS(loop$body))
find_between_tags <- function(tag, body, ns) {
  block  <- glue::glue("{ns}:html_block[@dtag='{tag}']")
  after  <- "following-sibling::"
  before <- "preceding-sibling::"
  after_first_tag <- glue::glue("{after}{block}")
  before_last_tag <- glue::glue("{before}*[{before}{block}]")
  xpath <- glue::glue(".//{after_first_tag}/{before_last_tag}")
  xml2::xml_find_all(body, xpath)
}

#' Add labels to div tags in the form of a "dtag" attribute
#' 
#' @param body an xml document
#' @return the document, invisibly
#' @keywords internal
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [make_pairs()] for connecting open and closing tags
#' [get_div_levels()] for documenting the level of div tags
label_div_tags <- function(body) {
  clean_div_tags(body)
  ns     <- NS(body)
  xpath  <- glue::glue(".//{ns}:html_block[contains(text(), 'div')]")
  nodes  <- xml2::xml_find_all(body, xpath)
  ntext  <- xml2::xml_text(nodes)
  labels <- make_pairs(ntext)
  xml2::xml_set_attr(nodes, "dtag", glue::glue("div-{labels}"))
  invisible(body)
}

#' Clean the div tags from an xml document
#'
#' @param body an xml document
#' @return an xml document
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [make_pairs()] for connecting open and closing tags
#' [get_div_levels()] for documenting the level of div tags
#' @details
#'
#' Commonmark knows what raw HTML looks like and will read it in as an HTML
#' block, escaping the tag. it does this for every HTML tag that is preceded by
#' a blank line, so this: `<div class='hello'>\n\n</div>` becomes two html_block
#' elements
#' 
#' ```
#' <html_block>
#'   &lt;div class='hello'&gt;\n
#' </html_block>
#' <html_block>
#'   &lt;/div&gt;\n
#' </html_block>
#' ```
#'
#' However, if an element is not preceded by a non-html element, it becomes
#' part of that html element. So this `<div class='hello'>\n</div>` becomes a 
#' single html_block element:
#'
#' ```
#' <html_block>
#'   &lt;div class='hello'&gt;\n&lt;/div&gt;\n
#' </html_block>
#' ```
#' 
#' Sometimes, this process can gobble up text that is markdown instead of HTML,
#'
#' This function will find multiple tags in HTML blocks and separates them into
#' different blocks. 
#'
#' @keywords internal
#' @examples
#' txt <- " 
#' <div class='challenge'>
#' ## Challenge
#' 
#' do that challenging thing.
#' 
#' ```{r}
#' cat('it might be challenging to do this')
#' ```
#' <div class='solution'>
#' ```{r}
#' It's not that challenging
#' ```
#' </div>
#' <div class='solution'>
#' We just have to try harder and use `<div>` tags
#' 
#' ```{r}
#' cat('better faster stronger with <div>')
#' ```
#' <img src='https://carpentries.org/logo.svg'/>
#' 
#' </div>
#' </div>
#'
#' <div class='good'>
#'
#' ## Good divs
#'
#' </div>
#' 
#' "
#' library(purrr)
#' library(xml2)
#' 
#' f <- tempfile()
#' writeLines(txt, f)
#' ex <- tinkr::to_xml(f)
#' xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
#' pegboard:::clean_div_tags(ex$body)
#' xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
#' pegboard:::label_div_tags(ex$body)
#' xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
clean_div_tags <- function(body) {
  # Find all the multi-div tags and replace newlines with double newlines
  d   <- xml2::xml_find_all(body, ".//d1:html_block[contains(text(), 'div')]")
  # regex checks for closed divs with something after them
  d   <- d[grepl('div(.+?)?[>]\n ?.', xml2::xml_text(d))]
  txt <- gsub("[>]\n(?!$)", ">\n\n", xml2::xml_text(d), perl = TRUE)
  txt <- gsub("\n[<]", "\n\n<", txt, perl = TRUE)

  # convert text to xml
  nodelist <- purrr::map(txt, ~xml2::read_xml(commonmark::markdown_xml(.x)))

  # replace the nodes
  for (i in seq_along(nodelist)) {
    nodes <- xml2::xml_children(nodelist[[i]])
    walk(nodes, ~xml2::xml_add_sibling(d[[i]], .x, .where = "before"))
    xml2::xml_remove(d[[i]])
  }
  invisible(body)
}
#' Get levels of a character vector of div tags
#'
#' @param nodes a character vector of div open and close tags
#' @return an integer vector indicating the depth of the tags where 0 indicates
#'   a closing tag
#' @keywords internal
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [make_pairs()] for connecting open and closing tags
#' @examples
#' nodes <- c(
#' "<div class='1'>", 
#'   "<div class='2'>" , 
#'   "</div>", 
#'   "<div class='2'>", 
#'     "<div class='3'>", 
#'     "</div>", 
#'   "</div>", 
#' "</div>")
#' pegboard:::get_div_levels(nodes)
get_div_levels <- function(nodes) {
  levels <- rep(0, length(nodes))
  opener <- grepl("class", nodes)
  nodestring <- paste(nodes, collapse = "")
  x <- xml2::read_xml(glue::glue("<document>{nodestring}</document>"))
  divs <- xml2::xml_find_all(x, ".//div")
  labels <- purrr::map_int(divs, find_node_level)
  levels[opener] <- labels
  levels
}

#' Make paired labels for opening and closing div tags
#'
#' @param nodes a character vector of div open and close tags
#' @return an integer vector with pairs of labels for each opening and closing
#'   tag. Note that the labels are produced by doing a cumulative sum of the
#'   node depths.
#' @keywords internal
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [make_pairs()] for connecting open and closing tags
#' [get_div_levels()] for documenting the level of div tags
#' @examples
#' nodes <- c(
#' "<div class='1'>", 
#'   "<div class='2'>" , 
#'   "</div>", 
#'   "<div class='2'>", 
#'     "<div class='3'>", 
#'     "</div>", 
#'   "</div>", 
#' "</div>")
#' pegboard:::make_pairs(nodes)
make_pairs <- function(nodes) {
  depths <- get_div_levels(nodes)
  n      <- length(nodes)
  opened <- depths > 0
  
  # Create unique labels for our div tags
  nzlevels <- depths[opened]
  labels   <- cumsum(nzlevels)

  # The label list is needed to populate our closing tags
  label_list <- split(labels, nzlevels)

  # loop over labels
  levels <- rev(sort(unique(nzlevels)))
  for (i in levels) {
    to_close <- which(depths == i)
    to_close <- next_zeroes(to_close, depths, n)
    depths[to_close] <- label_list[[i]]
  }

  depths[opened] <- labels
  depths
}

# fint the next zeroes in a vector, given a vector of indices
next_zeroes <- function(i, v, n) {
  vapply(i, next_zero, integer(1), v, n)
}

# find the next zero in a vector
#
# v <- c(1, 2, 0, 3, 0, 4, 5, 0)
# n <- length(v)
# next_zero(1, v, n) # 3
# next_zero(4, v, n) # 5
# next_zero(6, v, n) # 8
next_zero <- function(i, v, n) {
  res <- which(v[seq(i, n)] == 0)[1]
  res <- res - 1L + as.integer(i)
  if (length(res)) res else 0L
}

get_div_class <- function(div) {
  trimws(sub('^.+?class[=]["\']([- a-zA-Z0-9]+?)["\'].+?$', '\\1', div))
}
