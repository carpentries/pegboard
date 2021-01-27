#' Find all kramdown tags within the document
#'
#' @param body an XML document
#'
#' @return an XML nodeset with all the kramdown tags
#' @keywords internal
kramdown_tags <- function(body) {
  # Namespace for the document is listed in the attributes
  ns <- NS(body)
  tag <- "starts-with(text(), '{:') and contains(text(), '}')"
  srch <- glue::glue(".//<ns>:paragraph[<ns>:text[<tag>]]",
    .open  = "<",
    .close = ">"
  )
  xml2::xml_find_all(body, srch)
}

#' add the kramdown tags as attributes of special blocks
#'
#' @details
#' Kramdown is a bit weird in that it uses tags that trail elements like code
#' blocks or block quotes. If these follow block quotes, commonmark will parse
#' them being part of that block quote. This is not problematic per-se until you
#' run into a common situation in the Carpentries' curriculum: nested block
#' quotes
#'
#' ```
#' > # Challenge 1
#' >
#' > Some text here
#' >
#' > > # Solution 1
#' > >
#' > > ~~~
#' > > print("hello world!")
#' > > ~~~
#' > > {: .language-pyton}
#' > {: .solution}
#' {: .challenge}
#' ```
#'
#' When this is parsed with commonmark, the three tags at the end are parsed as
#' being part of the 2nd-level block quote:
#'
#' ```
#' ...
#' > > ~~~
#' > > {: .language-pyton}
#' > > {: .solution}
#' > > {: .challenge}
#' ```
#'
#' This function will take the block quote elements and add a "ktag" attribute
#' that represents the value of the tag. This will then be parsed by the xslt
#' style sheet and the tags will be properly appended.
#'
#' @param tags tags from the function `kramdown_tags()`
#' @keywords internal
set_ktag_block <- function(tags) {

  problems     <- list()
  parents      <- xml2::xml_parents(tags)
  parent_names <- xml2::xml_name(parents)

  ns <- NS(xml2::xml_root(parents))

  # only working in block quotes
  if (all(parent_names != "block_quote")) {
    # There are situations where the tags are parsed outside of the block quotes
    # In this case, we look behind our tag and test if it appears right after
    # the block. Note that this result has to be a nodeset
    parents      <- get_sibling_block(tags)
    parent_names <- xml2::xml_name(parents)
    problems <- list(element = tags, reason = "not inside block quote")
  }

  if (inherits(parents, "xml_nodeset")) {
    parents <- parents[parent_names == "block_quote"]
  }

  children <- xml2::xml_children(tags)
  nc       <- length(children)

  # Find out which children are tags

  are_tags <- which(
    xml2::xml_find_lgl(
      children,
      "boolean(starts-with(text(), '{:'))"
    )
  )

  # Sometimes, we just have to check to make sure the tag is really at the end
  # of the block. In this case, we already know that the parent is a blockquote
  # and we know that the parents and tags are blanaced, so here we want to 
  # just confirm that they are the end of the block. 
  balanced <- length(parents) == length(are_tags)
  if (balanced) {
    end_of_block <- get_lineend(tags) == get_lineend(parents)
  } else {
    end_of_block <- FALSE
  }

  # exclude the first tag if it's after a code block
  # In Rmarkdown documents, all code blocks are tagged with a language attribute
  #
  # Unfortunately, kramdown blocks are also allowed, which creates a weird
  # situation where we have language="NA" with a {: .language-r} tag trailing
  if (length(problems) > 0L && problems$reason == "not inside block quote") {
    # If we've already determined that it wasn't in a code block, then all these
    # do not matter
    after_code  <- FALSE
    is_language <- FALSE
    is_output   <- FALSE
  } else {
    after_code  <- after_thing(tags, "code_block[not(@language)]")
    is_language <- grepl("\\{: \\.language\\-", xml2::xml_text(children[[are_tags[1]]]))
    is_output   <- xml2::xml_text(children[[are_tags[1]]]) == "{: .output}"
  }


  if (!all(end_of_block) && (after_code || is_language || is_output)) {
    ctag <- children[[are_tags[1]]]
    are_tags <- are_tags[-1]
    if (after_code || is_language) {
      problems <- c(problems, set_ktag_code(ctag))
    } else {
      problems <- c(problems, list(element = ctag, reason = "not after code_block"))
    }
  }


  # Sometimes the tags are mis-aligned by the interpreter, which will happen
  # with the last solution block inside of a challenge block 
  #
  # When this happens, we need to find the nested block quote and
  # get its parents
  if (!balanced && length(parents) < length(are_tags) && length(parents) == 1) {
    blq <- glue::glue(".//{ns}:block_quote[not(@ktag)]/*")
    if (xml2::xml_find_lgl(parents, glue::glue("boolean({blq})"))) {
      parents <- xml2::xml_parents(
        xml2::xml_find_first(parents, blq)
      )
    } else {
      problems <- c(
        problems,
        list(
          element = list(parents = parents, tags = tags),
          reason  = "tag is mis-alinged with parents"
        )
      )
    }
  }

  # There are situations where the solution tag is included in the body of the
  # challenge block. In this case, we need to check:
  #  - a single block quote parent
  #  - a single tag
  #  - the challenge tag is a sibling (solutions can be top blocks)
  #
  #  In these cases, we need to fetch the preceeding sibling block quote,
  #  because that's what the solution tag originally belonged to.
  child <- children[[are_tags[1]]]
  if (length(parents) == 1 && length(are_tags) == 1 && challenge_is_sibling(tags)) {
    if (xml2::xml_text(child) == "{: .solution}") {
      parents <- get_sibling_block(tags)
    }
    problems <- c(problems,
      list(element = tags, problem = "solution block out-of-place")
    )
  }

  this_node <- tags


  for (tag in seq_along(are_tags)) {

    # Grab the correct parent from the list
    the_parent <- parents[tag]
    this_tag   <- xml2::xml_text(children[are_tags[tag]])
    xml2::xml_attr(the_parent, "ktag") <- this_tag

  }
  xml2::xml_remove(children[are_tags])

  # If there is nothing left to the paragraph after all the tags are pruned,
  # remove it
  if (xml2::xml_text(tags) == "") {
    xml2::xml_remove(tags)
  }

  return(if (length(problems)) problems else NULL)

}


