# Create a data frame describing the divs associated with nodes.

Native and fenced divs may have several tags grouped in a single
element. In order to mark the pairs, we need to account for what tags
exist in the nodes. This function creates that

## Usage

``` r
make_div_pairs(nodes, path = NULL, yaml = NULL)
```

## Arguments

- nodes:

  a nodelist containing native div and fenced div tags in `html_block`
  or `paragraphs`.

## Value

a list of data frames for each node with the following columns:

- node: numeric index of the node

- div: the text of the individual div element, stripped of context

- label: label of the div pair (div-label-class)

- pos: position the label will be relative to its associated node

## See also

Other div:
[`clean_div_tags()`](https://carpentries.github.io/pegboard/dev/reference/clean_div_tags.md),
[`find_between_tags()`](https://carpentries.github.io/pegboard/dev/reference/find_between_tags.md),
[`find_div_pairs()`](https://carpentries.github.io/pegboard/dev/reference/find_div_pairs.md),
[`get_divs()`](https://carpentries.github.io/pegboard/dev/reference/get_divs.md),
[`label_div_tags()`](https://carpentries.github.io/pegboard/dev/reference/div_labels.md),
[`label_pairs()`](https://carpentries.github.io/pegboard/dev/reference/label_pairs.md),
[`make_div()`](https://carpentries.github.io/pegboard/dev/reference/make_div.md),
[`replace_with_div()`](https://carpentries.github.io/pegboard/dev/reference/replace_with_div.md)

## Examples

```` r
txt <- "# Example with a mix of div tags

> PLEASE NEVER DO THE LESSONS THIS WAY
>
> I AM LITERALLY JUST TESTING A TERRIBLE EXAMPLE.

--------------------------------------------------------------------------------

<div class='challenge'>
## Challenge

do that challenging thing.

```{r}
cat('it might be challenging to do this')
```
:::: solution
```{r}
It's not that challenging
```
:::
<div class='solution'>
We just have to try harder and use `<div>` tags

:::::: callout
```{r}
cat('better faster stronger with <div>')
```
::::
:::::: discussion
<img src='https://carpentries.org/logo.svg'/>
:::::
</div>
</div>

<div class='good'>

## Good divs

</div>
" 
tmp <- tempfile()
writeLines(txt, tmp)
ex <- tinkr::to_xml(tmp)
pegboard:::clean_div_tags(ex$body)
#> [1] TRUE
nodes <- pegboard:::find_div_tags(ex$body)
divs  <- pegboard:::make_div_pairs(nodes)
do.call("rbind", divs)
#>     node                     div line            label    pos
#> 1      1 <div class='challenge'>   NA  div-1-challenge before
#> 2      2           :::: solution   NA   div-2-solution before
#> 3      3                     :::   NA   div-2-solution  after
#> 4      4  <div class='solution'>   NA   div-3-solution before
#> 5      5          :::::: callout   NA    div-4-callout before
#> 6.6    6                    ::::   NA    div-4-callout  after
#> 6.7    6       :::::: discussion   NA div-5-discussion before
#> 6.8    6                   :::::   NA div-5-discussion  after
#> 7      7                  </div>   NA   div-3-solution  after
#> 8      8                  </div>   NA  div-1-challenge  after
#> 9      9      <div class='good'>   NA       div-6-good before
#> 10    10                  </div>   NA       div-6-good  after
````
