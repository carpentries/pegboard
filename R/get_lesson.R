#' Get a carpentries lesson in XML format
#'
#' Download and extract a carpentries lesson in XML format. This uses [gert::git_clone()]
#' to download a carpentries lesson to your computer (defaults to the temporary
#' directory and extracts the lesson in `_episodes/` using [tinkr::to_xml()]
#'
#' @param lesson a github user/repo pattern to point to the lesson
#' @param path a directory to write the lesson to
#' @param overwrite if the `path` exists, setting this to `TRUE` will overwrite
#'   the path, otherwise, the contents of the path will be returned if it is a
#'   lesson repository.
#' @param ... arguments passed on to [Episode$new()][Episode].
#'
#' @return a list of xml objects, one element per episode.
#' @export
#' @examples
#'
#' if (interactive()) {
#'   png <- get_lesson("swcarpentry/python-novice-gapminder")
#'   str(png, max.level = 1)
#' }
get_lesson <- function(lesson = NULL, path = tempdir(), overwrite = FALSE, ...) {
  if (!requireNamespace("gert", quietly = FALSE)) {
    stop("Please install the {gert} package to use this feature.")
  }
  if (is.null(lesson) && fs::dir_exists(fs::path(path, "_episodes"))) {
    # user provides path to lesson on computer
    the_path <- normalizePath(path)
  } else if (!is.null(lesson)) {
    # user provides lesson name and path on computer to write to
    the_path <- fs::path(path, gsub("[/]", "--", lesson))
  } else {
    stop("please provide a lesson")
  }

  # Only download the lesson if it exists, otherwise, find it from the path
  if (fs::dir_exists(the_path)) {
    if (overwrite) {
      fs::dir_delete(the_path)
    }
  } else {
    fs::dir_create(the_path)
  }

  # If the directory contains episodes, then use that, otherwise, download the
  episodes     <- fs::path(the_path, "_episodes")
  episodes_rmd <- fs::path(the_path, "_episodes_rmd")

  if (!fs::dir_exists(episodes) && !fs::dir_exists(episodes_rmd)) {
    lpath <- gert::git_clone(
      url = glue::glue("https://github.com/{lesson}.git"),
      path = the_path,
      verbose = FALSE
    )
  }

  # Return a new lesson object
  return(Lesson$new(the_path, ...))
}
