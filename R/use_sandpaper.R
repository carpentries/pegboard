#' Convert a Jekyll-based lesson to a sandpaper-based lesson
#'
#' @param body the xml body of an episode
#' @param rmd if `TRUE`, the chunks will be converted to RMarkdown chunks
#' @return the body
#' @noRd
use_sandpaper <- function(body, rmd = TRUE) {
  langs      <- get_code(body, ".language-")
  any_python <- any(grepl("python", xml2::xml_attr(langs, "ktag")))
  purrr::walk(langs, liquid_to_commonmark, make_rmd = rmd)
  if (rmd) {
    setup <- get_setup_chunk(body)
    txt   <- parse(text = xml2::xml_text(setup))
    # remove function calls for jekyll sites
    #  - source() call knitr hooks
    #  - knitr_fig_path() sets up the relative path for jekyll
    rem <- grepl("source\\(.../bin/chunk-options.R.\\)", txt) |
           grepl("source\\(dvt_opts\\(", txt)                 |
           grepl("knitr_fig_path\\(.+?\\)", txt)
    txt[rem] <- NULL
    # add reticulate if needed
    if (any_python && length(txt) == 0 || !any(grepl("reticulate", txt))) {
      txt <- c(txt, as.expression('library("reticulate")'))
    }
    txt <- c(txt, as.expression("# Generated with {pegboard}"))
    xml2::xml_set_text(setup, paste(as.character(txt), collapse = "\n"))
  }
  return(body)
}
