# Collect and append validation messages

Given a data frame containing the results of validation tests, this will
append a column of labels that describes each failure.

## Usage

``` r
collect_labels(VAL, cli = FALSE, msg = heading_tests)
```

## Arguments

- VAL:

  a data frame containing the results of tests

- cli:

  indicator to use the cli package to format warnings

- msg:

  a named vector of template messages to provide for each test formatted
  for the glue package.

## See also

[`throw_link_warnings()`](https://carpentries.github.io/pegboard/dev/reference/throw_warnings.md)
for details on how this is implemented.

## Examples

``` r
# As an example, consider a data frame where you have observations in rows
# and the results of individual tests in columns:
set.seed(2023-11-16)
dat <- data.frame(
  name = letters[1:10],
  rank = sample(1:3, 10, replace = TRUE),
  A = sample(c(TRUE, FALSE), 10, replace = TRUE, prob = c(7, 3)),
  B = sample(c(TRUE, FALSE), 10, replace = TRUE, prob = c(7, 3)),
  C = sample(c(TRUE, FALSE), 10, replace = TRUE, prob = c(7, 3))
)
dat
#>    name rank     A     B     C
#> 1     a    1  TRUE FALSE  TRUE
#> 2     b    1 FALSE FALSE  TRUE
#> 3     c    3 FALSE  TRUE  TRUE
#> 4     d    1  TRUE  TRUE  TRUE
#> 5     e    2  TRUE  TRUE  TRUE
#> 6     f    2 FALSE  TRUE  TRUE
#> 7     g    3  TRUE FALSE  TRUE
#> 8     h    2  TRUE  TRUE FALSE
#> 9     i    2  TRUE FALSE  TRUE
#> 10    j    3 FALSE  TRUE  TRUE
# you can see what the results of the tests were, but it would be a good
# idea to have a lookup table describing what these results mean
dat_tests <- c(
  A = "[missing widget]: {name}",
  B = "[incorrect rank]: {rank}",
  C = "[something else]"
)
# collect_labels will create the output you need:
pb <- asNamespace("pegboard")
res <- pb$collect_labels(dat, msg = dat_tests)
res
#>    name rank     A     B     C                                   labels
#> 1     a    1  TRUE FALSE  TRUE                      [incorrect rank]: 1
#> 2     b    1 FALSE FALSE  TRUE  [missing widget]: b [incorrect rank]: 1
#> 3     c    3 FALSE  TRUE  TRUE                      [missing widget]: c
#> 4     d    1  TRUE  TRUE  TRUE                                         
#> 5     e    2  TRUE  TRUE  TRUE                                         
#> 6     f    2 FALSE  TRUE  TRUE                      [missing widget]: f
#> 7     g    3  TRUE FALSE  TRUE                      [incorrect rank]: 3
#> 8     h    2  TRUE  TRUE FALSE                         [something else]
#> 9     i    2  TRUE FALSE  TRUE                      [incorrect rank]: 2
#> 10    j    3 FALSE  TRUE  TRUE                      [missing widget]: j
writeLines(res$labels)
#>  [incorrect rank]: 1
#>  [missing widget]: b [incorrect rank]: 1
#>  [missing widget]: c
#> 
#> 
#>  [missing widget]: f
#>  [incorrect rank]: 3
#>  [something else]
#>  [incorrect rank]: 2
#>  [missing widget]: j
if (requireNamespace("cli", quietly = TRUE)) {
  # you can also specify cli to TRUE to format with CLI
  res <- pb$collect_labels(dat, cli = TRUE, msg = dat_tests)
  writeLines(res$labels)
}
#>  [incorrect rank]: 1
#>  [missing widget]: b [incorrect rank]: 1
#>  [missing widget]: c
#> 
#> 
#>  [missing widget]: f
#>  [incorrect rank]: 3
#>  [something else]
#>  [incorrect rank]: 2
#>  [missing widget]: j
```
