# Find the level of the current node releative to the document

Find the level of the current node releative to the document

## Usage

``` r
find_node_level(node)
```

## Arguments

- node:

  an XML node object

## Value

a number indicating how nested the current node is. 0 represents the
document itself, 1 represents all child elements of the document, etc.
