#' Finds and fixes unresolved links within an Episode
#'
#' @param body an XML document.
#' @return `fix_links()`: the modified body
#' @rdname fix_links
#' @keywords internal
#' @examples
#' loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
#' e <- Episode$new(loop, fix_links = FALSE)
#' e$links  # five links
#' e$images # four images
#' fix_links(e$body)
#' e$links  # eight links
#' e$images # five images
fix_links <- function(body) {
  fragments <- find_broken_links(body)
  fix_broken_links(fragments)
  invisible(body)
}

#' @rdname fix_links
#'
#' @description
#' `find_broken_links()` Find broken links from Jekyll that have spaces
#'
#' @return 
#'  - `find_broken_link()`: a list where each element represents a fragmented
#'  link. Inside each element are two elements:
#'   - parent: the parent paragraph node for the link
#'   - nodes: the series of four or five nodes that make up the link text
find_broken_links <- function(body) {
  nodes <- xml2::xml_find_all(body, make_link_patterns(), ns = get_ns())
  purrr::map(nodes, get_link_fragment_nodes)
}

#' @rdname fix_links
#'
#' @description
#' `fix_broken_links()` uses the output of `find_broken_links()` to replace the
#' node fragments with links. 
fix_broken_links <- function(fragments) {
  purrr::walk(fragments, fix_broken_link)
}

#' @description
#' `make_link_patterns()` a generator to create an XPath query that will search
#' for liquid markup following a closing bracket.
#'
#' @param ns the namespace prefix to use for the pattern
#' @rdname fix_links
#' @examples
#' make_link_patterns()
make_link_patterns <- function(ns = "md:") {

  predicate <- gsb("(<ctext('({{')> and <ctext('}}')>)")
  asis_nodes <- "text[@asis][text()=']']"
  destination <- glue::glue(
    ".//{ns}{asis_nodes}/following-sibling::{ns}text[{predicate}]",
  )
  return(destination)
}

ctext <- function(x) glue::glue("contains(text(), '{x}')")
gsb <- function(x) glue::glue(x, .open = "<", .close = ">")

#' Get the source for the link node fragments
#'
#' @param node a node determined to be a text representation of a link
#'   destination
#' @return the preceding three nodes, which will be by definition, the text
#'   of the link.
get_link_fragment_nodes <- function(node) {
  the_parent <- xml2::xml_parent(node)
  the_children <- xml2::xml_children(the_parent)
  # find the node in question by testing for identity since they represent the
  # same object, they will be identical. 
  id <- which(purrr::map_lgl(the_children, identical, node))
  # test for image with endsWith because they may have an inline image.
  is_image <- id > 4
  is_image <- is_image && endsWith(xml2::xml_text(the_children[[id - 4]]), "!")
  offset <- 3L + is_image
  the_children[(id - offset):id]
}

#' @rdname fix_links
#'
#' @description
#' `fix_broken_link()` takes a set of nodes that comprises a single link such as
#'
#' ```xml
#' <text asis="true">[</text>
#' <text>Home</text>
#' <text asis="true">]</text>
#' <text>({{ page.root }}/index.html) and other text</text>
#' ```
#' 
#' and recomposes them into an actual link node or image node.
#'
#' ```xml
#' <link destination="{{ page.root }}/index.html">Home</link>
#' <text> and other text</text>
#' ```
fix_broken_link <- function(nodes) {
  type <- if (length(nodes) == 4) "link" else "image"
  text <- paste(xml2::xml_text(nodes), collapse = "")
  to_replace <- text_to_links(text, ns = xml2::xml_ns(nodes[[1]]), type = type)
  purrr::walk(to_replace, 
    ~xml2::xml_add_sibling(nodes[[1]], .x, .where = "before")
  )
  xml2::xml_remove(nodes)
}

