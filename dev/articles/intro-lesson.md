# Introduction to the Lesson Object

## Introduction

The {pegboard} package facilitates the analysis and manipulation of
Markdown and R Markdown files by translating them to XML and back again.
This extends the {tinkr} package (see
[`vignette("tinkr", package = "tinkr")`](https://docs.ropensci.org/tinkr/articles/tinkr.html))
by providing additional methods that are specific for Carpentries-style
lessons. There are two `R6` classes defined in {pegboard}:

- [`pegboard::Episode`](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  objects that contain the XML data, YAML metadata and extra fields that
  define the child and parent files for a particular episode. These
  inherit from the
  [`tinkr::yarn`](https://docs.ropensci.org/tinkr/reference/yarn.html)
  R6 class.
- [`pegboard::Lesson`](https://carpentries.github.io/pegboard/dev/reference/Lesson.md)
  objects that contain lists of `Episode` objects categorised as
  “episodes”, “extra”, or “children”.

If you have a list of `Episode` objects, you can achieve *most* of what
you can with the lesson objects, because much of the `Lesson` object’s
function is to provide a methods that map over all of the `Episode`
object methods. The key difference between `Lesson` objects and a list
of `Episode` objects is that the `Lesson` object will collapse summaries
and to map relations between `Episodes` and their children or parent
documents.

**Before you read this vignette, please read the vignette on the
`Episode` object
([`vignette("intro-episode", package = "pegboard")`](https://carpentries.github.io/pegboard/dev/articles/intro-episode.md))**
so that you can understand the methods that come from the `Episode`
objects. In this vignette, we will talk about the structure of `Lesson`
objects, how to use the basic methods of these objects, inspecting
summaries of source vs built episodes, and assessing the lineage of
episodes that have parents and/or children documents.

But first, because of a default parameter that influences what methods
can be used depending on the lesson context, I need to explain a little
bit about Jekyll, the former lesson infrastructure.

### A Brief Word About History and Jekyll

Prior to The Workbench, we had the [styles
repository](https://github.com/carpentries/styles/), which was an
all-in-one toolbox that built websites with Jekyll. It was colloquially
known as the “Lesson Template.” It has two major differences to The
Workbench: folder structure and syntax.

#### Folder Structure

The folder structure of lessons built with Jekyll was one where content
and tooling lived side-by-side. This folder structure looked something
like this:

    #  .
    #  ├── Gemfile
    #  ├── Makefile
    #  ├── _config.yml
    #  ├── _episodes/
    #  │   └── 01-intro.md
    #  ├── _episodes_rmd/
    #  ├── _extras/
    #  │   ├── a.md
    #  │   └── b.md
    #  ├── _includes/
    #  ├── _layouts/
    #  ├── aio.md
    #  ├── assets/
    #  ├── bin/
    #  ├── fig/
    #  ├── index.md
    #  ├── reference.md
    #  ├── requirements.txt
    #  └── setup.md

When {pegboard} was first written, we initially assumed this folder
structure, where R Markdown and regular Markdown episodes lived in
different folders (and more often than not, the outputs of the R
Markdown files lived inside the `_episodes/` folder. The main method of
organising episodes was by numbers embedded in the name of the files.

As The Workbench developed, it was clear that this folder structure
needed to change, but we needed to keep compatibility with the old
lessons because we want to ensure that people can independently convert
from the old style lessons to the new style, thus we added the `jekyll`
parameter to the `Lesson` object initializer method, and set
`jekyll = TRUE` as the default to keep backwards compatibility.

## Creating a New Lesson Object

The `Lesson` object is invoked with the `Lesson$new()`, method. Here, I
will demonstrate a Workbench lesson. This is the folder structure of the
workbench lesson:

    #  .
    #  ├── config.yaml
    #  ├── episodes
    #  │   ├── intro.Rmd
    #  │   └── nope.md
    #  ├── index.md
    #  ├── instructors
    #  │   └── a.md
    #  ├── learners
    #  │   └── setup.md
    #  ├── profiles
    #  │   └── b.md
    #  └── site
    #      └── README.md

To read it in, because we have a Workbench lesson, we need to specify
`jekyll = FALSE` to register all the div tags and ensure that the lesson
is being treated like a Workbench lesson.

``` r

library("pegboard")
library("glue")
library("yaml")
library("xml2")
library("fs")
wbfragment <- lesson_fragment("sandpaper-fragment")
print(wbfragment) # path to the lesson
## [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment"
wb_lesson <- Lesson$new(wbfragment, jekyll = FALSE)
print(wb_lesson)
## <Lesson>
##   Public:
##     blocks: function (type = NULL, level = 0, path = FALSE) 
##     built: NULL
##     challenges: function (path = FALSE, graph = FALSE, recurse = TRUE) 
##     children: NULL
##     clone: function (deep = FALSE) 
##     episodes: list
##     extra: list
##     files: active binding
##     get: function (element = NULL, collection = "episodes") 
##     handout: function (path = NULL, solution = FALSE) 
##     has_children: active binding
##     initialize: function (path = ".", rmd = FALSE, jekyll = TRUE, ...) 
##     isolate_blocks: function () 
##     load_built: function () 
##     n_problems: active binding
##     overview: FALSE
##     path: /home/runner/work/_temp/Library/pegboard/sandpaper-fragment
##     reset: function () 
##     rmd: FALSE
##     sandpaper: TRUE
##     show_problems: active binding
##     solutions: function (path = FALSE) 
##     summary: function (collection = "episodes") 
##     thin: function (verbose = TRUE) 
##     trace_lineage: function (episode_path) 
##     validate_divs: function () 
##     validate_headings: function (verbose = TRUE) 
##     validate_links: function () 
##   Private:
##     deep_clone: function (name, value)
```

The Lesson printing here shows that it has a subset of methods that are
named similarly to methods and active bindings from the Episode class.
These are not inherited, but rather they are implemented across all the
Episode objects. The Episode objects themselves are parsed into one of
three elements: “episodes”, “children”, and “extra” (NOTE: the “extra”
slot may be superceded by elements that better match the folder
structure of lessons).

``` r

lapply(wb_lesson$episodes, class)
## $intro.Rmd
## [1] "Episode" "yarn"    "R6"
lapply(wb_lesson$children, class)
## list()
lapply(wb_lesson$extra, class)
## $index.md
## [1] "Episode" "yarn"    "R6"     
## 
## $a.md
## [1] "Episode" "yarn"    "R6"     
## 
## $setup.md
## [1] "Episode" "yarn"    "R6"     
## 
## $b.md
## [1] "Episode" "yarn"    "R6"
```

Notice here that there is only one episode in the `$episodes` item, but
in the directory tree above, we see two. This is because of the
`config.yaml` file, which defines the order of the episodes:

``` r

read_yaml(path(wbfragment, "config.yaml"))$episodes
## [1] "intro.Rmd"
```

Because `episodes/nope.Rmd` is not listed, it is not read in. This is
useful to avoid reading in content from files that are incomplete or not
correctly formatted.

## File Information

The Lesson object contains information about the file information:

``` r

# what is the root path for the lesson?
wb_lesson$path
## [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment"
# what episode files exist?
wb_lesson$files
##                                                                        intro.Rmd 
## "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment/episodes/intro.Rmd"
# do any of the files have children (Workbench lessons only)? 
wb_lesson$has_children
## [1] FALSE
```

## Accessors

As mentioned earlier, many of the methods in a `Lesson` object are
wrappers for methods in `Episode` objects. `challenges`, `solutions` are
the obvious ones.

``` r

wb_lesson$challenges()
## $intro.Rmd
## $intro.Rmd$`div-3-challenge`
## {xml_nodeset (12)}
##  [1] <paragraph sourcepos="32:1-32:48">\n  <text sourcepos="32:1-32:47" xml:s ...
##  [2] <heading sourcepos="34:1-34:30" level="2">\n  <text sourcepos="34:4-34:3 ...
##  [3] <paragraph sourcepos="36:1-36:35">\n  <text sourcepos="36:1-36:35" xml:s ...
##  [4] <code_block sourcepos="38:1-40:3" xml:space="preserve" language="r" name ...
##  [5] <paragraph sourcepos="42:1-42:34">\n  <text sourcepos="42:1-42:33" xml:s ...
##  [6] <heading sourcepos="44:1-44:9" level="2">\n  <text sourcepos="44:4-44:9" ...
##  [7] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name ...
##  [8] <paragraph sourcepos="50:1-50:34">\n  <text sourcepos="50:1-50:34" xml:s ...
##  [9] <heading sourcepos="53:1-53:66" level="2">\n  <text sourcepos="53:4-53:6 ...
## [10] <paragraph sourcepos="55:1-55:34">\n  <text sourcepos="55:1-55:33" xml:s ...
## [11] <paragraph sourcepos="57:1-57:67">\n  <text sourcepos="57:1-57:52" xml:s ...
## [12] <paragraph sourcepos="59:1-60:48">\n  <text sourcepos="59:1-59:33" xml:s ...
wb_lesson$solutions()
## $intro.Rmd
## $intro.Rmd$`div-4-solution`
## {xml_nodeset (4)}
## [1] <paragraph sourcepos="42:1-42:34">\n  <text sourcepos="42:1-42:33" xml:sp ...
## [2] <heading sourcepos="44:1-44:9" level="2">\n  <text sourcepos="44:4-44:9"  ...
## [3] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name= ...
## [4] <paragraph sourcepos="50:1-50:34">\n  <text sourcepos="50:1-50:34" xml:sp ...
## 
## $intro.Rmd$`div-5-solution`
## {xml_nodeset (3)}
## [1] <paragraph sourcepos="55:1-55:34">\n  <text sourcepos="55:1-55:33" xml:sp ...
## [2] <paragraph sourcepos="57:1-57:67">\n  <text sourcepos="57:1-57:52" xml:sp ...
## [3] <paragraph sourcepos="59:1-60:48">\n  <text sourcepos="59:1-59:33" xml:sp ...
```

For the rest of the elements (or active bindings), you will need to use
the `$get()` method. For example, if you wanted all code blocks from the
episodes and the extra content, you would use:

``` r

wb_lesson$get("code", collection = c("episodes", "extra"))
## $intro.Rmd
## {xml_nodeset (3)}
## [1] <code_block sourcepos="38:1-40:3" xml:space="preserve" language="r" name= ...
## [2] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name= ...
## [3] <code_block sourcepos="66:1-73:3" xml:space="preserve" language="r" name= ...
## 
## $index.md
## {xml_nodeset (0)}
## 
## $a.md
## {xml_nodeset (0)}
## 
## $setup.md
## {xml_nodeset (0)}
## 
## $b.md
## {xml_nodeset (0)}
```

Similarly, for links and headings you would use:

``` r

wb_lesson$get("links", collection = c("episodes", "extra"))
## $intro.Rmd
## {xml_nodeset (1)}
## [1] <link sourcepos="20:29-20:54" destination="https://carpentries.github.io/ ...
## 
## $index.md
## {xml_nodeset (0)}
## 
## $a.md
## {xml_nodeset (0)}
## 
## $setup.md
## {xml_nodeset (2)}
## [1] <link sourcepos="15:5-15:50" destination="http://example.com/putty" title ...
## [2] <link sourcepos="23:5-23:47" destination="http://example.com/terminal" ti ...
## 
## $b.md
## {xml_nodeset (0)}
wb_lesson$get("headings", collection = c("episodes", "extra"))
## $intro.Rmd
## {xml_nodeset (6)}
## [1] <heading sourcepos="15:1-15:15" level="2">\n  <text sourcepos="15:4-15:15 ...
## [2] <heading sourcepos="34:1-34:30" level="2">\n  <text sourcepos="34:4-34:30 ...
## [3] <heading sourcepos="44:1-44:9" level="2">\n  <text sourcepos="44:4-44:9"  ...
## [4] <heading sourcepos="53:1-53:66" level="2">\n  <text sourcepos="53:4-53:66 ...
## [5] <heading sourcepos="62:1-62:10" level="2">\n  <text sourcepos="62:4-62:10 ...
## [6] <heading sourcepos="76:1-76:7" level="2">\n  <text sourcepos="76:4-76:7"  ...
## 
## $index.md
## {xml_nodeset (0)}
## 
## $a.md
## {xml_nodeset (0)}
## 
## $setup.md
## {xml_nodeset (2)}
## [1] <heading sourcepos="13:1-13:14" level="2">\n  <text sourcepos="13:4-13:14 ...
## [2] <heading sourcepos="21:1-21:12" level="2">\n  <text sourcepos="21:4-21:12 ...
## 
## $b.md
## {xml_nodeset (0)}
```

## Methods Summaries and Validation

For summaries, you will get a data frame of the summaries. You can also
choose to include other collections in the summary:

``` r

wb_lesson$summary() # defaults to episodes
## # A tibble: 1 × 12
##   page      sections headings callouts challenges solutions  code output warning
##   <chr>        <int>    <int>    <int>      <int>     <int> <int>  <int>   <int>
## 1 intro.Rmd        6        6        6          1         2     3      0       0
## # ℹ 3 more variables: error <int>, images <int>, links <int>
wb_lesson$summary(collection = c("episodes", "extra"))
## # A tibble: 5 × 12
##   page      sections headings callouts challenges solutions  code output warning
##   <chr>        <int>    <int>    <int>      <int>     <int> <int>  <int>   <int>
## 1 intro.Rmd        6        6        6          1         2     3      0       0
## 2 index.md         0        0        0          0         0     0      0       0
## 3 a.md             0        0        0          0         0     0      0       0
## 4 setup.md         2        2        3          0         2     0      0       0
## 5 b.md             0        0        0          0         0     0      0       0
## # ℹ 3 more variables: error <int>, images <int>, links <int>
```

Validation will auto-check everything and return the results as data
frames. You can find more information abou the specific checks by
reading `vignette("validation", package = "pegboard")`.

Details of the individual functions can be found via
`?validate_links()`, `?validate_divs()`, and `?validate_headings()`.

``` r

divs <- wb_lesson$validate_divs()
print(divs)
##                   episodes               path        div         pb_label pos
## div-1-questions  intro.Rmd episodes/intro.Rmd  questions  div-1-questions   7
## div-2-objectives intro.Rmd episodes/intro.Rmd objectives div-2-objectives  13
## div-3-challenge  intro.Rmd episodes/intro.Rmd  challenge  div-3-challenge  37
## div-4-solution   intro.Rmd episodes/intro.Rmd   solution   div-4-solution  47
## div-5-solution   intro.Rmd episodes/intro.Rmd   solution   div-5-solution  60
## div-6-keypoints  intro.Rmd episodes/intro.Rmd  keypoints  div-6-keypoints  90
## div-1-instructor  setup.md  learners/setup.md instructor div-1-instructor   6
## div-2-solution    setup.md  learners/setup.md   solution   div-2-solution  14
## div-3-solution    setup.md  learners/setup.md   solution   div-3-solution  22
##                  is_known
## div-1-questions      TRUE
## div-2-objectives     TRUE
## div-3-challenge      TRUE
## div-4-solution       TRUE
## div-5-solution       TRUE
## div-6-keypoints      TRUE
## div-1-instructor     TRUE
## div-2-solution       TRUE
## div-3-solution       TRUE
headings <- wb_lesson$validate_headings()
print(headings)
##    episodes                                                         heading
## 1 intro.Rmd                                                    Introduction
## 2 intro.Rmd                                     Challenge 1: Can you do it?
## 3 intro.Rmd                                                          Output
## 4 intro.Rmd Challenge 2: how do you nest solutions within challenge blocks?
## 5 intro.Rmd                                                         Figures
## 6 intro.Rmd                                                            Math
## 7  setup.md                                                     For Windows
## 8  setup.md                                                       For MacOS
##   level pos         node first_heading_is_second_level greater_than_first_level
## 1     2  20 <heading....                          TRUE                     TRUE
## 2     2  39 <heading....                          TRUE                     TRUE
## 3     2  49 <heading....                          TRUE                     TRUE
## 4     2  58 <heading....                          TRUE                     TRUE
## 5     2  67 <heading....                          TRUE                     TRUE
## 6     2  81 <heading....                          TRUE                     TRUE
## 7     2  16 <heading....                          TRUE                     TRUE
## 8     2  24 <heading....                          TRUE                     TRUE
##   are_sequential have_names are_unique               path
## 1           TRUE       TRUE       TRUE episodes/intro.Rmd
## 2           TRUE       TRUE       TRUE episodes/intro.Rmd
## 3           TRUE       TRUE       TRUE episodes/intro.Rmd
## 4           TRUE       TRUE       TRUE episodes/intro.Rmd
## 5           TRUE       TRUE       TRUE episodes/intro.Rmd
## 6           TRUE       TRUE       TRUE episodes/intro.Rmd
## 7           TRUE       TRUE       TRUE  learners/setup.md
## 8           TRUE       TRUE       TRUE  learners/setup.md
links <- wb_lesson$validate_links()
## ! There were errors in 2/3 links
## ◌ Links must use HTTPS <https://https.cio.gov/everything/>
## 
## ::warning file=learners/setup.md,line=18:: [needs HTTPS]: [the PuTTY terminal](http://example.com/putty)
## ::warning file=learners/setup.md,line=26:: [needs HTTPS]: [Terminal.app](http://example.com/terminal)
print(links)
##    episodes scheme                server port user            path query
## 1 intro.Rmd  https carpentries.github.io   NA      /lesson-example      
## 2  setup.md   http           example.com   NA               /putty      
## 3  setup.md   http           example.com   NA            /terminal      
##   fragment                                         orig               text  alt
## 1          https://carpentries.github.io/lesson-example     lesson example <NA>
## 2                              http://example.com/putty the PuTTY terminal <NA>
## 3                           http://example.com/terminal       Terminal.app <NA>
##   title type  rel anchor sourcepos           filepath parents         node
## 1       link <NA>  FALSE        25 episodes/intro.Rmd         <link so....
## 2       link <NA>  FALSE        18  learners/setup.md         <link so....
## 3       link <NA>  FALSE        26  learners/setup.md         <link so....
##   known_protocol enforce_https internal_anchor internal_file
## 1           TRUE          TRUE            TRUE          TRUE
## 2           TRUE         FALSE            TRUE          TRUE
## 3           TRUE         FALSE            TRUE          TRUE
##   internal_well_formed all_reachable img_alt_text descriptive link_length
## 1                 TRUE          TRUE         TRUE        TRUE        TRUE
## 2                 TRUE          TRUE         TRUE        TRUE        TRUE
## 3                 TRUE          TRUE         TRUE        TRUE        TRUE
```

## Loading Built Documents

One thing that is very useful is to check the status of the built
documents to ensure that everything you expect is there. You can load
all of the built markdown documents with the `$load_built()` method and
the built documents will populate the `$built` field:

``` r

wb_lesson$load_built()
lapply(wb_lesson$built, class)
## $`site/built/a.md`
## [1] "Episode" "yarn"    "R6"     
## 
## $`site/built/b.md`
## [1] "Episode" "yarn"    "R6"     
## 
## $`site/built/index.md`
## [1] "Episode" "yarn"    "R6"     
## 
## $`site/built/intro.md`
## [1] "Episode" "yarn"    "R6"     
## 
## $`site/built/setup.md`
## [1] "Episode" "yarn"    "R6"
```

You can use these to inspect how the content is rendered and see that
the code blocks render what they should render. In thise case,
`episodes/intro.Rmd` will render one output block and one image.

``` r

to_check <- c("page", "code", "output", "images", "warning", "error")
wb_lesson$summary(collection = c("episodes", "built"))[to_check]
## # A tibble: 6 × 6
##   page                 code output images warning error
##   <chr>               <int>  <int>  <int>   <int> <int>
## 1 intro.Rmd               3      0      0       0     0
## 2 site/built/a.md         0      0      0       0     0
## 3 site/built/b.md         0      0      0       0     0
## 4 site/built/index.md     0      0      0       0     0
## 5 site/built/intro.md     3      1      1       0     0
## 6 site/built/setup.md     0      0      0       0     0
```

## Handouts

This is another method wrapped from the Episode method, where it
combines the output into a single file and prepends the Episode title
before each section:

``` r

writeLines(wb_lesson$handout())
```

    ## ## Using RMarkdown
    ## 
    ## ## Challenge 1: Can you do it?
    ## 
    ## What is the output of this command?
    ## 
    ## ```{r, eval=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```

## Accessing other `Episode` methods

For
[`pegboard::Episode`](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
methods that are not listed above, you will need to manually iterate
over the `Episode` objects. For example, if you wanted to extract all of
the instructor notes in the lesson, you could use
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html)

``` r

purrr::map(c(wb_lesson$episodes, wb_lesson$extra), 
  function(ep) ep$get_divs("instructor"))
## $intro.Rmd
## named list()
## 
## $index.md
## named list()
## 
## $a.md
## named list()
## 
## $setup.md
## $setup.md$`div-1-instructor`
## {xml_nodeset (3)}
## [1] <paragraph sourcepos="3:1-3:80">\n  <text sourcepos="3:1-3:80" xml:space= ...
## [2] <paragraph sourcepos="5:1-7:49">\n  <text sourcepos="5:1-5:74" xml:space= ...
## [3] <paragraph sourcepos="9:1-9:80">\n  <text sourcepos="9:1-9:80" xml:space= ...
## 
## 
## $b.md
## named list()
```

If you wanted to get a specific thing from the body of the document,
then you could use any of the functions from {xml2} such as
[`xml2::xml_find_first()`](http://xml2.r-lib.org/reference/xml_find_all.md)
or
[`xml2::xml_find_all()`](http://xml2.r-lib.org/reference/xml_find_all.md).
Here, we are looking first the first text element that is not a
fenced-div element:

``` r

purrr::map_chr(c(wb_lesson$episodes, wb_lesson$extra), 
  function(ep) {
    xpath <- ".//md:text[not(starts-with(text(), ':::'))]"
    nodes <- xml_find_first(ep$body, xpath, ep$ns)
    return(xml_text(nodes))
  }
)
##                                                                    intro.Rmd 
##                             "How do you write a lesson using RMarkdown and " 
##                                                                     index.md 
##                                                                           NA 
##                                                                         a.md 
##                                                                           NA 
##                                                                     setup.md 
## "Setup instructions live in this document. Please specify the tools and the" 
##                                                                         b.md 
##                                                                           NA
```

For more information about constructing XPath queries and working with
XML data, you can read
[`vignette("intro-xml", package = "pegboard")`](https://carpentries.github.io/pegboard/dev/articles/intro-xml.md)

## Creating a New Lesson with Child Documents

If you are unfamiliar with the concept of child documents, please read
the “Including Child Documents” vignette in the {sandpaper} package
(`vignette("include-child-documents", package = "sandpaper")`).

The
[`pegboard::Lesson`](https://carpentries.github.io/pegboard/dev/reference/Lesson.md)
object is very useful with lessons that contain child documents because
it records the relationships between documents. This is key for
workflows determining build order of a Lesson. If a source document is
modified, in any build system, that source document will trigger a
rebuild of the downstream page, and *the same should happen if a child
document of that source is modified* (if you are interested in the build
process used by {sandpaper}, you can read `sandpaper::build_status()`
and `sandpaper::hash_children()`). This functionality is implemented in
the `pegboard::Lesson$trace_lineage()` method, which returns all
documents required to build any given file. We will demonstrate the
utility of this later, but first, we will demonstrate how
`pegboard::Lesson$new()` auto-detects the child documents:

Take for example the same lesson, but `episodes/intro.Rmd` has the child
`episodes/files/cat.Rmd` which in turn has the child
`episodes/files/session.Rmd`:

    #  .
    #  ├── config.yaml
    #  ├── episodes
    #  │   ├── files
    #  │   │   ├── cat.Rmd
    #  │   │   └── session.Rmd
    #  │   ├── intro.Rmd
    #  │   └── nope.md
    #  ├── index.md
    #  ├── instructors
    #  │   └── a.md
    #  ├── learners
    #  │   └── setup.md
    #  ├── profiles
    #  │   └── b.md
    #  └── site
    #      └── README.md

A valid child document reference requires a code chunk with a `child`
attribute that points to a valid file relative to the parent document,
so if I have this code block inside `episodes/intro.Rmd`, then it will
include the child document called `episodes/files/cat.Rmd`:

```` default

```{r cat-child, child="files/cat.Rmd"}
```
````

During initialisation of a Workbench lesson (note: not currently
implemented for Jekyll lessons), the `Lesson` object will detect that at
least one `Episode` references at least one child document (via
[`find_children()`](https://carpentries.github.io/pegboard/dev/reference/find_children.md))
and read them in (see
[`load_children()`](https://carpentries.github.io/pegboard/dev/reference/load_children.md)
for details).

``` r

wbchild <- lesson_fragment("sandpaper-fragment-with-child")
wb_lesson_child <- Lesson$new(wbchild, jekyll = FALSE)
wb_lesson_child$has_children
## [1] TRUE
lapply(wb_lesson_child$children, class)
## $`/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd`
## [1] "Episode" "yarn"    "R6"     
## 
## $`/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/session.Rmd`
## [1] "Episode" "yarn"    "R6"
```

The reason it is useful is because if you have a child Episode object,
you can determine its parent and its final ancestor. Because these paths
are absolute paths, I am going to write a function that will use the
{glue} package to print it nicely for us:

``` r

show_child_parents <- function(child) {
  parents <- fs::path_rel(child$parents, start = child$lesson)
  build_parents <- fs::path_rel(child$build_parents, start = child$lesson)

  msg <- "Ancestors for {child$name} ---
  Parent(s):         {parents}
  Final ancestor(s): {build_parents}"
  glue::glue(msg)
}

# cat.Rmd's parent is intro.Rmd
show_child_parents(wb_lesson_child$children[[1]])
## Ancestors for cat.Rmd ---
## Parent(s):         episodes/intro.Rmd
## Final ancestor(s): episodes/intro.Rmd

# session.Rmd's parent is cat.Rmd
show_child_parents(wb_lesson_child$children[[2]])
## Ancestors for session.Rmd ---
## Parent(s):         episodes/files/cat.Rmd
## Final ancestor(s): episodes/intro.Rmd
```

If you have the name of the final ancestor, then you can determine the
full lineage with the `$trace_lineage()` method, which is useful for
determining if a file should be rebuilt:

``` r

parent <- wb_lesson_child$children[[2]]$build_parents
print(parent)
## [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/intro.Rmd"
lineage <- wb_lesson_child$trace_lineage(parent)

# printing the lineage in a presentable fashion:
rel <- wb_lesson_child$path
pretty_lineage <- path_rel(lineage, start = rel)
pretty_lineage <- glue_collapse(pretty_lineage, sep = ", ", last = ", and ")
glue("The lineage of {path_rel(parent, start = rel)} is:
  {pretty_lineage}")
## The lineage of episodes/intro.Rmd is:
## episodes/intro.Rmd, episodes/files/cat.Rmd, and episodes/files/session.Rmd
```

## Jekyll Lessons

This section will talk about the peculiarities with lessons built with
the [carpentries/styles](https://carpentries.github.io/lesson-example/)
lesson template. Note that lesson transition methods are not implemented
in the `Lesson` object, if you want to find out about methods for
transition, please read the Jekyll section in
[`vignette("intro-episode", package = "pegboard")`](https://carpentries.github.io/pegboard/dev/articles/intro-episode.md).

### Syntax

The former Jekyll syntax used [kramdown-flavoured
markdown](https://kramdown.gettalong.org/syntax.html), which evolved
separately from [commonmark](https://spec.commonmark.org/), the syntax
that {pegboard} knows and that Pandoc-flavoured markdown extends. One of
the key differences with the kramdown syntax is that it used something
known as [Inline Attribute Lists
(IAL)](https://kramdown.gettalong.org/syntax.html#inline-attribute-lists)
to help define classes for markdown elements. These elements were
formated as `{: <attributes>}` where `<attributes>` is replaced by class
definitions and key/value pairs. They always appear *after* the relevant
block which lead to code blocks that looked like this:

``` markdown
~~~
ls -larth /path/to/dir
~~~
{: .language-bash}
```

Moreover, to achieve the special callout blocks, we used blockquotes
that were given special classes (which is an accessbility no-no because
those blocks were not semantic HTML) and the nesting of these block
quotes looked like this:

``` markdown
> ## Challenge
> 
> How do you list all files in a directory in reverse order by the time it was 
> last updated?
> 
> > ## Solution
> > 
> > ~~~
> > ls -larth /path/to/dir
> > ~~~
> > {: .language-bash}
> {: .solution}
{: .challenge}
```

One of the biggest challenges with this for authors was that, unless you
used an editor like vim or emacs, this was difficult to write with all
the prefixed blockquote characters and keeping track of which IALs
belonged to which block.

### Methods

There are some methods that are specific to lessons that are built with
Jekyll. In particular, the `n_problems` and `show_problems` active
binding are useful for determining if anything went wrong with parsing
the kramdown syntax, the `$isolate_blocks()` method was used to strip
out all non-blockquote content, the `$blocks()` method returned all
block quote with filters for types, and the `$rmd` field was an
indicator that the lesson used R Markdown.

``` r

jekyll <- Lesson$new(lesson_fragment("lesson-fragment"), jekyll = TRUE)
jekyll$n_problems
##             10-lunch.md         12-for-loops.md 14-looping-data-sets.md 
##                       0                       0                       0 
##             17-scope.md 
##                       0
rmd    <- Lesson$new(lesson_fragment("rmd-lesson"), jekyll = TRUE)
## could not find _episodes/, using _episodes_rmd/ as the source
rmd$n_problems
## 01-test.Rmd 
##           0
```

As mentioned above, in Jekyll uses special block quotes to format
callout blocks. The `$challenges()` and `$solutions()` methods recognise
this and will return the block quotes:

``` r

jekyll$challenges()
## $`10-lunch.md`
## {xml_nodeset (0)}
## 
## $`12-for-loops.md`
## {xml_nodeset (7)}
## [1] <block_quote sourcepos="160:1-167:14" ktag="{: .challenge}">\n  <heading  ...
## [2] <block_quote sourcepos="169:1-192:14" ktag="{: .challenge}">\n  <heading  ...
## [3] <block_quote sourcepos="194:1-217:14" ktag="{: .challenge}">\n  <heading  ...
## [4] <block_quote sourcepos="219:1-298:14" ktag="{: .challenge}">\n  <heading  ...
## [5] <block_quote sourcepos="300:1-328:14" ktag="{: .challenge}">\n  <heading  ...
## [6] <block_quote sourcepos="330:1-366:14" ktag="{: .challenge}">\n  <heading  ...
## [7] <block_quote sourcepos="368:1-388:14" ktag="{: .challenge}">\n  <heading  ...
## 
## $`14-looping-data-sets.md`
## {xml_nodeset (3)}
## [1] <block_quote sourcepos="95:1-108:14" ktag="{: .challenge}">\n  <heading s ...
## [2] <block_quote sourcepos="110:1-140:14" ktag="{: .challenge}">\n  <heading  ...
## [3] <block_quote sourcepos="142:1-170:14" ktag="{: .challenge}">\n  <heading  ...
## 
## $`17-scope.md`
## {xml_nodeset (2)}
## [1] <block_quote sourcepos="45:1-60:14" ktag="{: .challenge}">\n  <heading so ...
## [2] <block_quote sourcepos="62:1-95:14" ktag="{: .challenge}">\n  <heading so ...
jekyll$solutions()
## $`10-lunch.md`
## {xml_nodeset (0)}
## 
## $`12-for-loops.md`
## {xml_nodeset (10)}
##  [1] <block_quote sourcepos="163:3-167:14" ktag="{: .solution}">\n  <heading  ...
##  [2] <block_quote sourcepos="180:3-190:38" ktag="{: .solution}">\n  <heading  ...
##  [3] <block_quote sourcepos="207:3-217:14" ktag="{: .solution}">\n  <heading  ...
##  [4] <block_quote sourcepos="232:3-240:15" ktag="{: .solution}">\n  <heading  ...
##  [5] <block_quote sourcepos="250:3-258:15" ktag="{: .solution}">\n  <heading  ...
##  [6] <block_quote sourcepos="269:3-278:15" ktag="{: .solution}">\n  <heading  ...
##  [7] <block_quote sourcepos="285:3-293:15" ktag="{: .solution}">\n  <heading  ...
##  [8] <block_quote sourcepos="316:3-328:14" ktag="{: .solution}">\n  <heading  ...
##  [9] <block_quote sourcepos="351:3-366:14" ktag="{: .solution}">\n  <heading  ...
## [10] <block_quote sourcepos="380:3-388:14" ktag="{: .solution}">\n  <heading  ...
## 
## $`14-looping-data-sets.md`
## {xml_nodeset (3)}
## [1] <block_quote sourcepos="104:3-108:14" ktag="{: .solution}">\n  <heading s ...
## [2] <block_quote sourcepos="128:3-140:14" ktag="{: .solution}">\n  <heading s ...
## [3] <block_quote sourcepos="147:3-170:14" ktag="{: .solution}">\n  <heading s ...
## 
## $`17-scope.md`
## {xml_nodeset (0)}
```

For other blocks, you can use the `$blocks()` method:

``` r

jekyll$blocks(".prereq")
## $`10-lunch.md`
## {xml_nodeset (0)}
## 
## $`12-for-loops.md`
## {xml_nodeset (0)}
## 
## $`14-looping-data-sets.md`
## {xml_nodeset (0)}
## 
## $`17-scope.md`
## {xml_nodeset (0)}
rmd$blocks(".prereq")
## $`01-test.Rmd`
## {xml_nodeset (1)}
## [1] <block_quote sourcepos="16:1-20:11" ktag="{: .prereq}">\n  <heading sourc ...
```
