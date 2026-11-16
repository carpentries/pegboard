# Make paired labels for opening and closing div tags

Make paired labels for opening and closing div tags

## Usage

``` r
find_div_pairs(divs, close = div_close_regex())
```

## Arguments

- close:

  the regex for a valid closing tag

- nodes:

  a character vector of div open and close tags

## Value

an integer vector with pairs of labels for each opening and closing tag.
Note that the labels are produced by doing a cumulative sum of the node
depths.

## See also

Other div:
[`clean_div_tags()`](https://carpentries.github.io/pegboard/reference/clean_div_tags.md),
[`find_between_tags()`](https://carpentries.github.io/pegboard/reference/find_between_tags.md),
[`get_divs()`](https://carpentries.github.io/pegboard/reference/get_divs.md),
[`label_div_tags()`](https://carpentries.github.io/pegboard/reference/div_labels.md),
[`label_pairs()`](https://carpentries.github.io/pegboard/reference/label_pairs.md),
[`make_div()`](https://carpentries.github.io/pegboard/reference/make_div.md),
[`make_div_pairs()`](https://carpentries.github.io/pegboard/reference/make_div_pairs.md),
[`replace_with_div()`](https://carpentries.github.io/pegboard/reference/replace_with_div.md)

## Examples

``` r
nodes <- c(
"<div class='1'>", 
  "<div class='2'>" , 
  "</div>", 
  "<div class='2'>", 
    "<div class='3'>", 
    "</div>", 
  "</div>", 
"</div>")
pegboard:::find_div_pairs(nodes)
#> [1] 1 2 2 3 4 4 3 1
```
