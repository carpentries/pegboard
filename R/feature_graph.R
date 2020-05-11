feature_graph <- function(blocks, src = "challenge", snk = "lesson") {
  # Find the names of the contents
  feat   <- purrr::map(blocks, xml2::xml_contents)
  fnames <- purrr::map_chr(feat, xml2::xml_name)
  # place them in a data frame, bookended by source and sink
  res    <- data.frame(
    from = c(src, fnames),
    to   = c(fnames, snk)
  )
  # any nested block quotes go thorugh the same process and are appended
  if (any(fnames == "block_quote")) {
    res$from[res$from == "block_quote"] <- "solution"
    res$to[res$to == "block_quote"]     <- "solution"
    solutions <- feature_graph(
      feat[fnames == "block_quote"],
      src = "solution",
      sink = "challenge"
    )
    res <- rbind(res, solutions)
  }
  res
}
