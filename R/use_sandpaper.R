#' Convert a Jekyll-based lesson to a sandpaper-based lesson
#'
#' @param body the xml body of an episode
#' @param rmd if `TRUE`, the chunks will be converted to RMarkdown chunks
#' @return the body
#' @noRd
use_sandpaper <- function(body, rmd = TRUE) {
  fix_sandpaper_links(body)
  # Fix the code tags
  ns         <- NS(body)
  langs      <- get_code(body, "", "@ktag") # grab all of the tags
  any_python <- any(grepl("python", xml2::xml_attr(langs, "ktag")))
  purrr::walk(langs, liquid_to_commonmark, make_rmd = rmd)
  has_setup_chunk <- xml2::xml_find_lgl(
    body, 
    # setup is the first code block that is not included
    glue::glue("boolean(./{ns}:code_block[1][@language='r' and @include='FALSE'])")
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
    txt[rem] <- NULL
    needs_reticulate <- rmd && 
      any_python            && 
      (length(txt) == 0 || !any(grepl("reticulate", txt)))
    if (needs_reticulate) {
      txt <- c(txt, as.expression('library("reticulate")'))
    }
    txt <- c(txt, "# Generated with {pegboard}")
    xml2::xml_set_text(setup, paste(as.character(txt), collapse = "\n"))
  }
  invisible(return(body))
}
