#' Issue a warning via CLI if it exists or send a message
#'
#' @param msg the message as a glue or CLI string
#' @param cli if `TRUE`, the CLI package will be used to issue the message,
#'   defaults to `FALSE`, which means that the message will be issued via 
#'   message and glue.
#' @param ... named arguments to be evaluated in the message via glue or CLI
#' 
#' @return nothing, invisibly; used for side-effect
#' @rdname cli_helpers
issue_warning <- function(msg, cli = FALSE, ...) {
  l <- list(...)
  for (i in names(l)) {
    assign(i, l[[i]])
  }
  if (cli) {
    cli::cli_alert_warning(msg)
  } else {
    message(glue::glue("! {glue::glue(msg)}"))
  }
  invisible()
}

#' Create a single character that reports line errors
#'
#' @param path path to the file to report
#' @param pos position of the error
#' @param type the type of warning that should be thrown (defaults to warning)
#' @param sep a character to use to separate the human message and the line number
#' @rdname cli_helpers
line_report <- function(msg = "", path, pos, sep = "\t", type = "warning") {
  ci <- Sys.getenv("CI") != ""
  if (ci) {
    res <- "::{type} file={path},line={pos}::{msg}"
  } else {
    res <- "{path}:{pos}{sep}{msg}"
  }
  glue::glue_collapse(glue::glue(res), sep = "\n")
}

#' Append a stylized label to elements of a vector
#'
#' @param l a vector/list of characters
#' @param i the index of elements to append
#' @param e the new element to append to each element
#' @param cli if `TRUE`, stylizes `e` with `f`
#' @param f a function from \pkg{cli} that will transform `e`
#'
#' @return, `l`, appended
#' @rdname cli_helpers
#'
#' @examples
#' x <- letters[1:5]
#' x2 <- pegboard:::append_labels(x, 
#'   c(1, 3), 
#'   "appended", 
#'   cli = requireNamespace("cli", quietly = TRUE), 
#'   f = "col_cyan"
#' )
#' cat(glue::glue("[{x}]->[{x2}]"))
append_labels <- function(l, i = TRUE, e = "", cli = FALSE, f = "style_inverse") {
  f <- if (cli) utils::getFromNamespace(f, "cli") else function(e) e
  l[i] <- paste(l[i], f(e))
  l
}
