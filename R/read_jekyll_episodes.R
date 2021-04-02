read_jekyll_episodes <- function(path = NULL, rmd = FALSE, ...) {
  # Old Lesson
  md_src  <- fs::path(path, "_episodes")
  rmd_src <- fs::path(path, "_episodes_rmd")

  if (!rmd && fs::dir_exists(md_src)) {
    src <- md_src
  } else if (fs::dir_exists(rmd_src) && (rmd || !fs::dir_exists(md_src))) {
    if (!rmd) {
      message("could not find _episodes/, using _episodes_rmd/ as the source")
      rmd <- TRUE
    }
    src <- rmd_src
  } else {
    stop(glue::glue("could not find either _episodes/ or _episodes_rmd/ in {path}"))
  }

  return(list(episodes = read_markdown_files(src, ...), rmd = rmd))
}
