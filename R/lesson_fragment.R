#' Example Lesson Fragments
#'
#' Partial lessons mainly used for testing and demonstration purposes
#'
#' @note
#' The lesson-fragment example was taken from the python novice gapminder
#' lesson
#'
#' @param name the name of the lesson fragment. Can be one of:
#'   - lesson-fragment
#'   - rmd-lesson
#'   - sandpaper-fragment
#'   - sandpaper-fragment with children
#'
#' @return a path to a lesson fragment whose contents are:
#'   - `lesson-fragment` contains one `_episodes` directory with three files:
#'   "10-lunch.md", "14-looping-data-sets.md", and "17-scope.md"
#'   - `rmd-fragment` contains one episode under `_episodes_rmd` called
#'     `01-test.Rmd`. 
#'   - `sandpaper-fragment` contains a trimmed-down Workbench lesson that
#'     has its R Markdown content pre-built
#'   - `sandpaper-fragment-with-children` contains much of the same content as
#'   `sandpaper-fragment`, but the `episodes/index.Rmd` file references child
#'   documents.
#' @export
#' @examples
#' lesson_fragment()
#' lesson_fragment("rmd-lesson")
#' lesson_fragment("sandpaper-fragment")
#' lesson_fragment("sandpaper-fragment-with-children")
lesson_fragment <- function(name = "lesson-fragment") {
  allowed <- c("lesson-fragment", "rmd-lesson", 
    "sandpaper-fragment", "sandpaper-fragment-with-children")
  name <- match.arg(name, allowed)
  return(system.file(name, package = "pegboard"))
}
