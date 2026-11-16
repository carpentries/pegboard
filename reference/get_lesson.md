# Get a carpentries lesson in XML format

Download and extract a carpentries lesson in XML format. This uses
[`gert::git_clone()`](https://docs.ropensci.org/gert/reference/git_fetch.html)
to download a carpentries lesson to your computer (defaults to the
temporary directory and extracts the lesson in `_episodes/` using
[`tinkr::to_xml()`](https://docs.ropensci.org/tinkr/reference/to_xml.html)

## Usage

``` r
get_lesson(lesson = NULL, path = tempdir(), overwrite = FALSE, ...)
```

## Arguments

- lesson:

  a github user/repo pattern to point to the lesson

- path:

  a directory to write the lesson to

- overwrite:

  if the `path` exists, setting this to `TRUE` will overwrite the path,
  otherwise, the contents of the path will be returned if it is a lesson
  repository.

- ...:

  arguments passed on to
  [Episode\$new()](https://carpentries.github.io/pegboard/reference/Episode.md).

## Value

a list of xml objects, one element per episode.

## Examples

``` r

if (interactive()) {
  png <- get_lesson("swcarpentry/python-novice-gapminder")
  str(png, max.level = 1)
}
```