set_ktag_code <- function(tag) {

  ns       <- NS(tag)
  problems <- list()

  # Situation: tag is a text element -----------------------------------------
  if (!after_thing(tag, "code_block") && xml2::xml_name(tag) == "text") {
    tag <- xml2::xml_parent(tag)
  }

  # Get the tag and check its validity ---------------------------------------
  kram_tag <- xml2::xml_text(xml2::xml_child(tag, 1))
  is_a_tag <- grepl("^[{][:] ?[.].+?[}]$", kram_tag)

  # Situation: tag is not what it seems --------------------------------------
  if (!is_a_tag) {
    msg <- if (!after_thing(tag, "code_block")) "orphan code tag" else "unknown code tag"
    problems <- c(problems, list(element = tag, reason = msg))
  } else {
    # Find the end of the challenge block ------------------------------------
    code_block_sib <- glue::glue(".//preceding-sibling::{ns}:code_block[1]")
    the_block      <- xml2::xml_find_first(tag, code_block_sib)

    # Assign the tag attribute -----------------------------------------------
    xml2::xml_attr(the_block, "ktag") <- kram_tag

    # Remove any softbreaks --------------------------------------------------
    n <- xml2::xml_length(tag)
    if (n > 1 && xml2::xml_text(xml2::xml_child(tag, 2)) == "") {
      xml2::xml_remove(xml2::xml_child(tag, 2))
    }

    # Remove the tag ---------------------------------------------------------
    xml2::xml_remove(xml2::xml_child(tag, 1))

    # If there is nothing left, remove the paragraph element -----------------
    if (xml2::xml_text(tag) == "") {
      xml2::xml_remove(tag)
    }
  }

  return(if (length(problems)) problems else NULL)
}
