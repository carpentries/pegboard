# Clean pandoc fenced divs and place them in their own paragraph elements

Sometimes pandoc fenced divs are bunched together, which makes it
difficult to track the pairs. This separates them into different
paragraph elements so that we can track them

## Usage

``` r
clean_fenced_divs(body)
```

## Arguments

- body:

  an xml document

## Value

an xml document

## Note

DEPRECATED.

## Examples

```` r
txt <- "::::::: challenge
## Challenge

do that challenging thing.

```{r}
cat('it might be challenging to do this')
```
::::: solution ::::
```{r}
It's not that challenging
```
::::
::: solution ::::::::
We just have to try harder and use `<div>` tags

```{r}
cat('better faster stronger with <div>')
```
<img src='https://carpentries.org/logo.svg'/>

What if we include some `:::` code in here or ::: like this

:::::
:::::

::: good

## Good divs

:::"
f <- tempfile()
writeLines(txt, f)
ex <- tinkr::to_xml(f, sourcepos = TRUE)
ex$body
#> {xml_document}
#> <document sourcepos="1:1-31:3" xmlns="http://commonmark.org/xml/1.0">
#>  [1] <paragraph sourcepos="1:1-1:17">\n  <text sourcepos="1:1-1:17" xml:space ...
#>  [2] <heading sourcepos="2:1-2:12" level="2">\n  <text sourcepos="2:4-2:12" x ...
#>  [3] <paragraph sourcepos="4:1-4:26">\n  <text sourcepos="4:1-4:26" xml:space ...
#>  [4] <code_block sourcepos="6:1-8:3" xml:space="preserve" language="r" name=" ...
#>  [5] <paragraph sourcepos="9:1-9:19">\n  <text sourcepos="9:1-9:19" xml:space ...
#>  [6] <code_block sourcepos="10:1-12:3" xml:space="preserve" language="r" name ...
#>  [7] <paragraph sourcepos="13:1-15:47">\n  <text sourcepos="13:1-13:4" xml:sp ...
#>  [8] <code_block sourcepos="17:1-19:3" xml:space="preserve" language="r" name ...
#>  [9] <html_block sourcepos="20:1-20:45" xml:space="preserve">&lt;img src='htt ...
#> [10] <paragraph sourcepos="22:1-22:59">\n  <text sourcepos="22:1-22:24" xml:s ...
#> [11] <paragraph sourcepos="24:1-25:5">\n  <text sourcepos="24:1-24:5" xml:spa ...
#> [12] <paragraph sourcepos="27:1-27:8">\n  <text sourcepos="27:1-27:8" xml:spa ...
#> [13] <heading sourcepos="29:1-29:12" level="2">\n  <text sourcepos="29:4-29:1 ...
#> [14] <paragraph sourcepos="31:1-31:3">\n  <text sourcepos="31:1-31:3" xml:spa ...
predicate <- ".//d1:paragraph/d1:text[starts-with(text(), ':::')]"
xml2::xml_text(xml2::xml_find_all(ex$body, predicate))
#> [1] "::::::: challenge"     "::::: solution ::::"   "::::"                 
#> [4] "::: solution ::::::::" ":::::"                 ":::::"                
#> [7] "::: good"              ":::"                  
pegboard:::clean_fenced_divs(ex$body)
xml2::xml_text(xml2::xml_find_all(ex$body, predicate))
#> [1] "::::::: challenge"     "::::: solution ::::"   "::::"                 
#> [4] "::: solution ::::::::" ":::::"                 ":::::"                
#> [7] "::: good"              ":::"                  
````
