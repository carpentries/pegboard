# Get code blocks from xml document

Get code blocks from xml document

## Usage

``` r
get_code(body, type = ".language-", attr = "@ktag")
```

## Arguments

- body:

  an xml document from a jekyll site

- type:

  a full or partial string of a code block attribute from Jekyll without
  parenthesis.

- attr:

  what attribute to query in search of code blocks. Default is @ktag,
  which will search for "{: \\type\\".

## Value

an xml nodeset object

## Details

This uses the XPath function `fn:starts-with()` to search for the code
block and automatically includes the opening brace, so regular
expressions are not allowed. This is used by the `$code`, `$output`, and
`$error` elements of the
[Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
class.

## Examples

``` r

e <- Episode$new(fs::path(lesson_fragment(), "_episodes", "17-scope.md"))

get_code(e$body)
#> {xml_nodeset (3)}
#> [1] <code_block sourcepos="10:1-16:3" xml:space="preserve" name="" ktag="{: . ...
#> [2] <code_block sourcepos="28:1-31:3" xml:space="preserve" name="" ktag="{: . ...
#> [3] <code_block sourcepos="50:3-58:5" xml:space="preserve" name="" ktag="{: . ...
get_code(e$body, ".output")
#> {xml_nodeset (1)}
#> [1] <code_block sourcepos="33:1-35:3" xml:space="preserve" name="" ktag="{: . ...
get_code(e$body, ".error")
#> {xml_nodeset (2)}
#> [1] <code_block sourcepos="37:1-42:3" xml:space="preserve" name="" ktag="{: . ...
#> [2] <code_block sourcepos="73:3-93:5" xml:space="preserve" name="" ktag="{: . ...
```
