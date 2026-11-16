# Extract list elements from a block

Extract list elements from a block

## Usage

``` r
get_list_block(self, type = "questions", in_yaml = TRUE)
```

## Arguments

- self:

  an Episode object

- type:

  the type of block/div to extract the list from

- in_yaml:

  indicator if the elements are in the YAML header (`TRUE`, default for
  styles version 9 lessons) or if they are in the body of the lesson
  (`FALSE`, for sandpaper lessons).

## Value

a character vector
