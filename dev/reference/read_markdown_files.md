# Process Markdown files in a directory into Episode objects

Process Markdown files in a directory into Episode objects

## Usage

``` r
read_markdown_files(src, cfg = list(), sandpaper = TRUE, ...)
```

## Arguments

- src:

  \[character\] the path to a folder containing markdown episodes

- cfg:

  \[list\] a parsed config file that can be used to specify the order of
  the files with a key that matches the folder name.

- sandpaper:

  \[logical\] if `TRUE`, the episodes are expected to be processed with
  sandpaper and will have the `$confirm_sandpaper()` method triggered.

- ...:

  methods passed to the
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  initializer

## Value

a list of
[Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
objects