#' @description
#' `links_within_text_regex()`: finding different types of links within markdown
#' text can be challenging because it involves characters used in regex for
#' grouping and character classes. In general, I want to do two things with text
#' that I get back from a document:
#'
#'  1. split the links out from the text
#'  2. identify which parts of the resulting vector are links.
#'
#' This way, I can convert the links to links and the text to text.
#'
#' @rdname fix_links
#' @examples
#' helpers <- pegboard:::links_within_text_regex()
#' helpers
#' txt <- "text ![image text](a.png) with [a link](b.org) and text"
#' res <- strsplit(txt, helpers["to_split"], perl = TRUE)[[1]]
#' data.frame(res)
#' grepl(helpers["find_links"], res, perl = TRUE)
links_within_text_regex <- function() {

  b1 <- "\\["
  b2 <- "\\]"
  p1 <- "\\("
  p2 <- "\\)"
  woo <- "\\!"
  # Does not match: ][ or )[ ![
  first_b1 <- glue::glue("(?<!({b2}|{p2}|{woo})){b1}")
  # Does not match: ]] or ][ or ](
  last_b2  <- glue::glue("{b2}(?!({b2}|{b1}|{p1}))")
  rgx      <- glue::glue("{first_b1}|{last_b2}|{p2}")
  # Does not match [][ or []( (image links)
  lnk      <- glue::glue("(?<!{b1}){b2}({b1}|{p1})")

  return(c(to_split = rgx, find_links = lnk))
}

#' @description
#' `text_to_links()`: Splits links away from text and returns a nodeset to insert
#' 
#' @param txt text derived from `xml2::xml_text()`
#' @param ns a namespace object
#' @param type the type of link as defined in [LINKS].
#' @param sourcepos defaults to NULL. If this is not NULL, it's the sourcepos
#'   attribute of the text node(s) and will be applied to the new nodes.
#' @return `text_to_links()`: if ns is NULL: a character vector of XML text
#'   nodes, otherwise, new XML text nodes.
#' @rdname fix_links
#' @examples
#' txt <- "Some text [and a link]({{ page.root }}/link.to#thing), 
#' some other text."
#' pegboard:::text_to_links(txt, type = "link")
#' md <- c(md = "http://commonmark.org/xml/1.0")
#' class(md) <- "xml_namespace"
#' pegboard:::text_to_links(txt, md, "link")
text_to_links <- function(txt, ns = NULL, type, sourcepos = NULL) {

  regex_helpers <- links_within_text_regex()
  rgx <- regex_helpers["to_split"]
  lnk <- regex_helpers["find_links"]

  texts <- strsplit(txt, rgx, perl = TRUE)[[1]]
  texts <- texts[texts != ""]
  # escape ampersands that are not valid code points, though this will still
  # allow invalid code points, but it's better than nothing
  texts <- gsub("[&](?![#]?[A-Za-z0-9]+?[;])", "&amp;", texts, perl = TRUE)
  are_links <- grepl(lnk, texts, perl = TRUE)
  texts[are_links]  <- purrr::map_chr(texts[are_links], make_link, pattern = lnk, type = type)
  texts[!are_links] <- glue::glue("<text>{texts[!are_links]}</text>")
  if (!is.null(ns)) {
    # TODO: fix this process for creating new nodes. Use the process from 
    # {tinkr} to do this. 
    texts <- xml_new_paragraph(glue::glue_collapse(texts), ns, tag = FALSE)
    texts <- xml2::xml_children(texts)
    xml2::xml_set_attr(texts, "sourcepos", sourcepos)
  }
  texts
}



#' @description
#' `make_link()`: makes a link depending on the link type
#'
#' @param pattern a regular expression that is used for splitting the link
#' from the surrounding text. 
#' @rdname fix_links
make_link <- function(txt, pattern, type = "rel_link") {
  # relative tags are processed
  txt <- if (type == "image") sub("^\\!\\[", '', txt) else txt
  # split the link text and text into a two-element vector
  text_link <- rev(strsplit(txt, pattern, perl = TRUE)[[1]])
  link <- glue::glue_collapse(text_link, sep = "'><text>")
  glue::glue("<{type} destination='{link}</text></{type}>")
}



