#' Process downloaded lessons
#'
#' @param lesson a list of XML object representing lessons
#' @inheritParams get_challenges
#' @export
#'
#' @return a list of XML block quotes for each episode
#' @examples
#'
#' png <- get_lesson("swcarpentry/python-novice-gapminder")
#' get_challenges(png[[1]]$body)
#'
process_lesson <- function(lesson, as_list = FALSE) {
  purrr::map(lesson, ~get_challenges(.x[["body"]], as_list = FALSE))
}
