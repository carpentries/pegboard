# Gather blocks from the XML body of a carpentries lesson

This will search an XML document for `block_quotes` with the specified
type and level and extract them into a nodeset.

## Usage

``` r
get_blocks(body, type = NULL, level = 0)
```

## Arguments

- body:

  the XML body of a carpentries lesson (an xml2 object)

- type:

  the type of block quote in the Jekyll syntax like ".challenge",
  ".discussion", or ".solution"

- level:

  the level of the block within the document. Defaults to `1`, which
  represents all of the block_quotes are not nested within any other
  block quotes. Increase the nubmer to increase the level of nesting.

## Value

an xml nodeset object with each element representing a blockquote that
matched the input criteria.

## Note

At the moment, blocks are returned at the specified level. If you select
`type = ".solution", level = 1`, you will receive blocks that *contain*
solution blocks even though these blocks are almost always nested within
other blocks.

## Examples

``` r
frg <- Lesson$new(lesson_fragment())
# Find all the blocks in the
get_blocks(frg$episodes[["17-scope.md"]]$body)
#> {xml_nodeset (2)}
#> [1] <block_quote sourcepos="45:1-60:14" ktag="{: .challenge}">\n  <heading so ...
#> [2] <block_quote sourcepos="62:1-95:14" ktag="{: .challenge}">\n  <heading so ...
```
