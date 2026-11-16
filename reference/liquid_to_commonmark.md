# Convert liquid code blocks to commonmark code blocks

Liquid code blocks are generally codified by

## Usage

``` r
liquid_to_commonmark(block, make_rmd = FALSE)
```

## Arguments

- block:

  a code block

- make_rmd:

  if `TRUE`, the language will be wrapped in curly braces to be
  evaluated by RMarkdown

## Value

the node, invisibly.

## Details

    print("code goes " + "here")

: .language-python

However, there is a simpler syntax that we can use:

    print("code goes " + "here")

This will take in a code block and convert it so that it will no longer
use the liquid tag (which we have added as a "ktag" attribute for
"kramdown" tag)

## Examples

``` r

frg1 <- Lesson$new(lesson_fragment())
frg2 <- frg1$clone(deep = TRUE)
py1  <- get_code(frg1$episodes[["17-scope.md"]]$body, ".language")
py2  <- get_code(frg2$episodes[["17-scope.md"]]$body, ".language")
py1
#> {xml_nodeset (3)}
#> [1] <code_block sourcepos="10:1-16:3" xml:space="preserve" name="" ktag="{: . ...
#> [2] <code_block sourcepos="28:1-31:3" xml:space="preserve" name="" ktag="{: . ...
#> [3] <code_block sourcepos="50:3-58:5" xml:space="preserve" name="" ktag="{: . ...
invisible(lapply(py1, liquid_to_commonmark, make_rmd = FALSE))
invisible(lapply(py2, liquid_to_commonmark, make_rmd = TRUE))
py1
#> {xml_nodeset (3)}
#> [1] <code_block sourcepos="10:1-16:3" xml:space="preserve" name="" info="pyth ...
#> [2] <code_block sourcepos="28:1-31:3" xml:space="preserve" name="" info="pyth ...
#> [3] <code_block sourcepos="50:3-58:5" xml:space="preserve" name="" info="pyth ...
py2
#> {xml_nodeset (3)}
#> [1] <code_block sourcepos="10:1-16:3" xml:space="preserve" name="python-chunk ...
#> [2] <code_block sourcepos="28:1-31:3" xml:space="preserve" name="python-chunk ...
#> [3] <code_block sourcepos="50:3-58:5" xml:space="preserve" name="python-chunk ...
```
