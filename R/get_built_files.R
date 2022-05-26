get_built_files <- function(lesson = ".") {
  if (inherits(lesson, "character") && fs::dir_exists(lesson)) {
    path <- lesson
    lesson <- Lesson$new(path, jekyll = FALSE)
  } else {
    path <- lesson$path
  }
  if (!fs::dir_exists(fs::path(path, "site", "built"))) { 
    txt <- "No files built. Run {.code sandpaper::build_lesson()} to build."
    cli::cli_alert_warning(txt)
    return(NULL)
  } 
  lfiles <- fs::path_file(lesson$files)
  built_files <- fs::path(path, "site", "built", fs::path_ext_set(lfiles, "md"))
  res <- purrr::map(built_files, 
    ~Episode$new(.x, process_tags = FALSE, fix_liquid = FALSE, fix_links = FALSE)$confirm_sandpaper())

  names(res) <- fs::path_rel(built_files, path)
  res
}
