# Issue a warning via CLI if it exists or send a message

This allows us to control the messages emitted *and* continue to keep
CLI as a suggested package.

## Usage

``` r
issue_warning(
  msg = NULL,
  cli = has_cli(),
  what = NULL,
  url = NULL,
  n = NULL,
  N = NULL,
  infos = list(),
  reports = list(),
  ...
)

pb_message(..., domain = NULL, appendLF = TRUE)

line_report(msg = "", path, pos, sep = "\t", type = "warning")

append_labels(l, i = TRUE, e = "", cli = FALSE, f = "style_inverse")

message_muffler(expr, keep = FALSE)
```

## Arguments

- msg:

  the message as a glue or CLI string. Defaults to NULL

- cli:

  if `TRUE`, stylizes `e` with `f`

- what:

  the name of the specific element to report in an error

- url:

  a url for extra information to help.

- n:

  the number of elements errored

- N:

  the number total elements

- infos:

  the information about the errors to be shown to the user

- reports:

  the reported errors.

- ...:

  named arguments to be evaluated in the message via glue or CLI

- domain:

  see [`gettext`](https://rdrr.io/r/base/gettext.html). If `NA`,
  messages will not be translated, see also the note in
  [`stop`](https://rdrr.io/r/base/stop.html).

- appendLF:

  logical: should messages given as a character string have a newline
  appended?

- path:

  path to the file to report

- pos:

  position of the error

- sep:

  a character to use to separate the human message and the line number

- type:

  (used in the context of CI only) the type of warning that should be
  thrown (defaults to warning)

- l:

  a vector/list of characters

- i:

  the index of elements to append

- e:

  the new element to append to each element

- f:

  a function from cli that will transform `e`

- expr:

  an R expression.

- keep:

  if `TRUE`, the messages are kept in a list. Defautls to `FALSE` where
  cli message are discarded.

## Value

nothing, invisibly; used for side-effect

, `l`, appended

if `keep = FALSE`, the output of `expr`, if `keep = TRUE`, a list with
the elements `val = expr` and `msg = <cliMessage>s`

## Details

The vast majority of the code in this function is copied directly from
the [`message()`](https://rdrr.io/r/base/message.html) function.

## Examples

``` r
pegboard:::pb_message("hello")
#> hello
x <- letters[1:5]
x2 <- pegboard:::append_labels(x, 
  c(1, 3), 
  "appended", 
  cli = requireNamespace("cli", quietly = TRUE), 
  f = "col_cyan"
)
writeLines(glue::glue("[{x}]->[{x2}]"))
#> [a]->[a appended]
#> [b]->[b]
#> [c]->[c appended]
#> [d]->[d]
#> [e]->[e]
pegboard:::message_muffler({
  cli::cli_text("hello there! I'm staying in!")
  pegboard:::pb_message("normal looking message that's not getting through")
  message("this message makes it out!")
  runif(1)
})
#> this message makes it out!
#> [1] 0.08075014
pegboard:::message_muffler({
  cli::cli_text("hello there! I'm staying in!")
  pegboard:::pb_message("normal looking message that's not getting through")
  message("this message makes it out!")
  runif(1)
}, keep = TRUE)
#> this message makes it out!
#> $val
#> [1] 0.834333
#> 
#> $msg
#> $msg[[1]]
#> <cliMessage: hello there! I'm staying in!
#> >
#> 
#> $msg[[2]]
#> <pbMessage: normal looking message that's not getting through
#> >
#> 
#> 
```
