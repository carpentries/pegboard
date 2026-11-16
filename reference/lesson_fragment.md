# Example Lesson Fragments

Partial lessons mainly used for testing and demonstration purposes

## Usage

``` r
lesson_fragment(name = "lesson-fragment")
```

## Arguments

- name:

  the name of the lesson fragment. Can be one of:

  - lesson-fragment

  - rmd-lesson

  - sandpaper-fragment

  - sandpaper-fragment with child

## Value

a path to a lesson fragment whose contents are:

- `lesson-fragment` contains one `_episodes` directory with three files:
  "10-lunch.md", "14-looping-data-sets.md", and "17-scope.md"

- `rmd-fragment` contains one episode under `_episodes_rmd` called
  `01-test.Rmd`.

- `sandpaper-fragment` contains a trimmed-down Workbench lesson that has
  its R Markdown content pre-built

- `sandpaper-fragment-with-child` contains much of the same content as
  `sandpaper-fragment`, but the `episodes/index.Rmd` file references
  child documents.

## Note

The lesson-fragment example was taken from the python novice gapminder
lesson

## Examples

``` r
lesson_fragment()
#> [1] "/home/runner/work/_temp/Library/pegboard/lesson-fragment"
lesson_fragment("rmd-lesson")
#> [1] "/home/runner/work/_temp/Library/pegboard/rmd-lesson"
lesson_fragment("sandpaper-fragment")
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment"
lesson_fragment("sandpaper-fragment-with-child")
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child"
```
