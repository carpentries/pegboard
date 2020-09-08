#' Convert a lesson to use dovetail
#'
#' This will convert your lesson to use the {dovetail} R package for processing
#' specialized block quotes which will do two things:
#'
#' 1. convert your lesson from md to Rmd
#' 2. add to your setup chunk the following code
#'   ```
#'   library('dovetail')
#'   source(dvt_opts())
#'   ```
#' If there is no setup chunk, one will be created. If there is a setup chunk,
#' then the `source` and `knitr_fig_path` calls will be removed.
#' @param body the episode body to convert
#' @return the episode, invisibly
#' @noRd
#' @keywords internal
use_dovetail <- function(body) {
  setup <- get_setup_chunk(body)
  txt   <- parse(text = xml2::xml_text(setup))
  to_inject <- as.expression(c('library("dovetail")', 'source(dvt_opts())'))
  if (length(txt) > 0) {
    if (!grepl("knitr_fig_path", txt)) {
      to_inject <- c(to_inject, as.expression('knitr_fig_path("fig-")'))
    }
    rem      <- grepl("source\\(.../bin/chunk-options.R.\\)", txt)
    txt[rem] <- NULL
  } else {
    to_inject <- c(to_inject, as.expression('knitr_fig_path("fig-")'))
  }
  to_inject <- c(to_inject, as.expression("# Generated with {pegboard}"))
  txt <- c(txt, to_inject)
  xml2::xml_set_text(setup, paste(as.character(txt), collapse = "\n"))
  body
}

