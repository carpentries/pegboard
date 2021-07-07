#' Fix relative and jekyll links to be compatible with {sandpaper}
#'
#' This function will perform the transformation on three node types:
#'
#'  - image
#'  - link
#'  - html_node
#' 
#' The transformation will be to remove relative paths ("../") and replace
#' Jekyll templating (e.g. "{{ page.root }}" and "{{ site.swc_pages }}" with
#' either nothing or the link to software carpentry, respectively. 
#'
#' @note This is absolutely NOT comprehensive and some links will fail to be 
#' converted. If this happens, please report an issue: 
#' <https://github.com/carpentries/pegboard/issues/new/>
#'
#' @param body an XML node
#' @return the body, invisibly
#' @export
#' @examples
#'
#' loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
#' e <- Episode$new(loop)
#' b <- e$body
#' # Links that exist
#' xml2::xml_find_all(b, ".//d1:image")
#' xml2::xml_find_all(b, ".//d1:html_block")
#' xml2::xml_find_all(b, ".//d1:link[contains(@destination, '{{')]")
#' fix_sandpaper_links(b)
#' # links that were fixed
#' xml2::xml_find_all(b, ".//d1:image")
#' xml2::xml_find_all(b, ".//d1:html_block")
#' xml2::xml_find_all(b, ".//d1:link[contains(@destination, '{{')]")
fix_sandpaper_links <- function(body) {
  ns       <- NS(body)
  jek_dest <- "contains(@destination, '{{')"
  rel_dest <- "contains(@destination, '../')"
  jek_text <- "contains(text(), '{{')"
  rel_text <- "contains(text(), '../')"
  lnk_type <- glue::glue("{jek_dest} or {rel_dest}")

  # Fix links and markdown images
  link_search <- glue::glue(".//{ns}link[{lnk_type}]")
  img_search  <- glue::glue(".//{ns}image[{lnk_type}]")
  html_search <- glue::glue(
    ".//{ns}html_block[{jek_text} or {rel_text}]"
  )
  links <- xml2::xml_find_all(body, link_search)
  lattr <- xml2::xml_attr(links, "destination")
  # We will run into situations where commonmark doesn't know what to do with
  # something like 
  # 
  # [link]({{ page.root }}/{% link 
  # thing.md %})
  missing_links <- grepl("{%", lattr, fixed = TRUE) &
    !grepl("%}", lattr, fixed = TRUE)
  if (any(missing_links)) {
    ml <- links[missing_links]
    txt <- xml2::xml_find_first(ml, 
      glue::glue(".//following-sibling::{ns}text[contains(text(), '%}')]")
    )
    irl_txt <- xml2::xml_text(txt)
    pattern <- "^(.+?) ?[%][}][)](.*?)$"
    lattr[missing_links] <- sub(pattern, "\\1", irl_txt, perl = TRUE)
    lattr[missing_links] <- sub('[.]R?md$', '.html', lattr[missing_links])
    xml2::xml_set_text(txt,
      sub(pattern, "\\2", irl_txt, perl = TRUE)
    )
  }
  xml2::xml_set_attr(links, "destination", replace_links(lattr))

  image <- xml2::xml_find_all(body, img_search)
  iattr <- xml2::xml_attr(image, "destination")
  xml2::xml_set_attr(image, "destination", replace_links(iattr))

  # Fix links in html nodes (e.g. raw HTML that was inserted to markdown, like
  # <img src="../fig"/>
  hblok <- xml2::xml_find_all(body, html_search)
  hattr <- xml2::xml_text(hblok)
  xml2::xml_set_text(hblok, replace_links(hattr))
  return(invisible(body))
}

replace_links <- function(links) {
  links <- gsub("[.][.][/]", "", links)
  links <- gsub("[{][{] ?page.root ?[}][}][/]?", "", links)
  links <- gsub("[{][{] ?site.swc_pages ?[}][}][/]?", "https://swcarpentry.github.io/", links)
  links
}

