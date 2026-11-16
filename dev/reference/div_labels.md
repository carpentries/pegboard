# Add labels to div tags in the form of a "dtag" node with a paired "label" attribute.

Add labels to div tags in the form of a "dtag" node with a paired
"label" attribute.

## Usage

``` r
label_div_tags(body)

find_div_tags(body)

clear_div_labels(body)
```

## Arguments

- body:

  an xml document

## Value

- `label_div_tags()`: the document, modified

- `clear_div_labels()`: the document, modified

- `find_div_tags()`: a node list

## See also

Other div:
[`clean_div_tags()`](https://carpentries.github.io/pegboard/dev/reference/clean_div_tags.md),
[`find_between_tags()`](https://carpentries.github.io/pegboard/dev/reference/find_between_tags.md),
[`find_div_pairs()`](https://carpentries.github.io/pegboard/dev/reference/find_div_pairs.md),
[`get_divs()`](https://carpentries.github.io/pegboard/dev/reference/get_divs.md),
[`label_pairs()`](https://carpentries.github.io/pegboard/dev/reference/label_pairs.md),
[`make_div()`](https://carpentries.github.io/pegboard/dev/reference/make_div.md),
[`make_div_pairs()`](https://carpentries.github.io/pegboard/dev/reference/make_div_pairs.md),
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
ex$body
#> {xml_document}
#> <document xmlns="http://commonmark.org/xml/1.0">
#>  [1] <heading level="1">\n  <text xml:space="preserve">Example with a mix of  ...
#>  [2] <block_quote>\n  <paragraph>\n    <text xml:space="preserve">PLEASE NEVE ...
#>  [3] <thematic_break/>
#>  [4] <html_block xml:space="preserve">&lt;div class='challenge'&gt;\n## Chall ...
#>  [5] <paragraph>\n  <text xml:space="preserve">do that challenging thing.</te ...
#>  [6] <code_block xml:space="preserve" language="r" name="">cat('it might be c ...
#>  [7] <paragraph>\n  <text xml:space="preserve">:::: solution</text>\n</paragr ...
#>  [8] <code_block xml:space="preserve" language="r" name="">It's not that chal ...
#>  [9] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
#> [10] <html_block xml:space="preserve">&lt;div class='solution'&gt;\nWe just h ...
#> [11] <paragraph>\n  <text xml:space="preserve">:::::: callout</text>\n</parag ...
#> [12] <code_block xml:space="preserve" language="r" name="">cat('better faster ...
#> [13] <paragraph>\n  <text xml:space="preserve">::::</text>\n  <softbreak/>\n  ...
#> [14] <html_block xml:space="preserve">&lt;/div&gt;\n&lt;/div&gt;\n</html_block>
#> [15] <html_block xml:space="preserve">&lt;div class='good'&gt;\n</html_block>
#> [16] <heading level="2">\n  <text xml:space="preserve">Good divs</text>\n</he ...
#> [17] <html_block xml:space="preserve">&lt;/div&gt;\n</html_block>
pegboard:::label_div_tags(ex$body)
ex$body
#> {xml_document}
#> <document xmlns="http://commonmark.org/xml/1.0">
#>  [1] <heading level="1">\n  <text xml:space="preserve">Example with a mix of  ...
#>  [2] <block_quote>\n  <paragraph>\n    <text xml:space="preserve">PLEASE NEVE ...
#>  [3] <thematic_break/>
#>  [4] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-challenge"/>
#>  [5] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">& ...
#>  [6] <heading xmlns="http://commonmark.org/xml/1.0" level="2">\n  <text xml:s ...
#>  [7] <paragraph>\n  <text xml:space="preserve">do that challenging thing.</te ...
#>  [8] <code_block xml:space="preserve" language="r" name="">cat('it might be c ...
#>  [9] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-solution"/>
#> [10] <paragraph>\n  <text xml:space="preserve">:::: solution</text>\n</paragr ...
#> [11] <code_block xml:space="preserve" language="r" name="">It's not that chal ...
#> [12] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
#> [13] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-solution"/>
#> [14] <dtag xmlns="http://carpentries.org/pegboard/" label="div-3-solution"/>
#> [15] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">& ...
#> [16] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pr ...
#> [17] <dtag xmlns="http://carpentries.org/pegboard/" label="div-4-callout"/>
#> [18] <paragraph>\n  <text xml:space="preserve">:::::: callout</text>\n</parag ...
#> [19] <code_block xml:space="preserve" language="r" name="">cat('better faster ...
#> [20] <dtag xmlns="http://carpentries.org/pegboard/" label="div-5-discussion"/>
#> ...
pegboard:::clear_div_labels(ex$body)
````
