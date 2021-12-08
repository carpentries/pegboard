# This helper is for testing 
expect_moved_yaml <- function(episode, class, position) {
  # 1. capture object and label
  act <- quasi_label(rlang::enquo(episode), arg = "body")

  ns <- get_ns(act$val$body)
  # Length is okay ----------------------------------------------------------
  act$n_blocks <- length(xml2::xml_find_all(act$val$body, ".//md:html_block", ns))
  expect(
    act$n_blocks == 2,
    sprintf("%s had %s html blocks instead of 2.", act$lab, format(act$n_blocks))
  )

  # Tags match as expected
  divs      <- act$val$get_divs()[[position]]
  enames    <- xml2::xml_name(divs)
  div_open  <- xml2::xml_text(divs[[1]])
  div_close <- xml2::xml_text(divs[[length(divs)]])
  expect(
    grepl(paste("::::::::::", class), div_open),
    sprintf("Opening tag is invalid: %s", div_open)
  )
  expect(
    grepl("::::::::::::::::::::", div_close),
    sprintf("Closing tag is invalid: %s", div_close)
  )
  expect(
    identical(enames, c("paragraph", "list", "paragraph")),
    sprintf("The %s block is formatted improperly:\n%s", 
      class,
      paste(enames, collapse = ", ")
    )
  )
  invisible(act$val)
}

