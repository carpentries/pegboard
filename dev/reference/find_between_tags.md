# Find nodes between two nodes with a given dtag

Find nodes between two nodes with a given dtag

## Usage

``` r
find_between_tags(
  tag,
  body,
  ns = "pb",
  find = "dtag[@label='{tag}']",
  include = FALSE
)
```

## Arguments

- tag:

  an integer representing a unique dtag attribute

- body:

  an xml document

- ns:

  the namespace from the body

- find:

  an xpath element to search for (without namespace tag)

- include:

  if `TRUE`, the tags themselves will be included in the output

## Value

a nodeset between tags that have the dtag attribute matching `tag`

## See also

Other div:
[`clean_div_tags()`](https://carpentries.github.io/pegboard/dev/reference/clean_div_tags.md),
[`find_div_pairs()`](https://carpentries.github.io/pegboard/dev/reference/find_div_pairs.md),
[`get_divs()`](https://carpentries.github.io/pegboard/dev/reference/get_divs.md),
[`label_div_tags()`](https://carpentries.github.io/pegboard/dev/reference/div_labels.md),
[`label_pairs()`](https://carpentries.github.io/pegboard/dev/reference/label_pairs.md),
[`make_div()`](https://carpentries.github.io/pegboard/dev/reference/make_div.md),
[`make_div_pairs()`](https://carpentries.github.io/pegboard/dev/reference/make_div_pairs.md),
[`replace_with_div()`](https://carpentries.github.io/pegboard/dev/reference/replace_with_div.md)

## Examples

``` r
loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
loop$body # a full document with block quotes and code blocks, etc
#> {xml_document}
#> <document sourcepos="1:1-190:22" xmlns="http://commonmark.org/xml/1.0">
#>  [1] <heading sourcepos="2:1-2:65" level="2">\n  <text sourcepos="2:4-2:9" xm ...
#>  [2] <list sourcepos="4:1-6:0" type="bullet" tight="true">\n  <item sourcepos ...
#>  [3] <code_block sourcepos="7:1-12:3" xml:space="preserve" name="" ktag="{: . ...
#>  [4] <code_block sourcepos="14:1-33:3" xml:space="preserve" name="" ktag="{:  ...
#>  [5] <heading sourcepos="36:1-36:126" level="2">\n  <text sourcepos="36:4-36: ...
#>  [6] <list sourcepos="38:1-47:0" type="bullet" tight="true">\n  <item sourcep ...
#>  [7] <code_block sourcepos="48:1-51:3" xml:space="preserve" name="" ktag="{:  ...
#>  [8] <code_block sourcepos="53:1-57:3" xml:space="preserve" name="" ktag="{:  ...
#>  [9] <code_block sourcepos="60:1-62:3" xml:space="preserve" name="" ktag="{:  ...
#> [10] <code_block sourcepos="64:1-66:3" xml:space="preserve" name="" ktag="{:  ...
#> [11] <heading sourcepos="69:1-69:52" level="2">\n  <text sourcepos="69:4-69:7 ...
#> [12] <list sourcepos="71:1-73:0" type="bullet" tight="true">\n  <item sourcep ...
#> [13] <code_block sourcepos="74:1-78:3" xml:space="preserve" name="" ktag="{:  ...
#> [14] <code_block sourcepos="80:1-87:3" xml:space="preserve" name="" ktag="{:  ...
#> [15] <list sourcepos="90:1-94:0" type="bullet" tight="true">\n  <item sourcep ...
#> [16] <block_quote sourcepos="95:1-108:14" ktag="{: .challenge}">\n  <heading  ...
#> [17] <block_quote sourcepos="110:1-140:14" ktag="{: .challenge}">\n  <heading ...
#> [18] <block_quote sourcepos="142:1-170:14" ktag="{: .challenge}">\n  <heading ...
#> [19] <heading sourcepos="172:1-172:29" level="3">\n  <text sourcepos="172:5-1 ...
#> [20] <html_block sourcepos="174:1-174:86" xml:space="preserve">&lt;img src="h ...
#> ...
loop$unblock() # removing blockquotes and replacing with div tags
# find all the div tags
ns <- pegboard:::get_ns(loop$body)
tags <- xml2::xml_find_all(loop$body, ".//pb:dtag", ns)
tags <- xml2::xml_attr(tags, "label")
tags
#>  [1] "div-1-challenge" "div-2-solution"  "div-2-solution"  "div-1-challenge"
#>  [5] "div-3-challenge" "div-4-solution"  "div-4-solution"  "div-3-challenge"
#>  [9] "div-5-challenge" "div-6-solution"  "div-6-solution"  "div-5-challenge"
# grab the contents of the first div tag
pegboard:::find_between_tags(tags[[1]], loop$body)
#> {xml_nodeset (9)}
#> [1] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> [2] <heading sourcepos="95:3-95:24" level="2">\n  <text sourcepos="95:6-95:24 ...
#> [3] <paragraph sourcepos="97:3-97:87">\n  <text sourcepos="97:3-97:26" xml:sp ...
#> [4] <list sourcepos="99:3-103:1" type="ordered" start="1" delim="period" tigh ...
#> [5] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> [6] <heading sourcepos="104:5-104:15" level="2">\n  <text sourcepos="104:8-10 ...
#> [7] <paragraph sourcepos="106:5-108:14">\n  <text sourcepos="106:5-106:33" xm ...
#> [8] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
#> [9] <paragraph xmlns="http://commonmark.org/xml/1.0">\n  <text xml:space="pre ...
```
