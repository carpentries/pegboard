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
    #' Create a new Episode
    #' @param path \[`character`\] path to a markdown episod file on disk
    #' @return A new Episode object with extraced XML data
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' scope$name
    #' scope$lesson
    #' scope$challenges
    initialize = function(path = NULL) {
      if (!file.exists(path)) {
        stop(glue::glue("the file '{path}' does not exist"))
      }
      safe_to_xml <- purrr::possibly(
        tinkr::to_xml,
        otherwise =
          list(
            yaml = NULL,
            body = xml2::xml_missing()
          ),
        quiet = TRUE
      )
      lsn <- safe_to_xml(path)
      self$path <- path
      self$yaml <- lsn$yaml
      self$body <- lsn$body
    }
  ),
  active = list(
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
      get_code(self$body)
    },

    #' @field name \[`character`\] the name of the source file without the path
    name = function() {
      fs::path_file(self$path)
    },

    #' @field lesson \[`character`\] the path to the lesson where the episode is from
    lesson = function() {
      fs::path_dir(fs::path_dir(self$path))
    }
  )
)
