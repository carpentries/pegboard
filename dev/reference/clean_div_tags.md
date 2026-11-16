# Clean the div tags from an xml document

Clean the div tags from an xml document

## Usage

``` r
clean_div_tags(body)
```

## Arguments

- body:

  an xml document

## Value

`TRUE` if divs were detected and cleaned, `FALSE` if there were no divs.

## Details

Commonmark knows what raw HTML looks like and will read it in as an HTML
block, escaping the tag. it does this for every HTML tag that is
preceded by a blank line, so this: `<div class='hello'>\n\n</div>`
becomes two html_block elements

    <html_block>
      &lt;div class='hello'&gt;\n
    </html_block>
    <html_block>
      &lt;/div&gt;\n
    </html_block>

However, if an element is not preceded by a non-html element, it becomes
part of that html element. So this `<div class='hello'>\n</div>` becomes
a single html_block element:

    <html_block>
      &lt;div class='hello'&gt;\n&lt;/div&gt;\n
    </html_block>

Sometimes, this process can gobble up text that is markdown instead of
HTML,

This function will find multiple tags in HTML blocks and separates them
into different blocks.

## See also

Other div:
[`find_between_tags()`](https://carpentries.github.io/pegboard/dev/reference/find_between_tags.md),
[`find_div_pairs()`](https://carpentries.github.io/pegboard/dev/reference/find_div_pairs.md),
[`get_divs()`](https://carpentries.github.io/pegboard/dev/reference/get_divs.md),
[`label_div_tags()`](https://carpentries.github.io/pegboard/dev/reference/div_labels.md),
[`label_pairs()`](https://carpentries.github.io/pegboard/dev/reference/label_pairs.md),
[`make_div()`](https://carpentries.github.io/pegboard/dev/reference/make_div.md),
[`make_div_pairs()`](https://carpentries.github.io/pegboard/dev/reference/make_div_pairs.md),
[`replace_with_div()`](https://carpentries.github.io/pegboard/dev/reference/replace_with_div.md)

## Examples

```` r
txt <- " 
<div class='challenge'>
## Challenge

do that challenging thing.

```{r}
cat('it might be challenging to do this')
```
<div class='solution'>
```{r}
It's not that challenging
```
</div>
<div class='solution'>
We just have to try harder and use `<div>` tags

```{r}
cat('better faster stronger with <div>')
```
<img src='https://carpentries.org/logo.svg'/>

</div>
</div>

<div class='good'>

## Good divs

</div>

"
library(purrr)
library(xml2)

f <- tempfile()
writeLines(txt, f)
ex <- tinkr::to_xml(f)
xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
#> {xml_nodeset (5)}
#> [1] <html_block xml:space="preserve">&lt;div class='challenge'&gt;\n## Challe ...
#> [2] <html_block xml:space="preserve">&lt;div class='solution'&gt;\n```{r}\nIt ...
#> [3] <html_block xml:space="preserve">&lt;/div&gt;\n&lt;/div&gt;\n</html_block>
#> [4] <html_block xml:space="preserve">&lt;div class='good'&gt;\n</html_block>
#> [5] <html_block xml:space="preserve">&lt;/div&gt;\n</html_block>
pegboard:::clean_div_tags(ex$body)
#> [1] TRUE
xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
#> {xml_nodeset (8)}
#> [1] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [2] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [3] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [4] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [5] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [6] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [7] <html_block xml:space="preserve">&lt;div class='good'&gt;\n</html_block>
#> [8] <html_block xml:space="preserve">&lt;/div&gt;\n</html_block>
pegboard:::label_div_tags(ex$body)
xml2::xml_find_all(ex$body, ".//d1:html_block[contains(text(), 'div')]")
#> {xml_nodeset (8)}
#> [1] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [2] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [3] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [4] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [5] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [6] <html_block xmlns="http://commonmark.org/xml/1.0" xml:space="preserve">&l ...
#> [7] <html_block xml:space="preserve">&lt;div class='good'&gt;\n</html_block>
#> [8] <html_block xml:space="preserve">&lt;/div&gt;\n</html_block>
````
