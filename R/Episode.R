#' Class representing XML source of a Carpentries episode
#'
#' @description
#' Wrapper around an xml document to manipulate and inspect Carpentries episodes
#' @details
#' This class is a fancy wrapper around the results of [tinkr::to_xml()] and
#' has method specific to the Carpentries episodes.
#' @export
Episode <- R6::R6Class("Episode",
  inherit = tinkr::yarn,
  public = list(
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
      TOX <- purrr::safely(super$initialize, otherwise = default, quiet = FALSE)
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
      self$path <- lsn$path
      self$yaml <- lsn$yaml
      self$body <- lsn$body
      self$ns   <- lsn$ns
    },


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
    #' label all the div elements within the Episode to extract them with 
    #' `$get_divs()`
    label_divs = function() {
      label_div_tags(self)
      return(invisible(self))
    },
    
    #' @description
    #' return all div elements within the Episode
    #' @param type the type of div tag (e.g. 'challenge' or 'solution')
    #' @param include `\[logical\]` if `TRUE`, the div tags will be included in
    #' the output. Defaults to `FALSE`, which will only return the text between
    #' the div tags.
    get_divs = function(type = NULL, include = FALSE) {
      get_divs(self$body, type = type, include = include)
    },

    #' @description
    #' Extract the yaml metadata from the episode
    get_yaml = function() {
      yaml::yaml.load(self$yaml)
    },
    
    #' @description
    #' Ammend or add a setup code block to use `{dovetail}`
    #' 
    #' This will convert your lesson to use the {dovetail} R package for
    #' processing specialized block quotes which will do two things:
    #'
    #' 1. convert your lesson from md to Rmd
    #' 2. add to your setup chunk the following code
    #'    ```
    #'    library('dovetail')
    #'    source(dvt_opts())
    #'    ```
    #' If there is no setup chunk, one will be created. If there is a setup
    #' chunk, then the `source` and `knitr_fig_path` calls will be removed.
    use_dovetail = function() {
      if (private$mutations['use_dovetail']) {
        return(invisible(self))
      }
      use_dovetail(self$body)
      private$mutations['use_dovetail'] <- TRUE
      invisible(self)
    },

    #' @description
    #' Use the sandpaper package for processing
    #'
    #' This will convert your lesson to use the `{sandpaper}` R package for
    #' processing the lesson instead of Jekyll (default). Doing this will have
    #' the following effects:
    #'
    #' 1. code blocks that were marked with liquid tags (e.g. `{: .language-r}`
    #'    are converted to standard code blocks or Rmarkdown chunks (with 
    #'    language information at the top of the code block)
    #' 2. If rmarkdown is used and the lesson contains python code, 
    #'    `library('reticulate')` will be added to the setup chunk of the 
    #'    lesson.
    #'
    #' @param rmd if `TRUE`, lessons will be converted to RMarkdown documents
    use_sandpaper = function(rmd = FALSE) {
      if (rmd && private$mutations['use_sandpaper_rmd']) {
        return(invisible(self))
      }
      if (!rmd && private$mutations['use_sandpaper_md']) {
        return(invisible(self))
      }
      use_sandpaper(self$body, rmd)
      type <- if (rmd) 'use_sandpaper_rmd' else 'use_sandpaper_md'
      private$mutations[type] <- TRUE
      invisible(self)
    },

    #' @description
    #' Remove error blocks
    remove_error = function() {
      if (private$mutations['remove_error']) {
        return(invisible(self))
      }
      purrr::walk(self$error, xml2::xml_remove)
      private$mutations['remove_error'] <- TRUE
      invisible(self)
    },
    
    #' @description
    #' Remove output blocks
    remove_output = function() {
      if (private$mutations['remove_output']) {
        return(invisible(self))
      }
      purrr::walk(self$output, xml2::xml_remove)
      private$mutations['remove_output'] <- TRUE
      invisible(self)
    },
    
    #' @description 
    #' move the objectives yaml item to the body
    move_objectives = function() {
      if (private$mutations['move_objectives']) {
        invisible(self)
      }
      dovetail <- private$mutations['use_dovetail']
      yml <- self$get_yaml()
      move_yaml(yml, self$body, "objectives", dovetail)
      private$clear_yaml_item("objectives")
      private$mutations['move_objectives'] <- TRUE
      invisible(self)
    },
    
    #' @description 
    #' move the keypoints yaml item to the body
    move_keypoints = function() {
      if (private$mutations['move_keypoints']) {
        invisible(self)
      }
      dovetail <- private$mutations['use_dovetail']
      yml <- self$get_yaml()
      move_yaml(yml, self$body, "keypoints", dovetail)
      private$clear_yaml_item("keypoints")
      private$mutations['move_keypoints'] <- TRUE
      invisible(self)
    },

    #' @description 
    #' move the questions yaml item to the body
    move_questions = function() {
      if (private$mutations['move_questions']) {
        invisible(self)
      }
      dovetail <- private$mutations['use_dovetail']
      yml <- self$get_yaml()
      move_yaml(yml, self$body, "questions", dovetail)
      private$clear_yaml_item("questions")
      private$mutations['move_questions'] <- TRUE
      invisible(self)
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

    #' @description show the markdown contents on the screen
    #' @return a character vector with one line for each line of output
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' scope$head()
    #' scope$tail()
    #' scope$show()
    show = function() {
      super$show(get_stylesheet())
    },

    #' @description show the first n lines of markdown contents on the screen
    #' @param n the number of lines to show from the top 
    #' @return a character vector with one line for each line of output
    head = function(n = 6L) {
      super$head(n, get_stylesheet())
    },

    #' @description show the first n lines of markdown contents on the screen
    #' @param n the number of lines to show from the top 
    #' @return a character vector with one line for each line of output
    tail = function(n = 6L) {
      super$tail(n, get_stylesheet())
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
      private$mutations <- private$mutations & FALSE
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
      if (private$mutations['isolate_blocks']) {
        return(invisible(self))
      }
      isolate_kram_blocks(self$body)
      private$mutations['isolate_blocks'] <- TRUE
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
      if (private$mutations['unblock']) {
        return(invisible(self))
      }
      if (private$mutations['use_dovetail']) {
        purrr::walk(self$get_blocks(), to_dovetail, token = token)
      } else {
        purrr::walk(self$get_blocks(level = 0), replace_with_div)
        label_div_tags(self)
      }
      private$mutations['unblock'] <- TRUE
      invisible(self)
    },

    #' @description perform validation on headings in a document.
    #'
    #' This will validate the following aspects of all headings:
    #'
    #'  - greater than level 1
    #'  - increse sequentially (e.g. no jumps from 2 to 4)
    #'  - unique in their own hierarchy
    #'  - have names
    #'  - first heading starts at level 2
    #'
    #' @param verbose if `TRUE` (default), a message for each rule broken will
    #'   be issued to the stderr. if `FALSE`, this will be silent. 
    #' @return a logical `TRUE` for valid headings and `FALSE` for invalid 
    #'   headings.
    #' @examples
    #' # Example: There are multiple headings called "Solution" that are not
    #' # nested within a higher-level heading and will throw an error
    #' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    #' loop$validate_headings()
    #' 
    validate_headings = function(verbose = TRUE){
      validate_headings(self$headings, verbose)
    }
),
  active = list(
    #' @field show_problems \[`list`\] a list of all the problems that occurred in parsing the episode
    show_problems = function() {
      private$problems
    },

    #' @field headings \[`xml_nodeset`\] all headings in the document
    headings = function() {
      get_headings(self$body)
    },

    #' @field tags \[`xml_nodeset`\] all the kramdown tags from the episode
    tags = function() {
      xml2::xml_find_all(self$body, ".//@ktag")
    },

    #' @field questions \[`character`\] the questions from the episode
    questions = function() {
      get_list_block(self, type = "questions", in_yaml = !private$mutations['move_questions'])
    },

    #' @field keypoints \[`character`\] the keypoints from the episode
    keypoints = function() {
      get_list_block(self, type = "keypoints", in_yaml = !private$mutations['move_keypoints'])
    },

    #' @field objectives \[`character`\] the objectives from the episode
    objectives = function() {
      get_list_block(self, type = "objectives", in_yaml = !private$mutations['move_objectives'])
    },

    #' @field challenges \[`xml_nodeset`\] all the challenges blocks from the episode
    challenges = function() {
      if (!private$mutations['unblock']) {
        type <- "block"
      } else if (private$mutations['use_dovetail']) {
        type <- "chunk"
      } else {
        type <- "div"
      }
      get_challenges(self$body, type = type)
    },

    #' @field solutions \[`xml_nodeset`\] all the solutions blocks from the episode
    solutions = function() {
      if (!private$mutations['unblock']) {
        type <- "block"
      } else if (private$mutations['use_dovetail']) {
        type <- "chunk"
      } else {
        type <- "div"
      }
      get_solutions(self$body, type = type)
    },

    #' @field output \[`xml_nodeset`\] all the output blocks from the episode
    output = function() {
      if (any(private$mutations[c('use_sandpaper_md', 'use_sandpaper_rmd')])) {
        self$code[which(xml2::xml_attr(self$code, "info") == "output")]
      } else {
        get_code(self$body, ".output")
      }
    },

    #' @field error \[`xml_nodeset`\] all the error blocks from the episode
    error = function() {
      if (any(private$mutations[c('use_sandpaper_md', 'use_sandpaper_rmd')])) {
        self$code[which(xml2::xml_attr(self$code, "info") == "error")]
      } else {
        get_code(self$body, ".error")
      }
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
    mutations = c(
      unblock           = FALSE, # have kramdown blocks been converted?
      use_dovetail      = FALSE, # are we keeping challenges in code blocks?
      use_sandpaper_md  = FALSE, # are we using a sandpaper lesson? 
      use_sandpaper_rmd = FALSE, #   e.g. code has label, not liquid tag
      isolate_blocks    = FALSE, # does our lesson consist of only blocks?
      move_keypoints    = FALSE, # are the keypoints in the body?
      move_questions    = FALSE, # are the questions in the body?
      move_objectives   = FALSE, # are the objectives in the body?
      remove_error      = FALSE, # have errors been removed?
      remove_output     = FALSE, # have output been removed?
      NULL
    ),

    problems = list(),

    deep_clone = function(name, value) {
      if (name == "body") {
        xml2::read_xml(as.character(value))
      } else {
        value
      }
    }
  )
)
