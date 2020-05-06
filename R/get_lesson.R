#' Get a carpentries lesson in XML format
#'
#' Download and extract a carpentries lesson in XML format. This uses [git2r::clone()]
#' to download a carpentries lesson to your computer (defaults to the temporary
#' directory and extracts the lesson in `_episodes/` using [tinkr::to_xml()]
#'
#' @param lesson a github user/repo pattern to point to the lesson
#' @param path a directory to write the lesson to
#'
#' @return a list of xml objects, one element per episode.
get_lesson <- function(lesson = "swcarpentry/python-novice-gapminder", path = tempdir(), overwrite = FALSE) {

  the_path  <- file.path(path, gsub("[/]", "--", lesson))

  if (fs::dir_exists(the_path)) {
    if (overwrite) {
      fs::dir_delete(the_path)
    } else {
      lpath <- git2r::repository(the_path)
    }
  } else {
    stopifnot(dir.create(the_path) == 1)
    lpath <- git2r::clone(
      glue::glue("https://github.com/{lesson}.git"),
      local_path = the_path
    )
  }


  the_files <- fs::dir_ls(file.path(fs::path_dir(lpath$path), "_episodes"))

  stopifnot(length(the_files) > 0)

  xmls <- purrr::map(the_files, tinkr::to_xml)
  xmls
}
