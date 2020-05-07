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
    #' Extract all challenge blocks from the Episode
    #' @return an `xml_nodeset` object with each node being a `block_quote`. 
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    #' scope$challenges()
    challenges = function() {
      get_challenges(self$body)
    },

    #' @description
    #' name of the file without the path.
    #' @return a character
    #' @examples
    #' scope$name()
    name = function() {
      fs::path_file(self$path)
    },

    #' @description
    #' path to the lesson
    #' @return a character 
    #' @examples
    #' scope$lesson()
    lesson = function() {
      fs::path_dir(fs::path_dir(self$path))
    },

    #' @description 
    #' Create a new Episode
    #' @param path \[`character`\] path to a markdown episod file on disk
    #' @return A new Episode object with extraced XML data
    #' @examples
    #' scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    initialize = function(path = NULL) {
      if (!file.exists(path)) {
        stop(glue::glue("the file '{path}' does not exist"))
      }
      lsn       <- tinkr::to_xml(path)
      self$path <- path
      self$yaml <- lsn$yaml
      self$body <- lsn$body
    }
  )
)
    
