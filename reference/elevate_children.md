# elevate all children of a node

elevate all children of a node

## Usage

``` r
elevate_children(parent, remove = TRUE)
```

## Arguments

- parent:

  an xml node (notably a block quote)

- remove:

  a logical value. If `TRUE` (default), the parent node is removed from
  the document.

## Value

the elevated nodes, invisibly

## Examples

``` r
if (FALSE) { # \dontrun{
scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
# get all the challenges (2 blocks)
scope$get_blocks(".challenge")
b1 <- scope$get_blocks(".challenge")[[1]]
elevate_children(b1)
# now there is only one block:
scope$get_blocks(".challenge")
} # }
```
