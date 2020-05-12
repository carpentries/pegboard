feature_graph <- function(blocks, src = "challenge", snk = "lesson", recurse = TRUE) {
  # Find the names of the contents
  feat   <- xml2::xml_contents(blocks)
  pos    <- xml2::xml_attr(feat, "sourcepos")
  fnames <- xml2::xml_name(feat)
  # place them in a data frame, bookended by source and sink
  res    <- data.frame(
    from = c(src, fnames),
    to   = c(fnames, snk),
    pos  = c(xml2::xml_attr(blocks, "sourcepos"), pos)
  )
  # any nested block quotes go thorugh the same process and are appended
  if (recurse && any(fnames == "block_quote")) {
    res$from[res$from == "block_quote"] <- "solution"
    res$to[res$to == "block_quote"]     <- "solution"
    solutions <- purrr::map_dfr(feat[fnames == "block_quote"],
      ~feature_graph(.x, src = "solution", snk = "challenge")
    )
    res <- rbind(res, solutions)
  }
  res
}
