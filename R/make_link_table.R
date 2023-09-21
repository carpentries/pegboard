#' Create a table of parsed URLs from a single Episode object. 
#'
#' @param yrn an Episode class object
#' @return a data frame containing the following columns:
#' - scheme The scheme for the URL (http, https, mailto, ftp, etc...)
#' - server The first part of the URL (e.g. doi.org or github.com)
#' - port the port number if it exists (note: liquid tags produce weird ports)
#' - user associated with port, usually blank
#' - path the path element of the link
#' - query anything after a "?" in a URL
#' - fragment navigation within a page; anything after "#" in a URL
#' - orig the original, unparsed URL
#' - text the text associated with the URL (stripped of markup)
#' - title the title (if any) of the URL
#' - type the type of URL (image or link)
#' - rel if it's a relative URL, the name of the anchor, otherwise NA.
#' - anchor logical if the URL is an anchor
#' - sourcepos the source position in the file
#' - filepath relative path to the source file
#' - parents list column of paths to the build parents
#' - node a list column of the nodes with the links
#' @keywords internal
#' @export
#' @examples
#' loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
#' make_link_table(Episode$new(loop))
make_link_table <- function(yrn) {

  yml_lines <- length(yrn$yaml)
  # Combining nodesets forces these to be lists, meaning that we have to use
  # mappers here.
  limg      <- c(yrn$links, yrn$get_images(process = TRUE))
  if (length(limg) == 0) {
    return(NULL)
  }
  types     <- purrr::map_chr(limg, xml2::xml_name)
  urls      <- purrr::map_chr(limg, xml2::xml_attr, "destination")
  url_table <- xml2::url_parse(urls)

  url_table$orig      <- urls
  url_table$text      <- purrr::map_chr(limg, get_link_text)
  url_table$alt       <- purrr::map_chr(limg, xml2::xml_attr, "alt")
  url_table$title     <- purrr::map_chr(limg, xml2::xml_attr, "title")
  url_table$type      <- purrr::map_chr(limg, xml2::xml_name)
  url_table$rel       <- purrr::map_chr(limg, xml2::xml_attr, "rel")
  url_table$anchor    <- !is.na(purrr::map_chr(limg, xml2::xml_attr, "anchor"))
  url_table$sourcepos <- purrr::map_int(limg, get_linestart) + yml_lines
  url_table$filepath  <- fs::path_rel(yrn$path, yrn$lesson)
  if (yrn$has_parents) {
    parents <- list(fs::path_rel(yrn$build_parents, yrn$lesson))
  } else {
    parents <- list(character(0))
  }
  url_table$parents   <- parents
  url_table$node      <- I(c(limg))

  url_table[order(url_table$sourcepos), , drop = FALSE]
}

get_link_text <- function(link) {
  res <- purrr::map_chr(xml2::xml_children(link), xml2::xml_text)
  paste(res[res != ""], collapse = " ")
}
