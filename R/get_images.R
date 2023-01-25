#' Get images from an Episode/yarn object
#'
#' @param yrn an Episode/yarn object
#' @param process if `TRUE` (default), images will be processed via 
#'   [process_images()] to add the alt attribute and extract images from HTML
#'   blocks. `FALSE` will present the nodes as found by XPath search.
#' @return an xml_nodelist
#' @keywords internal
get_images <- function(yrn, process = TRUE) {
  img    <- ".//md:image"
  hblock <- ".//md:html_block[contains(text(), '<img')]"
  hline  <- ".//md:html_inline[starts-with(text(), '<img')]"
  xpath  <- glue::glue("{img} | {hblock} | {hline}")
  images <- xml2::xml_find_all(yrn$body, xpath, yrn$ns)
  images <- if (process) process_images(images) else images
  images
}

#' Set alt attribute for image nodes; extract images from HTML blocks
#'
#' Markdown specification is not always clear about what goes in the text part
#' of an image. Pandoc specifies a markdown image as 
#'   ![caption text](img.png){alt="alt text"}
#' Since commonmark does not recognize the alt-text, we need to find it 
#' ourselves. 
#'
#' Moreover, it's possible to include HTML images, so we need to parse the HTML
#' to expose the alt text.
#'
#' @param images an XML nodelist that contains blocs with image information
#' @param ns the namespace to use 
#' @return a copy of the nodelist
#' @keywords internal
process_images <- function(images, ns = tinkr::md_ns()) {
  xpath <- "self::*/following-sibling::*[1]/self::*[starts-with(text(), '{')]"
  have_alts <- xml2::xml_find_lgl(images, glue::glue("boolean({xpath})"), ns)
  have_no_attr <- is.na(xml2::xml_attr(images[have_alts], "alt"))
  html_nodes <- grepl("html_", xml2::xml_name(images))
  if (sum(have_alts) && all(have_no_attr)) {
    set_alt_attr(images[have_alts], xpath, ns)
  }
  if (sum(html_nodes)) {
    # This creates a copy of the nodes

    # HTML nodes are tricky because you can pack a whole bunch of images in
    # there, so what we do is extract them and then figure out if we have to
    # add new nodes on to the end.
    img_blocks <- extract_img_from_html(images[html_nodes])
    nh <- sum(html_nodes)
    which_node <- which(html_nodes)
    # Replace the existing HTML nodes
    for (i in seq(nh)) {
      images[[which_node[i]]] <- img_blocks[[i]]
    }
    # Append any remaining nodes at the end
    if (length(img_blocks) > nh) {
      n <- length(images)
      for (i in seq(length(img_blocks) - nh)) {
        images[[n + i]] <- img_blocks[[nh + i]]
      }
    }
  }
  images
}

#' Set the alt text for a nodeset of images
#'
#' This finds the attribute curly braces after an image declaration, extracts
#' the alt text, and adds it as an attribute to the image, which is useful in
#' parsing the XML, and will not affect rendering.
#'
#' @note this function assumes that the images entering have a curly brace
#'   following.
#'
#' @param images a nodeset of images
#' @param xpath an XPath expression that finds the first curly brace immediately
#'   after a node. 
#' @param ns the namespace of the XML
#' @return the nodeset, invisibly.
set_alt_attr <- function(images, xpath, ns) {
  attrs <- xml2::xml_find_all(images, glue::glue("./{xpath}"), ns = ns)
  # We have the text of the alt text here, but it's possible that the alt text
  # was separated on different lines
  attr_texts <- xml2::xml_text(attrs)
  no_closing <- !grepl("[}]", attr_texts)
  if (any(no_closing)) {
    fixed_text <- purrr::map_chr(attrs[no_closing], get_broken_attr_text, ns)
    attr_texts[no_closing] <- fixed_text
  }
  htmls <- paste(gsub("[{](.+)[}]", "<img \\1/>", attr_texts), collapse = "\n")
  htmls <- xml2::read_html(htmls)
  alts <- xml2::xml_find_all(htmls, ".//img")
  alts <- xml2::xml_attr(alts, "alt")
  purrr::walk2(images, alts, function(img, alt) {
    if (!is.na(alt)) xml2::xml_set_attr(img, "alt", alt)
  })
  invisible(images)
}

#' @noRd
#'
#' @param attr_node an attribute node following an image. This should be a
#'   text node that will start with `{`.
#' @param ns the xml namespace
get_broken_attr_text <- function(attr_node, ns) {
  closer <- xml2::xml_find_first(attr_node, closing_attr_xpath(), ns)
  # find all the sibling nodes between the attr_node and the closer
  # and extract the text
  txt <- xml2::xml_text(find_between_nodes(attr_node, closer))
  # collapse the text without the newlines
  paste(txt[txt != ''], collapse = " ")
}

closing_attr_xpath <- function() {
  # This XPath satement is _really_ hairy. Effectively, we are looking for
  # _closing_ bracket with the possibility that there could be brackets that
  # look like our closer. We will know a bracket is a closer if it is the last
  # one on the line or if it is preceded by a quote or space.
  #
  # 1. a bracket at the end of the line is a closing bracket 
  #   (this could be violated but I think it's a safe edge case)
  ender <- "substring(text(), string-length(text)) = '}'"
  # 2. a bracket that is preceded by a single quote
  single_quote <- "contains(text(), concat(\"'\", \"}\"))"
  # 3. a bracket that is preceded by a space
  # 4. a bracket that is preceded by a double quote
  possible_closers <- paste0(c(" ", '"'), "}")
  closer_pred <- paste0("contains(text(), '", possible_closers, "')")
  # collapsing everything together
  final_pred <- paste(c(closer_pred, single_quote, ender), collapse = " or ")
  paste0("./following-sibling::md:text[", final_pred, "][1]")
}


extract_img_from_html <- function(html_blocks) {
  res <- purrr::map(html_blocks, 
    ~xml2::xml_find_all(xml2::read_html(xml2::xml_text(.x)), ".//img")
  )
  srcpos <- purrr::map_chr(html_blocks, ~xml2::xml_attr(.x, "sourcepos"))
  purrr::walk(res, ~xml2::xml_set_attr(.x, "destination", xml2::xml_attr(.x, "src")))
  purrr::walk2(res, srcpos, ~xml2::xml_set_attr(.x, "sourcepos", .y))
  res <- purrr::map(res, c)
  purrr::flatten(res)
}
