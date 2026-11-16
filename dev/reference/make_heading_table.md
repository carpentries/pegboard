# Create a table for headings

Create a table for headings

## Usage

``` r
make_heading_table(headings, offset = 5L)
```

## Arguments

- headings:

  an `xml_nodeset` object with text and "level" attributes

- offest:

  the offset for the yaml header (artifact of tinkr), defaults to 5L,
  which is for the two fences plus title, teaching, and exercises.

## Value

a data frame with three columns:

- heading the text of the heading

- level the heading level

- pos the position of the heading in the document

- node the node containing the heading

## Examples

``` r
path <- file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
loop <- Episode$new(path)
pegboard:::make_heading_table(loop$headings, offset = length(loop$yaml))
#> Warning: The yaml field of yarn objects was deprecated in tinkr 0.2.1.
#> ℹ Please use frontmatter instead.
#>                                                             heading level pos
#> 1      Use a for loop to process files given a list of their names.     2  17
#> 2  Use glob.glob to find sets of files whose names match a pattern.     2  51
#> 3                     Use glob and for to process batches of files.     2  84
#> 4                                               Determining Matches     2 110
#> 5                                                          Solution     2 119
#> 6                                                 Minimum File Size     2 125
#> 7                                                          Solution     2 143
#> 8                                                    Comparing Data     2 157
#> 9                                                          Solution     2 162
#> 10                                        ZNK test links and images     3 187
#>            node
#> 1  <heading....
#> 2  <heading....
#> 3  <heading....
#> 4  <heading....
#> 5  <heading....
#> 6  <heading....
#> 7  <heading....
#> 8  <heading....
#> 9  <heading....
#> 10 <heading....
```
