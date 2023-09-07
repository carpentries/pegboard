#' Convert a Jekyll-based lesson to a sandpaper-based lesson
#'
#' @param body the xml body of an episode
#' @param rmd if `TRUE`, the chunks will be converted to RMarkdown chunks
#' @param yml a list derived from the `_config.yml` file that defines the site
#'   variables.
#' @param path the path to the source of the body. Defaults to NULL. This is
#'   used in conjunction with `known_paths`
#' @param known_paths a character vector with the known paths in the lesson.
#'   This is used to determine the correct path to other files in the lesson.
#' @return the body
#' @noRd
use_sandpaper <- function(body, rmd = TRUE, yml = list(), path = NULL, known_paths = NULL) {
  if (inherits(body, "xml_missing")) {
    warning("episode body missing", call. = FALSE)
    return(invisible(body))
  }
  fix_sandpaper_links(body, yml, path, known_paths)
  # Remove {% include links.md %}
  lnks <- xml2::xml_find_all(body, 
    ".//md:text[contains(text(),'include links.md') and contains(text(),'{%')]",
    ns = get_ns(body)
  )
  xml2::xml_remove(lnks)
  # Remove {% include base_path.html %}
  bp <- xml2::xml_find_all(body, 
    ".//md:text[contains(text(),'include base_path') and contains(text(),'{%')]",
    ns = get_ns(body)
  )
  xml2::xml_remove(bp)
  img_attrs <- xml2::xml_find_all(body, 
    ".//md:image/following-sibling::md:text[1][starts-with(text(), '{:')]",
    ns = get_ns(body)
  )
  if (length(img_attrs)) {
    xml2::xml_set_text(img_attrs,
      sub("{:", "{", xml2::xml_text(img_attrs), fixed = TRUE))
  }
  # Fix the code tags
  langs      <- get_code(body, "", "@ktag") # grab all of the tags
  any_python <- any(grepl("python", xml2::xml_attr(langs, "ktag")))
  purrr::walk(langs, liquid_to_commonmark, make_rmd = rmd)
 
  has_setup_chunk <- xml2::xml_find_lgl(
    body, 
    # setup is the first code block that is not included
    "boolean(./md:code_block[1][@language='r' and (@name='setup' or @include='FALSE')])",
    get_ns(body)
  )
  if (has_setup_chunk || rmd) {
    setup <- get_setup_chunk(body)
    txt   <- parse(text = xml2::xml_text(setup))
    # remove function calls for jekyll sites
    #  - source() call knitr hooks
    #  - knitr_fig_path() sets up the relative path for jekyll
    rem <- grepl("source\\(.../bin/chunk-options.R.\\)", txt) |
           grepl("source\\(dvt_opts\\(", txt)                 |
           grepl("knitr_fig_path\\(.+?\\)", txt)
    txt <- txt[!rem]
    needs_reticulate <- rmd && 
      any_python            && 
      (length(txt) == 0 || !any(grepl("reticulate", txt)))
    if (needs_reticulate) {
      txt <- c(txt, as.expression('library("reticulate")'))
    }
    txt <- c(txt, "# Generated with {pegboard}")
    xml2::xml_set_text(setup, paste(as.character(txt), collapse = "\n"))
  }
  invisible(return(xml2::read_xml(as.character(body))))
}
