#' Read in all markdown files associated with a sandpaper lesson
#'
#' @param path the path to the lesson 
#' @param ... arguments to pass to [read_markdown_files()]
#' @return a list of two elements: 
#'   - episodes contains all the [Episode] objects representing markdown files
#'     in the `episodes` folder
#'   - extra contains all the [Episode] objects representing markdown files in
#'     all other folders (including top-level)
#'   - overview a boolean that indicates if the lesson is an overview
#' @keywords internal
read_sandpaper_lesson <- function(path, ...) {
  cfg <- fs::dir_ls(path, regexp = "config[.]ya?ml")
  n_cfg <- length(cfg)
  if (n_cfg > 1L) {
    # stop if there are two config files
    cfg <- paste(fs::path_file(cfg), collapse = ", ")
    msg <- "Found > 1 config files in the lesson: {cfg}.\nThis could be due to an incomplete conversion. Please check the contents of {path}."
    msg <- glue(msg)
    stop(msg, call. = FALSE)

  }
  if (n_cfg == 1L && fs::file_exists(cfg)) {
    the_cfg <- yaml::read_yaml(cfg, eval.expr = FALSE)
  } else {
    the_cfg <- list()
  }

  episode_path <- fs::path(path, "episodes")
  extra_paths <- fs::path(path, c("instructors", "learners", "profiles"))

  # everything in _episodes_
  episodes <- read_markdown_files(
    episode_path, the_cfg, process_tags = FALSE, ...)

  # everything in the top-level
  standard_files <- read_markdown_files(path, process_tags = FALSE, ...)

  # everything in other folders
  extra_files <- purrr::flatten(purrr::map(extra_paths,
      read_markdown_files, the_cfg, process_tags = FALSE, ...))
  
  # Will somebody _please_ think about the _children_?!
  the_children <- load_children(c(episodes, standard_files, extra_files))

  return(list(
      episodes = episodes, 
      extra = c(standard_files, extra_files),
      children = the_children,
      overview = the_cfg$overview %||% FALSE))
}
