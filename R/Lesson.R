#' Class to contain a single Lesson by the Carpentries
#'
#' @description
#' This is a wrapper for several [Episode] class objects.
#' @details
#' Lessons are made of up several episodes within the `_episodes/` directory of
#' a lesson. This class keeps track of several episodes and allows us to switch
#' between RMarkdown and markdown episodes
#' @export
Lesson <- R6::R6Class("Lesson",
  public = list(

    #' @field path \[`character`\] path to Lesson directory
    path = NULL,

    #' @field episodes \[`list`\] list of [Episode] class objects.
    episodes = NULL,

    #' @field rmd \[`logical`\] when `TRUE`, the episodes represent RMarkdown
    #'   files, default is `FALSE` for markdown files.
    rmd = FALSE,

    #' @description
    #' Gather all of the blocks from the lesson in a list of xml_nodeset objects
    #' @param body the XML body of a carpentries lesson (an xml2 object)
    #' @param type the type of block quote in the Jekyll syntax like ".challenge",
    #'   ".discussion", or ".solution"
    #' @param level the level of the block within the document. Defaults to `0`,
    #'   which represents all of the block_quotes within the document regardless
    #'   of nesting level.
    #' @param path \[`logical`\] if `TRUE`, the names of each element
    #'   will be equivalent to the path. The default is `FALSE`, which gives the
    #'   name of each episode.
    blocks = function(type = NULL, level = 0, path = FALSE) {
      nms <-  if (path) purrr::map(self$episodes, "path") else names(self$episodes)
      res <- purrr::map(self$episodes, ~.x$get_blocks(type = type, level = level))
      names(res) <- nms
      return(res)
    },

    #' @description
    #' Gather all of the challenges from the lesson in a list of xml_nodeset objects
    #' @param path \[`logical`\] if `TRUE`, the names of each element
    #'   will be equivalent to the path. The default is `FALSE`, which gives the
    #'   name of each episode.
    #' @param graph \[`logical`\] if `TRUE`, the output will be a data frame
    #'   representing the directed graph of elements within the challenges. See
    #'   the `get_challenge_graph()` method in [Episode].
    #' @param recurse \[`logical`\] when `graph = TRUE`, this will include the
    #'   solutions in the output. See [Episode] for more details.
    challenges = function(path = FALSE, graph = FALSE, recurse = TRUE) {
      nms <-  if (path) purrr::map(self$episodes, "path") else names(self$episodes)
      eps <- self$episodes
      names(eps) <- nms
      if (graph) {
        res <- purrr::map_dfr(eps, ~.x$get_challenge_graph(recurse), .id = "Episode")
      } else {
        res <- purrr::map(eps, "challenges")
      }
      return(res)
    },

    #' @description
    #' Gather all of the solutions from the lesson in a list of xml_nodeset objects
    #' @param path \[`logical`\] if `TRUE`, the names of each element
    #'   will be equivalent to the path. The default is `FALSE`, which gives the
    #'   name of each episode.
    solutions = function(path = FALSE) {
      nms <-  if (path) purrr::map(self$episodes, "path") else names(self$episodes)
      res <- purrr::map(self$episodes, "solutions")
      names(res) <- nms
      return(res)
    },

    #' @description
    #' Remove episodes that have no challenges
    #' @param verbose \[`logical`\] if `TRUE` (default), the names of each
    #'   episode removed is reported. Set to `FALSE` to remove this behavior.
    #' @return the Lesson object, invisibly
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$thin()
    thin = function(verbose = TRUE) {
      if (verbose) {
        to_remove <- lengths(self$challenges()) == 0
        if (sum(to_remove) > 0) {
          nms <- glue::glue_collapse(names(to_remove)[to_remove], sep = ", ", last = ", and ")
          epis <- if (sum(to_remove) > 1) "episodes" else "episode"
          message(glue::glue("Removing {sum(to_remove)} {epis}: {nms}"))
          self$episodes[to_remove] <- NULL
        } else {
          message("Nothing to remove!")
        }
      } else {
        self$episodes[lengths(self$challenges()) == 0] <- NULL
      }
      invisible(self)
    },

    #' @description create a new Lesson object from a directory
    #' @param path \[`character`\] path to a lesson directory. This must have a
    #'   folder called `_episodes` within that contains markdown episodes
    #' @param rmd \[`logical`\] when `TRUE`, the imported files will be the
    #'   source RMarkdown files. Defaults to `FALSE`, which reads the rendered
    #'   markdown files.
    #' @return a new Lesson object that contains a list of [Episode] objects in
    #' `$episodes`
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$path
    #' frg$episodes
    initialize = function(path = NULL, rmd = FALSE) {

      if (!fs::dir_exists(path)) {
        stop(glue::glue("the directory '{path}' does not exist or is not a directory"))
      }

      md_src <- fs::path(path, "_episodes")
      rmd_src <- fs::path(path, "_episodes_rmd")

      if (!rmd && fs::dir_exists(md_src)) {
        src <- md_src
      } else if (fs::dir_exists(rmd_src) && (rmd || !fs::dir_exists(md_src))) {
        if (!rmd) {
          message("could not find _episodes/, using _episodes_rmd/ as the source")
          rmd <- TRUE
        }
        src <- rmd_src
      } else {
        stop(glue::glue("could not find either _episodes/ or _episodes_rmd/ in {path}"))
      }

      # Grabbing ONLY the markdown files (there are other sources of detritus)
      the_episodes <- fs::dir_ls(src, glob = "*md")

      if (!any(grepl("\\.R?md$", the_episodes))) {
        stop(glue::glue("The {src} directory must have (R)markdown files"))
      }

      self$episodes <- purrr::map(the_episodes, Episode$new)
      # Names of the episodes will be the filename, not the basename
      names(self$episodes) <- fs::path_file(the_episodes)
      self$path <- path
      self$rmd  <- rmd
    }
  ),
  active = list(

    #' @field number of problems per episode
    n_problems = function() {
      purrr::map_int(self$episodes, ~length(.x$show_problems))
    },

    #' @field contents of the problems per episode
    show_problems = function() {
      res <- purrr::map(self$episodes, "show_problems")
      res[!purrr::map_lgl(res, is.null)]
    },

    #' @field files the source files for each episode
    files = function() {
      purrr::map_chr(self$episodes, "path")
    }

  )
)
