# Validate Callout Blocks for sandpaper episodes

The Carpentries Workbench uses [pandoc fenced
divs](https://pandoc.org/MANUAL.html#extension-fenced_divs) to create
special blocks within the lesson for learners and instructors to provide
breaks in the narrative flow for focus on specific tasks or caveats.
These fenced divs look something like this:

## Usage

``` r
validate_divs(yrn)

div_is_known(div_table)

KNOWN_DIVS

div_tests

div_info
```

## Format

An object of class `character` of length 16.

An object of class `character` of length 1.

An object of class `character` of length 1.

## Arguments

- yrn:

  a [tinkr::yarn](https://docs.ropensci.org/tinkr/reference/yarn.html)
  or
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
  object.

- div_table:

  a data frame derived from
  [`make_div_table()`](https://carpentries.github.io/pegboard/reference/make_div_table.md)

## Value

a data frame with the following columns:

- div: the type of div

- label: the label of the div

- line: the line number of the div label

- is_known: a logical value if the div is a known type (`TRUE`) or not
  (`FALSE`)

## Details

    ::: callout

    ### Hello!

    This is a callout block

    :::

Lessons created with The Carpentries Workbench are expected to have the
following fenced divs:

- objectives (top)

- questions (top)

- keypoints (bottom)

The following fenced divs can occur in the lesson, but are not required:

- prereq

- callout

- caution

- challenge

- solution (nested inside challenge)

- hint (nested inside challenge)

- discussion

- checklist

- testimonial

- tab (can only contain text, images, and code blocks)

- group-tab (can only contain text, images, and code blocks)

Any other div names will produce structure in the resulting DOM, but
they will not have any special visual styling.
