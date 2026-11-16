# Get all headings in the XML document

Get all headings in the XML document

## Usage

``` r
get_headings(body)

show_heading_tree(tree)
```

## Arguments

- body:

  an XML document

- tree:

  a data frame produced via
  [`validate_headings()`](https://carpentries.github.io/pegboard/dev/reference/validate_headings.md)

## Value

an object of class `xml_nodeset` with all the headings in the document.
