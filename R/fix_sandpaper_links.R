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
#' @param body an XML document
#' @param yml the list of key/value pairs derived from the `_config.yml` file
#' @param path the path to the current episode
#' @param known a character vector of known episodes in the lesson, relative to
#'   the lesson root.
#' @return the body, invisibly
#' @export
#' @examples
#'
#' loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
#' e <- Episode$new(loop)
#' b <- e$body
#' pegboard:::make_link_table(e)$orig
#' suppressWarnings(yml <- yaml::read_yaml(file.path(e$lesson, "_config.yml")))
#' fix_sandpaper_links(b, yml)
#' pegboard:::make_link_table(e)$orig
fix_sandpaper_links <- function(body, yml = list(), path = NULL, known = NULL) {
  ns       <- NS(body)
  jek_dest <- "contains(@destination, '{{')"
  rel_dest <- "contains(@destination, '../')"
  jek_text <- "contains(text(), '{{')"
  rel_text <- "contains(text(), '../')"
  lnk_type <- glue::glue("{jek_dest} or {rel_dest}")

  # Fix links and markdown images
  link_search <- glue::glue(".//{ns}link[{lnk_type}]")
  img_search  <- glue::glue(".//{ns}image[{lnk_type}]")
  html_search <- glue::glue(".//{ns}html_block[{jek_text} or {rel_text}]")
  links <- xml2::xml_find_all(body, link_search)
  lattr <- xml2::xml_attr(links, "destination")
  # We will run into situations where commonmark doesn't know what to do with
  # something like 
  # 
  # [link]({{ page.root }}/{% link 
  # thing.md %}) with other text here
  # 
  # Here we transform it to be
  # [link]({{ page.root }}/{% link thing.md %})
  # with other text here
  missing_links <- grepl("{%", lattr, fixed = TRUE) &
    !grepl("%}", lattr, fixed = TRUE)
  if (any(missing_links)) {
    ml <- links[missing_links]
    txt <- xml2::xml_find_first(ml, 
      glue::glue(".//following-sibling::{ns}text[contains(text(), '%}')]")
    )
    irl_txt <- xml2::xml_text(txt)
    # pattern to detect fragment and any text that comes after it
    pattern <- "^(.+?) ?[%][}][)](.*?)$"
    # apply the link to the missing links
    lattr[missing_links] <- sub(pattern, "\\1", irl_txt, perl = TRUE)
    xml2::xml_set_text(txt, sub(pattern, "\\2", irl_txt, perl = TRUE))
  }
  link_dests <- replace_links(lattr, yml)
  xml2::xml_set_attr(links, "destination", link_dests) 

  # fixing all other links
  links <- xml2::xml_find_all(body, glue::glue(".//{ns}link"))
  link_dests <- fix_local_paths(xml2::xml_attr(links, "destination"), path, known)
  xml2::xml_set_attr(links, "destination", link_dests)

  image <- xml2::xml_find_all(body, img_search)
  iattr <- xml2::xml_attr(image, "destination")
  xml2::xml_set_attr(image, "destination", replace_links(iattr, yml))
  make_pandoc_alt(xml2::xml_find_all(body, glue::glue(".//{ns}image")))

  # Fix links in html nodes (e.g. raw HTML that was inserted to markdown, like
  # <img src="../fig"/>
  hblok <- xml2::xml_find_all(body, html_search)
  hattr <- xml2::xml_text(hblok)
  xml2::xml_set_text(hblok, replace_links(hattr, yml))
  return(invisible(body))
}

# wrapper that adds {{ mustache }} templates around a liquid object
stache <- function(thing) paste0("[{][{] ?", thing, " ?[}][}][/]?")
# wrapper for link tags like {% link _episodes/page.md %}
# https://jekyllrb.com/docs/liquid/tags/
glasses <- function(thing) paste0("[{][%] ?link (", thing, ") ?[%][}]")

#' Low-rent mustache templating
#'
#' This is a dead-simple version of mustache tempalating that allows me to
#' replace `{{ site.variables }}` with the templated variables from the lesson and
#' maybe devise my own translation later on.
#'
#' @param links a character vector that contains `{{ site.variables }}` embedded
#' @param yml a list derived from a yaml file with key/value pairs corresponding
#'   to site variables. 
#' @return the links vector with site variables replaced with their values
#' @noRd
translate_site_variables <- function(links, yml = list()) {
  vars <- yml[vapply(yml, typeof, character(1)) == "character"]
  are_links <- grepl("^http", vars)
  vars[are_links] <- paste0(vars[are_links], "/")
  vars[are_links] <- sub("//$", "/", vars[are_links])
  for (var in names(vars)) {
    links <- gsub(stache(paste0("site.", var)), vars[var], links)
  }
  links
}

#' Replace liquid templating with portable links
#'
#' @param links a character vector with liquid templated links
#' @param yml a list derived from a yaml file
#' @return the links vector, fixed
#' @noRd
replace_links <- function(links, yml) {
  # flatten links
  links <- gsub("[.][.][/]", "", links)
  links <- gsub(stache("page.root"), "", links)
  links <- gsub(stache("site.baseurl"), "", links)
  links <- gsub(stache("relative_root_path"), "", links)
  links <- translate_site_variables(links, yml)
  episode <- function() glasses("_episodes/([^ %]+?)")
  links <- gsub(episode(), "\\2", links, perl = TRUE)
  links <- gsub(glasses("[^ %]+?"), "\\1", links, perl = TRUE)
  # to fix links that were pointing to the source page
  links[links == ""] <- "."
  links
}

fix_local_paths <- function(links, path, files) {
  parsed <- xml2::url_parse(links)
  to_fix <- parsed$server == "" & parsed$scheme == ""
  olinks <- links
  links[to_fix] <- sub("/(index.html)?", "", links[to_fix])
  links[to_fix] <- sub("/(.+?)\\.html", "/\\1", links[to_fix])

  files_sans_ext <- fs::path_ext_remove(fs::path_file(files))
  names(files) <- files_sans_ext
  files["setup"] <- "learners/setup.md"
  files["guide"] <- "instructors/instructor-notes.md"
  files["discuss"] <- "learners/discuss.md"
  files["reference"] <- "learners/reference.md"
  files <- sub("_episodes(_rmd)?/", "episodes/", files)
  files <- sub("_extras", "instructors", files)

  links_sans_ext <- sub("[#].+$", "", fs::path_ext_remove(fs::path_file(links)))
  type <- fs::path_dir(path)
  ext  <- fs::path_ext(path)
  
  for (this_link in which(to_fix)) {
    link_name <- links_sans_ext[this_link]
    new_path <- files[link_name]
    if (is.na(new_path)) {
      next
    }
    if (parsed$fragment[this_link] != "") {
      new_path <- paste0(new_path, "#", parsed$fragment[this_link])
    }
    links[this_link] <- switch(type, 
      "." = new_path,
      "_episodes" = make_episode_path(new_path, ext),
      "_episodes_rmd" = make_episode_path(new_path, ext),
      "_extras" = fs::path("..", new_path)
    )
  }
  links
}

make_episode_path <- function(path, ext) {
  dir <- fs::path_dir(path)
  switch(dir, 
    episodes = sub("episodes/", "", fs::path_ext_set(path, ext)),
    fs::path("..", path)
  )
}



