# Create an xml document that contains two html_block elements that contain div tags.

Create an xml document that contains two html_block elements that
contain div tags.

## Usage

``` r
make_div(what, fenced = TRUE)
```

## Arguments

- what:

  the class of block

## Value

an xml document with commonmark namespace

## See also

Other div:
[`clean_div_tags()`](https://carpentries.github.io/pegboard/reference/clean_div_tags.md),
[`find_between_tags()`](https://carpentries.github.io/pegboard/reference/find_between_tags.md),
[`find_div_pairs()`](https://carpentries.github.io/pegboard/reference/find_div_pairs.md),
[`get_divs()`](https://carpentries.github.io/pegboard/reference/get_divs.md),
[`label_div_tags()`](https://carpentries.github.io/pegboard/reference/div_labels.md),
[`label_pairs()`](https://carpentries.github.io/pegboard/reference/label_pairs.md),
[`make_div_pairs()`](https://carpentries.github.io/pegboard/reference/make_div_pairs.md),
[`replace_with_div()`](https://carpentries.github.io/pegboard/reference/replace_with_div.md)

## Examples

``` r
cha <- pegboard:::make_div("challenge")
cha
#> {xml_document}
#> <document xmlns="http://commonmark.org/xml/1.0">
#> [1] <paragraph>\n  <text xml:space="preserve">::::::::::::::::::::::::::::::: ...
#> [2] <paragraph>\n  <text xml:space="preserve">::::::::::::::::::::::::::::::: ...
cat(pegboard:::xml_to_md(cha))
#> :::::::::::::::::::::::::::::::::::::::: challenge
#> 
#> ::::::::::::::::::::::::::::::::::::::::::::::::::
```
