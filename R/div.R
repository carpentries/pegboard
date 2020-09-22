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
#' [find_div_pairs()] for connecting open and closing tags
#' [clean_fenced_divs()] for cleaning cluttered pandoc div tags
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
#' [find_div_pairs()] for connecting open and closing tags
#' [clean_fenced_divs()] for cleaning cluttered pandoc div tags
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
#' [find_div_pairs()] for connecting open and closing tags
#' [clean_fenced_divs()] for cleaning cluttered pandoc div tags
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
  # 5. Define search pattern
  block <- grepl("^:::", prent)
  block <- ifelse(block, "paragraph", "html_block")
  block <- glue::glue("{block}[@dtag='{{tag}}']")
  res   <- purrr::map2(
    tags[valid], block[valid],
    ~find_between_tags(.x, body, ns, .y)
  )
  names(res) <- tags[valid]
  res
}

#' Find nodes between two nodes with a given dtag
#'
#' @param tag an integer representing a unique dtag attribute
#' @param body an xml document
#' @param ns the namespace from the body
#' @param find an xpath element to search for (without namespace tag)
#' @return a nodeset between tags that have the dtag attribute matching `tag`
#' @keywords internal div
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [find_div_pairs()] for connecting open and closing tags
#' [clean_fenced_divs()] for cleaning cluttered pandoc div tags
#' @examples
#' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
#' loop$body # a full document with block quotes and code blocks, etc
#' loop$unblock() # removing blockquotes and replacing with div tags
#' # find all the div tags
#' tags <- xml2::xml_text(xml2::xml_find_all(loop$body, ".//@dtag"))
#' tags
#' # grab the contents of the first div tag
#' pegboard:::find_between_tags(tags, loop$body, pegboard:::NS(loop$body))
find_between_tags <- function(tag, body, ns, find = "html_block[@dtag='{tag}']") {
  block  <- glue::glue("{ns}:{glue::glue(find)}")
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
#' [find_div_pairs()] for connecting open and closing tags
#' [clean_fenced_divs()] for cleaning cluttered pandoc div tags
label_div_tags <- function(body) {
  # Clean up the div tags 
  body   <- clean_fenced_divs(body)
  body   <- clean_div_tags(body)
  ns     <- NS(body)
  # Find all div tags in html blocks or fenced div tags in paragraphs
  divs   <- ".//{ns}:html_block[contains(text(), '<div') or contains(text(), '</div')]"
  ndiv   <- ".//{ns}:paragraph[{ns}:text[starts-with(text(), ':::')]]"
  xpath  <- glue::glue("{glue::glue(divs)} | {glue::glue(ndiv)}")
  nodes  <- xml2::xml_find_all(body, xpath)
  # TODO: There seems to be a problem with 
  # https://github.com/swcarpentry/python-novice-gapminder/blame/gh-pages/_episodes/01-run-quit.md
  # and fencepost errors finding the last two closing div tags

  # Convert text to labels and add the attributes to the nodes
  ntext  <- xml2::xml_text(nodes)
  labels <- find_div_pairs(ntext)
  types  <- get_div_class(ntext)[!duplicated(labels)]
  labels <- glue::glue("div-{labels}-{types[labels]}")
  xml2::xml_set_attr(nodes, "dtag", labels)
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
#' [find_div_pairs()] for connecting open and closing tags
#' [clean_fenced_divs()] for cleaning cluttered pandoc div tags
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

#' Clean pandoc fenced divs and place them in their own paragraph elements
#'
#' Sometimes pandoc fenced divs are bunched together, which makes it difficult
#' to track the pairs. This separates them into different paragraph elements so
#' that we can track them
#'
#' @param body an xml document
#' @return an xml document
#' @keywords internal
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [find_div_pairs()] for connecting open and closing tags
#' [clean_fenced_divs()] for cleaning cluttered pandoc div tags
#' @examples
#' txt <- "::::::: challenge
#' ## Challenge
#' 
#' do that challenging thing.
#' 
#' ```{r}
#' cat('it might be challenging to do this')
#' ```
#' ::::: solution ::::
#' ```{r}
#' It's not that challenging
#' ```
#' ::::
#' ::: solution ::::::::
#' We just have to try harder and use `<div>` tags
#' 
#' ```{r}
#' cat('better faster stronger with <div>')
#' ```
#' <img src='https://carpentries.org/logo.svg'/>
#' 
#' What if we include some `:::` code in here or ::: like this
#' 
#' :::::
#' :::::
#' 
#' ::: good
#' 
#' ## Good divs
#' 
#' :::"
#' f <- tempfile()
#' writeLines(txt, f)
#' ex <- tinkr::to_xml(f, sourcepos = TRUE)
#' ex$body
#' predicate <- ".//d1:paragraph[d1:text[starts-with(text(), ':::')]]"
#' xml2::xml_text(xml2::xml_find_all(ex$body, predicate))
#' pegboard:::clean_fenced_divs(ex$body)
#' xml2::xml_text(xml2::xml_find_all(ex$body, predicate))
clean_fenced_divs <- function(body) {
  ns <- NS(body)
  # Find the parents and then see if they have multiple child elements that
  # need to be split off into separate paragraphs. 
  predicate <- "[starts-with(text(), ':::')]"
  parent_xslt  <- glue::glue(".//{ns}:paragraph[{ns}:text{predicate}]")
  is_a_tag     <- glue::glue("boolean(self::*{predicate})")
  rents        <- xml2::xml_find_all(body, parent_xslt)
  names(rents) <- xml2::xml_attr(rents, "sourcepos")
  children     <- purrr::map(rents, xml2::xml_children)
  multi_tag    <- purrr::map(children, ~xml2::xml_find_lgl(.x, is_a_tag))

  # We want to isolate the div nodes, so we need to fix any paragraphs that 
  # have more than one child.
  to_fix <- lengths(children) > 1L
  if (any(to_fix)) {
    rents_to_fix <- rents[to_fix]
  } else {
    return(invisible(body))
  }

  # Calculate the number of new parent blocks needed
  need_n_blocks <- function(tags) {
    # number of tags is 2n - 1L assuming that the tags are bookends
    n <- sum(tags) * 2L - 1L 
    # If the tags are not bookending, then we need to make sure to include
    # paragraphs to account for that
    not_bookend <- sum(!tags & seq_along(tags) %in% c(1L, length(tags)))
    n + not_bookend
  }

  # For each parent:
  #   1. add new siblings above the parent, determined by the number of blocks
  #      needed.
  #   2. fill in the siblings with the children of the original parent
  #   3. remove the original parent
  for (parent in names(rents_to_fix)) {
    the_children <- children[[parent]]
    are_tags     <- multi_tag[[parent]]
    n_children   <- length(the_children)
    n_parents    <- need_n_blocks(are_tags)

    # Create siblings --------------------------------------
    purrr::walk(
      seq(n_parents), 
      ~xml2::xml_add_sibling(rents[[parent]], rents[[parent]], .where = "before")
    )
    the_parents <- xml2::xml_find_all(body, glue::glue(".//node()[@sourcepos='{parent}']"))

    # Remove contents of siblings -------------------------
    purrr::walk(
      the_parents[-length(the_parents)],
      ~xml2::xml_remove(xml2::xml_children(.x))
    )

    # Fill in children ------------------------------------
    this_child  <- 1L
    this_parent <- 1L
    while(this_child <= n_children) {
      child_is_tag <- are_tags[[this_child]]
      if (xml2::xml_name(the_children[[this_child]]) != "softbreak") {
        xml2::xml_add_child(the_parents[[this_parent]], the_children[[this_child]])
      }
      # Switch parents if the current or next child is a tag
      this_child <- this_child + 1L
      if (this_child <= n_children) {
        should_switch <- child_is_tag || are_tags[[this_child]]
      } else {
        should_switch <- FALSE
      }
      this_parent <- this_parent + should_switch
    }
    # Remove the old parent ------------------------------
    xml2::xml_remove(rents_to_fix[[parent]])
  }
  return(invisible(body))
}

get_div_class <- function(div) {
  trimws(sub('^(.+?class[=]["\']|[:]{3,}?)([- a-zA-Z0-9]+?)(["\'].+?|[:]*?)$', '\\2', div))
}

#' Make paired labels for opening and closing div tags
#'
#' @param nodes a character vector of div open and close tags
#' @param close the regex for a valid closing tag
#' @return an integer vector with pairs of labels for each opening and closing
#'   tag. Note that the labels are produced by doing a cumulative sum of the
#'   node depths.
#' @keywords internal
#' @seealso [get_divs()] for finding labelled tags, 
#' [find_between_tags()] to extract things between the tags, 
#' [label_div_tags()] for labelling div tags,
#' [clean_div_tags()] for cleaning cluttered div tags,
#' [replace_with_div()] for replacing blockquotes with div tags
#' [find_div_pairs()] for connecting open and closing tags
#' [clean_fenced_divs()] for cleaning cluttered pandoc div tags
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
#' pegboard:::find_div_pairs(nodes)
find_div_pairs <- function(divs, close = "(^ *?[<][/]div[>] *?\n?$|^[:]{3,80}$)") {
  n_item <- length(divs)
  n_tags <- n_item / 2
  if (n_tags != sum(grepl(close, divs))) { 
    stop("the number of closing tags must equal the number of opening tags")
  }

  tag_stack <- integer(n_tags)
  labels    <- integer(n_item)
  labels[1]    <- 1L
  tag_stack[1] <- 1L

  this_item    <- 2L
  this_tag     <- 1L
  tag_count    <- 1L
  while(this_item <= n_item) {
    is_closed <- grepl(close, divs[this_item])
    # Tags that are closed will be labelled with the current tag on the stack
    # and then have the stack decreased
    if (is_closed) {
      labels[this_item]   <- tag_stack[this_tag]
      tag_stack[this_tag] <- 0L
      this_tag <- this_tag - 1L
    } else {
    # New tags will have a new label added to the stack
      tag_count <- tag_count + 1L
      this_tag  <- this_tag  + 1L
      tag_stack[this_tag] <- tag_count
      labels[this_item] <- tag_stack[this_tag]
    }
    this_item <- this_item + 1L
  }
  labels
}