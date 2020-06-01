#' Finds and fixes unresolved links within an Episode
#'
#' @param body the body of an episode
#' @return the modified body
fix_links <- function(body) {
  lnks <- find_lesson_links(body)
  purrr::walk(lnks, resolve_links)
  body
}

find_lesson_links <- function(body, links = "") {
  ns <- NS(body)
  relative_link <- "(contains(text(), '({{') and contains(text(), '}}'))"
  link_md <- "(contains(text(), '[') and contains(text(), '][') and contains(text(), ']'))"
  xml2::xml_find_all(body,
    glue::glue(".//{ns}:paragraph/{ns}:text[{relative_link} or {link_md}]")
  )
}

resolve_links <- function(txt) {
  lnks <- text_to_links(xml2::xml_text(txt), xml2::xml_ns(txt))
  purrr::walk(lnks, ~xml2::xml_add_sibling(txt, .x, .where = "before"))
  xml2::xml_remove(txt)
  lnks
}

# txt <- "Some text [and a link]({{ page.root }}/link.to#thing), some other text [and another link][link-to-thing]."
# text_to_links(txt)
text_to_links <- function(txt, ns = NULL) {
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
  the_links <- purrr::map_chr(texts[are_links],
    ~glue::glue_collapse(rev(strsplit(.x, lnk, perl = TRUE)[[1]]), sep = "'><text>")
  )
  texts[are_links]  <- glue::glue("<link destination='{the_links}</text></link>")
  texts[!are_links] <- glue::glue("<text>{texts[!are_links]}</text>")
  if (!is.null(ns)) {
    texts <- xml_new_paragraph(glue::glue_collapse(texts), ns, tag = FALSE)
    texts <- xml2::xml_children(texts)
  }
  texts
}



