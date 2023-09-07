
# {pegboard}: Parse Source Files in The Carpentries Workbench <img src='man/figures/logo.png' align='right' alt='' width=120 />

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![pegboard status
badge](https://carpentries.r-universe.dev/badges/pegboard)](https://carpentries.r-universe.dev)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pegboard)](https://CRAN.R-project.org/package=pegboard)
[![Codecov test
coverage](https://codecov.io/gh/carpentries/pegboard/branch/main/graph/badge.svg)](https://codecov.io/gh/carpentries/pegboard?branch=main)
[![R build
status](https://github.com/carpentries/pegboard/workflows/R-CMD-check/badge.svg)](https://github.com/carpentries/pegboard/actions)
[![R-CMD-check](https://github.com/carpentries/pegboard/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/carpentries/pegboard/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

> \[pegboard\] is tempered hardboard which is pre-drilled with evenly
> spaced holes. The holes are used to accept pegs or hooks to support
> various items, such as tools in a workshop.
>
> <https://en.wikipedia.org/wiki/Pegboard>

The {pegboard} package is part of [The Carpentries
Workbench](https://carpentries.github.io/workbench/) and it’s main
functionality is to parse Markdown and R Markdown documents into XML
representations (via [{tinkr}](https://docs.ropensci.org/tinkr/)). By
using XML, we are able to easily arrange and parse the elements of the
lessons which makes two things possible:

- parse and validate the lessons for structural markdown elements
- translate markdown syntax of Carpentries-style materials from the
  [styles lesson infrastructure
  (Jekyll-based)](https://github.com/carpentries/styles) to The
  Workbench (Pandoc-based) (see the [lesson transition
  tool](https://github.com/carpentries/lesson-transition#readme) for
  details)

There are two [{R6}](https://cran.r-project.org/package=R6) objects in
the package:

- Episode: stores the xml content of a single Markdown or R Markdown
  file. This extends the the [`tinkr::yarn`
  class](https://docs.ropensci.org/tinkr/reference/yarn.html).
- Lesson: stores all publishable markdown content as `Episodes` within a
  lesson

One simple usage is getting a summary of the content of an episode.
Let’s investigate the contents of [the “Episode Structure”
episode](https://carpentries.github.io/sandpaper-docs/episodes.html) of
the Workbench documentation:

``` r
library("pegboard")
library("withr")
# Download the file we need ------------------------------------
src <- "https://raw.githubusercontent.com/carpentries/sandpaper-docs/main/episodes/episodes.Rmd"
tmp <- local_tempfile(fileext = ".Rmd")
download.file(src, tmp)

# Load episode
ep <- Episode$new(tmp)
# Summary -------------------------------------------------------------
# confirm that we are using sandpaper and get a summary of the contents
ep$confirm_sandpaper()$summary()
#|   sections   headings   callouts challenges  solutions       code     output    warning      error     images      links 
#|         16         33         29          7          7         35          1          0          0          4         21

# Validation ----------------------------------------------------------
# NOTE: a lot of invalid links because files do not exist outside of
#       the lesson context
lnk <- ep$validate_links()
#| ! There were errors in 12/23 links
#| ◌ Some linked internal files do not exist
#| 
#| file9c2d53b7cd66.Rmd:38 [missing file]: [next episode](editing.md)
#| file9c2d53b7cd66.Rmd:51 [missing file]: [the Introduction](introduction.md)
#| file9c2d53b7cd66.Rmd:203 [missing file]: [The Workbench Component Guide](component-guide.md)
#| file9c2d53b7cd66.Rmd:780 [missing file]: [the setup page](../learners/setup.md)
#| file9c2d53b7cd66.Rmd:796 [missing file]: [another episode (e.g. introduction)](introduction.md)
#| file9c2d53b7cd66.Rmd:797 [missing file]: [the home page](../index.md)
#| file9c2d53b7cd66.Rmd:798 [missing file]: [the setup page](../learners/setup.md)
#| file9c2d53b7cd66.Rmd:799 [missing file]: [the "line length" section in the style guide](../learners/style.md#line-length)
#| file9c2d53b7cd66.Rmd:805 [missing file]: [the style guide](../learners/style.md)
#| file9c2d53b7cd66.Rmd:825 [missing file]: [internal links](../episodes/episodes.Rmd#internal-links)
#| file9c2d53b7cd66.Rmd:860 [missing file]: [Hex sticker for The Carpentries](fig/carpentries-hex-blue.svg)
#| file9c2d53b7cd66.Rmd:902 [missing file]: [Example of Wrapped Alt Text (with apologies to William Carlos Williams)](fig/freezer.png)
str(lnk, max.level = 1)
#| 'data.frame':    25 obs. of  26 variables:
#|  $ scheme              : chr  "" "" "" "" ...
#|  $ server              : chr  "" "" "" "" ...
#|  $ port                : int  NA NA NA NA NA NA NA NA NA NA ...
#|  $ user                : chr  "" "" "" "" ...
#|  $ path                : chr  "editing.md" "introduction.md" "" "component-guide.md" ...
#|  $ query               : chr  "" "" "" "" ...
#|  $ fragment            : chr  "" "" "callout-blocks" "" ...
#|  $ orig                : chr  "editing.md" "introduction.md" "#callout-blocks" "component-guide.md" ...
#|  $ text                : chr  "next episode" "the Introduction" "the next section" "The Workbench Component Guide" ...
#|  $ alt                 : chr  NA NA NA NA ...
#|  $ title               : chr  "" "" "" "" ...
#|  $ type                : chr  "link" "link" "link" "link" ...
#|  $ rel                 : chr  NA NA NA NA ...
#|  $ anchor              : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#|  $ sourcepos           : int  38 51 168 203 318 327 468 545 550 630 ...
#|  $ filepath            : chr  "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" ...
#|  $ node                :List of 25
#|   ..- attr(*, "class")= chr "AsIs"
#|  $ known_protocol      : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ enforce_https       : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ internal_anchor     : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ internal_file       : logi  FALSE FALSE TRUE FALSE TRUE TRUE ...
#|  $ internal_well_formed: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ all_reachable       : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ img_alt_text        : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ descriptive         : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ link_length         : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
hdg <- ep$validate_headings()
str(hdg, max.level = 1)
#| 'data.frame':    33 obs. of  10 variables:
#|  $ heading                      : chr  "Introduction" "Buoyant Barnacle" "Creating A New Episode" "What is the .Rmd extension?" ...
#|  $ level                        : int  2 3 2 3 2 3 3 3 2 3 ...
#|  $ pos                          : int  29 48 63 80 117 126 143 156 196 200 ...
#|  $ node                         :List of 33
#|   ..- attr(*, "class")= chr "AsIs"
#|  $ first_heading_is_second_level: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ greater_than_first_level     : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ are_sequential               : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ have_names                   : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ are_unique                   : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ path                         : chr  "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" ...
div <- ep$validate_divs()
#| ! There were errors in 1/29 fenced divs
#| ◌ The Carpentries Workbench knows the following div types callout, objectives, questions, challenge, prereq, checklist, solution, hint, discussion, testimonial, keypoints, instructor, spoiler
#| 
#| file9c2d53b7cd66.Rmd:457 [unknown div] empty-div
str(div, max.level = 1)
#| 'data.frame':    29 obs. of  5 variables:
#|  $ path    : chr  "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" "file9c2d53b7cd66.Rmd" ...
#|  $ div     : chr  "questions" "objectives" "prereq" "callout" ...
#|  $ pb_label: chr  "div-1-questions" "div-2-objectives" "div-3-prereq" "div-4-callout" ...
#|  $ pos     : int  9 20 46 78 141 198 226 243 253 272 ...
#|  $ is_known: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
```

## Installation

{pegboard} is not currently on CRAN, but it can be installed from our
[Carpentries Universe](https://carpentries.r-universe.dev/ui#builds)
(updated every hour) with the following commands:

``` r
options(repos = c(
  carpentries = "https://carpentries.r-universe.dev/", 
  CRAN = "https://cran.rstudio.com/"
))
install.packages("pegboard")
```

## Example

To use {pegboard} in the context of The Workbench, you will need to have
a lesson handy. If you don’t have one, you can use the `get_lesson()`
function, which will use [{gert}](https://r-lib.github.io/gert/) to
clone a lesson repository to your computer.

(NOTE: this file was last run on 2023-09-06 08:45:54.227933)

``` r
library("pegboard")
library("purrr")
library("xml2")
library("fs")

d <- fs::file_temp(pattern = "PBREADME")
rng <- get_lesson("swcarpentry/r-novice-gapminder", path = d, jekyll = FALSE)
rng
#| <Lesson>
#|   Public:
#|     blocks: function (type = NULL, level = 0, path = FALSE) 
#|     built: NULL
#|     challenges: function (path = FALSE, graph = FALSE, recurse = TRUE) 
#|     clone: function (deep = FALSE) 
#|     episodes: list
#|     extra: list
#|     files: active binding
#|     get: function (element = NULL, collection = "episodes") 
#|     handout: function (path = NULL, solution = FALSE) 
#|     initialize: function (path = ".", rmd = FALSE, jekyll = TRUE, ...) 
#|     isolate_blocks: function () 
#|     load_built: function () 
#|     n_problems: active binding
#|     overview: FALSE
#|     path: /tmp/RtmpBNM7Jl/PBREADME9c2d5fd860a1/swcarpentry--r-novi ...
#|     reset: function () 
#|     rmd: FALSE
#|     sandpaper: TRUE
#|     show_problems: active binding
#|     solutions: function (path = FALSE) 
#|     summary: function (collection = "episodes") 
#|     thin: function (verbose = TRUE) 
#|     validate_divs: function () 
#|     validate_headings: function (verbose = TRUE) 
#|     validate_links: function () 
#|   Private:
#|     deep_clone: function (name, value)

# Get a summary of all the elements in each episode
rng$summary()
#| # A tibble: 16 × 12
#|    page                         sections headings callouts challenges solutions  code output warning error images links
#|    <chr>                           <int>    <int>    <int>      <int>     <int> <int>  <int>   <int> <int>  <int> <int>
#|  1 01-rstudio-intro.Rmd               28       28       19          5         5    47      1       0     0      2     6
#|  2 02-project-intro.Rmd               12       19       12          5         1     4      0       0     0      1     3
#|  3 03-seeking-help.Rmd                15       15       11          3         3    12      0       0     0      0     7
#|  4 04-data-structures-part1.Rmd        2       50       31          9        15    77      0       0     0      0     1
#|  5 05-data-structures-part2.Rmd       15       15       12          4         4    33      0       0     0      0     3
#|  6 06-data-subsetting.Rmd             33       34       26          8         8    76      0       0     0      2     0
#|  7 07-control-flow.Rmd                15       15       17          5         5    36      0       0     0      0     0
#|  8 08-plot-ggplot2.Rmd                20       20       18          6         6    23      0       0     0      0    12
#|  9 09-vectorization.Rmd               11       11       14          4         4    24      0       0     0      0     1
#| 10 10-functions.Rmd                   20       21       19          5         5    28      0       0     0      0    12
#| 11 11-writing-data.Rmd                 6        6        7          2         2    11      0       0     0      0     0
#| 12 12-plyr.Rmd                         8        8       10          3         3    17      0       0     0      2     1
#| 13 13-dplyr.Rmd                       18       18       11          3         3    30      0       0     0      3     6
#| 14 14-tidyr.Rmd                       10       10        9          3         3    16      0       0     0      4     5
#| 15 15-knitr-markdown.Rmd              22       22       13          4         4     9      0       0     0      2    18
#| 16 16-wrap-up.Rmd                      9        9        4          0         0     1      0       0     0      0     1

# Validate lesson elements
rng$validate_links()
rng$validate_divs()
rng$validate_headings() # this is not run by default in sandpaper lessons
#| # Episode: "Data Structures" 
#| ├─### Tip: Editing Text files in R  (must be level 2)
#| ├─### Check your data for factors 
#| ├─### Data Types 
#| ├─### Vectors and Type Coercion 
#| ├─### Discussion 1 
#| ├─### Discussion 1 
#| ├─### Challenge 1 
#| │ └─#### Copy the code template 
#| ├─### Instructions for the tasks 
#| │ └─#### 1. Print the data 
#| ├─### Tip 1.1 
#| ├─### Solution to Challenge 1.1 
#| │ └─#### 2. Overview of the data types 
#| ├─### Tip 1.2 
#| ├─### Solution to Challenge 1.2 
#| │ └─#### 3. Which data type do we need? 
#| ├─### Tip 1.3 
#| ├─### Solution to Challenge 1.3 
#| │ └─#### 4. Correct the problematic value 
#| ├─### Tip 1.4 
#| ├─### Solution to challenge 1.4 
#| │ └─#### 5. Convert the column "weight" to the correct data type 
#| ├─### Tip 1.5 
#| ├─### Solution to Challenge 1.5 
#| ├─### Some basic vector functions 
#| ├─### Challenge 2 
#| ├─### Solution to Challenge 2 
#| ├─### Lists 
#| ├─## Names 
#| │ ├─### Accessing vectors and lists by name 
#| │ ├─### Accessing and changing names 
#| │ ├─### Challenge 3 
#| │ ├─### Solution to Challenge 3 
#| │ ├─### Challenge 4 
#| │ └─### Solution to Challenge 4 
#| └─## Data frames 
#|   ├─### Challenge 5 
#|   ├─### Solution to Challenge 5 
#|   ├─### Tip: Renaming data frame columns 
#|   ├─### Matrices 
#|   ├─### Challenge 6 
#|   ├─### Solution to Challenge 6 
#|   ├─### Challenge 7 
#|   ├─### Solution to Challenge 7 
#|   ├─### Challenge 8 
#|   ├─### Solution to Challenge 8 
#|   ├─### Challenge 9 
#|   └─### Solution to Challenge 9 
#| # Episode: "Vectorization" 
#| ├─## Challenge 1 
#| ├─## Solution to challenge 1 
#| ├─## Challenge 2 
#| ├─## Solution to challenge 2 
#| ├─## Tip: some useful functions for logical vectors 
#| ├─## Tip: element-wise vs. matrix multiplication 
#| ├─## Challenge 3 
#| ├─## Solution to challenge 3 
#| ├─## Challenge 4  (duplicated)
#| ├─## Challenge 4  (duplicated)
#| └─## Tip: Operations on vectors of unequal length 
#| # Episode: "Functions Explained" 
#| ├─## What is a function? 
#| ├─## Defining a function 
#| ├─## Tip  (duplicated)
#| ├─## Challenge 1 
#| ├─## Solution to challenge 1 
#| ├─## Combining functions 
#| ├─## Challenge 2 
#| ├─## Solution to challenge 2 
#| ├─## Interlude: Defensive Programming 
#| │ └─### Checking conditions with stopifnot() 
#| ├─## Challenge 3 
#| ├─## Solution to challenge 3 
#| ├─## More on combining functions 
#| ├─## Tip: Pass by value 
#| ├─## Tip: Function scope 
#| ├─## Challenge 4 
#| ├─## Solution to challenge 4 
#| ├─## Challenge 5 
#| ├─## Solution to challenge 5 
#| ├─## Tip  (duplicated)
#| └─## Tip: Testing and documenting
```

### Manipulation

The XML contents of the lesson are contained within the `$body` element
of the Episode object and anything you do to that XML document is
retained within the object itself (see the [{tinkr}
documentation](https://docs.ropensci.org/tinkr) for more details):

``` r
ep1 <- rng$episodes[[1]]
ep1$body
#| {xml_document}
#| <document sourcepos="1:1-712:0" xmlns="http://commonmark.org/xml/1.0">
#|  [1] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-objectives"/>
#|  [2] <paragraph sourcepos="2:1-2:50">\n  <text sourcepos="2:1-2:50" xml:space="preserve">::::::::::::::::::::::::::::::::::::::: objectives</text>\n</paragraph>
#|  [3] <list sourcepos="4:1-12:0" type="bullet" tight="true">\n  <item sourcepos="4:1-4:62">\n    <paragraph sourcepos="4:3-4:62">\n      <text sourcepos="4:3-4:62" xml:space="preserve">Describe the purpose and use of each pane in the RStudio IDE</text>\n    </paragraph>\n  </item>\n  <item sourcep ...
#|  [4] <paragraph sourcepos="13:1-13:50">\n  <text sourcepos="13:1-13:50" xml:space="preserve">::::::::::::::::::::::::::::::::::::::::::::::::::</text>\n</paragraph>
#|  [5] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-objectives"/>
#|  [6] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-questions"/>
#|  [7] <paragraph sourcepos="15:1-15:50">\n  <text sourcepos="15:1-15:50" xml:space="preserve">:::::::::::::::::::::::::::::::::::::::: questions</text>\n</paragraph>
#|  [8] <list sourcepos="17:1-21:0" type="bullet" tight="true">\n  <item sourcepos="17:1-17:38">\n    <paragraph sourcepos="17:3-17:38">\n      <text sourcepos="17:3-17:38" xml:space="preserve">How to find your way around RStudio?</text>\n    </paragraph>\n  </item>\n  <item sourcepos="18:1-18:25">\ ...
#|  [9] <paragraph sourcepos="22:1-22:50">\n  <text sourcepos="22:1-22:50" xml:space="preserve">::::::::::::::::::::::::::::::::::::::::::::::::::</text>\n</paragraph>
#| [10] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-questions"/>
#| [11] <code_block sourcepos="24:1-25:3" xml:space="preserve" language="r" name="" include="FALSE"/>
#| [12] <heading sourcepos="27:1-27:13" level="2">\n  <text sourcepos="27:4-27:13" xml:space="preserve">Motivation</text>\n</heading>
#| [13] <paragraph sourcepos="29:1-37:45">\n  <text sourcepos="29:1-29:81" xml:space="preserve">Science is a multi-step process: once you've designed an experiment and collected</text>\n  <softbreak/>\n  <text sourcepos="30:1-30:85" xml:space="preserve">data, the real fun begins! This lesson will te ...
#| [14] <heading sourcepos="39:1-39:31" level="2">\n  <text sourcepos="39:4-39:31" xml:space="preserve">Before Starting The Workshop</text>\n</heading>
#| [15] <paragraph sourcepos="41:1-41:204">\n  <text sourcepos="41:1-41:204" xml:space="preserve">Please ensure you have the latest version of R and RStudio installed on your machine. This is important, as some packages used in the workshop may not install correctly (or at all) if R is not up to dat ...
#| [16] <list sourcepos="43:1-45:0" type="bullet" tight="true">\n  <item sourcepos="43:1-43:81">\n    <paragraph sourcepos="43:3-43:81">\n      <link sourcepos="43:3-43:81" destination="https://www.r-project.org/" title="">\n        <text sourcepos="43:4-43:52" xml:space="preserve">Download and inst ...
#| [17] <heading sourcepos="46:1-46:26" level="2">\n  <text sourcepos="46:4-46:26" xml:space="preserve">Introduction to RStudio</text>\n</heading>
#| [18] <paragraph sourcepos="48:1-48:60">\n  <text sourcepos="48:1-48:60" xml:space="preserve">Welcome to the R portion of the Software Carpentry workshop.</text>\n</paragraph>
#| [19] <paragraph sourcepos="50:1-52:52">\n  <text sourcepos="50:1-50:76" xml:space="preserve">Throughout this lesson, we're going to teach you some of the fundamentals of</text>\n  <softbreak/>\n  <text sourcepos="51:1-51:69" xml:space="preserve">the R language as well as some best practices for o ...
#| [20] <paragraph sourcepos="54:1-57:31">\n  <text sourcepos="54:1-54:68" xml:space="preserve">We'll be using RStudio: a free, open-source R Integrated Development</text>\n  <softbreak/>\n  <text sourcepos="55:1-55:83" xml:space="preserve">Environment (IDE). It provides a built-in editor, works on  ...
#| ...
ep1$head(20) # show the first 20 lines of the file
#| ---
#| title: Introduction to R and RStudio
#| teaching: 45
#| exercises: 10
#| source: Rmd
#| ---
#| 
#| ::::::::::::::::::::::::::::::::::::::: objectives
#| 
#| - Describe the purpose and use of each pane in the RStudio IDE
#| - Locate buttons and options in the RStudio IDE
#| - Define a variable
#| - Assign data to a variable
#| - Manage a workspace in an interactive R session
#| - Use mathematical and comparison operators
#| - Call functions
#| - Manage packages
#| 
#| ::::::::::::::::::::::::::::::::::::::::::::::::::
new_content <- r"{

#### NEW CONTENT

Hello! This is **new markdown content** generated via the 
[{pegboard}](https://carpentries.github.io/pegboard) package that will 
appear above the objectives block!

}"
ep1$add_md(new_content, where = 0L) 
ep1$head(20) # the new content has been added to the top
#| ---
#| title: Introduction to R and RStudio
#| teaching: 45
#| exercises: 10
#| source: Rmd
#| ---
#| 
#| #### NEW CONTENT
#| 
#| Hello! This is **new markdown content** generated via the
#| [{pegboard}](https://carpentries.github.io/pegboard) package that will
#| appear above the objectives block!
#| 
#| ::::::::::::::::::::::::::::::::::::::: objectives
#| 
#| - Describe the purpose and use of each pane in the RStudio IDE
#| - Locate buttons and options in the RStudio IDE
#| - Define a variable
#| - Assign data to a variable
#| - Manage a workspace in an interactive R session
ep1$headings[[1]] # the first heading is level 4. Let's change that using {xml2}
#| {xml_node}
#| <heading level="4">
#| [1] <text xml:space="preserve">NEW CONTENT</text>
xml2::xml_set_attr(ep1$headings[[1]], "level", "2")
ep1$head(20)
#| ---
#| title: Introduction to R and RStudio
#| teaching: 45
#| exercises: 10
#| source: Rmd
#| ---
#| 
#| ## NEW CONTENT
#| 
#| Hello! This is **new markdown content** generated via the
#| [{pegboard}](https://carpentries.github.io/pegboard) package that will
#| appear above the objectives block!
#| 
#| ::::::::::::::::::::::::::::::::::::::: objectives
#| 
#| - Describe the purpose and use of each pane in the RStudio IDE
#| - Locate buttons and options in the RStudio IDE
#| - Define a variable
#| - Assign data to a variable
#| - Manage a workspace in an interactive R session
ep1$headings[[1]] # the first heading is now level 2
#| {xml_node}
#| <heading level="2">
#| [1] <text xml:space="preserve">NEW CONTENT</text>
# write the file
ep1$write(fs::path_dir(ep1$path), format = "Rmd")
readLines(ep1$path, 20)
#|  [1] "---"                                                                    "title: Introduction to R and RStudio"                                   "teaching: 45"                                                           "exercises: 10"                                                         
#|  [5] "source: Rmd"                                                            "---"                                                                    ""                                                                       "## NEW CONTENT"                                                        
#|  [9] ""                                                                       "Hello! This is **new markdown content** generated via the"              "[{pegboard}](https://carpentries.github.io/pegboard) package that will" "appear above the objectives block!"                                    
#| [13] ""                                                                       "::::::::::::::::::::::::::::::::::::::: objectives"                     ""                                                                       "- Describe the purpose and use of each pane in the RStudio IDE"        
#| [17] "- Locate buttons and options in the RStudio IDE"                        "- Define a variable"                                                    "- Assign data to a variable"                                            "- Manage a workspace in an interactive R session"
```
