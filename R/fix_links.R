#' Finds and fixes unresolved links within an Episode
#'
#' @param body the body of an episode
#' @return the modified body
fix_links <- function(body) {
  purrr::walk(names(LINKS), fix_link_type, body)
  body
}

# A list of predicates that will match links
ctext <- function(x) glue::glue("contains(text(), '{x}')")
gsb <- function(x) glue::glue(x, .open = "<", .close = ">")
LINKS <- list(
  rel_image = gsb("(<ctext('![')> and <ctext(']({{')> and <ctext('}}')>)"),
  md_image  = gsb("(<ctext('![')> and <ctext('][')>   and <ctext(']')>)"),
  rel_link  = gsb("(<ctext('[')>  and <ctext(']({{')> and <ctext('}}')>)"),
  md_link   = gsb("(<ctext('[')>  and <ctext('][')>   and <ctext(']')>)")
)

fix_link_type <- function(type, body) {
  lnks <- find_lesson_links(body, type)
  purrr::walk(lnks, resolve_links, type = type)
  body
}

# Finds all text nodes that contain the link type
find_lesson_links <- function(body, type = "rel_link") {
  ns <- NS(body)
  xml2::xml_find_all(body,
    glue::glue(".//{ns}:paragraph/{ns}:text[{LINKS[[type]]}][not(@klink)]")
  )
}

# Operates on an individual text node within a paragraph.
# Steps:
#  1. modify underlying text to new nodes, splitting off links
#  2. inserts all the modified nodes before the text node
#  3. remove the old text node
resolve_links <- function(txt, type) {
  lnks <- text_to_links(xml2::xml_text(txt), xml2::xml_ns(txt), type)
  purrr::walk(lnks, ~xml2::xml_add_sibling(txt, .x, .where = "before"))
  xml2::xml_remove(txt)
  lnks
}

# Splits links away from text and returns a nodeset to insert
# txt <- "Some text [and a link]({{ page.root }}/link.to#thing), some other text [and another link][link-to-thing]."
# text_to_links(txt)
text_to_links <- function(txt, ns = NULL, type) {
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

  texts <- strsplit(txt, rgx, perl = TRUE)[[1]]
  texts <- texts[texts != ""]
  are_links <- grepl(lnk, texts, perl = TRUE)
  texts[are_links]  <- purrr::map_chr(texts[are_links], make_link, pattern = lnk, type = type)
  texts[!are_links] <- glue::glue("<text>{texts[!are_links]}</text>")
  if (!is.null(ns)) {
    texts <- xml_new_paragraph(glue::glue_collapse(texts), ns, tag = FALSE)
    texts <- xml2::xml_children(texts)
  }
  texts
}

# makes a link depending on the link type
make_link <- function(txt, pattern, type = "rel_link") {
  type <- strsplit(type, "_")[[1]]
  if (type[1] == "rel") {
    # relative tags are processed
    txt <- if (type[2] == "image") sub("^\\!\\[", '', txt) else txt
    text_link <- rev(strsplit(txt, pattern, perl = TRUE)[[1]])
    link <- glue::glue_collapse(text_link, sep = "'><text>")
    glue::glue("<{type[2]} destination='{link}</text></{type[2]}>")
  } else {
    txt <- if (grepl("^[!]", txt)) txt else glue::glue("[{txt}")
    # if the type is not relative, keep it as text and add the klink tag
    glue::glue("<text klink='true'>{txt}]</text>")
  }
}



