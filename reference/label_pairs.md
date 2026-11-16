# Label pairs of parentheses.

This function is the labeller for
[`find_div_pairs()`](https://carpentries.github.io/pegboard/reference/find_div_pairs.md)

## Usage

``` r
label_pairs(pairs, n_tags, reverse = FALSE)
```

## Arguments

- pairs:

  a vector of parentheses.

- n_tags:

  the number of closing tags

- reverse:

  if `TRUE`, the search from the end of the stack

## Value

a vector of integers indicating the pair of parentheses.

## See also

Other div:
[`clean_div_tags()`](https://carpentries.github.io/pegboard/reference/clean_div_tags.md),
[`find_between_tags()`](https://carpentries.github.io/pegboard/reference/find_between_tags.md),
[`find_div_pairs()`](https://carpentries.github.io/pegboard/reference/find_div_pairs.md),
[`get_divs()`](https://carpentries.github.io/pegboard/reference/get_divs.md),
[`label_div_tags()`](https://carpentries.github.io/pegboard/reference/div_labels.md),
[`make_div()`](https://carpentries.github.io/pegboard/reference/make_div.md),
[`make_div_pairs()`](https://carpentries.github.io/pegboard/reference/make_div_pairs.md),
[`replace_with_div()`](https://carpentries.github.io/pegboard/reference/replace_with_div.md)

## Examples

``` r

x <- c("(", "(", ")", ")")
pegboard:::label_pairs(x, 2)
#> [1] 1 2 2 1
x <- c("(", "(", ")", "(", "(", ")", ")", ")")
pegboard:::label_pairs(x, 4)
#> [1] 1 2 2 3 4 4 3 1
```
