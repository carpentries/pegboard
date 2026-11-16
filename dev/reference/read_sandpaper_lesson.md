# Read in all markdown files associated with a sandpaper lesson

Read in all markdown files associated with a sandpaper lesson

## Usage

``` r
read_sandpaper_lesson(path, ...)
```

## Arguments

- path:

  the path to the lesson

- ...:

  arguments to pass to
  [`read_markdown_files()`](https://carpentries.github.io/pegboard/dev/reference/read_markdown_files.md)

## Value

a list of two elements:

- episodes contains all the
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  objects representing markdown files in the `episodes` folder

- extra contains all the
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  objects representing markdown files in all other folders (including
  top-level)

- overview a boolean that indicates if the lesson is an overview
