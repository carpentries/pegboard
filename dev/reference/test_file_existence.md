# Test for the existence of a file

Test for the existence of a file

## Usage

``` r
test_file_existence(paths, home)
```

## Arguments

- paths:

  the relative paths to be tested

- home:

  the root directory of these paths

## Value

a logical vector of the same length as `paths` indicating if a file
exists \_anywhere in the lesson infrastructure

## Details

This function detects the existence of files relative to the current
folder while taking into account references to the built site.

To understand *why* this is needed consider that both The Workbench and
Jekyll takes contents from the source folders and pools them in a flat
file structure for the website. Because of this, it's possible to write
links like `[link](resource.html)` or `[link](../learners/resource.md)`
and they will continue to be valid.

## See also

[`link_internal_file()`](https://carpentries.github.io/pegboard/dev/reference/validate_links.md)
which calls this function

## Examples

``` r
pb <- asNamespace("pegboard")
# Example: validation of links in a sandpaper context -----------------------
fs::dir_tree(lesson_fragment("sandpaper-fragment"))
#> /home/runner/work/_temp/Library/pegboard/sandpaper-fragment
#> ├── config.yaml
#> ├── episodes
#> │   ├── intro.Rmd
#> │   └── nope.md
#> ├── index.md
#> ├── instructors
#> │   └── a.md
#> ├── learners
#> │   └── setup.md
#> ├── profiles
#> │   └── b.md
#> └── site
#>     ├── DESCRIPTION
#>     ├── README.md
#>     ├── _pkgdown.yaml
#>     └── built
#>         ├── a.md
#>         ├── b.md
#>         ├── config.yaml
#>         ├── fig
#>         │   └── intro-rendered-pyramid-1.png
#>         ├── index.md
#>         ├── intro.md
#>         ├── md5sum.txt
#>         └── setup.md
links <- c(
  "../episodes/fig/missing.png", # does not exist
  "../index.md", # exists
  "../instructors/a.md", # exists
  "../episodes/intro.Rmd", # exists
  "setup.md", # exists
  "intro.html" # exists
)
home <- fs::path(lesson_fragment("sandpaper-fragment"), "learners")
# show the resulting vector with our paths relative to the "learners" folder
setNames(pb$test_file_existence(links, home), links)
#> ../episodes/fig/missing.png                 ../index.md 
#>                       FALSE                        TRUE 
#>         ../instructors/a.md       ../episodes/intro.Rmd 
#>                        TRUE                        TRUE 
#>                    setup.md                  intro.html 
#>                        TRUE                        TRUE 

# Example: validation of links in a sandpaper context with children ---------
# in this context, the references must be relative to the _parent_ file
# for this example, the home folder is the parent of the child, which is
# obtained from the `$build_parent` element in the child file. To demonstrate
# this, I will first load the lesson
context <- lesson_fragment("sandpaper-fragment-with-child")
lsn <- Lesson$new(context, jekyll = FALSE)
fs::dir_tree(context)
#> /home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child
#> ├── config.yaml
#> ├── episodes
#> │   ├── files
#> │   │   ├── cat.Rmd
#> │   │   └── session.Rmd
#> │   ├── intro.Rmd
#> │   └── nope.md
#> ├── index.md
#> ├── instructors
#> │   └── a.md
#> ├── learners
#> │   └── setup.md
#> ├── profiles
#> │   └── b.md
#> └── site
#>     ├── DESCRIPTION
#>     ├── README.md
#>     ├── _pkgdown.yaml
#>     └── built
#>         ├── a.md
#>         ├── b.md
#>         ├── config.yaml
#>         ├── fig
#>         │   └── intro-rendered-pyramid-1.png
#>         ├── index.md
#>         ├── intro.md
#>         ├── md5sum.txt
#>         └── setup.md
links <- c(
  "../episodes/fig/missing.png", # does not exist
  "../index.md", # exists
  "../instructors/a.md", # exists
  "intro.Rmd", # exists
  "../learners/setup.md", # does not exist
  "intro.html" # exists
)
# in practice, we check that the episode has parents:
lsn$episodes[[1]]$has_parents # episodes do not have parents
#> [1] FALSE
lsn$children[[2]]$has_parents # but children do!
#> [1] TRUE
# The "home" path in the context of a child document is the _build parent_,
# which is the parent that will eventually contain the output of the child.
# in the case of this lesson, both child files are used in the intro.Rmd,
# even though `cat.Rmd` is the parent of `session.Rmd`
setNames(lsn$get("parents", "children"), fs::path_file(names(lsn$children)))
#> $cat.Rmd
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/intro.Rmd"
#> 
#> $session.Rmd
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd"
#> 
# They both show that `intro.Rmd` is the build parent
setNames(lsn$get("build_parents", "children"), fs::path_file(names(lsn$children)))
#> $cat.Rmd
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/intro.Rmd"
#> 
#> $session.Rmd
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/intro.Rmd"
#> 
# show the links as if they existed in the `session.Rmd` file
home <- lsn$children[[2]]$build_parents
setNames(pb$test_file_existence(links, home), links)
#> ../episodes/fig/missing.png                 ../index.md 
#>                       FALSE                        TRUE 
#>         ../instructors/a.md                   intro.Rmd 
#>                        TRUE                        TRUE 
#>        ../learners/setup.md                  intro.html 
#>                        TRUE                        TRUE 

# Example: validation of links in a Jekyll context --------------------------
fs::dir_tree(lesson_fragment())
#> /home/runner/work/_temp/Library/pegboard/lesson-fragment
#> ├── _config.yml
#> └── _episodes
#>     ├── 10-lunch.md
#>     ├── 12-for-loops.md
#>     ├── 14-looping-data-sets.md
#>     └── 17-scope.md
links <- c(
  "../non-existent.md",       # does not exist
  "../_config.yml",           # exists
  "../_episodes/10-lunch.md", # exists 
  "10-lunch.html"             # exists in built site
)
# set the home folder to be the "_extras" folder
home <- fs::path(lesson_fragment(), "_extras")
# show the resulting vector with our paths
setNames(pb$test_file_existence(links, home), links)
#>       ../non-existent.md           ../_config.yml ../_episodes/10-lunch.md 
#>                    FALSE                     TRUE                     TRUE 
#>            10-lunch.html 
#>                     TRUE 
```
