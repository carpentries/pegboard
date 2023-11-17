#' Issue a warning via CLI if it exists or send a message
#'
#' @param msg the message as a glue or CLI string. Defaults to NULL
#' @param cli if `TRUE`, the CLI package will be used to issue the message,
#'   defaults to `FALSE`, which means that the message will be issued via 
#'   message and glue.
#' @param what the name of the specific element to report in an error
#' @param url a url for extra information to help.
#' @param n the number of elements errored
#' @param N the number total elements
#' @param infos the information about the errors to be shown to the user
#' @param reports the reported errors. 
#' @param ... named arguments to be evaluated in the message via glue or CLI
#' 
#' @return nothing, invisibly; used for side-effect
#' @rdname cli_helpers
issue_warning <- function(msg = NULL, cli = has_cli(), what = NULL, url = NULL, n = NULL, N = NULL, infos = list(), reports = list(), ...) {
  wd <- getOption("width")
  cliwd <- getOption("cli.width")
  on.exit(options(width = wd, cli.width = cliwd), add = TRUE)
  options(width = 1000)
  options(cli.width = 1000)

  if (!is.null(msg)) {
    if (cli) {
      cli::cli_alert_warning(msg)
    } else {
      pb_message(glue::glue(msg))
    }
    return(NULL)
  }
  l <- list(...)
  for (i in names(l)) {
    assign(i, l[[i]])
  }
  what <- if (is.null(what)) "elements" else what
  n    <- if (is.null(n)) "?" else n
  N    <- if (is.null(N)) "?" else N
  msg <- "There were errors in {n}/{N} {what}"
  if (cli) {
    cli::cli_alert_warning(msg)

    first <- cli::cli_div(theme = list(ul = list("list-style-type" = function() cli::symbol$circle_dotted)))
    cli::cli_li(infos)
    if (!is.null(url)) {
      cli::cli_text("{.url {url}}")
    }
    cli::cli_par()
    cli::cli_end(id = first)

    cli::cli_div(theme = list(ul = list("list-style-type" = function() "")))
    cli::cli_li(reports)
    cli::cli_end()
  } else {
    infos <- paste(c(infos), collapse = "\n - ")
    reports <- paste(reports, collapse = "\n")
    url <- if (is.null(url)) "" else paste0("\n<", url, ">")
    out <- "! {glue::glue(msg)}
    
    - {infos}{url}

    {reports}
    "
    pb_message(glue::glue(out))
  }
  invisible()
}


#' Utility to make "pegboard" class of messages 
#'
#' This allows us to control the messages emitted _and_ continue to keep CLI as
#' a suggested package.
#'
#' The vast majority of the code in this function is copied directly from the
#' [message()] function.
#'
#' @inheritParams base::message
#' @rdname cli_helpers
#' @examples
#' pegboard:::pb_message("hello")
pb_message <- function (..., domain = NULL, appendLF = TRUE) {
  msg <- .makeMessage(..., domain = domain, appendLF = appendLF)
  cond <- structure(list(message = msg), 
    class = c("pbMessage", "simpleMessage", "message", "condition"))
  defaultHandler <- function(c) {
    cat(conditionMessage(c), file = stderr(), sep = "")
  }
  withRestarts({
    signalCondition(cond)
    defaultHandler(cond)
  }, muffleMessage = function() NULL)
  invisible()
}


#' Create a single character that reports line errors
#'
#' @param path path to the file to report
#' @param pos position of the error
#' @param type (used in the context of CI only) the type of warning that should
#'    be thrown (defaults to warning)
#' @param sep a character to use to separate the human message and the line
#'   number
#' @rdname cli_helpers
line_report <- function(msg = "", path, pos, sep = "\t", type = "warning") {
  ci <- Sys.getenv("CI") != ""
  if (ci) {
    res <- "::{type} file={path},line={pos}::{msg}"
  } else {
    res <- "{path}:{pos}{sep}{msg}"
  }
  glue::glue(res)
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
#' writeLines(glue::glue("[{x}]->[{x2}]"))
append_labels <- function(l, i = TRUE, e = "", cli = FALSE, f = "style_inverse") {
  f <- if (cli) utils::getFromNamespace(f, "cli") else function(e) e
  l[i] <- paste(l[i], f(e))
  l
}

#' Swallow messages from the cli and pegboard packages
#'
#' @param expr an R expression.
#' @param keep if `TRUE`, the messages are kept in a list. Defautls to `FALSE`
#'   where cli message are discarded.
#' @return if `keep = FALSE`, the output of `expr`, if `keep = TRUE`, a list
#'   with the elements `val = expr` and `msg = <cliMessage>s`
#' @rdname cli_helpers
#' @examples
#' pegboard:::message_muffler({
#'   cli::cli_text("hello there! I'm staying in!")
#'   pegboard:::pb_message("normal looking message that's not getting through")
#'   message("this message makes it out!")
#'   runif(1)
#' })
#' pegboard:::message_muffler({
#'   cli::cli_text("hello there! I'm staying in!")
#'   pegboard:::pb_message("normal looking message that's not getting through")
#'   message("this message makes it out!")
#'   runif(1)
#' }, keep = TRUE)
message_muffler <- function(expr, keep = FALSE) {
  messages <- NULL
  expr <- substitute(expr)
  collector <- function(msg) {
    messages <<- c(messages, list(msg))
    invokeRestart("muffleMessage")
  }
  val <- withCallingHandlers(eval.parent(expr), 
    cliMessage = collector, 
    pbMessage = collector
  )
  if (keep) {
    return(list(val = val, msg = messages))
  } else {
    return(val)
  }
}
