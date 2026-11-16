# Gather solutions from the XML body of a carpentries lesson

This will search an XML document for a solution marker and extract all
of the block quotes that are ancestral to that marker so that we can
extract the solution blockquotes from the carpentries lessons.

## Usage

``` r
get_solutions(body, type = c("block", "div", "chunk"), parent = NULL)
```

## Arguments

- body:

  the XML body of a carpentries lesson (an xml2 object)

- type:

  the type of element containing the solutions "block" is the default
  and will search for all of the blockquotes with liquid/kramdown
  markup, "div" will search for all div tags with class of solution, and
  "chunk" will search for all of code chunks with the engine of
  solution.

- parent:

  the outer block containing the solution. Default is a challenge block,
  but it could also be a discussion block.

## Value

- type = "block" (default) an xml nodelist of blockquotes

- type = "div" a list of xml nodelists

- type = "chunk" an xml nodelist of code blocks

## Note

- the `parent` parameter is only valid for the "block" (default) type

- the "chunk" type has the limitation that solutions are embedded within
  their respective blocks, so counting the number of solution elements
  via this method may an undercount

## Examples

``` r
loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
get_solutions(loop$body, "block")
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="104:3-108:14" ktag="{: .solution}">\n  <heading s ...
#> [2] <block_quote sourcepos="128:3-140:14" ktag="{: .solution}">\n  <heading s ...
#> [3] <block_quote sourcepos="147:3-170:14" ktag="{: .solution}">\n  <heading s ...
get_solutions(loop$unblock()$body, "div")
#> $`div-2-solution`
#> {xml_nodeset (4)}
#> [1] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> [2] <heading sourcepos="104:5-104:15" level="2">\n  <text sourcepos="104:8-10 ...
#> [3] <paragraph sourcepos="106:5-108:14">\n  <text sourcepos="106:5-106:33" xm ...
#> [4] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> 
#> $`div-4-solution`
#> {xml_nodeset (4)}
#> [1] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> [2] <heading sourcepos="128:5-128:15" level="2">\n  <text sourcepos="128:8-12 ...
#> [3] <code_block sourcepos="129:5-137:7" xml:space="preserve" name="" ktag="{: ...
#> [4] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> 
#> $`div-6-solution`
#> {xml_nodeset (5)}
#> [1] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> [2] <heading sourcepos="147:5-147:15" level="2">\n  <text sourcepos="147:8-14 ...
#> [3] <paragraph sourcepos="148:5-151:31">\n  <text sourcepos="148:5-148:61" xm ...
#> [4] <code_block sourcepos="152:5-167:7" xml:space="preserve" name="" ktag="{: ...
#> [5] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> 
loop$reset()
get_solutions(loop$use_dovetail()$unblock()$body, "chunk")
#> {xml_nodeset (3)}
#> [1] <code_block sourcepos="95:1-108:14" language="challenge" name="&quot;95:1 ...
#> [2] <code_block sourcepos="110:1-140:14" language="challenge" name="&quot;110 ...
#> [3] <code_block sourcepos="142:1-170:14" language="challenge" name="&quot;142 ...
```
