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
      lsn <- tinkr::to_xml(path)
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
