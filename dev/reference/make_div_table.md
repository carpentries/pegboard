# Create a table of divs in an episode

Create a table of divs in an episode

## Usage

``` r
make_div_table(yrn)
```

## Arguments

- yrn:

  a [tinkr::yarn](https://docs.ropensci.org/tinkr/reference/yarn.html)
  or
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  object.

## Value

a data frame with the following columns:

- path: path to the file, relative to the lesson

- div: the type of div

- pb_label: the label of the div

- line: the line number of the div label
