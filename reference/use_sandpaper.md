# Convert a Jekyll-based lesson to a sandpaper-based lesson

Convert a Jekyll-based lesson to a sandpaper-based lesson

## Usage

``` r
use_sandpaper(body, rmd = TRUE, yml = list(), path = NULL, known_paths = NULL)
```

## Arguments

- body:

  the xml body of an episode

- rmd:

  if `TRUE`, the chunks will be converted to RMarkdown chunks

- yml:

  a list derived from the `_config.yml` file that defines the site
  variables.

- path:

  the path to the source of the body. Defaults to NULL. This is used in
  conjunction with `known_paths`

- known_paths:

  a character vector with the known paths in the lesson. This is used to
  determine the correct path to other files in the lesson.

## Value

the body

## Details

A Jekyll episode is littered with kramdown inline attribute tags and
liquid-formatted links. Converting to sandpaper means the following:

- links using liquid formatting (e.g.
  `[text]({{ site.path }}/01-episode/)` are replaced with their relative
  counterparts (`[text](01-episode.md)`.

- include statements for `links.md` and `base_path.md` are removed

- image attributes have the kramdown `:` removed

- code blocks with a kramdown inline attribute tag are converted to
  commonmark via the internal
  [`liquid_to_commonmark()`](https://carpentries.github.io/pegboard/reference/liquid_to_commonmark.md).

- Lesson template-specific code is removed from the setup chunk in R
  Markdown files.
