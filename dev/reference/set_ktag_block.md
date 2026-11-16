# add the kramdown tags as attributes of special blocks

add the kramdown tags as attributes of special blocks

## Usage

``` r
set_ktag_block(tags)
```

## Arguments

- tags:

  tags from the function
  [`kramdown_tags()`](https://carpentries.github.io/pegboard/dev/reference/kramdown_tags.md)

## Details

Kramdown is a bit weird in that it uses tags that trail elements like
code blocks or block quotes. If these follow block quotes, commonmark
will parse them being part of that block quote. This is not problematic
per-se until you run into a common situation in the Carpentries'
curriculum: nested block quotes

    > # Challenge 1
    >
    > Some text here
    >
    > > # Solution 1
    > >
    > > ~~~
    > > print("hello world!")
    > > ~~~
    > > {: .language-pyton}
    > {: .solution}
    {: .challenge}

When this is parsed with commonmark, the three tags at the end are
parsed as being part of the 2nd-level block quote:

    ...
    > > ~~~
    > > {: .language-pyton}
    > > {: .solution}
    > > {: .challenge}

This function will take the block quote elements and add a "ktag"
attribute that represents the value of the tag. This will then be parsed
by the xslt style sheet and the tags will be properly appended.
