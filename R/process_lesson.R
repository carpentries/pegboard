#' Process downloaded lessons
#'
#' @param lesson a list of XML object representing lessons
#' @inheritParams get_challenges
#' @export
#'
#' @return a list of XML block quotes for each episode
#' @examples
#'
#' frg <- get_lesson(path = lesson_fragment())
#' process_lesson(frg)
process_lesson <- function(lesson, as_list = FALSE) {
  purrr::map(lesson, ~get_challenges(.x[["body"]], as_list = FALSE))
}
