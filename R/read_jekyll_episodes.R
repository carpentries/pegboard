read_jekyll_episodes <- function(path = NULL, rmd = FALSE, ...) {
  # Old Lesson
  md_src  <- fs::path(path, "_episodes")
  rmd_src <- fs::path(path, "_episodes_rmd")
  # Enforce that we are using RMD files
  rmd_exists <- fs::dir_exists(rmd_src)
  md_exists <- fs::dir_exists(md_src)
  no_episodes <- !rmd_exists && !md_exists
  not_overview <- !endsWith(fs::path_file(path), "-workshop")
  is_overview <- no_episodes && !not_overview

  if (is_overview) {
    return(list(episodes = NULL, rmd = FALSE, overview = TRUE))
  }

  if (not_overview && no_episodes) {
    stop(glue::glue("could not find either _episodes/ or _episodes_rmd/ in {path}"))
  }

  rmd_files <- if (rmd_exists) fs::dir_ls(rmd_src, glob = "*Rmd") else character(0)
  md_files  <- if (md_exists) fs::dir_ls(md_src, glob = "*md") else character(0)
  md_n <- length(md_files)
  rmd_n <- length(rmd_files)
  read_rmd <- rmd_n > 0L

  if (read_rmd) {
    rmd_slugs <- fs::path_ext_remove(fs::path_file(rmd_files))
    md_slugs  <- fs::path_ext_remove(fs::path_file(md_files))
    all_rmd   <- md_n == 0L || identical(rmd_slugs, md_slugs)
    rmd <- TRUE
  } else {
    all_rmd <- FALSE
  }

  read_md <- md_exists && md_n > 0L && !all_rmd

  eps <- list()

  if (read_md) {
    eps <- read_markdown_files(md_src, sandpaper = FALSE, ...)
  } else if (all_rmd) {
    pb_message("could not find _episodes/, using _episodes_rmd/ as the source")
  } else if (md_exists && md_n == 0L) {
    stop(glue::glue("The _episodes/ directory must have (R)markdown files"),
      call. = FALSE
    )
  } else {
    # source directory does not exist, but the rmd does
  }

  if (read_rmd) {
    rmd_eps <- read_markdown_files(rmd_src, sandpaper = FALSE, ...)
    if (!all_rmd) {
      to_switch <- fs::path_ext_set(rmd_slugs[rmd_slugs %in% md_slugs], "md")
      new_names <- fs::path_ext_set(to_switch, "Rmd")
      eps[to_switch] <- rmd_eps[new_names]
      names(eps) <- unname(purrr::map_chr(eps, "name"))
    } else {
      eps <- rmd_eps
    }
  }

  return(list(episodes = eps, rmd = rmd, overview = !not_overview))
}
