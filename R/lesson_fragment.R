#' An example lesson fragment
#'
#' This example was taken from the python novice gapminder lesson
#'
#' @return a path to a lesson fragment that contains one `_episodes` directory
#'    with three files: "10-lunch.md", "14-looping-data-sets.md", and
#'    "17-scope.md"
#' @export
#' @examples
#'
#' lesson_fragment()
lesson_fragment <- function() {
  system.file("lesson-fragment", package = "pegboard")
}
