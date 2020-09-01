#' Class representing XML source of a Carpentries episode
#'
#' @description
#' Wrapper around an xml document to manipulate and inspect Carpentries episodes
#' @details
#' This class is a fancy wrapper around the results of [tinkr::to_xml()] and
#' has method specific to the Carpentries episodes.
#' @export
Episode <- R6::R6Class("Episode",
  public = list(

    #' @field path \[`character`\] path to file on disk
    path = NULL,

    #' @field yaml \[`character`\] text block at head of file
    yaml = NULL,

    #' @field body \[`xml_document`\] an xml document of the episode
    body = NULL,

    #' @field ns \[`xml_document`\] an xml namespace set to the file name
    ns = NULL,

    #' @description return all `block_quote` elements within the Episode
    #' @param type the type of block quote in the Jekyll syntax like ".challenge",
    #'   ".discussion", or ".solution"
    #' @param level the level of the block within the document. Defaults to `1`,
    #'   which represents all of the block_quotes are not nested within any other
    #'   block quotes. Increase the nubmer to increase the level of nesting.
    #' @return \[`xml_nodeset`\] all the blocks from the episode with the given
    #'   tag and level.
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' # get all the challenges
    #' scope$get_blocks(".challenge")
    #' # get the solutions
    #' scope$get_blocks(".solution", level = 2)
    #' \dontrun{
    #'
    #'   # download the source files for r-novice-gampinder into a Lesson object
    #'   rng <- get_lesson("swcarpentry/r-novice-gapminder")
    #'   dsp1 <- rng$episodes[["04-data-structures-part1.md"]]
    #'   # There are 9 blocks in total
    #'   dsp1$get_blocks()
    #'   # One is a callout block
    #'   dsp1$get_blocks(".callout")
    #'   # One is a discussion block
    #'   dsp1$get_blocks(".discussion")
    #'   # Seven are Challenge blocks
    #'   dsp1$get_blocks(".challenge")
    #'   # There are eight solution blocks:
    #'   dsp1$get_blocks(".solution", level = 2L)
    #' }
    get_blocks = function(type = NULL, level = 1L) {
      get_blocks(self$body, type = type, level = level)
    },

    #' @description
    #' Extract the yaml metadata from the episode
    get_yaml = function() {
      yaml::yaml.load(self$yaml)
    },
    
    #' @description 
    #' move the objectives yaml item to the body
    move_objectives = function() {
      yml <- self$get_yaml()
      move_yaml(yml, self$body, "objectives")
      private$clear_yaml_item("objectives")
    },
    
    #' @description 
    #' move the keypoints yaml item to the body
    move_keypoints = function() {
      yml <- self$get_yaml()
      move_yaml(yml, self$body, "keypoints")
      private$clear_yaml_item("keypoints")
    },

    #' @description 
    #' move the questions yaml item to the body
    move_questions = function() {
      yml <- self$get_yaml()
      move_yaml(yml, self$body, "questions")
      private$clear_yaml_item("questions")
    },

    #' @description
    #' Create a graph of the top-level elements for the challenges.
    #'
    #' @param recurse if `TRUE` (default), the content of the solutions will be
    #'   included in the graph; `FALSE` will keep the solutions as `block_quote`
    #'   elements.
    #' @return a data frame with four columns representing all the elements
    #'   within the challenges in the Episode:
    #'   - Block: The sequential number of the challenge block
    #'   - from: the inward elements
    #'   - to: the outward elements
    #'   - pos: the position in the markdown document
    #'
    #'   Note that there are three special node names:
    #'   - challenge: start or end of the challenge block
    #'   - solution: start of the solution block
    #'   - lesson: start of the lesson block
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' scope$get_challenge_graph()
    get_challenge_graph = function(recurse = TRUE) {
      purrr::map_dfr(self$challenges, feature_graph, recurse = recurse, .id = "Block")
    },

    #' @description write the episode to disk as markdown
    #'
    #' @param path the path to write your file to. Defaults to an empty
    #'   directory in your temporary folder
    #' @param format one of "md" (default) or "xml". This will
    #'   create a file with the correct extension in the path
    #' @param edit if `TRUE`, the file will open in an editor. Defaults to
    #'   `FALSE`.
    #' @return the episode object
    #' @note The current XLST spec for {tinkr} does not support kramdown, which
    #'   the Carpentries Episodes are styled with, thus some block tags will be
    #'   destructively modified in the conversion.
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' scope$write()
    write = function(path = NULL, format = "md", edit = FALSE) {
      if (is.null(path)) {
        path <- fs::file_temp(pattern = "dir")
        message(glue::glue("Creating temporary directory '{path}'"))
        fs::dir_create(path)
      }
      if (!fs::dir_exists(path)) {
        stop(glue::glue("the directory '{path}' does not exist"), call. = FALSE)
      }
      the_file <- fs::path(path, self$name)
      fs::path_ext(the_file) <- format
      if (format %in% c("md", "Rmd")) {
        stylesheet <- get_stylesheet()
        on.exit(fs::file_delete(stylesheet))
        tinkr::to_md(self, path = the_file, stylesheet_path = stylesheet)
      } else if (format == "xml") {
        xml2::write_xml(self$body, file = the_file, options = c("format", "as_xml"))
      } else if (format == "html") {
        xml2::write_html(self$body, file = the_file, options = c("format", "as_html"))
      } else {
        stop(glue::glue("format = '{format}' is not a valid option"), call. = FALSE)
      }
      # nocov start
      if (fs::file_exists(the_file) && edit) file.edit(the_file)
      # nocov end
      return(invisible(self))
    },

    #' @description
    #' Re-read episode from disk
    #' @return the episode object
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' xml2::xml_text(scope$tags[1])
    #' xml2::xml_set_text(scope$tags[1], "{: .code}")
    #' xml2::xml_text(scope$tags[1])
    #' scope$reset()
    #' xml2::xml_text(scope$tags[1])
    reset = function() {
      self$initialize(self$path)
      return(invisible(self))
    },

    #' @description
    #' Remove all elements except for those within block quotes that have a
    #' kramdown tag. Note that this is a destructive process.
    #' @return the Episode object, invisibly
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' scope$body # a full document with block quotes and code blocks, etc
    #' scope$isolate_blocks()$body # only one challenge block_quote
    isolate_blocks = function() {
      isolate_kram_blocks(self$body)
      invisible(self)
    },

    #' @description convert challenge blocks to roxygen-like code blocks
    #' @param token the token to use to indicate non-code, Defaults to "#'"
    #' @return the Episode object, invisibly
    #' @examples
    #' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    #' loop$body # a full document with block quotes and code blocks, etc
    #' loop$get_blocks() # all the blocks in the episode
    #' loop$unblock()
    #' loop$get_blocks() # no blocks
    #' loop$code # now there are two blocks with challenge tags
    unblock = function(token = "#'") {
      purrr::walk(self$get_blocks(), to_dovetail, token = token)
      invisible(self)
    },

    #' @description Create a new Episode
    #' @param path \[`character`\] path to a markdown episode file on disk
    #' @param process_tags \[`logical`\] if `TRUE` (default), kramdown tags will
    #'   be processed into attributes of the parent nodes. If `FALSE`, these
    #'   tags will be treated as text
    #' @param fix_links \[`logical`\] if `TRUE` (default), links pointing to
    #'   liquid tags (e.g. `{{ page.root }}`) and included links (those supplied
    #'   by a call to `{\% import links.md \%}`) will be appropriately processed
    #'   as valid links.
    #' @return A new Episode object with extracted XML data
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' scope$name
    #' scope$lesson
    #' scope$challenges
    initialize = function(path = NULL, process_tags = TRUE, fix_links = TRUE) {
      if (!file.exists(path)) {
        stop(glue::glue("the file '{path}' does not exist"))
      }
      default <- list(
        yaml = NULL,
        body = xml2::xml_missing()
      )
      TOX <- purrr::safely(tinkr::to_xml, otherwise = default, quiet = FALSE)
      lsn <- TOX(path, sourcepos = TRUE)
      if (!is.null(lsn$error)) {
        private$record_problem(lsn$error)
      }
      lsn <- lsn$result

      # Process the kramdown tags
      if (process_tags) {
        tags <- kramdown_tags(lsn$body)
        blocks <- tags[are_blocks(tags)]
        tags   <- tags[!are_blocks(tags)]
        # recording problems to inspect later
        bproblem <- purrr::map(blocks, set_ktag_block)
        cproblem <- purrr::map(tags, set_ktag_code)
        bproblem <- bproblem[!purrr::map_lgl(bproblem, is.null)]
        cproblem <- cproblem[!purrr::map_lgl(cproblem, is.null)]
        if (length(bproblem) > 0) {
          private$record_problem(list(blocks = bproblem))
        }
        if (length(cproblem) > 0) {
          private$record_problem(list(code = cproblem))
        }
      }

      if (fix_links) fix_links(lsn$body)

      # Initialize the object
      self$path <- path
      self$yaml <- lsn$yaml
      self$body <- lsn$body
      self$ns   <- xml2::xml_ns(lsn$body)
    }
  ),
  active = list(
    #' @field show_problems \[`list`\] a list of all the problems that occurred in parsing the episode
    show_problems = function() {
      private$problems
    },

    #' @field tags \[`xml_nodeset`\] all the kramdown tags from the episode
    tags = function() {
      xml2::xml_find_all(self$body, ".//@ktag")
    },

    #' @field challenges \[`xml_nodeset`\] all the challenges blocks from the episode
    challenges = function() {
      get_challenges(self$body)
    },

    #' @field solutions \[`xml_nodeset`\] all the solutions blocks from the episode
    solutions = function() {
      get_solutions(self$body)
    },

    #' @field output \[`xml_nodeset`\] all the output blocks from the episode
    output = function() {
      get_code(self$body, ".output")
    },

    #' @field error \[`xml_nodeset`\] all the error blocks from the episode
    error = function() {
      get_code(self$body, ".error")
    },

    #' @field code \[`xml_nodeset`\] all the code blocks from the episode
    code = function() {
      get_code(self$body, type = NULL, attr = NULL)
    },

    #' @field name \[`character`\] the name of the source file without the path
    name = function() {
      fs::path_file(self$path)
    },

    #' @field lesson \[`character`\] the path to the lesson where the episode is from
    lesson = function() {
      fs::path_dir(fs::path_dir(self$path))
    }
  ),
  private = list(
    clear_yaml_item = function(what) {
      yml <- self$get_yaml()
      yml[[what]] <- NULL
      self$yaml <- c("---", strsplit(yaml::as.yaml(yml), "\n")[[1]], "---")
    },
    record_problem = function(x) {
      private$problems <- c(private$problems, x)
    },
    problems = list(),

    deep_clone = function(name, value) {
      if (name == "body") {
        # The new root always seems to insert an extra namespace attribtue to
        # the nodes. This process finds those attributes and removes them.
        new <- xml2::xml_new_root(value, .copy = TRUE)

        old_text  <- xml2::xml_find_all(value, ".//node()")
        old_attrs <- unique(unlist(purrr::map(xml2::xml_attrs(old_text), names)))

        new_text  <- xml2::xml_find_all(new, ".//node()")
        new_attrs <- unique(unlist(purrr::map(xml2::xml_attrs(new_text), names)))

        dff <- setdiff(new_attrs, old_attrs)
        xml2::xml_set_attr(new_text, dff, NULL)

        new
      } else {
        value
      }
    }
  )
)
