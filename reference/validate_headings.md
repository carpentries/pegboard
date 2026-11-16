# Validate headings

This will validate the following aspects of all headings:

## Usage

``` r
validate_headings(headings, title = NULL, offset = 5L)

heading_tests

heading_info

headings_first_heading_is_second_level(VAL)

headings_greater_than_first_level(VAL)

headings_are_sequential(VAL)

headings_have_names(VAL)

headings_are_unique(VAL)
```

## Format

An object of class `character` of length 5.

An object of class `character` of length 5.

## Arguments

- headings:

  an object of xml_nodelist.

- title:

  the title of the document

- offset:

  the number of lines to offset the position (equal to the size of the
  yaml header).

- VAL:

  a data frame that contains the results of
  [`make_heading_table()`](https://carpentries.github.io/pegboard/reference/make_heading_table.md)
  and logical columns that match the name of the test.

## Value

a list with two elements:

1.  a data frame that contains the results of
    [`make_heading_table()`](https://carpentries.github.io/pegboard/reference/make_heading_table.md)
    and logical columns for each test where `FALSE` indicates a failed
    test for a given heading.

2.  a data frame that can be printed as a tree with
    [`show_heading_tree()`](https://carpentries.github.io/pegboard/reference/heading_utils.md)

## Details

- first heading starts at level 2 (`first_heading_is_second_level`)

- greater than level 1 (`all_are_greater_than_first_level`)

- increse sequentially (e.g. no jumps from 2 to 4)
  (`all_are_sequential`)

- have names (`all_have_names`)

- unique in their own hierarchy (`all_are_unique`)

## Note

This is an internal function implemented for the
[Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
and [Lesson](https://carpentries.github.io/pegboard/reference/Lesson.md)
classes.

## Examples

``` r
l <- Lesson$new(lesson_fragment())
e <- l$episodes[[3]]
# Our headings validators run a series of tests on headings and return a data
# frame with information about the headings along with the results of the
# tests
v <- pegboard:::validate_headings(e$headings, e$get_yaml()$title, length(e$yaml))
names(v)
#> [1] "results" "tree"   
v$results
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
#>            node first_heading_is_second_level greater_than_first_level
#> 1  <heading....                          TRUE                     TRUE
#> 2  <heading....                          TRUE                     TRUE
#> 3  <heading....                          TRUE                     TRUE
#> 4  <heading....                          TRUE                     TRUE
#> 5  <heading....                          TRUE                     TRUE
#> 6  <heading....                          TRUE                     TRUE
#> 7  <heading....                          TRUE                     TRUE
#> 8  <heading....                          TRUE                     TRUE
#> 9  <heading....                          TRUE                     TRUE
#> 10 <heading....                          TRUE                     TRUE
#>    are_sequential have_names are_unique
#> 1            TRUE       TRUE       TRUE
#> 2            TRUE       TRUE       TRUE
#> 3            TRUE       TRUE       TRUE
#> 4            TRUE       TRUE       TRUE
#> 5            TRUE       TRUE      FALSE
#> 6            TRUE       TRUE       TRUE
#> 7            TRUE       TRUE      FALSE
#> 8            TRUE       TRUE       TRUE
#> 9            TRUE       TRUE      FALSE
#> 10           TRUE       TRUE       TRUE
v$results$path <- fs::path_rel(e$path, e$lesson)
# The validator does not produce any warnings or messages, but this data
# frame can be passed on to other functions that will throw them for us. We
# have a function that will throw a warning/message for each heading that
# fails the tests. These messages are controlled by `heading_tests` and 
# `heading_info`.
pegboard:::heading_tests
#>   first_heading_is_second_level        greater_than_first_level 
#>             "(must be level 2)"         "(first level heading)" 
#>                  are_sequential                      have_names 
#> "(non-sequential heading jump)"                     "(no name)" 
#>                      are_unique 
#>                  "(duplicated)" 
pegboard:::heading_info
#>      first_heading_is_second_level           greater_than_first_level 
#>    "First heading must be level 2" "Level 1 headings are not allowed" 
#>                     are_sequential                         have_names 
#>      "Headings must be sequential"           "Headings must be named" 
#>                         are_unique 
#>          "Headings must be unique" 
pegboard:::throw_heading_warnings(v$results)
#> ! There were errors in 3/10 headings
#> ◌ Headings must be unique
#> <https://webaim.org/techniques/semanticstructure/#headings>
#> 
#> ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
#> ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
#> ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)
# Because the headings are best understood in tree form we have a utility
# that will print the heading tree with the associated errors:
pegboard:::show_heading_tree(v$tree)
#> ── Heading structure ───────────────────────────────────────────────────────────
#> # Episode: “Looping Over Data Sets” 
#> ├─## Use a for loop to process files given a list of their names. 
#> ├─## Use glob.glob to find sets of files whose names match a pattern. 
#> ├─## Use glob and for to process batches of files. 
#> ├─## Determining Matches 
#> ├─## Solution  (duplicated)
#> ├─## Minimum File Size 
#> ├─## Solution  (duplicated)
#> ├─## Comparing Data 
#> └─## Solution  (duplicated)
#>   └─### ZNK test links and images 
#> ────────────────────────────────────────────────────────────────────────────────
```
