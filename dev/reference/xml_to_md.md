# Convert xml to markdown

Convert xml to markdown

## Usage

``` r
xml_to_md(body, stylesheet = "xml2md_gfm_kramdown.xsl", newlines = FALSE)
```

## Arguments

- body:

  an xml document

- stylesheet:

  the name of a stylesheet passed to `get_stylesheet`

- newlines:

  a logical indicating that newlines (aka softbreaks) should be inserted
  between elements (defaults to `FALSE`, meaning that no separator will
  be added between elements).

## Value

a character vector of length 1

## Examples

``` r
cha <- pegboard:::make_div("challenge")
sol <- pegboard:::make_div("solution")
xml2::xml_add_child(cha, xml2::xml_child(sol, 1), .where =  1)
xml2::xml_add_child(cha, xml2::xml_child(sol, 2), .where = 2)
cat(pegboard:::xml_to_md(cha))
#> :::::::::::::::::::::::::::::::::::::::: challenge
#> 
#> :::::::::::::::: solution
#> 
#> :::::::::::::::::::::::::
#> 
#> ::::::::::::::::::::::::::::::::::::::::::::::::::
```
