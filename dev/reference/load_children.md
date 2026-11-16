# Recursively Load Child Documents

Process a list of
[Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
objects to do two things:

1.  recursively read in the child documents declared in the parent
    documents

2.  for each child, update the `$parent` and `$build_parent` elements

## Usage

``` r
load_children(all_parents)

read_children(parent, all_children = list(), ...)

add_parent(child, parent)
```

## Arguments

- all_parents:

  a list of
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  objects

- parent:

  an
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  object

- all_children:

  a list of
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  objects

- child:

  an
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  object

## Value

a list of
[Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
objects from the children. If no children exist, then this is `NULL`. In
the case of `add_parent()`, this is called for its side-effect to update
the child object and it always returns `NULL`.

## Details

When we want to build lessons, it's important to be able to find all of
the documents that are necessary to build a particular file. If there is
a modification in a child document, sandpaper needs to know that it
should flag the parent for rebuilding. To do this, we need two pieces of
information:

1.  The earliest ancestors of a given child document.

2.  The full list of descendants of a given parent document.

Each Episode object only knows about itself, so it can only report its
immediate children, but not the children of children, or even its parent
(unless we explicitly tell it what its parent is). The
[Lesson](https://carpentries.github.io/pegboard/dev/reference/Lesson.md)
object contains the context of all of the Episodes and can provide this
information.

During Lesson object initialisation, the `load_children()` function is
called to process all source documents for their children. This creates
an empty list of children that is continuously appended to during the
function call. It then calls `read_children()` on each parent document,
which will append itself as a parent to any existing children in the
`all_children` list, intitialize new
[Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
objects from the unread child documents, and then search those for
children until there are no children left to read.

## See also

[`find_children()`](https://carpentries.github.io/pegboard/dev/reference/find_children.md)
for details on how child documents are discovered

## Examples

``` r
# needed for using internal functions: loading the namespace
pb <- asNamespace("pegboard")
ex <- lesson_fragment("sandpaper-fragment-with-child")
lsn <- Lesson$new(ex, jekyll = FALSE)
children <- pb$load_children(lsn$episodes)

# load_children will start from scratch, so it will produce new Episode files
identical(names(children), names(lsn$children))
#> [1] TRUE
purrr::map2(children, lsn$children, identical)
#> $`/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd`
#> [1] FALSE
#> 
#> $`/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/session.Rmd`
#> [1] FALSE
#> 

# read children takes in a list of children episodes and appends that list
# with the descendants

# given a full list of children, it will return the same list
these_children <- pb$read_children(lsn$episodes[[1]], children)
purrr::map2(these_children, children, identical)
#> $`/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd`
#> [1] TRUE
#> 
#> $`/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/session.Rmd`
#> [1] TRUE
#> 

# given a partial list, it will append to it
new_children <- pb$read_children(lsn$episodes[[1]], children[1])
purrr::map2(new_children, children, identical)
#> $`/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd`
#> [1] TRUE
#> 
#> $`/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/session.Rmd`
#> [1] FALSE
#> 
```
