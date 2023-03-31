#' Create an xml document that contains two html_block elements 
#' that contain div tags. 
#'
#' @param what the class of block
#' @return an xml document with commonmark namespace
#' @keywords internal
#' @family div
#' @examples
#' cha <- pegboard:::make_div("challenge")
#' cha
#' cat(pegboard:::xml_to_md(cha))
make_div <- function(what, fenced = TRUE) {
  if (fenced) {
    n <- if (grepl("solution", what, fixed = TRUE)) 25 else 50
    open <- paste(rep(":", n - nchar(what) - 1L), collapse = "")
    dots <- paste(rep(":", n), collapse = "")
    div <- glue::glue("{open} {what}\n\n{dots}")
  } else {
    div <- glue::glue('<div class="{what}">\n\n</div>')
  }
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
#' @family div
#' @examples
#' frg <- Lesson$new(lesson_fragment())
#' lop <- frg$episodes$`14-looping-data-sets.md`
#' xml2::xml_find_all(lop$body, ".//d1:html_block")
#' lop$get_blocks(level = 1)
#' lop$get_blocks(level = 2)
#' purrr::walk(lop$get_blocks(level = 2), pegboard:::replace_with_div)
#' purrr::walk(lop$get_blocks(level = 1), pegboard:::replace_with_div)
#' lop$get_blocks()
#' # add tags
#' pegboard:::label_div_tags(lop$body)
#' lop$get_divs()
#' xml2::xml_text(lop$get_divs()[[1]])
replace_with_div <- function(block) {
  # Grab the type of block and filter out markup
  type <- gsub("[{:}.]", "", xml2::xml_attr(block, "ktag"))
  if (all(is.na(type))) {
    return(invisible(block))
  }
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
#' @family div
#' @examples
#' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
#' loop$body # a full document with block quotes and code blocks, etc
#' loop$unblock() # removing blockquotes and replacing with div tags
#' pegboard:::get_divs(loop$body, 'challenge') # all challenge blocks
#' pegboard:::get_divs(loop$body, 'solution') # all solution blocks
get_divs <- function(body, type = NULL, include = FALSE){
  ns    <- get_ns(body)
  if (!any(ns == "http://carpentries.org/pegboard/")) {
    return(list())
  }
  # 1. Find tags
  nodes <- xml2::xml_find_all(body, ".//pb:dtag", ns)
  tags  <- xml2::xml_attr(nodes, "label")
  # 2. Get the first tag of each pair
  start <- !duplicated(tags)
  # 3. Find div classes
  types <- if (is.null(type)) TRUE else grepl(type, tags)
  # 4. Extract nodes between tags
  valid <- start & types
  # 5. Define search pattern
  res   <- purrr::map(
    tags[valid], 
    ~find_between_tags(.x, body, "pb", "dtag[@label='{tag}']", include = include)
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
#' @param include if `TRUE`, the tags themselves will be included in the output
#' @return a nodeset between tags that have the dtag attribute matching `tag`
#' @keywords internal div
#' @family div
#' @examples
#' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
#' loop$body # a full document with block quotes and code blocks, etc
#' loop$unblock() # removing blockquotes and replacing with div tags
#' # find all the div tags
#' ns <- pegboard:::get_ns(loop$body)
#' tags <- xml2::xml_find_all(loop$body, ".//pb:dtag", ns)
#' tags <- xml2::xml_attr(tags, "label")
#' tags
#' # grab the contents of the first div tag
#' pegboard:::find_between_tags(tags[[1]], loop$body)
find_between_tags <- function(tag, body, ns = "pb", find = "dtag[@label='{tag}']", include = FALSE) {
  ns <- paste0(ns, ":")
  block  <- glue::glue("{ns}{glue::glue(find)}")
  tinkr::find_between(body, get_ns(body), pattern = block, include = include)
}

#' Add labels to div tags in the form of a "dtag" node with a paired "label"
#' attribute.
#' 
#' @param body an xml document
#' @return 
#'   - `label_div_tags()`: the document, modified
#'   - `clear_div_labels()`: the document, modified
#'   - `find_div_tags()`: a node list
#' @keywords internal
#' @family div
#' @rdname div_labels
#' @examples
#' txt <- "# Example with a mix of div tags
#' 
#' > PLEASE NEVER DO THE LESSONS THIS WAY
#' >
#' > I AM LITERALLY JUST TESTING A TERRIBLE EXAMPLE.
#' 
#' --------------------------------------------------------------------------------
#' 
#' <div class='challenge'>
#' ## Challenge
#' 
#' do that challenging thing.
#' 
#' ```{r}
#' cat('it might be challenging to do this')
#' ```
#' :::: solution
#' ```{r}
#' It's not that challenging
#' ```
#' :::
#' <div class='solution'>
#' We just have to try harder and use `<div>` tags
#' 
#' :::::: callout
#' ```{r}
#' cat('better faster stronger with <div>')
#' ```
#' ::::
#' :::::: discussion
#' <img src='https://carpentries.org/logo.svg'/>
#' :::::
#' </div>
#' </div>
#' 
#' <div class='good'>
#' 
#' ## Good divs
#' 
#' </div>
#' " 
#' tmp <- tempfile()
#' writeLines(txt, tmp)
#' ex <- tinkr::to_xml(tmp)
#' ex$body
#' pegboard:::label_div_tags(ex$body)
#' ex$body
#' pegboard:::clear_div_labels(ex$body)
label_div_tags <- function(body) {
  if (!inherits(body, "xml_document")) {
    path <- body$path
    yaml <- length(body$yaml)
    body <- body$body
  } else {
    path <- NULL
    yaml <- NULL
  }
  # Clean up the div tags 
  clear_div_labels(body)
  any_divs <- clean_div_tags(body)
  nodes  <- find_div_tags(body)
  if (!any_divs && length(nodes) == 0) {
    return(invisible(body))
  }
  divtab <- make_div_pairs(nodes, path = path, yaml = yaml)
  purrr::walk2(nodes, divtab, add_pegboard_nodes)
  invisible(body)
}

#' @rdname div_labels
find_div_tags <- function(body) {
  ns     <- "md:"
  # Find all div tags in html blocks or fenced div tags in paragraphs
  pblock <- "starts-with(text(), ':::')"
  divs   <- ".//{ns}html_block[contains(text(), '<div') or contains(text(), '</div')]"
  ndiv   <- ".//{ns}paragraph[{ns}text[{pblock}]]"
  xpath  <- glue::glue("{glue::glue(divs)} | {glue::glue(ndiv)}")
  nodes  <- xml2::xml_find_all(body, xpath, get_ns(body))
  nodes
}

#' @rdname div_labels
clear_div_labels <- function(body) {
  ns <- get_ns(body)
  if (!any(ns == "http://carpentries.org/pegboard/")) return(invisible(NULL))
  dtags <- xml2::xml_find_all(body, ".//pb:dtag", get_ns(body))
  purrr::walk(dtags, xml2::xml_remove)
}

#' Create a data frame describing the divs associated with nodes.
#'
#' Native and fenced divs may have several tags grouped in a single element.
#' In order to mark the pairs, we need to account for what tags exist in the
#' nodes. This function creates that 
#' 
#' @param nodes a nodelist containing native div and fenced div tags in 
#'   `html_block` or `paragraphs`.
#' @return a list of data frames for each node with the following columns:
#'   - node: numeric index of the node
#'   - div: the text of the individual div element, stripped of context
#'   - label: label of the div pair (div-label-class)
#'   - pos: position the label will be relative to its associated node
#' @keywords internal
#' @family div
#' @examples
#' txt <- "# Example with a mix of div tags
#' 
#' > PLEASE NEVER DO THE LESSONS THIS WAY
#' >
#' > I AM LITERALLY JUST TESTING A TERRIBLE EXAMPLE.
#' 
#' --------------------------------------------------------------------------------
#' 
#' <div class='challenge'>
#' ## Challenge
#' 
#' do that challenging thing.
#' 
#' ```{r}
#' cat('it might be challenging to do this')
#' ```
#' :::: solution
#' ```{r}
#' It's not that challenging
#' ```
#' :::
#' <div class='solution'>
#' We just have to try harder and use `<div>` tags
#' 
#' :::::: callout
#' ```{r}
#' cat('better faster stronger with <div>')
#' ```
#' ::::
#' :::::: discussion
#' <img src='https://carpentries.org/logo.svg'/>
#' :::::
#' </div>
#' </div>
#' 
#' <div class='good'>
#' 
#' ## Good divs
#' 
#' </div>
#' " 
#' tmp <- tempfile()
#' writeLines(txt, tmp)
#' ex <- tinkr::to_xml(tmp)
#' pegboard:::clean_div_tags(ex$body)
#' nodes <- pegboard:::find_div_tags(ex$body)
#' divs  <- pegboard:::make_div_pairs(nodes)
#' do.call("rbind", divs)
make_div_pairs <- function(nodes, path = NULL, yaml = NULL) {
  types <- xml2::xml_name(nodes)
  # list to store parsed nodes in
  lines <- divs <- vector(mode = "list", length = length(types))
  fenced_divs <- types == "paragraph"
  
  # Grab all the fenced div text, which consists of finding the text nodes that
  # only have the div tags... pretty straightforward
  if (any(fenced_divs)) {
    pblock <- "starts-with(text(), ':::')"
    chills <- glue::glue(".//node()[{pblock}]")
    chills <- purrr::map(nodes[fenced_divs], ~xml2::xml_find_all(.x, chills))
    divs[fenced_divs] <- purrr::map(chills, xml2::xml_text)
    lines[fenced_divs] <- purrr::map(chills, get_linestart)
  }
  # Grab all of the native div text, stripping out any content that happens to
  # be between div tags (it's happened before, even after cleaning). 
  if (any(!fenced_divs)) {
    ndivs <- xml2::xml_text(nodes[!fenced_divs])
    # Clean content between divs (we don't particularly care about them
    ndivs <- gsub("[>]([^<]|(?<=[`])[<])+?([<]?)", ">\n\\2", ndivs, perl = TRUE)
    divs[!fenced_divs] <- strsplit(trimws(ndivs), "\n")
    lines[!fenced_divs] <- rep(get_linestart(nodes[!fenced_divs]), 
      lengths(divs[!fenced_divs])
    )
  }
  res <- data.frame(
    node = rep(seq_along(divs), lengths(divs)),
    div  = unlist(divs, use.names = FALSE),
    line = unlist(lines),
    stringsAsFactors = FALSE
  )
 
  labels <- tryCatch(find_div_pairs(res$div), error = function(e) e)
  if (inherits(labels, "error")) {
    raise_div_error(res, path, yaml, type = labels$message)
  }
  # find the divs that are closing tags
  ends      <- duplicated(labels)
  # create the label by querying the class
  types     <- get_div_class(res$div)[!ends]
  res$label <- glue::glue("div-{labels}-{types[labels]}")
  # tell us if the tag should go before or after the node
  res$pos   <- ifelse(ends, "after", "before")
  split(res, res$node)
}

# Raise an error when divs are unbalanced
#
# @param res a data frame containing 
#   - node: a unique identifier for each div element
#   - div a each div element
#   - line the line number of the div element
# @param path the path of the file containing the div
# @param yaml an integer offset representing the length of the yaml header
raise_div_error <- function(res, path, yaml, type) {
  div <- sub(div_close_regex(), "  [close]", get_div_class(res$div))
  ci <- Sys.getenv("CI") != ""
  if (ci) {
    sub      <- if (type == "close") div != "  [close]" else div == "  [close]"
    pre_msg  <- ""
    line_msg <- glue::glue("check for the corresponding {type} tag")
  } else {
    sub      <- TRUE
    pre_msg  <- "Here is a list of all the tags in the file:\n"
    line_msg <- glue::glue("| tag: {div}")
  }
  msg <- line_report(msg = line_msg, path = path, pos = res$line[sub] + yaml)
  msg <- glue::glue_collapse(msg, sep = "\n")
  msg <- glue::glue("Missing {type} section (div) tag in {path}.
      {pre_msg}{msg}")
  stop(msg, call. = FALSE)
}

#' Add a pegboard node before or after a node
#' 
#' These nodes have the namespace of "http://carpentries.org/pegboard/"
#' @keywords internal
#' @param node a single node
#' @param df a data frame generated from [make_div_pairs()]
#' @return NULL, invisibly
add_pegboard_nodes <- function(node, df) {
  parents <- xml2::xml_parents(node)
  if (length(parents) > 1L) {
    node <- parents[[2]]
  }
  for (i in seq(nrow(df))) {
    xml2::xml_add_sibling(
      node,
      "dtag",
      label = df$label[i],
      xmlns = "http://carpentries.org/pegboard/", 
      .where = df$pos[i]
    )
  }
  invisible(NULL)
}


#' Clean the div tags from an xml document
#'
#' @param body an xml document
#' @return `TRUE` if divs were detected and cleaned, `FALSE` if there were no
#'   divs.
#' @family div
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
  ns  <- get_ns(body)
  d   <- xml2::xml_find_all(body, ".//md:html_block[contains(text(), 'div')]", ns)
  if (length(d) == 0) {
    return(FALSE)
  }

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
  return(TRUE)
}

#nocov start
#' Clean pandoc fenced divs and place them in their own paragraph elements
#'
#' Sometimes pandoc fenced divs are bunched together, which makes it difficult
#' to track the pairs. This separates them into different paragraph elements so
#' that we can track them
#'
#' @param body an xml document
#' @return an xml document
#' @keywords internal
#' @note DEPRECATED.
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
#' predicate <- ".//d1:paragraph/d1:text[starts-with(text(), ':::')]"
#' xml2::xml_text(xml2::xml_find_all(ex$body, predicate))
#' pegboard:::clean_fenced_divs(ex$body)
#' xml2::xml_text(xml2::xml_find_all(ex$body, predicate))
clean_fenced_divs <- function(body) {
  ns <- NS(body)
  # Find the parents and then see if they have multiple child elements that
  # need to be split off into separate paragraphs. 
  predicate <- "[starts-with(text(), ':::')]"
  parent_xslt  <- glue::glue(".//{ns}paragraph[{ns}text{predicate}]")
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
#nocov end

get_div_class <- function(div) { 
  # this regex is kind of weird so here is the explanation:
  # ^ asserts position at start of a line
  # 1st Capturing Group (.+?class[=]["\']|[:]{3,}?\s?[{]?\s?[.]?)
  # --- matches the preamble. One of the following:
    # HTML case: 1st Alternative .+?class[=]["\']
    #  - <div class="  
    # FENCED DIV 2nd Alternative [:]{3,}?\s?[{]?\s?[.]?
    #  - ::: {.
    #  - :::
    #  - ::: .
  # 2nd Capturing Group ([-a-zA-Z0-9]+)
  # --- Matches the class itself assumed to be made of up of letters, numbers 
  #     and dashes
  # 3rd Capturing Group (["\'].+?|.*?[}]?[:]*?)
  # --- matches anything after the class
  # HTML case:1st Alternative ["\'].+?
     # the closing quote and then literally anything after
  # FENCED DIV 2nd Alternative .*?[}]?[:]*?
     # 
  trimws(sub('^(.+?class[=]["\']|[:]{3,}?\\s?[{]?\\s?[.]?)([-a-zA-Z0-9]+).*(["\'].+?|.*?[}]?[:]*?)$', '\\2', div)) 
} 

div_close_regex <- function() {
  "(^ *?[<][/]div[>] *?\n?$|^[:]{3,80}$)"
} 

#' Make paired labels for opening and closing div tags
#'
#' @param nodes a character vector of div open and close tags
#' @param close the regex for a valid closing tag
#' @return an integer vector with pairs of labels for each opening and closing
#'   tag. Note that the labels are produced by doing a cumulative sum of the
#'   node depths.
#' @keywords internal
#' @family div
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
find_div_pairs <- function(divs, close = div_close_regex()) {
  pairs <- sub(close, ")", divs)
  pairs[pairs != ")"] <- "("
  close_tags <- sum(pairs == ")")
  open_tags  <- sum(pairs == "(")
  if (close_tags != open_tags) {
    tags <- c(open = open_tags, close = close_tags)
    bad <- if (open_tags < close_tags) 1L else 2L
    msg1 <- "A section (div) tag mis-match was detected."
    msg2 <- c("There are not enough {names(tags)[bad]} tags ({tags[bad]}) for",
      "the number of {names(tags)[-bad]} tags ({tags[-bad]}).")
    msg <- paste(msg2, collapse = " ")
    if (requireNamespace("cli")) {
      cli::cli_alert_danger(msg1)
      stop(cli::cli_alert_danger(msg, id = names(tags)[bad]), call. = FALSE)
    } else {
      pb_message(msg1)
      pb_message(glue::glue(msg))
      stop(names(tags)[bad], call. = FALSE)
    }
  }
  label_pairs(pairs, close_tags)
}

#' Label pairs of parentheses. 
#'
#' This function is the labeller for [find_div_pairs()]
#' @param pairs a vector of parentheses.
#' @param n_tags the number of closing tags
#' @param reverse if `TRUE`, the search from the end of the stack
#'
#' @return a vector of integers indicating the pair of parentheses. 
#' @keywords internal
#' @family div
#'
#' @examples
#'
#' x <- c("(", "(", ")", ")")
#' pegboard:::label_pairs(x, 2)
#' x <- c("(", "(", ")", "(", "(", ")", ")", ")")
#' pegboard:::label_pairs(x, 4)
label_pairs <- function(pairs, n_tags, reverse = FALSE) {
  n_item <- length(pairs)
  if (reverse) pairs <- rev(pairs)

  # Vectors --------------------------------------------------------------------
  # The tag stack is a vector of integers (set to zero) equal to the length of
  # the number of pairs. The value of an individual item in the stack is a label
  tag_stack <- integer(n_tags)
  # The labels is a vector that will be our output. It contains the labels for
  # each element in pairs
  labels    <- integer(n_item)
  labels[1]    <- 1L
  tag_stack[1] <- 1L

  # Counters -------------------------------------------------------------------
  # We walk over `this_item` to control the loop. 
  # It follows both `pairs` and `labels`
  this_item    <- 2L
  # This tag denotes the current position of the `tag_stack`
  this_tag     <- 1L
  # tag_count keeps track of the current tag label
  tag_count    <- 1L
  while(this_item <= n_item) {
    is_closed <- pairs[this_item] == if (reverse) "(" else ")"
    # is_closed <- grepl(close, divs[this_item])
    # Tags that are closed will be labelled with the current tag on the stack
    # and then have the stack decreased
    if (is_closed) {
      # This will error whenever there are too many closing tags (odd number)
      labels[this_item]   <- tag_stack[this_tag]
      tag_stack[this_tag] <- 0L
      this_tag <- this_tag - 1L
    } else {
    # New tags will have a new label added to the stack
      tag_count <- tag_count + 1L
      this_tag  <- this_tag  + 1L
      tag_stack[this_tag] <- tag_count
      labels[this_item]   <- tag_stack[this_tag]
    }
    this_item <- this_item + 1L
  }
  if (reverse) rev(labels) else labels
}
