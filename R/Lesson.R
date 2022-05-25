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

    #' @field episodes \[`list`\] list of [Episode] class objects representing
    #'   the episodes of the lesson.
    episodes = NULL,

    #' @field built \[`list`\] list of [Episode] class objects representing
    #'   the markdown artefacts rendered from RMarkdown files.
    built = NULL,

    #' @field extra \[`list`\] list of [Episode] class objects representing
    #'   the extra markdown components including index, setup, information
    #'   for learners, information for instructors, and learner profiles. This
    #'   is not processed for the jekyll lessons.
    extra = NULL,

    #' @field sandpaper \[`logical`\] when `TRUE`, the episodes in the lesson
    #'   are written in pandoc flavoured markdown. `FALSE` would indicate a 
    #'   jekyll-based lesson written in kramdown.
    sandpaper = TRUE,

    #' @field rmd \[`logical`\] when `TRUE`, the episodes represent RMarkdown
    #'   files, default is `FALSE` for markdown files (deprecated and unused).
    rmd = FALSE,

    #' @description create a new Lesson object from a directory
    #' @param path \[`character`\] path to a lesson directory. This must have a
    #'   folder called `_episodes` within that contains markdown episodes. 
    #'   Defaults to the current working directory.
    #' @param rmd \[`logical`\] when `TRUE`, the imported files will be the
    #'   source RMarkdown files. Defaults to `FALSE`, which reads the rendered
    #'   markdown files.
    #' @param jekyll \[`logical`\] when `TRUE` (default), the structure of the
    #'   lesson is assumed to be derived from the carpentries/styles repository.
    #'   When `FALSE`, The structure is assumed to be a {sandpaper} lesson and
    #'   extra content for learners, instructors, and profiles will be populated.
    #' @param ... arguments passed on to [Episode$new][Episode]
    #' @return a new Lesson object that contains a list of [Episode] objects in
    #' `$episodes`
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$path
    #' frg$episodes
    initialize = function(path = ".", rmd = FALSE, jekyll = TRUE, ...) {
      stop_if_no_path(path)
      if (jekyll) {
        jeky <- read_jekyll_episodes(path, rmd, ...)
        self$episodes <- jeky$episodes
        self$rmd <- jeky$rmd
        self$sandpaper <- FALSE
      } else {
        episode_path <- fs::path(path, "episodes")
        extra_paths <- fs::path(path, c("instructors", "learners", "profiles"))
        cfg <- fs::dir_ls(path, regexp = "config[.]ya?ml")

        self$episodes <- read_markdown_files(
          episode_path, cfg, process_tags = FALSE, ...)

        standard_files <- read_markdown_files(path, process_tags = FALSE, ...)

        extra_files <- purrr::flatten(purrr::map(extra_paths,
          read_markdown_files, cfg, process_tags = FALSE, ...))

        self$extra <- c(standard_files, extra_files)

      }
      self$path <- path
    },

    #' @description
    #' read in the markdown content generated from RMarkdown sources and load
    #' load them into memory
    load_built = function() {
      if (!self$sandpaper) {
        invisible(NULL)
      }
      self$built <- get_built_files(self) 
      invisible(self)
    },

    #' @description
    #' A getter for various active bindings in the [Episode] class of objects.
    #' In practice this is syntactic sugar around 
    #' `purrr::map(l$episodes, ~.x$element)`
    #' 
    #' @param element \[`character`\] a defined element from the active bindings
    #' in the [Episode] class. Defaults to NULL, which will return nothing. 
    #' Elements that do not exist in the [Episode] class will return NULL
    #' @param collection \[`character`\] one or more of "episodes" (default),
    #' "extra", or "built". Select `TRUE` to collect information from all files.
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$get("error") # error code blocks
    #' frg$get("links") # links
    get = function(element = NULL, collection = "episodes") {
      if (is.null(element)) {
        return(NULL)
      }
      things <- c("episodes", "extra", "built")
      names(things) <- things
      things <- things[collection]
      if (length(things) == 1L) {
        to_collect <- self[[things]]
      } else {
        to_collect <- purrr::flatten(purrr::map(things, ~self[[.x]]))
      }
      purrr::map(to_collect, ~.x[[element]])
    },
    #' @description
    #' summary of element counts in each episode. This can be useful for
    #' assessing a broad overview of the lesson dynamics
    #' @param collection \[`character`\] one or more of "episodes" (default),
    #' "extra", or "built". Select `TRUE` to collect information from all files.
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$summary() # episode summary (default)
    summary = function(collection = "episodes") {
      if (!self$sandpaper) {
        cli::cli_alert_warning("Summary only for workbench lessons")
        return(NULL)
      }
      things <- c("episodes", "extra", "built")
      names(things) <- things
      things <- things[collection]
      if (length(things) == 1L) {
        to_collect <- self[[things]]
      } else {
        to_collect <- purrr::flatten(purrr::map(things, ~self[[.x]]))
      }
      res <- purrr::map(to_collect, ~.x$summary())
      res <- stack_rows(res)
      names(res)[1] <- "page"
      return(res)
    },

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

    #' @description
    #' Re-read all Episodes from disk
    #' @return the Lesson object
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$episodes[[1]]$body
    #' frg$isolate_blocks()$episodes[[1]]$body # empty
    #' frg$reset()$episodes[[1]]$body # reset
    reset = function() {
      self$initialize(self$path)
      return(invisible(self))
    },

    #' @description
    #' Remove all elements except for those within block quotes that have a
    #' kramdown tag. Note that this is a destructive process.
    #' @return the Episode object, invisibly
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$isolate_blocks()$body # only one challenge block_quote
    isolate_blocks = function() {
      purrr::walk(self$episodes, ~.x$isolate_blocks())
      invisible(self)
    },

    #' @description create a handout for all episodes in the lesson
    #' @param path the path to the R Markdown file to be written. If `NULL`
    #'   (default), no file will be written and the lines of the output document
    #'   will be returned.
    #' @param solution if `TRUE` solutions will be retained. Defaults to `FALSE`
    #' @return if `path = NULL`, a character vector, otherwise, the object
    #'   itself is returned.
    #' @examples
    #' lsn <- Lesson$new(lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
    #' cat(lsn$handout())
    #' cat(lsn$handout(solution = TRUE))
    handout = function(path = NULL, solution = FALSE) {
      hands <- purrr::map(self$episodes, 
        ~paste0("## ", .x$get_yaml()["title"], "\n\n", 
          .x$handout(solution = solution)
        )
      )
      squish <- purrr::flatten_chr(hands)
      if (is.null(path)) {
        return(invisible(squish))
      } else {
        writeLines(squish, con = path)
      }
      return(self)
    },

    #' @description
    #' Validate that the heading elements meet minimum accessibility 
    #' requirements. See the internal [validate_headings()] for deails.
    #'
    #' This will validate the following aspects of all headings:
    #'
    #'  - first heading starts at level 2 (`first_heading_is_second_level`)
    #'  - greater than level 1 (`greater_than_first_level`)
    #'  - increse sequentially (e.g. no jumps from 2 to 4) (`are_sequential`)
    #'  - have names (`have_names`)
    #'  - unique in their own hierarchy (`are_unique`)
    #'
    #' @param verbose if `TRUE`, the heading tree will be printed to the console
    #'   with any warnings assocated with the validators
    #' @return a data frame with a variable number of rows and the follwoing 
    #'   columns:
    #'    - **episode** the filename of the episode
    #'    - **heading** the text from a heading
    #'    - **level** the heading level
    #'    - **pos** the position of the heading in the document
    #'    - **node** the XML node that represents the heading
    #'    - (the next five columns are the tests listed above)
    #'    - **path** the path to the file. 
    #'   
    #'   Each row in the data frame represents an individual heading across the
    #'   Lesson. See [validate_headings()] for more details.
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$validate_headings()
    validate_headings = function(verbose = TRUE) {
      res <- purrr::map(self$episodes, 
        ~.x$validate_headings(verbose = verbose, warn = FALSE)
      )
      res <- stack_rows(res)
      throw_heading_warnings(res)
      invisible(res)
    },
    #' @description
    #' Validate that the divs are known. See the internal [validate_divs()] for
    #' details.
    #' 
    #' ## Validation variables
    #'
    #' - divs are known (`is_known`)
    #'
    #' @param verbose if `TRUE` (default), Any failed tests will be printed to
    #'   the console as a message giving information of where in the document
    #'   the failing divs appear.
    #' @return a wide data frame with five rows and the number of columns equal
    #'   to the number of episodes in the lesson with an extra column indicating
    #'   the type of validation. See the same method in the [Episode] class for 
    #'   details.
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$validate_divs()
    validate_divs = function() {
      res <- purrr::map(self$episodes, ~.x$validate_divs(warn = FALSE))
      res <- stack_rows(res)
      throw_div_warnings(res)
      invisible(res)
    },
    #' @description
    #' Validate that the links and images are valid and accessible. See the
    #' internal [validate_links()] for details.
    #' 
    #' ## Validation variables
    #'
    #'  - External links use HTTPS (`enforce_https`)
    #'  - Internal links exist (`internal_okay`)
    #'  - External links are reachable (`all_reachable`) (planned)
    #'  - Images have alt text (`img_alt_text`)
    #'  - Link text is descriptive (`descriptive`)
    #'  - Link text is more than a single letter (`link_length`)
    #'
    #' @param verbose if `TRUE` (default), Any failed tests will be printed to
    #'   the console as a message giving information of where in the document
    #'   the failing links/images appear.
    #' @return a wide data frame with five rows and the number of columns equal
    #'   to the number of episodes in the lesson with an extra column indicating
    #'   the type of validation. See the same method in the [Episode] class for 
    #'   details.
    #' @examples
    #' frg <- Lesson$new(lesson_fragment())
    #' frg$validate_links()
    validate_links = function() {
      res <- purrr::map(self$episodes, ~.x$validate_links(warn = FALSE))
      res <- stack_rows(res)
      throw_link_warnings(res)
      invisible(res)
    }
  ),
  active = list(

    #' @field n_problems number of problems per episode
    n_problems = function() {
      purrr::map_int(self$episodes, ~length(.x$show_problems))
    },

    #' @field show_problems contents of the problems per episode
    show_problems = function() {
      res <- purrr::map(self$episodes, "show_problems")
      res[purrr::map_lgl(res, ~length(.x) > 0)]
    },

    #' @field files the source files for each episode
    files = function() {
      purrr::map_chr(self$episodes, "path")
    }
  ),
  private = list(
    deep_clone = function(name, value) {
      if (name == "episodes") {
        purrr::map(value, ~.x$clone(deep = TRUE))
      } else {
        value
      }
    }
  )
)
