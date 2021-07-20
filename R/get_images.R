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
  xpath <- "self::*/following-sibling::md:text[starts-with(text(), '{')]"
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
#' Note: this function works by side-effect
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
    close_xpath <- "self::*/following-sibling::md:text[contains(text(), '}')]"
    add_alts <- purrr::map_chr(attrs[no_closing], 
      ~xml2::xml_text(xml2::xml_find_all(.x, glue::glue("./{close_xpath}"), ns))
    )
    attr_texts[no_closing] <- paste(attr_texts[no_closing], add_alts)
  }
  htmls <- paste(gsub("[{](.+?)[}]", "<img \\1/>", attr_texts), collapse = "\n")
  htmls <- xml2::read_html(htmls)
  alts <- xml2::xml_find_all(htmls, ".//img")
  xml2::xml_set_attr(images, "alt", xml2::xml_attr(alts, "alt"))
  invisible(images)
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
