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
    #' @param fix_liquid \[`logical`\] defaults to `FALSE`, which means data is
    #'   immediately passed to [tinkr::yarn]. If `TRUE`, all liquid variables
    #'   in relative links have spaces removed to allow the commonmark parser to
    #'   interpret them as links.
    #' @param ... arguments passed on to [tinkr::yarn] and [tinkr::to_xml()]
    #' @return A new Episode object with extracted XML data
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' scope$name
    #' scope$lesson
    #' scope$challenges
    initialize = function(path = NULL, process_tags = TRUE, fix_links = TRUE, fix_liquid = FALSE, ...) {
      if (!file.exists(path)) {
        stop(glue::glue("the file '{path}' does not exist"))
      }
      links <- getOption("sandpaper.links")
      if (length(links) && fs::file_exists(links)) {
        # if we have links, we concatenate our input files 
        tmpin <- tempfile(fileext = ".md")
        fs::file_copy(path, tmpin)
        file.append(tmpin, links)
        path <- tmpin
        on.exit(unlink(tmpin), add = TRUE)
      }
      default <- list(
        yaml = NULL,
        body = xml2::xml_missing()
      )
      TOX <- purrr::safely(super$initialize, otherwise = default, quiet = FALSE)
      if (fix_liquid) {
        tmp <- fix_liquid_relative_link(path)
        lsn <- TOX(tmp, sourcepos = TRUE, ...)
        close(tmp)
      } else {
        lsn <- TOX(path, sourcepos = TRUE, ...)
      }
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
      self$ns   <- lsn$ns
    },


    #' @description enforce that the episode is a {sandpaper} episode withtout
    #' going through the conversion steps. The default Episodes from pegboard
    #' were assumed to be generated using Jekyll with kramdown syntax. This is
    #' a bit of a kludge to bypass the normal checks for kramdown syntax and 
    #' just assume pandoc syntax
    confirm_sandpaper = function() {
      ok <- c("unblock", "use_sandpaper_md", "use_sandpaper_rmd",
        "move_questions", "move_objectives", "move_keypoints")
      muts <- private$mutations
      muts[ok] <- TRUE
      private$mutations <- muts
      invisible(
        tryCatch(self$label_divs(),
          error = function(e) {
            msg <- glue::glue("
              {e$message}
              Section (div) tags for {self$name} will not be labelled"
            )
            message(msg, call. = FALSE)
            self
          })
      )
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
    #' fetch the image sources and optionally process them for easier parsing.
    #' The default version of this function is equivalent to the active binding
    #' `$images`.
    #'
    #' @param process if `TRUE`, images will be processed via the internal
    #' function [process_images()], which will add the `alt` attribute, if
    #' available and extract img nodes from HTML blocks. 
    #' @return an `xml_nodelist`
    #' @examples
    #'
    #' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    #' loop$get_images()
    #' loop$get_images(process = TRUE)
    get_images = function(process = FALSE) {
      get_images(self, process = process)
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
    #' @param yml the list derived from the yml file for the episode
    use_sandpaper = function(rmd = FALSE, yml = list()) {
      if (rmd && private$mutations['use_sandpaper_rmd']) {
        return(invisible(self))
      }
      if (!rmd && private$mutations['use_sandpaper_md']) {
        return(invisible(self))
      }
      if (length(yml) == 0) {
        pth <- fs::path(self$lesson, "_config.yml")
        if (fs::file_exists(pth)) {
          suppressWarnings(yml <- yaml::read_yaml(pth))
        }
      }
      self$body <- use_sandpaper(self$body, rmd, yml)

      # Remove the common yaml offenders
      suppressWarnings(this_yaml <- self$get_yaml())
      this_yaml[["root"]] <- NULL
      this_yaml[["layout"]] <- NULL
      self$yaml <- c("---", strsplit(yaml::as.yaml(this_yaml), "\n")[[1]], "---")

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
    #' Create a trimmed-down RMarkdown document that strips prose and contains
    #' only important code chunks and challenge blocks without solutions.
    #' @param path (handout) a path to an R Markdown file to write. If this is
    #'   `NULL`, no file will be written and the lines of the output will be
    #'   returned.
    #' @param solutions if `TRUE`, include solutions in the output. Defaults to
    #'   `FALSE`, which removes the solution blocks.
    #' @return a character vector if `path = NULL`, otherwise, it is called for
    #'   the side effect of creating a file.
    #' @examples
    #' lsn <- Lesson$new(lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
    #' e <- lsn$episodes[[1]]
    #' cat(e$handout())
    #' cat(e$handout(solution = TRUE))
    handout = function(path = NULL, solutions = FALSE) {
      cp <- self$clone(deep = TRUE)
      cp$unblock()$use_sandpaper()
      if (!solutions) {
        purrr::walk(cp$solutions, xml2::xml_remove)
      }
      challenges <- purrr::map(cp$challenges, trim_fence)
      code <- cp$code
      code <- code[xml2::xml_attr(code, "purl") %in% "TRUE"]
      isolate_elements(cp$body, challenges, code)
      cp$yaml <- c()
      res <- tinkr::to_md(cp, path = path, stylesheet_path = get_stylesheet())
      if (is.null(path)) {
        invisible(res)
      } else {
        invisible(self)
      }
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
    #'  - first heading starts at level 2 (`first_heading_is_second_level`)
    #'  - greater than level 1 (`greater_than_first_level`)
    #'  - increse sequentially (e.g. no jumps from 2 to 4) (`are_sequential`)
    #'  - have names (`have_names`)
    #'  - unique in their own hierarchy (`are_unique`)
    #'
    #' @param verbose if `TRUE` (default), a message for each rule broken will
    #'   be issued to the stderr. if `FALSE`, this will be silent. 
    #' @param warn if `TRUE` (default), a warning will be issued if there are
    #'   any failures in the tests.
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
    #' # Example: There are multiple headings called "Solution" that are not
    #' # nested within a higher-level heading and will throw an error
    #' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    #' loop$validate_headings()
    validate_headings = function(verbose = TRUE, warn = TRUE) {
      out <- validate_headings(self$headings, 
        self$get_yaml()$title, 
        offset = length(self$yaml))
      if (is.null(out)) {
        return(out)
      }
      res <- out$result
      res$path <- fs::path_rel(self$path, self$lesson)
      failures <- !all(apply(res[names(heading_tests)], MARGIN = 2L, all))
      if (warn) {
        throw_heading_warnings(res)
      }
      if (verbose && failures) {
        show_heading_tree(out$tree)
      }
      invisible(res)
    },

    #' @description perform validation on divs in a document.
    #'
    #' This will validate the following aspects of divs. See [validate_divs()]
    #' for details.
    #'
    #'  - divs are of a known type (`is_known`)
    #'
    #' @param warn if `TRUE` (default), a warning message will be if there are
    #'   any divs determined to be invalid. Set to `FALSE` if you want the
    #'   table for processing later.
    #' @return a logical `TRUE` for valid divs and `FALSE` for invalid 
    #'   divs.
    #' @examples
    #' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    #' loop$validate_divs()
    validate_divs = function(warn = TRUE) {
      res <- validate_divs(self)
      if (warn) {
        throw_div_warnings(res)
      }
      invisible(res)
    },
    
    #' @description perform validation on links and images in a document.
    #'
    #' This will validate the following aspects of links. See [validate_links()]
    #' for details.
    #'
    #'  - External links use HTTPS (`enforce_https`)
    #'  - Internal links exist (`internal_okay`)
    #'  - External links are reachable (`all_reachable`) (planned)
    #'  - Images have alt text (`img_alt_text`)
    #'  - Link text is descriptive (`descriptive`)
    #'  - Link text is more than a single letter (`link_length`)
    #'
    #' @param warn if `TRUE` (default), a warning message will be if there are
    #'   any links determined to be invalid. Set to `FALSE` if you want the
    #'   table for processing later.
    #' @return a logical `TRUE` for valid links and `FALSE` for invalid 
    #'   links.
    #' @examples
    #' loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    #' loop$validate_links()
    validate_links = function(warn = TRUE) {
      res <- validate_links(self)
      if (warn) {
        throw_link_warnings(res)
      }
      invisible(res)
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
    #' @field links \[`xml_nodeset`\] all links (not images) in the document
    links = function() {
      xpath <- ".//md:link | .//md:text[klink]"
      xml2::xml_find_all(self$body, xpath, self$ns)
    },
    #' @field images \[`xml_nodeset`\] all image sources in the document
    images = function() {
      get_images(self, process = FALSE)
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
      lsn <- fs::path_dir(self$path)
      sub_folders <- c("episodes", "learners", "instructors", "profiles",
      "_episodes", "_episodes_rmd", "_extras")
      if (basename(lsn) %in% sub_folders) {
        lsn <- fs::path_dir(lsn)
      }
      lsn
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
