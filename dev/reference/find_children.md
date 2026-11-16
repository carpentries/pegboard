# Detect the child documents of an Episode object

- `find_children()` returns the *immediate* children for any given
  Episode object.

- `trace_children()` is used *after processing* in the context of a
  Lesson to trace the entire lineage from a source parent episode.

## Usage

``` r
find_children(parent, ancestor = NULL)

trace_children(parent, lsn)
```

## Arguments

- parent:

  an
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  or [tinkr::yarn](https://docs.ropensci.org/tinkr/reference/yarn.html)
  object (`trace_children()` requires an `Episode` object).

- ancestor:

  an
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  object that is used to determine the parent path this also can be
  `NULL`.

- lsn:

  a
  [Lesson](https://carpentries.github.io/pegboard/dev/reference/Lesson.md)
  object that contains the `parent` and all its children.

## Value

a character vector of the absolute paths to child documents

## Details

It is possible to define [child
documents](https://bookdown.org/yihui/rmarkdown-cookbook/child-document.html)
in knitr documents by using the `child` attribute in code chunks. For
example, let's say we have a file called `episodes/parent.Rmd`:

    This content is from _a child document_:

    ```{r child = "files/the-child.Rmd"}
    ```

where `files/the-child.Rmd` is relative to **the build parent**, in this
case it is `episodes/parent.Rmd`. This is important

The `find_children()` function will extract the immediate children from
a single
[Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
object (in this case, it will return
`/path/to/episodes/files/the-child.Rmd`), but it will not detect any
further descendants. To detect the entire lineage, the Episode must be
read in the context of a Lesson (or processed with
[`load_children()`](https://carpentries.github.io/pegboard/dev/reference/load_children.md)).

This function is used during Episode initialisation to populate the
`$children` element of the `Episode` object, which lists paths to the
known children for further processing.

### Tracing full lineages

It is possible for a child document to have further children defined,
but there is a caveat: The child document is going to be read from the
context of the `root.dir` knitr option, which in sandpaper is set to be
`site/built` after the markdown contents and assets are copied over.

    This is the first child. The following content is from the grandchild:

    ```{r child = "files/the-grandchild.md"}
    ```

When an Episode is read *in the context of a Lesson*, the children are
processed with
[`load_children()`](https://carpentries.github.io/pegboard/dev/reference/load_children.md)
so that each document with children will have a non-zero value of the
`$children` element. We recurse through the `$children` element in the
[Lesson](https://carpentries.github.io/pegboard/dev/reference/Lesson.md)
object to exhaust the search for the child documents.

The `trace_children()` will return the entire lineage for a given
*parent* document. Which, in the case of the examples defined above
would be: `/path/to/episodes/parent.Rmd`,
`/path/to/episodes/files/the-child.Rmd`, and
`/path/to/episodes/files/the-grandchild.md`.

### NOTE

For standard lessons, child documents are written relative to the
directory of the build parent document. Usually, these child documents
will be in the `files` folder under their parent folder. Overview
lessons are a little different. For overview lessons (in The Workbench,
these are lessons which contain `overview: true` in config.yaml), the
child documents may point to `files/child.md`, but in reality, the child
document is at the root of the lesson `../files/child.md`. We correct
for this by first checking that the child documents exist and if they
don't defaulting to the top of the lesson.

## Examples

``` r
# needed for using internal functions: loading the namespace
pb <- asNamespace("pegboard")
# This example demonstrates a child document with another child document
# nested inside. First, we demonstrate how `find_children()` only returns
# the immediate children and then we demonstrate how the full lineage is
# extracted in the Lesson object.
#
# `find_children()` --------------------------------------------------------
ex <- lesson_fragment("sandpaper-fragment-with-child")

# The introduction has a single child document
intro <- tinkr::yarn$new(fs::path(ex, "episodes", "intro.Rmd"))
intro$head(21) # show the child document 
#> ---
#> title: "Using RMarkdown"
#> teaching: 10
#> exercises: 2
#> ---
#> 
#> :::::::::::::::::::::::::::::::::::::: questions
#> 
#> - How do you write a lesson using RMarkdown and `{sandpaper}`?
#> 
#> ::::::::::::::::::::::::::::::::::::::::::::::::
#> 
#> ::::::::::::::::::::::::::::::::::::: objectives
#> 
#> - Explain how to use markdown with the new lesson template
#> - Demonstrate how to include pieces of code, figures, and nested challenge blocks
#> 
#> ::::::::::::::::::::::::::::::::::::::::::::::::
#> 
#> ```{r cat-child, child="files/cat.Rmd"}
#> ```
pb$find_children(intro)
#> /home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd
# this is identical to the `$children` element of an Episode object
ep <- Episode$new(fs::path(ex, "episodes", "intro.Rmd"))
ep$children
#> /home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd

# Loading the child document reveals another child
child <- Episode$new(ep$children[[1]])
child$children
#> /home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/files/session.Rmd
child$show()
#> Here is a picture of a kitten:
#> 
#> ![I hope you have a good day](https://placekitten.com/300/300){alt='a random cute kitten'}
#> 
#> ```{r sessionInfo(), child="files/session.Rmd"}
#> ```
#> 

# `trace_children()` -------------------------------------------------------
# In the context of the lesson, we can find all the descendants
lsn <- Lesson$new(ex, jekyll = FALSE)
pb$trace_children(ep, lsn)
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/intro.Rmd"        
#> [2] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd"    
#> [3] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/session.Rmd"
# This is the same as using the method of the same name in the Lesson object
# using the path to the episode
lsn$trace_lineage(ep$path)
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/intro.Rmd"        
#> [2] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd"    
#> [3] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/session.Rmd"
# show the children
purrr::walk(lsn$children, function(ep) {
    message("----", ep$path, "----")
    ep$show()
  }
)
#> ----/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd----
#> Here is a picture of a kitten:
#> 
#> ![I hope you have a good day](https://placekitten.com/300/300){alt='a random cute kitten'}
#> 
#> ```{r sessionInfo(), child="files/session.Rmd"}
#> ```
#> 
#> ----/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/session.Rmd----
#> <details>
#> <summary>Here is the sesion information for this build</summary>
#> 
#> ```{r session-info}
#> sessioninfo::session_info()
#> ```
#> 
#> </details>
#> 
```
