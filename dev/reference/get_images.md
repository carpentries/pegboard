# Get images from an Episode/yarn object

Get images from an Episode/yarn object

## Usage

``` r
get_images(yrn, process = TRUE)
```

## Arguments

- yrn:

  an Episode/yarn object

- process:

  if `TRUE` (default), images will be processed via
  [`process_images()`](https://carpentries.github.io/pegboard/dev/reference/process_images.md)
  to add the alt attribute and extract images from HTML blocks. `FALSE`
  will present the nodes as found by XPath search.

## Value

an xml_nodelist

## Details

Markdown users can write images as either markdown or HTML. If they
write images as HTML, then the commonmark XML parser recognises these as
generic "HTML blocks" and they can't be found by just searching for
`.//md:image`. This function searches both `md:html_block` and
`md:html_inline` for image content that it can extract for downstream
analysis.

## Examples

``` r
tmp <- tempfile()
on.exit(unlink(tmp))
txt <- '
![a kitten](https://placekitten.com/200/200){alt="a pretty kitten"}

<!-- an html image of a kitten -->
<img src="https://placekitten.com/200/200">

an inline html image of a kitten <img src="https://placekitten.com/50/50">
'
writeLines(txt, tmp)
ep <- Episode$new(tmp)
ep$show()
#> ![a kitten](https://placekitten.com/200/200){alt="a pretty kitten"}
#> 
#> <!-- an html image of a kitten -->
#> 
#> <img src="https://placekitten.com/200/200">
#> 
#> an inline html image of a kitten <img src="https://placekitten.com/50/50">
#> 
# without process = TRUE, images in HTML elements are not converted
ep$get_images() 
#> {xml_nodeset (3)}
#> [1] <image sourcepos="2:1-2:44" destination="https://placekitten.com/200/200" ...
#> [2] <html_block sourcepos="5:1-5:43" xml:space="preserve">&lt;img src="https: ...
#> [3] <html_inline sourcepos="7:34-7:74" xml:space="preserve">&lt;img src="http ...
# setting process = TRUE will extract the HTML elements for analysis 
# (e.g to detect alt text)
ep$get_images(process = TRUE)
#> {xml_nodeset (3)}
#> [1] <image sourcepos="2:1-2:44" destination="https://placekitten.com/200/200" ...
#> [2] <img src="https://placekitten.com/200/200" destination="https://placekitt ...
#> [3] <img src="https://placekitten.com/50/50" destination="https://placekitten ...
```
