#' An example lesson fragment
#'
#' This example was taken from the python novice gapminder lesson
#' @param name the name of the lesson fragment
#'
#' @return a path to a lesson fragment that contains one `_episodes` directory
#'    with three files: "10-lunch.md", "14-looping-data-sets.md", and
#'    "17-scope.md"
#' @export
#' @examples
#'
#' lesson_fragment()
lesson_fragment <- function(name = "lesson-fragment") {
  system.file(name, package = "pegboard")
}
