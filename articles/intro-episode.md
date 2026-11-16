# Introduction to the Episode Object

## Introduction

The {pegboard} package facilitates the analysis and manipulation of
Markdown and R Markdown files by translating them to XML and back again.
This extends the {tinkr} package (see
[`vignette("tinkr", package = "tinkr")`](https://docs.ropensci.org/tinkr/articles/tinkr.html))
by providing additional methods that are specific for Carpentries-style
lessons. There are two `R6` classes defined in {pegboard}:

- [`pegboard::Episode`](https://carpentries.github.io/pegboard/reference/Episode.md)
  objects that contain the XML data, YAML metadata and extra fields that
  define the child and parent files for a particular episode. These
  inherit from the
  [`tinkr::yarn`](https://docs.ropensci.org/tinkr/reference/yarn.html)
  R6 class.
- [`pegboard::Lesson`](https://carpentries.github.io/pegboard/reference/Lesson.md)
  objects that contain lists of `Episode` objects categorised as
  “episodes”, “extra”, or “children”.

This vignette will be discussing the structure of Episode objects, how
to query the contents with the {xml2} package, and how to use the
methods and active bindings to get information about, extract, and
manipulate anything inside of a Markdown or R Markdown document.

## Reading Markdown Content

Each `Episode` object starts from a Markdown file. In particular for
{pegboard}, we assume that this Markdown file is written using
[Pandoc](https://pandoc.org/MANUAL.html) syntax (a superset of
[CommonMark](https://commonmark.org/)). It can be any markdown file, but
for us to explore what the `Episode` object has to offer us, let’s take
an example R Markdown file that is present in a fragment of a
Carpentries Workbench lesson that we have in this package. We will be
using the {xml2} package to explore the object and the {fs} package to
help with constructing file paths.

``` r

library("pegboard")
library("xml2")
library("fs")
```

This is what our lesson fragment looks like. It is a fragment because
it’s main purpose is to be used for examples and tests, but it contains
the basic structure of a lesson that we want.

    ## /home/runner/work/_temp/Library/pegboard/sandpaper-fragment
    ## ├── config.yaml
    ## ├── episodes
    ## │   ├── intro.Rmd
    ## │   └── nope.md
    ## ├── index.md
    ## ├── instructors
    ## │   └── a.md
    ## ├── learners
    ## │   └── setup.md
    ## ├── profiles
    ## │   └── b.md
    ## └── site
    ##     └── README.md

We can retrieve it with the
[`lesson_fragment()`](https://carpentries.github.io/pegboard/reference/lesson_fragment.md)
function, which loads example data from pegboard. Here we will take that
lesson fragment and read in the first episode with the initialization
method, `Episode$new()`, followed by `$confirm_sandpaper()`, a
confirmation that the episode was created to work with
[{sandpaper}](https://carpentries.github.io/sandpaper/), the user
interface and build engine of The Carpentries Workbench (for information
on non-workbench content, see the section on [Jekyll Lesson Markdown
Content](#jekyll-lesson-markdown-content)) and `$protect_math()` which
will prevent special characters in LaTeX math from being escaped.

``` r

lsn <- lesson_fragment("sandpaper-fragment")
# Read in the intro.Rmd document as an `Episode` object
intro_path <- path(lsn, "episodes", "intro.Rmd")
intro <- Episode$new(intro_path)$confirm_sandpaper()$protect_math()
```

If we print out the Episode object, I’m going to get a long list of
methods, fields and active bindings (functions that act like fields)
printed:

``` r

intro
## <Episode>
##   Inherits from: <yarn>
##   Public:
##     add_md: function (md, where = 0L) 
##     append_md: function (md, nodes = NULL, space = TRUE) 
##     body: xml_document, xml_node
##     build_parents: 
##     challenges: active binding
##     children: 
##     clone: function (deep = FALSE) 
##     code: active binding
##     confirm_sandpaper: function () 
##     error: active binding
##     frontmatter: --- title: "Using RMarkdown" teaching: 10 exercises: 2 ---
##     frontmatter_format: YAML
##     get_blocks: function (type = NULL, level = 1L) 
##     get_challenge_graph: function (recurse = TRUE) 
##     get_divs: function (type = NULL, include = FALSE) 
##     get_images: function (process = FALSE) 
##     get_protected: function (type = NULL) 
##     get_yaml: function () 
##     handout: function (path = NULL, solutions = FALSE) 
##     has_children: active binding
##     has_parents: active binding
##     head: function (n = 6L) 
##     headings: active binding
##     images: active binding
##     initialize: function (path = NULL, process_tags = TRUE, fix_links = TRUE, 
##     isolate_blocks: function () 
##     keypoints: active binding
##     label_divs: function () 
##     lesson: active binding
##     links: active binding
##     md_vec: function (xpath = NULL, stylesheet_path = stylesheet()) 
##     move_keypoints: function () 
##     move_objectives: function () 
##     move_questions: function () 
##     name: active binding
##     ns: http://commonmark.org/xml/1.0
##     objectives: active binding
##     output: active binding
##     parents: 
##     path: /home/runner/work/_temp/Library/pegboard/sandpaper-fragm ...
##     prepend_md: function (md, nodes = NULL, space = TRUE) 
##     protect_curly: function () 
##     protect_fences: function () 
##     protect_math: function () 
##     protect_unescaped: function () 
##     questions: active binding
##     remove_error: function () 
##     remove_output: function () 
##     reset: function () 
##     show: function (n = TRUE) 
##     show_problems: active binding
##     solutions: active binding
##     summary: function () 
##     tags: active binding
##     tail: function (n = 6L) 
##     unblock: function (token = "#'", force = FALSE) 
##     use_dovetail: function () 
##     use_sandpaper: function (rmd = FALSE, yml = list()) 
##     validate_divs: function (warn = TRUE) 
##     validate_headings: function (verbose = TRUE, warn = TRUE) 
##     validate_links: function (warn = TRUE) 
##     warning: active binding
##     write: function (path = NULL, format = "md", edit = FALSE) 
##     yaml: active binding
##   Private:
##     clear_yaml_item: function (what) 
##     deep_clone: function (name, value) 
##     encoding: UTF-8
##     md_lines: function (path = NULL, stylesheet = NULL) 
##     mutations: TRUE FALSE TRUE TRUE FALSE TRUE TRUE TRUE FALSE FALSE
##     problems: list
##     record_problem: function (x) 
##     sourcepos: TRUE
```

The actual XML content is in the `$body` field. This contains all the
data from the markdown document, but in XML form.

``` r

intro$body
## {xml_document}
## <document sourcepos="1:1-91:48" xmlns="http://commonmark.org/xml/1.0">
##  [1] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-questions"/>
##  [2] <paragraph sourcepos="2:1-2:49">\n  <text sourcepos="2:1-2:48" xml:space ...
##  [3] <list sourcepos="4:1-5:0" type="bullet" tight="true">\n  <item sourcepos ...
##  [4] <paragraph sourcepos="6:1-6:48">\n  <text sourcepos="6:1-6:48" xml:space ...
##  [5] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-questions"/>
##  [6] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-objectives"/>
##  [7] <paragraph sourcepos="8:1-8:48">\n  <text sourcepos="8:1-8:48" xml:space ...
##  [8] <list sourcepos="10:1-12:0" type="bullet" tight="true">\n  <item sourcep ...
##  [9] <paragraph sourcepos="13:1-13:48">\n  <text sourcepos="13:1-13:48" xml:s ...
## [10] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-objectives"/>
## [11] <heading sourcepos="15:1-15:15" level="2">\n  <text sourcepos="15:4-15:1 ...
## [12] <paragraph sourcepos="17:1-20:78">\n  <text sourcepos="17:1-17:79" xml:s ...
## [13] <paragraph sourcepos="22:1-23:28">\n  <text sourcepos="22:1-22:79" xml:s ...
## [14] <list sourcepos="25:2-31:0" type="ordered" start="1" delim="period" tigh ...
## [15] <dtag xmlns="http://carpentries.org/pegboard/" label="div-3-challenge"/>
## [16] <paragraph sourcepos="32:1-32:48">\n  <text sourcepos="32:1-32:47" xml:s ...
## [17] <heading sourcepos="34:1-34:30" level="2">\n  <text sourcepos="34:4-34:3 ...
## [18] <paragraph sourcepos="36:1-36:35">\n  <text sourcepos="36:1-36:35" xml:s ...
## [19] <code_block sourcepos="38:1-40:3" xml:space="preserve" language="r" name ...
## [20] <dtag xmlns="http://carpentries.org/pegboard/" label="div-4-solution"/>
## ...
```

If we want to see what the contents look like, you can use the
`$show()`, `$head()`, or `$tail()` methods (note: the `$show()` method
will print out the entire markdown document).

``` r

intro$head(10)
## ---
## title: "Using RMarkdown"
## teaching: 10
## exercises: 2
## ---
## 
## :::::::::::::::::::::::::::::::::::::: questions
## 
## - How do you write a lesson using RMarkdown and `{sandpaper}`?
intro$tail(10)
## Cool, right?
## 
## ::::::::::::::::::::::::::::::::::::: keypoints
## 
## - Use `.Rmd` files for lessons even if you don't need to generate any code
## - Run `sandpaper::check_lesson()` to identify any issues with your lesson
## - Run `sandpaper::build_lesson()` to preview your lesson locally
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::
intro$show()
```

    ## ---
    ## title: "Using RMarkdown"
    ## teaching: 10
    ## exercises: 2
    ## ---
    ## 
    ## :::::::::::::::::::::::::::::::::::::: questions
    ## 
    ## - How do you write a lesson using RMarkdown and `{sandpaper}`?
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## ::::::::::::::::::::::::::::::::::::: objectives
    ## 
    ## - Explain how to use markdown with the new lesson template
    ## - Demonstrate how to include pieces of code, figures, and nested challenge blocks
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## ## Introduction
    ## 
    ## This is the new Carpentries template. It is written in [RMarkdown][r-markdown],
    ## which is a variant of Markdown that allows you to render code inside the
    ## lesson. Please refer to the [lesson
    ## example](https://carpentries.github.io/lesson-example) for full documentation.
    ## 
    ## What you need to know is that there are three block quotes required for a valid
    ## Carpentries lesson template:
    ## 
    ## 1. `questions` are displayed at the beginning of the episode to prime the
    ##    learner for the content.
    ## 2. `objectives` are the learning objectives for an episode displayed with
    ##    the questions.
    ## 3. `keypoints` are displayed at the end of the episode to reinforce the
    ##    objectives.
    ## 
    ## ::::::::::::::::::::::::::::::::::::: challenge
    ## 
    ## ## Challenge 1: Can you do it?
    ## 
    ## What is the output of this command?
    ## 
    ## ```{r, eval=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```
    ## 
    ## :::::::::::::::::::::::: solution
    ## 
    ## ## Output
    ## 
    ## ```{r, echo=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```
    ## 
    ## ::::::::::::::::::::::::::::::::::
    ## 
    ## ## Challenge 2: how do you nest solutions within challenge blocks?
    ## 
    ## :::::::::::::::::::::::: solution
    ## 
    ## You can add a line with at least three colons and a `solution` tag.
    ## 
    ## :::::::::::::::::::::::::::::::::
    ## ::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## ## Figures
    ## 
    ## You can also include figures:
    ## 
    ## ```{r pyramid}
    ## pie(
    ##   c(Sky = 78, "Sunny side of pyramid" = 17, "Shady side of pyramid" = 5), 
    ##   init.angle = 315, 
    ##   col = c("deepskyblue", "yellow", "yellow3"), 
    ##   border = FALSE
    ## )
    ## ```
    ## 
    ## ## Math
    ## 
    ## One of our episodes contains $\LaTeX$ equations when describing how to create
    ## dynamic reports with {knitr}, so we now use mathjax to describe this:
    ## 
    ## `$\alpha = \dfrac{1}{(1 - \beta)^2}$` becomes: $\alpha = \dfrac{1}{(1 - \beta)^2}$
    ## 
    ## Cool, right?
    ## 
    ## ::::::::::::::::::::::::::::::::::::: keypoints
    ## 
    ## - Use `.Rmd` files for lessons even if you don't need to generate any code
    ## - Run `sandpaper::check_lesson()` to identify any issues with your lesson
    ## - Run `sandpaper::build_lesson()` to preview your lesson locally
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::

## File information

For information about the file and its relationship to other files, you
can use the following active bindings, which are useful when working
with Episodes in a lesson context.

``` r

intro$path
## /home/runner/work/_temp/Library/pegboard/sandpaper-fragment/episodes/intro.Rmd
intro$name
## [1] "intro.Rmd"
intro$lesson
## [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment"
# NOTE: relationships to other episodes are automatically handled in the
#       Lesson context
intro$has_parents
## [1] FALSE
intro$has_children
## [1] FALSE
intro$children # separate documents processed as if they were part of this document
## character(0)
intro$parents  # the immediate documents that would require this document to build
## character(0)
intro$build_parents # the final documents that would require this document to build
## character(0)
```

## Accessing Markdown Elements

The `Episode` object is centered around the `$body` item, which contains
the XML representation of document. It is possible to find markdown
elements from XPath statments:

``` r

xml2::xml_find_all(intro$body, ".//md:link", ns = intro$ns)
## {xml_nodeset (1)}
## [1] <link sourcepos="20:29-20:54" destination="https://carpentries.github.io/ ...
xml2::xml_find_first(intro$body, ".//md:list[@type='ordered']", ns = intro$ns)
## {xml_node}
## <list sourcepos="25:2-31:0" type="ordered" start="1" delim="period" tight="true">
## [1] <item sourcepos="25:2-26:28">\n  <paragraph sourcepos="25:5-26:28">\n     ...
## [2] <item sourcepos="27:2-28:18">\n  <paragraph sourcepos="27:5-28:18">\n     ...
## [3] <item sourcepos="29:2-31:0">\n  <paragraph sourcepos="29:5-30:15">\n    < ...
```

However, there are some useful elements that we want to know about, so I
have implemented them in active bindings and methods:

``` r

# headings where level 2 headings are equivalent to sections
intro$headings
## {xml_nodeset (6)}
## [1] <heading sourcepos="15:1-15:15" level="2">\n  <text sourcepos="15:4-15:15 ...
## [2] <heading sourcepos="34:1-34:30" level="2">\n  <text sourcepos="34:4-34:30 ...
## [3] <heading sourcepos="44:1-44:9" level="2">\n  <text sourcepos="44:4-44:9"  ...
## [4] <heading sourcepos="53:1-53:66" level="2">\n  <text sourcepos="53:4-53:66 ...
## [5] <heading sourcepos="62:1-62:10" level="2">\n  <text sourcepos="62:4-62:10 ...
## [6] <heading sourcepos="76:1-76:7" level="2">\n  <text sourcepos="76:4-76:7"  ...
# all callouts/fenced divs
intro$get_divs()
## $`div-1-questions`
## {xml_nodeset (3)}
## [1] <paragraph sourcepos="2:1-2:49">\n  <text sourcepos="2:1-2:48" xml:space= ...
## [2] <list sourcepos="4:1-5:0" type="bullet" tight="true">\n  <item sourcepos= ...
## [3] <paragraph sourcepos="6:1-6:48">\n  <text sourcepos="6:1-6:48" xml:space= ...
## 
## $`div-2-objectives`
## {xml_nodeset (3)}
## [1] <paragraph sourcepos="8:1-8:48">\n  <text sourcepos="8:1-8:48" xml:space= ...
## [2] <list sourcepos="10:1-12:0" type="bullet" tight="true">\n  <item sourcepo ...
## [3] <paragraph sourcepos="13:1-13:48">\n  <text sourcepos="13:1-13:48" xml:sp ...
## 
## $`div-3-challenge`
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
## 
## $`div-4-solution`
## {xml_nodeset (4)}
## [1] <paragraph sourcepos="42:1-42:34">\n  <text sourcepos="42:1-42:33" xml:sp ...
## [2] <heading sourcepos="44:1-44:9" level="2">\n  <text sourcepos="44:4-44:9"  ...
## [3] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name= ...
## [4] <paragraph sourcepos="50:1-50:34">\n  <text sourcepos="50:1-50:34" xml:sp ...
## 
## $`div-5-solution`
## {xml_nodeset (3)}
## [1] <paragraph sourcepos="55:1-55:34">\n  <text sourcepos="55:1-55:33" xml:sp ...
## [2] <paragraph sourcepos="57:1-57:67">\n  <text sourcepos="57:1-57:52" xml:sp ...
## [3] <paragraph sourcepos="59:1-60:48">\n  <text sourcepos="59:1-59:33" xml:sp ...
## 
## $`div-6-keypoints`
## {xml_nodeset (3)}
## [1] <paragraph sourcepos="85:1-85:48">\n  <text sourcepos="85:1-85:47" xml:sp ...
## [2] <list sourcepos="87:1-90:0" type="bullet" tight="true">\n  <item sourcepo ...
## [3] <paragraph sourcepos="91:1-91:48">\n  <text sourcepos="91:1-91:48" xml:sp ...
intro$challenges
## $`div-3-challenge`
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
intro$solutions
## $`div-4-solution`
## {xml_nodeset (4)}
## [1] <paragraph sourcepos="42:1-42:34">\n  <text sourcepos="42:1-42:33" xml:sp ...
## [2] <heading sourcepos="44:1-44:9" level="2">\n  <text sourcepos="44:4-44:9"  ...
## [3] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name= ...
## [4] <paragraph sourcepos="50:1-50:34">\n  <text sourcepos="50:1-50:34" xml:sp ...
## 
## $`div-5-solution`
## {xml_nodeset (3)}
## [1] <paragraph sourcepos="55:1-55:34">\n  <text sourcepos="55:1-55:33" xml:sp ...
## [2] <paragraph sourcepos="57:1-57:67">\n  <text sourcepos="57:1-57:52" xml:sp ...
## [3] <paragraph sourcepos="59:1-60:48">\n  <text sourcepos="59:1-59:33" xml:sp ...
# questions, objectives, and keypoints are standard and return char vectors
intro$objectives 
## [1] "Explain how to use markdown with the new lesson template"                       
## [2] "Demonstrate how to include pieces of code, figures, and nested challenge blocks"
intro$questions
## [1] "How do you write a lesson using RMarkdown and `{sandpaper}`?"
intro$keypoints
## [1] "Use `.Rmd` files for lessons even if you don't need to generate any code"
## [2] "Run `sandpaper::check_lesson()` to identify any issues with your lesson" 
## [3] "Run `sandpaper::build_lesson()` to preview your lesson locally"
# code blocks and output types
intro$code
## {xml_nodeset (3)}
## [1] <code_block sourcepos="38:1-40:3" xml:space="preserve" language="r" name= ...
## [2] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name= ...
## [3] <code_block sourcepos="66:1-73:3" xml:space="preserve" language="r" name= ...
intro$output
## {xml_nodeset (0)}
intro$warning
## {xml_nodeset (0)}
intro$error
## {xml_nodeset (0)}
# images and links
intro$images
## {xml_nodeset (0)}
intro$get_images() # parses images embedded in `<img>` tags
## {xml_nodeset (0)}
intro$links
## {xml_nodeset (1)}
## [1] <link sourcepos="20:29-20:54" destination="https://carpentries.github.io/ ...
```

Much of these are summarized in the `$summary()` method:

``` r

intro$summary()
##   sections   headings   callouts challenges  solutions       code     output 
##          6          6          6          1          2          3          0 
##    warning      error     images      links 
##          0          0          0          1
```

## Code blocks and code chunks

In markdown, a **code block** is written with fences of at least three
backtick characters (`` ` ``) followed by the language for syntax
highlighting:

```` markdown

List all files in reverse temporal order, printing their sizes in
a human-readable format:

```bash
ls -larth /path/to/folder
```
````

> List all files in reverse temporal order, printing their sizes in a
> human-readable format:
>
> ``` bash
> ls -larth /path/to/folder
> ```

When these are processed by {pegboard}, the resulting XML has this
structure where the backticks inform that kind of node (`code_block`)
and the language type is known as the “info” attribute. Everything
inside the code block is the node text and has whitespace preserved

``` xml
<code_block info="bash" xml:space="preserve">
ls -larth /path/to/folder
</code_block>
```

In R Markdown, there are special code blocks that are called code chunks
that can be dynamically evaluated. These are distinguished by the curly
braces around the language specifier and [optional
attributes](https://yihui.org/knitr/options/) that control the output of
the chunk.

```` default

There is a code chunk here that will produce a plot, but not show the code:

```{r chunky, echo=FALSE, fig.alt="a plot of y = mx + b for m = 1 and b = 0"}
plot(1:10, type = "l")
```
````

> There is a code chunk here that will produce a plot, but not show the
> code:
>
> ![a plot of y = mx + b for m = 1 and b =
> 0](intro-episode_files/figure-html/chunk-name-1.png)

When this is processed with {pegboard}, the “info” part of the code
block is further split into “language”, “name” and further attributes
based on the chunk options:

``` xml
<code_block xml:space="preserve" language="r" name="chunky" echo="FALSE" fig.alt="&quot;a plot of y = mx + b for m = 1 and b = 0&quot;">
plot(1:10, type = "l")
</code_block>
```

Both code blocks will be encountered, but the difference between them is
that the R Markdown code chunks will have the “language” attribute. This
is an important concept to know about when you are searching and
manipulating R Markdown documents with XPath (see
[`vignette("intro-xml", package = "pegboard")`](https://carpentries.github.io/pegboard/articles/intro-xml.md)).
The next section will walk through some aspects of manipulation that we
can do with these documents.

## Manipulation

Because everything centers around the `$body` element and is extracted
with {xml2}, it’s possible to manipulate the elements of the document.
One thing that is possible is that we can add new content to the
document using the `$add_md()` method, which will add a markdown element
after any paragraph in the document.

For example, we can add information about pegboard with a new code block
after the first heading:

``` r

intro$head(26) # first 26 lines
## ---
## title: "Using RMarkdown"
## teaching: 10
## exercises: 2
## ---
## 
## :::::::::::::::::::::::::::::::::::::: questions
## 
## - How do you write a lesson using RMarkdown and `{sandpaper}`?
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::
## 
## ::::::::::::::::::::::::::::::::::::: objectives
## 
## - Explain how to use markdown with the new lesson template
## - Demonstrate how to include pieces of code, figures, and nested challenge blocks
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::
## 
## ## Introduction
## 
## This is the new Carpentries template. It is written in [RMarkdown][r-markdown],
## which is a variant of Markdown that allows you to render code inside the
## lesson. Please refer to the [lesson
## example](https://carpentries.github.io/lesson-example) for full documentation.
intro$body # first heading is item 11
## {xml_document}
## <document sourcepos="1:1-91:48" xmlns="http://commonmark.org/xml/1.0">
##  [1] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-questions"/>
##  [2] <paragraph sourcepos="2:1-2:49">\n  <text sourcepos="2:1-2:48" xml:space ...
##  [3] <list sourcepos="4:1-5:0" type="bullet" tight="true">\n  <item sourcepos ...
##  [4] <paragraph sourcepos="6:1-6:48">\n  <text sourcepos="6:1-6:48" xml:space ...
##  [5] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-questions"/>
##  [6] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-objectives"/>
##  [7] <paragraph sourcepos="8:1-8:48">\n  <text sourcepos="8:1-8:48" xml:space ...
##  [8] <list sourcepos="10:1-12:0" type="bullet" tight="true">\n  <item sourcep ...
##  [9] <paragraph sourcepos="13:1-13:48">\n  <text sourcepos="13:1-13:48" xml:s ...
## [10] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-objectives"/>
## [11] <heading sourcepos="15:1-15:15" level="2">\n  <text sourcepos="15:4-15:1 ...
## [12] <paragraph sourcepos="17:1-20:78">\n  <text sourcepos="17:1-17:79" xml:s ...
## [13] <paragraph sourcepos="22:1-23:28">\n  <text sourcepos="22:1-22:79" xml:s ...
## [14] <list sourcepos="25:2-31:0" type="ordered" start="1" delim="period" tigh ...
## [15] <dtag xmlns="http://carpentries.org/pegboard/" label="div-3-challenge"/>
## [16] <paragraph sourcepos="32:1-32:48">\n  <text sourcepos="32:1-32:47" xml:s ...
## [17] <heading sourcepos="34:1-34:30" level="2">\n  <text sourcepos="34:4-34:3 ...
## [18] <paragraph sourcepos="36:1-36:35">\n  <text sourcepos="36:1-36:35" xml:s ...
## [19] <code_block sourcepos="38:1-40:3" xml:space="preserve" language="r" name ...
## [20] <dtag xmlns="http://carpentries.org/pegboard/" label="div-4-solution"/>
## ...
```

```` r

cb <- c("You can clone the **{pegboard} package**:

```sh
git clone https://github.com/carpentries/pegboard.git
```
")
intro$add_md(cb, where = 11)
intro$head(26) # code block has been added
## ---
## title: "Using RMarkdown"
## teaching: 10
## exercises: 2
## ---
## 
## :::::::::::::::::::::::::::::::::::::: questions
## 
## - How do you write a lesson using RMarkdown and `{sandpaper}`?
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::
## 
## ::::::::::::::::::::::::::::::::::::: objectives
## 
## - Explain how to use markdown with the new lesson template
## - Demonstrate how to include pieces of code, figures, and nested challenge blocks
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::
## 
## ## Introduction
## 
## You can clone the **{pegboard} package**:
## 
## ```sh
## git clone https://github.com/carpentries/pegboard.git
## ```
````

``` r

intro$code
## {xml_nodeset (4)}
## [1] <code_block info="sh" xml:space="preserve" name="">git clone https://gith ...
## [2] <code_block sourcepos="38:1-40:3" xml:space="preserve" language="r" name= ...
## [3] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name= ...
## [4] <code_block sourcepos="66:1-73:3" xml:space="preserve" language="r" name= ...
```

You can also manipulate existing elements. For example, let’s say we
wanted to make sure all R code chunks were named. We can do so by
querying and manipulating the code blocks:

``` r

code <- intro$code
code
## {xml_nodeset (4)}
## [1] <code_block info="sh" xml:space="preserve" name="">git clone https://gith ...
## [2] <code_block sourcepos="38:1-40:3" xml:space="preserve" language="r" name= ...
## [3] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name= ...
## [4] <code_block sourcepos="66:1-73:3" xml:space="preserve" language="r" name= ...
# executable code chunks will have the "language" attribute
is_chunk <- xml2::xml_has_attr(code, "language")
chunks <- code[is_chunk]
chunk_names <- xml2::xml_attr(chunks, "name")
nonames <- chunk_names == ""
chunk_names[nonames] <- paste0("chunk-", seq(sum(nonames)))
xml2::xml_set_attr(chunks, "name", chunk_names)
code
## {xml_nodeset (4)}
## [1] <code_block info="sh" xml:space="preserve" name="">git clone https://gith ...
## [2] <code_block sourcepos="38:1-40:3" xml:space="preserve" language="r" name= ...
## [3] <code_block sourcepos="46:1-48:3" xml:space="preserve" language="r" name= ...
## [4] <code_block sourcepos="66:1-73:3" xml:space="preserve" language="r" name= ...
```

We can see that the chunks now have names, but the proof is in the
rendering:

``` r

intro$show()
```

    ## ---
    ## title: "Using RMarkdown"
    ## teaching: 10
    ## exercises: 2
    ## ---
    ## 
    ## :::::::::::::::::::::::::::::::::::::: questions
    ## 
    ## - How do you write a lesson using RMarkdown and `{sandpaper}`?
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## ::::::::::::::::::::::::::::::::::::: objectives
    ## 
    ## - Explain how to use markdown with the new lesson template
    ## - Demonstrate how to include pieces of code, figures, and nested challenge blocks
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## ## Introduction
    ## 
    ## You can clone the **{pegboard} package**:
    ## 
    ## ```sh
    ## git clone https://github.com/carpentries/pegboard.git
    ## ```
    ## 
    ## This is the new Carpentries template. It is written in [RMarkdown][r-markdown],
    ## which is a variant of Markdown that allows you to render code inside the
    ## lesson. Please refer to the [lesson
    ## example](https://carpentries.github.io/lesson-example) for full documentation.
    ## 
    ## What you need to know is that there are three block quotes required for a valid
    ## Carpentries lesson template:
    ## 
    ## 1. `questions` are displayed at the beginning of the episode to prime the
    ##    learner for the content.
    ## 2. `objectives` are the learning objectives for an episode displayed with
    ##    the questions.
    ## 3. `keypoints` are displayed at the end of the episode to reinforce the
    ##    objectives.
    ## 
    ## ::::::::::::::::::::::::::::::::::::: challenge
    ## 
    ## ## Challenge 1: Can you do it?
    ## 
    ## What is the output of this command?
    ## 
    ## ```{r chunk-1, eval=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```
    ## 
    ## :::::::::::::::::::::::: solution
    ## 
    ## ## Output
    ## 
    ## ```{r chunk-2, echo=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```
    ## 
    ## ::::::::::::::::::::::::::::::::::
    ## 
    ## ## Challenge 2: how do you nest solutions within challenge blocks?
    ## 
    ## :::::::::::::::::::::::: solution
    ## 
    ## You can add a line with at least three colons and a `solution` tag.
    ## 
    ## :::::::::::::::::::::::::::::::::
    ## ::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## ## Figures
    ## 
    ## You can also include figures:
    ## 
    ## ```{r pyramid}
    ## pie(
    ##   c(Sky = 78, "Sunny side of pyramid" = 17, "Shady side of pyramid" = 5), 
    ##   init.angle = 315, 
    ##   col = c("deepskyblue", "yellow", "yellow3"), 
    ##   border = FALSE
    ## )
    ## ```
    ## 
    ## ## Math
    ## 
    ## One of our episodes contains $\LaTeX$ equations when describing how to create
    ## dynamic reports with {knitr}, so we now use mathjax to describe this:
    ## 
    ## `$\alpha = \dfrac{1}{(1 - \beta)^2}$` becomes: $\alpha = \dfrac{1}{(1 - \beta)^2}$
    ## 
    ## Cool, right?
    ## 
    ## ::::::::::::::::::::::::::::::::::::: keypoints
    ## 
    ## - Use `.Rmd` files for lessons even if you don't need to generate any code
    ## - Run `sandpaper::check_lesson()` to identify any issues with your lesson
    ## - Run `sandpaper::build_lesson()` to preview your lesson locally
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::

## Handouts

**NOTE: This will change in version 0.8.0**. It is possible to generate
a code handout by using the `$handout()` method. This will grab all
challenge blocks along with any code block that contains `purl = TRUE`
and strip out everything else. You can also specifiy `solution = TRUE`
to include the solutions:

``` r

writeLines(intro$handout())
```

    ## ## Challenge 1: Can you do it?
    ## 
    ## What is the output of this command?
    ## 
    ## ```{r chunk-1, eval=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```

``` r

writeLines(intro$handout(solution = TRUE))
```

    ## ## Challenge 1: Can you do it?
    ## 
    ## What is the output of this command?
    ## 
    ## ```{r chunk-1, eval=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```
    ## 
    ## :::::::::::::::::::::::: solution
    ## 
    ## ## Output
    ## 
    ## ```{r chunk-2, echo=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```
    ## 
    ## ::::::::::::::::::::::::::::::::::
    ## 
    ## ## Challenge 2: how do you nest solutions within challenge blocks?
    ## 
    ## :::::::::::::::::::::::: solution
    ## 
    ## You can add a line with at least three colons and a `solution` tag.

I want to show that the `purl = TRUE` method actually works, so I’ll
take the `chunks` from above and include the last one:

``` r

xml2::xml_set_attr(chunks[chunk_names == "pyramid"], "purl", TRUE)
writeLines(intro$handout())
```

    ## ## Challenge 1: Can you do it?
    ## 
    ## What is the output of this command?
    ## 
    ## ```{r chunk-1, eval=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```
    ## 
    ## ```{r pyramid, purl=TRUE}
    ## pie(
    ##   c(Sky = 78, "Sunny side of pyramid" = 17, "Shady side of pyramid" = 5), 
    ##   init.angle = 315, 
    ##   col = c("deepskyblue", "yellow", "yellow3"), 
    ##   border = FALSE
    ## )
    ## ```

The `path` arguments allows this to be written to a file so that it can
be converted to a script using
[`knitr::purl`](https://rdrr.io/pkg/knitr/man/knit.html)

``` r

tmp <- tempfile()
intro$handout(path = tmp)
writeLines(readLines(tmp))
```

    ## ## Challenge 1: Can you do it?
    ## 
    ## What is the output of this command?
    ## 
    ## ```{r chunk-1, eval=FALSE}
    ## paste("This", "new", "template", "looks", "good")
    ## ```
    ## 
    ## ```{r pyramid, purl=TRUE}
    ## pie(
    ##   c(Sky = 78, "Sunny side of pyramid" = 17, "Shady side of pyramid" = 5), 
    ##   init.angle = 315, 
    ##   col = c("deepskyblue", "yellow", "yellow3"), 
    ##   border = FALSE
    ## )
    ## ```

## Reset

One of the things about manipulating these documents in code is that it
is possible to go back and reset if things are not correct, which is why
we have the `$reset()` method:

``` r

intro$reset()$confirm_sandpaper()$protect_math()$head(25)
## ---
## title: "Using RMarkdown"
## teaching: 10
## exercises: 2
## ---
## 
## :::::::::::::::::::::::::::::::::::::: questions
## 
## - How do you write a lesson using RMarkdown and `{sandpaper}`?
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::
## 
## ::::::::::::::::::::::::::::::::::::: objectives
## 
## - Explain how to use markdown with the new lesson template
## - Demonstrate how to include pieces of code, figures, and nested challenge blocks
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::
## 
## ## Introduction
## 
## This is the new Carpentries template. It is written in [RMarkdown][r-markdown],
## which is a variant of Markdown that allows you to render code inside the
## lesson. Please refer to the [lesson
## example](https://carpentries.github.io/lesson-example) for full documentation.
```

## Jekyll Lesson Markdown Content

This section describes the features that you would expect to find in a
lesson that was built with the former infrastructure,
<https://github.com/carpentries/styles>, which was built using the
Jekyll static site generator. These style lessons are no longer
supported by The Carpentries. {pegboard} does support these lessons so
that they can be transitioned to use The Workbench syntax via [The
Carpentries Lesson Transition
Tool](https://github.com/carpentries/lesson-transition#readme). This was
the *first* syntax that was supported by {pegboard} because the package
was written initially as a way to explore the structure of our lessons.

### The Syntax of Jekyll Lessons

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

### Special methods and active bindings

``` r

library("pegboard")
library("xml2")
library("fs")
```

Episodes written in the Jekyll syntax have special functions and active
bindings that allow them to be analyzed and transformed to Workbench
episodes. Here is an example from a lesson fragment:

``` r

lf <- lesson_fragment()
ep <- Episode$new(path(lf, "_episodes", "14-looping-data-sets.md"))
# show relevant sections of head and tail
ep$head(29)
```

    ## ---
    ## title: "Looping Over Data Sets"
    ## teaching: 5
    ## exercises: 10
    ## questions:
    ## - "How can I process many data sets with a single command?"
    ## objectives:
    ## - "Be able to read and write globbing expressions that match sets of files."
    ## - "Use glob to create lists of files."
    ## - "Write for loops to perform operations on files given their names in a list."
    ## keypoints:
    ## - "Use a `for` loop to process files given a list of their names."
    ## - "Use `glob.glob` to find sets of files whose names match a pattern."
    ## - "Use `glob` and `for` to process batches of files."
    ## ---
    ## 
    ## ## Use a `for` loop to process files given a list of their names.
    ## 
    ## - A filename is a character string.
    ## - And lists can contain character strings.
    ## 
    ## ```
    ## import pandas as pd
    ## for filename in ['data/gapminder_gdp_africa.csv', 'data/gapminder_gdp_asia.csv']:
    ##     data = pd.read_csv(filename, index_col='country')
    ##     print(filename, data.min())
    ## ```
    ## {: .language-python}

``` r

ep$tail(53)
```

    ## 
    ## > ## Comparing Data
    ## > 
    ## > Write a program that reads in the regional data sets
    ## > and plots the average GDP per capita for each region over time
    ## > in a single chart.
    ## > 
    ## > > ## Solution
    ## > > 
    ## > > This solution builds a useful legend by using the string [`split`](https://docs.python.org/3/library/stdtypes.html#str.split) method to
    ## > > extract the `region` from the path 'data/gapminder\_gdp\_a\_specific\_region.csv'. The [`pathlib module`]
    ## > > also provides useful abstractions for file and path manipulation like returning the name of a file
    ## > > without the file extension.
    ## > > 
    ## > > ```
    ## > > import glob
    ## > > import pandas as pd
    ## > > import matplotlib.pyplot as plt
    ## > > fig, ax = plt.subplots(1,1)
    ## > > for filename in glob.glob('data/gapminder_gdp*.csv'):
    ## > >     dataframe = pd.read_csv(filename)
    ## > >     # extract <region> from the filename, expected to be in the format 'data/gapminder_gdp_<region>.csv'.
    ## > >     # we will split the string using the split method and `_` as our separator,
    ## > >     # retrieve the last string in the list that split returns (`<region>.csv`), 
    ## > >     # and then remove the `.csv` extension from that string.
    ## > >     region = filename.split('_')[-1][:-4] 
    ## > >     dataframe.mean().plot(ax=ax, label=region)
    ## > > plt.legend()
    ## > > plt.show()
    ## > > ```
    ## > > {: .language-python}
    ## > {: .solution}
    ## {: .challenge}
    ## 
    ## ### ZNK test links and images
    ## 
    ## <img src="https://carpentries.org/assets/img/TheCarpentries.svg" alt="books as clubs">
    ## 
    ## <img src="../no-workie.svg" alt="books as clubs">
    ## 
    ## Link to [Home]({{ page.root }}/index.html) and to [shell]({{ site.swc_pages }}/shell-novice)
    ## 
    ## ![Carpentries logo](https://carpentries.org/assets/img/TheCarpentries.svg)
    ## 
    ## ![Non-working image](../no-workie.svg)
    ## 
    ## ![Non-working image with jekyll syntax]({{ page.root }}/no-workie.svg)
    ## 
    ## This text includes a [link that isn't parsed correctly by commonmark]({{ page.root }}{% link index.md %})
    ## . The rest of the text should be properly parsed.
    ## 
    ## {% include links.md %}

Notice that the questions, objectives, and keypoints are in the yaml
frontmatter. This is why we have an accessor that returns the list
instead of the node, for compatibility with the Jekyll lessons:

``` r

ep$questions
## [1] "How can I process many data sets with a single command?"
ep$objectives
## [1] "Be able to read and write globbing expressions that match sets of files."   
## [2] "Use glob to create lists of files."                                         
## [3] "Write for loops to perform operations on files given their names in a list."
ep$keypoints
## [1] "Use a `for` loop to process files given a list of their names."    
## [2] "Use `glob.glob` to find sets of files whose names match a pattern."
## [3] "Use `glob` and `for` to process batches of files."
```

Even though the challenges are formatted differently, the accessors will
still return them correctly:

``` r

ep$challenges
## {xml_nodeset (3)}
## [1] <block_quote sourcepos="95:1-108:14" ktag="{: .challenge}">\n  <heading s ...
## [2] <block_quote sourcepos="110:1-140:14" ktag="{: .challenge}">\n  <heading  ...
## [3] <block_quote sourcepos="142:1-170:14" ktag="{: .challenge}">\n  <heading  ...
ep$solutions
## {xml_nodeset (3)}
## [1] <block_quote sourcepos="104:3-108:14" ktag="{: .solution}">\n  <heading s ...
## [2] <block_quote sourcepos="128:3-140:14" ktag="{: .solution}">\n  <heading s ...
## [3] <block_quote sourcepos="147:3-170:14" ktag="{: .solution}">\n  <heading s ...
```

You can also get *all* of the block quotes using the `$get_blocks()`
method. NOTE: this will extract *all* block quotes (including those that
do not have the `ktag` attributes.

``` r

ep$get_blocks() # default is all top-level blocks (challenges/callouts)
## {xml_nodeset (3)}
## [1] <block_quote sourcepos="95:1-108:14" ktag="{: .challenge}">\n  <heading s ...
## [2] <block_quote sourcepos="110:1-140:14" ktag="{: .challenge}">\n  <heading  ...
## [3] <block_quote sourcepos="142:1-170:14" ktag="{: .challenge}">\n  <heading  ...
ep$get_blocks(level = 2) # nested blocks are usually solutions
## {xml_nodeset (3)}
## [1] <block_quote sourcepos="104:3-108:14" ktag="{: .solution}">\n  <heading s ...
## [2] <block_quote sourcepos="128:3-140:14" ktag="{: .solution}">\n  <heading s ...
## [3] <block_quote sourcepos="147:3-170:14" ktag="{: .solution}">\n  <heading s ...
ep$get_blocks(level = 0) # level zero is all levels
## {xml_nodeset (6)}
## [1] <block_quote sourcepos="95:1-108:14" ktag="{: .challenge}">\n  <heading s ...
## [2] <block_quote sourcepos="104:3-108:14" ktag="{: .solution}">\n  <heading s ...
## [3] <block_quote sourcepos="110:1-140:14" ktag="{: .challenge}">\n  <heading  ...
## [4] <block_quote sourcepos="128:3-140:14" ktag="{: .solution}">\n  <heading s ...
## [5] <block_quote sourcepos="142:1-170:14" ktag="{: .challenge}">\n  <heading  ...
## [6] <block_quote sourcepos="147:3-170:14" ktag="{: .solution}">\n  <heading s ...
ep$get_blocks(type = ".solution", level = 0) # filter by type
## {xml_nodeset (3)}
## [1] <block_quote sourcepos="104:3-108:14" ktag="{: .solution}">\n  <heading s ...
## [2] <block_quote sourcepos="128:3-140:14" ktag="{: .solution}">\n  <heading s ...
## [3] <block_quote sourcepos="147:3-170:14" ktag="{: .solution}">\n  <heading s ...
```

One of the things that was advantageous about blockquotes is that we
could analyze the pathway through the blockquotes and figure out how
they were comonly written in a lesson. The `$get_challenge_graph()`
creates a data frame that describes these relationships:

``` r

ep$get_challenge_graph()
##    Block       from         to          pos level
## 1      1  challenge    heading  95:1-108:14     1
## 2      1    heading  paragraph   95:3-95:24     1
## 3      1  paragraph       list   97:3-97:87     1
## 4      1       list   solution   99:3-103:1     1
## 5      1   solution     lesson 104:3-108:14     1
## 6      1   solution    heading 104:3-108:14     2
## 7      1    heading  paragraph 104:5-104:15     2
## 8      1  paragraph  challenge 106:5-108:14     2
## 9      2  challenge    heading 110:1-140:14     1
## 10     2    heading  paragraph 110:3-110:22     1
## 11     2  paragraph code_block 112:3-113:39     1
## 12     2 code_block  paragraph  115:3-123:5     1
## 13     2  paragraph   solution 124:3-126:72     1
## 14     2   solution     lesson 128:3-140:14     1
## 15     2   solution    heading 128:3-140:14     2
## 16     2    heading code_block 128:5-128:15     2
## 17     2 code_block  challenge  129:5-137:7     2
## 18     3  challenge    heading 142:1-170:14     1
## 19     3    heading  paragraph 142:3-142:19     1
## 20     3  paragraph   solution 144:3-146:20     1
## 21     3   solution     lesson 147:3-170:14     1
## 22     3   solution    heading 147:3-170:14     2
## 23     3    heading  paragraph 147:5-147:15     2
## 24     3  paragraph code_block 148:5-151:31     2
## 25     3 code_block  challenge  152:5-167:7     2
```

You might notice that there is an attribute called `ktag`. When a
Jekyll-formatted episode is read in, all of the IAL tags are processed
and placed in an attribute called `ktag` (**k**ramdown **tag**), which
is accessible via the `$tags` active binding. This is needed because
commonmark does not know how to process postfix tags and it is important
for the translation to commonmark syntax:

``` r

ep$tags
## {xml_nodeset (17)}
##  [1]  ktag="{: .language-python}"
##  [2]  ktag="{: .output}"
##  [3]  ktag="{: .language-python}"
##  [4]  ktag="{: .output}"
##  [5]  ktag="{: .language-python}"
##  [6]  ktag="{: .output}"
##  [7]  ktag="{: .language-python}"
##  [8]  ktag="{: .output}"
##  [9]  ktag="{: .challenge}"
## [10]  ktag="{: .solution}"
## [11]  ktag="{: .challenge}"
## [12]  ktag="{: .language-python}"
## [13]  ktag="{: .solution}"
## [14]  ktag="{: .language-python}"
## [15]  ktag="{: .challenge}"
## [16]  ktag="{: .solution}"
## [17]  ktag="{: .language-python}"
xml2::xml_parent(ep$tags)
## {xml_nodeset (17)}
##  [1] <code_block sourcepos="7:1-12:3" xml:space="preserve" name="" ktag="{: . ...
##  [2] <code_block sourcepos="14:1-33:3" xml:space="preserve" name="" ktag="{:  ...
##  [3] <code_block sourcepos="48:1-51:3" xml:space="preserve" name="" ktag="{:  ...
##  [4] <code_block sourcepos="53:1-57:3" xml:space="preserve" name="" ktag="{:  ...
##  [5] <code_block sourcepos="60:1-62:3" xml:space="preserve" name="" ktag="{:  ...
##  [6] <code_block sourcepos="64:1-66:3" xml:space="preserve" name="" ktag="{:  ...
##  [7] <code_block sourcepos="74:1-78:3" xml:space="preserve" name="" ktag="{:  ...
##  [8] <code_block sourcepos="80:1-87:3" xml:space="preserve" name="" ktag="{:  ...
##  [9] <block_quote sourcepos="95:1-108:14" ktag="{: .challenge}">\n  <heading  ...
## [10] <block_quote sourcepos="104:3-108:14" ktag="{: .solution}">\n  <heading  ...
## [11] <block_quote sourcepos="110:1-140:14" ktag="{: .challenge}">\n  <heading ...
## [12] <code_block sourcepos="115:3-123:5" xml:space="preserve" name="" ktag="{ ...
## [13] <block_quote sourcepos="128:3-140:14" ktag="{: .solution}">\n  <heading  ...
## [14] <code_block sourcepos="129:5-137:7" xml:space="preserve" name="" ktag="{ ...
## [15] <block_quote sourcepos="142:1-170:14" ktag="{: .challenge}">\n  <heading ...
## [16] <block_quote sourcepos="147:3-170:14" ktag="{: .solution}">\n  <heading  ...
## [17] <code_block sourcepos="152:5-167:7" xml:space="preserve" name="" ktag="{ ...
```

### Transformation

It was always known that we would want to use a different syntax to
write the lessons as much of the community struggled with the kramdown
syntax and it was difficult to parse and validate. The automated
transformation workflow is what powers the Lesson Transformation Tool
and we have composed it into a few basic steps:

1.  transform block quotes to fenced divs (via the `$unblock()` method,
    using the internal
    [`replace_with_div()`](https://carpentries.github.io/pegboard/reference/replace_with_div.md)
    function).
2.  removing the jekyll syntax, liquid templating, and fix relative
    links (via the `$use_sandpaper()` method, using the internal
    [`use_sandpaper()`](https://carpentries.github.io/pegboard/reference/use_sandpaper.md)
    function.
3.  moving the yaml frontmatter using the `$move_` methods

The process looks like this composable chain of methods:

``` r

ep$reset()
ep$
  unblock()$
  use_sandpaper()$
  move_questions()$
  move_objectives()$
  move_keypoints()
ep$head(31)
```

    ## ---
    ## title: Looping Over Data Sets
    ## teaching: 5
    ## exercises: 10
    ## ---
    ## 
    ## ::::::::::::::::::::::::::::::::::::::: objectives
    ## 
    ## - Be able to read and write globbing expressions that match sets of files.
    ## - Use glob to create lists of files.
    ## - Write for loops to perform operations on files given their names in a list.
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## :::::::::::::::::::::::::::::::::::::::: questions
    ## 
    ## - How can I process many data sets with a single command?
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## ## Use a `for` loop to process files given a list of their names.
    ## 
    ## - A filename is a character string.
    ## - And lists can contain character strings.
    ## 
    ## ```python
    ## import pandas as pd
    ## for filename in ['data/gapminder_gdp_africa.csv', 'data/gapminder_gdp_asia.csv']:
    ##     data = pd.read_csv(filename, index_col='country')
    ##     print(filename, data.min())
    ## ```

``` r

ep$tail(65)
```

    ## :::::::::::::::::::::::::::::::::::::::  challenge
    ## 
    ## ## Comparing Data
    ## 
    ## Write a program that reads in the regional data sets
    ## and plots the average GDP per capita for each region over time
    ## in a single chart.
    ## 
    ## :::::::::::::::  solution
    ## 
    ## ## Solution
    ## 
    ## This solution builds a useful legend by using the string [`split`](https://docs.python.org/3/library/stdtypes.html#str.split) method to
    ## extract the `region` from the path 'data/gapminder\_gdp\_a\_specific\_region.csv'. The [`pathlib module`]
    ## also provides useful abstractions for file and path manipulation like returning the name of a file
    ## without the file extension.
    ## 
    ## ```python
    ## import glob
    ## import pandas as pd
    ## import matplotlib.pyplot as plt
    ## fig, ax = plt.subplots(1,1)
    ## for filename in glob.glob('data/gapminder_gdp*.csv'):
    ##     dataframe = pd.read_csv(filename)
    ##     # extract <region> from the filename, expected to be in the format 'data/gapminder_gdp_<region>.csv'.
    ##     # we will split the string using the split method and `_` as our separator,
    ##     # retrieve the last string in the list that split returns (`<region>.csv`), 
    ##     # and then remove the `.csv` extension from that string.
    ##     region = filename.split('_')[-1][:-4] 
    ##     dataframe.mean().plot(ax=ax, label=region)
    ## plt.legend()
    ## plt.show()
    ## ```
    ## 
    ## :::::::::::::::::::::::::
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## ### ZNK test links and images
    ## 
    ## <img src="https://carpentries.org/assets/img/TheCarpentries.svg" alt="books as clubs">
    ## 
    ## <img src="no-workie.svg" alt="books as clubs">
    ## 
    ## Link to [Home](index.html) and to [shell](https://swcarpentry.github.io/shell-novice)
    ## 
    ## ![](https://carpentries.org/assets/img/TheCarpentries.svg){alt='Carpentries logo'}
    ## 
    ## ![](no-workie.svg){alt='Non-working image'}
    ## 
    ## ![](no-workie.svg){alt='Non-working image with jekyll syntax'}
    ## 
    ## This text includes a [link that isn't parsed correctly by commonmark](index.md)
    ## . The rest of the text should be properly parsed.
    ## 
    ## 
    ## 
    ## :::::::::::::::::::::::::::::::::::::::: keypoints
    ## 
    ## - Use a `for` loop to process files given a list of their names.
    ## - Use `glob.glob` to find sets of files whose names match a pattern.
    ## - Use `glob` and `for` to process batches of files.
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::::

#### Transformation tip!

There are times where the lesson authors forget to tag a block quote
with the correct type of tag to make it a callout block. In this case,
the block quote will remain unconverted in the lesson. For example let’s
say there was a block quote at the very top of the lesson that defined
prerequisites, but the author accidentally had a new line between the
blockquote and the IAL tag, meaning that the blockquote was not
processed:

``` r

# add a prerequisite block after the questions and objectives
untranslated_block <- "
> ## Barnaby
>
> - a barn
> - a bee
>

{: .prereq}
"
ep$add_md(untranslated_block, where = 10)
ep$head(31)
## ---
## title: Looping Over Data Sets
## teaching: 5
## exercises: 10
## ---
## 
## ::::::::::::::::::::::::::::::::::::::: objectives
## 
## - Be able to read and write globbing expressions that match sets of files.
## - Use glob to create lists of files.
## - Write for loops to perform operations on files given their names in a list.
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::::
## 
## :::::::::::::::::::::::::::::::::::::::: questions
## 
## - How can I process many data sets with a single command?
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::::
## 
## > ## Barnaby
## > 
## > - a barn
## > - a bee
## 
## {: .prereq}
## 
## ## Use a `for` loop to process files given a list of their names.
## 
## - A filename is a character string.
## - And lists can contain character strings.
```

Notice that the block quote is picked up only as a blockquote, but not a
*special* block quote.

``` r

ep$get_blocks(".prereq")
## {xml_nodeset (0)}
ep$get_blocks()
## {xml_nodeset (1)}
## [1] <block_quote>\n  <heading level="2">\n    <text xml:space="preserve">Barn ...
```

If we set the `ktag` attribute of this block quote to “{: .prereq}”,
then it will be recognised as a special blockquote, which can be
translated.

``` r

# remove the orphan prereq tag:
orphan_tag <- xml2::xml_find_all(ep$body, 
  ".//md:paragraph[md:text[contains(text(),'.prereq}')]]", ns = ep$ns)
xml2::xml_remove(orphan_tag)
ep$head(31)
```

    ## ---
    ## title: Looping Over Data Sets
    ## teaching: 5
    ## exercises: 10
    ## ---
    ## 
    ## ::::::::::::::::::::::::::::::::::::::: objectives
    ## 
    ## - Be able to read and write globbing expressions that match sets of files.
    ## - Use glob to create lists of files.
    ## - Write for loops to perform operations on files given their names in a list.
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## :::::::::::::::::::::::::::::::::::::::: questions
    ## 
    ## - How can I process many data sets with a single command?
    ## 
    ## ::::::::::::::::::::::::::::::::::::::::::::::::::
    ## 
    ## > ## Barnaby
    ## > 
    ## > - a barn
    ## > - a bee
    ## 
    ## ## Use a `for` loop to process files given a list of their names.
    ## 
    ## - A filename is a character string.
    ## - And lists can contain character strings.
    ## 
    ## ```python

``` r


# set the attribute of the block quote:
xml2::xml_set_attr(ep$get_blocks(), "ktag", "{: .prereq}")
ep$head(31)
## ---
## title: Looping Over Data Sets
## teaching: 5
## exercises: 10
## ---
## 
## ::::::::::::::::::::::::::::::::::::::: objectives
## 
## - Be able to read and write globbing expressions that match sets of files.
## - Use glob to create lists of files.
## - Write for loops to perform operations on files given their names in a list.
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::::
## 
## :::::::::::::::::::::::::::::::::::::::: questions
## 
## - How can I process many data sets with a single command?
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::::
## 
## > ## Barnaby
## > 
## > - a barn
## > - a bee
## {: .prereq}
## 
## ## Use a `for` loop to process files given a list of their names.
## 
## - A filename is a character string.
## - And lists can contain character strings.
ep$get_blocks(".prereq")
## {xml_nodeset (1)}
## [1] <block_quote ktag="{: .prereq}">\n  <heading level="2">\n    <text xml:sp ...
```

Now we can convert the block to a fenced div with `$unblock()`

``` r

ep$unblock(force = TRUE)$head(31)
## ---
## title: Looping Over Data Sets
## teaching: 5
## exercises: 10
## ---
## 
## ::::::::::::::::::::::::::::::::::::::: objectives
## 
## - Be able to read and write globbing expressions that match sets of files.
## - Use glob to create lists of files.
## - Write for loops to perform operations on files given their names in a list.
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::::
## 
## :::::::::::::::::::::::::::::::::::::::: questions
## 
## - How can I process many data sets with a single command?
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::::
## 
## ::::::::::::::::::::::::::::::::::::::::::  prereq
## 
## ## Barnaby
## 
## - a barn
## - a bee
## 
## ::::::::::::::::::::::::::::::::::::::::::::::::::
## 
## ## Use a `for` loop to process files given a list of their names.
```
