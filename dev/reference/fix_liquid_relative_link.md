# Remove spaces in relative links with liquid variables

Liquid has a syntax that wraps variables in double moustache braces that
may or may not have spaces within the moustaches. For example, to get
the link of the page root, you would use page.root to make it more
readable. However, this violates the expectation of the commonmark
parser and makes it think “oh, this is just ordinary text”.

## Usage

``` r
fix_liquid_relative_link(path, encoding = "UTF-8")
```

## Arguments

- path:

  path to an MD file

- encoding:

  encoding of the text, defaults to UTF-8

## Details

This function fixes the issue by removing the spaces within the braces.
