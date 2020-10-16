
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pegboard

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pegboard)](https://CRAN.R-project.org/package=pegboard)
[![Travis build
status](https://travis-ci.com/carpentries/pegboard.svg?branch=main)](https://travis-ci.com/carpentries/pegboard)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/carpentries/pegboard?branch=main&svg=true)](https://ci.appveyor.com/project/carpentries/pegboard)
[![Codecov test
coverage](https://codecov.io/gh/carpentries/pegboard/branch/main/graph/badge.svg)](https://codecov.io/gh/carpentries/pegboard?branch=main)
[![R build
status](https://github.com/carpentries/pegboard/workflows/R-CMD-check/badge.svg)](https://github.com/carpentries/pegboard/actions)
<!-- badges: end -->

> [pegboard](#pegboard) is tempered hardboard which is pre-drilled with
> evenly spaced holes. The holes are used to accept pegs or hooks to
> support various items, such as tools in a workshop.
> 
> <https://en.wikipedia.org/wiki/Pegboard>

The {pegboard} package is a way to explore the Carpentries’ lessons via
their XML representation. This package makes heavy use of rOpenSci’s
[{tinkr}](https://docs.ropensci.org/tinkr/) and
[{xml2}](https://cran.r-project.org/package=xml2).

There are two [{R6}](https://cran.r-project.org/package=R6) objects in
the package:

  - Episode: stores the xml content of a single episode
  - Lesson: stores all Episodes within a lesson

## Installation

This package is currently in development, but you can install it via
{remotes}:

``` r
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
remotes::install_github("carpentries/pegboard")
```

## Example

The first way to get started is to use the `get_lesson()` function,
which will use [{git2r}](https://cran.r-project.org/package=git2r) to
clone a lesson repository to your computer.

``` r
library(pegboard)
library(purrr)
library(xml2)
library(fs)

d <- fs::file_temp(pattern = "PBREADME")
rng <- get_lesson("swcarpentry/r-novice-gapminder", path = d)
#| cloning into '/tmp/RtmpvTL3ng/PBREADME2b1e4c0ba5a1/swcarpentry--r-novice-gapminder'...
#| Receiving objects:   1% (94/9360),   51 kb
#| Receiving objects:  11% (1030/9360),  427 kb
#| Receiving objects:  21% (1966/9360),  650 kb
#| Receiving objects:  31% (2902/9360), 8967 kb
#| Receiving objects:  41% (3838/9360), 14198 kb
#| Receiving objects:  51% (4774/9360), 21317 kb
#| Receiving objects:  61% (5710/9360), 26613 kb
#| Receiving objects:  71% (6646/9360), 30116 kb
#| Receiving objects:  81% (7582/9360), 32564 kb
#| Receiving objects:  91% (8518/9360), 36467 kb
#| Receiving objects: 100% (9360/9360), 44724 kb, done.
rng
#| <Lesson>
#|   Public:
#|     blocks: function (type = NULL, level = 0, path = FALSE) 
#|     challenges: function (path = FALSE, graph = FALSE, recurse = TRUE) 
#|     clone: function (deep = FALSE) 
#|     episodes: list
#|     files: active binding
#|     initialize: function (path = NULL, rmd = FALSE, ...) 
#|     isolate_blocks: function () 
#|     n_problems: active binding
#|     path: /tmp/RtmpvTL3ng/PBREADME2b1e4c0ba5a1/swcarpentry--r-novi ...
#|     reset: function () 
#|     rmd: TRUE
#|     show_problems: active binding
#|     solutions: function (path = FALSE) 
#|     thin: function (verbose = TRUE) 
#|   Private:
#|     deep_clone: function (name, value)

# Find all challenges
head(rng$challenges())
#| $`01-rstudio-intro.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="350:1-386:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [2] <block_quote sourcepos="504:1-540:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [3] <block_quote sourcepos="543:1-556:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [4] <block_quote sourcepos="559:1-571:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [5] <block_quote sourcepos="573:1-591:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| 
#| $`02-project-intro.Rmd`
#| {xml_nodeset (4)}
#| [1] <block_quote sourcepos="47:1-57:14" ktag="{: .challenge}">\n  <heading sourcepos="4 ...
#| [2] <block_quote sourcepos="68:1-74:14" ktag="{: .challenge}">\n  <heading sourcepos="6 ...
#| [3] <block_quote sourcepos="148:1-156:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [4] <block_quote sourcepos="158:1-182:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| 
#| $`03-seeking-help.Rmd`
#| {xml_nodeset (3)}
#| [1] <block_quote sourcepos="105:1-121:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [2] <block_quote sourcepos="123:1-153:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [3] <block_quote sourcepos="155:1-172:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| 
#| $`04-data-structures-part1.Rmd`
#| {xml_nodeset (7)}
#| [1] <block_quote sourcepos="329:1-343:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [2] <block_quote sourcepos="393:1-421:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [3] <block_quote sourcepos="482:1-541:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [4] <block_quote sourcepos="563:1-583:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [5] <block_quote sourcepos="586:1-609:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [6] <block_quote sourcepos="612:1-632:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [7] <block_quote sourcepos="635:1-663:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| 
#| $`05-data-structures-part2.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="100:1-111:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [2] <block_quote sourcepos="183:1-211:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [3] <block_quote sourcepos="315:1-339:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [4] <block_quote sourcepos="345:1-374:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [5] <block_quote sourcepos="376:1-392:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| 
#| $`06-data-subsetting.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="143:1-174:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [2] <block_quote sourcepos="245:1-264:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [3] <block_quote sourcepos="345:1-387:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [4] <block_quote sourcepos="497:1-520:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [5] <block_quote sourcepos="581:1-603:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [6] <block_quote sourcepos="606:1-624:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [7] <block_quote sourcepos="667:1-745:14" ktag="{: .challenge}">\n  <heading sourcepos= ...
#| [8] <block_quote sourcepos="747:1-765:14" ktag="{: .challenge}">\n  <heading sourcepos= ...

# Find all solutions
head(rng$solutions())
#| $`01-rstudio-intro.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="364:3-384:7" ktag="{: .solution}">\n  <heading sourcepos="3 ...
#| [2] <block_quote sourcepos="516:3-540:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [3] <block_quote sourcepos="548:3-556:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [4] <block_quote sourcepos="564:3-569:7" ktag="{: .solution}">\n  <heading sourcepos="5 ...
#| [5] <block_quote sourcepos="577:3-589:6" ktag="{: .solution}">\n  <heading sourcepos="5 ...
#| 
#| $`02-project-intro.Rmd`
#| {xml_nodeset (1)}
#| [1] <block_quote sourcepos="167:3-180:7" ktag="{: .solution}">\n  <heading sourcepos="1 ...
#| 
#| $`03-seeking-help.Rmd`
#| {xml_nodeset (3)}
#| [1] <block_quote sourcepos="114:3-121:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [2] <block_quote sourcepos="128:3-153:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [3] <block_quote sourcepos="163:3-172:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| 
#| $`04-data-structures-part1.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="222:3-231:15" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [2] <block_quote sourcepos="335:3-341:7" ktag="{: .solution}">\n  <heading sourcepos="3 ...
#| [3] <block_quote sourcepos="400:3-421:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [4] <block_quote sourcepos="499:3-541:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [5] <block_quote sourcepos="570:3-583:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [6] <block_quote sourcepos="595:3-607:7" ktag="{: .solution}">\n  <heading sourcepos="5 ...
#| [7] <block_quote sourcepos="621:3-630:3" ktag="{: .solution}">\n  <heading sourcepos="6 ...
#| [8] <block_quote sourcepos="650:3-661:7" ktag="{: .solution}">\n  <heading sourcepos="6 ...
#| 
#| $`05-data-structures-part2.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="106:3-111:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [2] <block_quote sourcepos="201:3-209:7" ktag="{: .solution}">\n  <heading sourcepos="2 ...
#| [3] <block_quote sourcepos="321:3-339:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [4] <block_quote sourcepos="354:3-372:7" ktag="{: .solution}">\n  <heading sourcepos="3 ...
#| [5] <block_quote sourcepos="384:3-390:3" ktag="{: .solution}">\n  <heading sourcepos="3 ...
#| 
#| $`06-data-subsetting.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="161:3-172:3" ktag="{: .solution}">\n  <heading sourcepos="1 ...
#| [2] <block_quote sourcepos="257:3-262:6" ktag="{: .solution}">\n  <heading sourcepos="2 ...
#| [3] <block_quote sourcepos="370:3-387:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [4] <block_quote sourcepos="516:3-520:14" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [5] <block_quote sourcepos="591:3-601:7" ktag="{: .solution}">\n  <heading sourcepos="5 ...
#| [6] <block_quote sourcepos="615:3-622:7" ktag="{: .solution}">\n  <heading sourcepos="6 ...
#| [7] <block_quote sourcepos="703:3-743:11" ktag="{: .solution}">\n  <heading sourcepos=" ...
#| [8] <block_quote sourcepos="755:3-763:7" ktag="{: .solution}">\n  <heading sourcepos="7 ...

# Find all discussion blocks
head(rng$blocks(".discussion"))
#| $`01-rstudio-intro.Rmd`
#| {xml_nodeset (0)}
#| 
#| $`02-project-intro.Rmd`
#| {xml_nodeset (0)}
#| 
#| $`03-seeking-help.Rmd`
#| {xml_nodeset (0)}
#| 
#| $`04-data-structures-part1.Rmd`
#| {xml_nodeset (1)}
#| [1] <block_quote sourcepos="217:1-231:15" ktag="{: .discussion}">\n  <heading sourcepos ...
#| 
#| $`05-data-structures-part2.Rmd`
#| {xml_nodeset (0)}
#| 
#| $`06-data-subsetting.Rmd`
#| {xml_nodeset (0)}
```

## Manipulation

At the moment, you can manipulate each episode in various ways. One of
the ways that will become useful in the future is translating the
episode from using the old and busted Jekyll syntax (e.g. using nested
block quotes to create specialized sections and writing
questions/keypoints/objectives in the YAML) to using a more intuitive
system (currently being evaluated). For example, let’s say we wanted to
transform an episode from Jekyll to using
[{sandpaper}](https://github.com/zkamvar/sandpaper#readme). This would
involve the following steps:

1.  transforming the block quotes to native or fenced div tags (or
    dovetail blocks)
2.  converting code block decorators (`{: .language-r}`) and modify
    setup chunk
3.  moving questions, objectives, and keypoints to the body of the
    document

Doing this by hand would be a nightmare, but we’ve written {pegboard} in
such a way that will streamline this process

First, let’s inspect how the file looks at the moment:

```` r
fun <- rng$episodes$`10-functions.Rmd`
fun$write(d, format = "Rmd")
cat(readLines(fs::path(d, fun$name), n = 60), sep = "\n")
#| ---
#| title: Functions Explained
#| teaching: 45
#| exercises: 15
#| questions:
#| - "How can I write a new function in R?"
#| objectives:
#| - "Define a function that takes arguments."
#| - "Return a value from a function."
#| - "Check argument conditions with `stopifnot()` in functions."
#| - "Test a function."
#| - "Set default values for function arguments."
#| - "Explain why we should divide programs into small, single-purpose functions."
#| keypoints:
#| - "Use `function` to define a new function in R."
#| - "Use parameters to pass values into functions."
#| - "Use `stopifnot()` to flexibly check function arguments in R."
#| - "Load functions into programs using `source()`."
#| source: Rmd
#| ---
#| 
#| ```{r, include=FALSE}
#| source("../bin/chunk-options.R")
#| knitr_fig_path("10-")
#| # Silently load in the data so the rest of the lesson works
#| gapminder <- read.csv("data/gapminder_data.csv", header=TRUE)
#| ```
#| 
#| If we only had one data set to analyze, it would probably be faster to load the
#| file into a spreadsheet and use that to plot simple statistics. However, the
#| gapminder data is updated periodically, and we may want to pull in that new
#| information later and re-run our analysis again. We may also obtain similar data
#| from a different source in the future.
#| 
#| In this lesson, we'll learn how to write a function so that we can repeat
#| several operations with a single command.
#| 
#| > ## What is a function?
#| > 
#| > Functions gather a sequence of operations into a whole, preserving it for
#| > ongoing use. Functions provide:
#| > 
#| > - a name we can remember and invoke it by
#| > - relief from the need to remember the individual operations
#| > - a defined set of inputs and expected outputs
#| > - rich connections to the larger programming environment
#| > 
#| > As the basic building block of most programming languages, user-defined
#| > functions constitute "programming" as much as any single abstraction can. If
#| > you have written a function, you are a computer programmer.
#| > 
#| {: .callout}
#| 
#| ## Defining a function
#| 
#| Let's open a new R script file in the `functions/` directory and call it
#| functions-lesson.R.
#| 
#| Let's define a function `fahr_to_kelvin()` that converts temperatures from
#| Fahrenheit to Kelvin:
````

Now, we can apply the transformation chain in the order we specifed:

```` r
fun$
  unblock()$         # transform block quotes
  use_sandpaper()$   # convert code block decorators and modify setup chunk
  move_questions()$  # ...
  move_objectives()$
  move_keypoints()$
  write(d, format = "Rmd")
cat(readLines(fs::path(d, fun$name), n = 70), sep = "\n")
#| ---
#| title: Functions Explained
#| teaching: 45
#| exercises: 15
#| source: Rmd
#| ---
#| 
#| ```{r, include=FALSE}
#| gapminder <- read.csv("data/gapminder_data.csv", header = TRUE)
#| ```
#| 
#| ::::::::::::::::::::::::::::::::::::::: objectives
#| 
#| ## Objectives
#| 
#| - Define a function that takes arguments.
#| - Return a value from a function.
#| - Check argument conditions with `stopifnot()` in functions.
#| - Test a function.
#| - Set default values for function arguments.
#| - Explain why we should divide programs into small, single-purpose functions.
#| 
#| ::::::::::::::::::::::::::::::::::::::::::::::::::
#| 
#| :::::::::::::::::::::::::::::::::::::::: questions
#| 
#| ## Questions
#| 
#| - How can I write a new function in R?
#| 
#| ::::::::::::::::::::::::::::::::::::::::::::::::::
#| 
#| If we only had one data set to analyze, it would probably be faster to load the
#| file into a spreadsheet and use that to plot simple statistics. However, the
#| gapminder data is updated periodically, and we may want to pull in that new
#| information later and re-run our analysis again. We may also obtain similar data
#| from a different source in the future.
#| 
#| In this lesson, we'll learn how to write a function so that we can repeat
#| several operations with a single command.
#| 
#| :::::::::::::::::::::::::::::::::::::::::  callout
#| 
#| ## What is a function?
#| 
#| Functions gather a sequence of operations into a whole, preserving it for
#| ongoing use. Functions provide:
#| 
#| - a name we can remember and invoke it by
#| - relief from the need to remember the individual operations
#| - a defined set of inputs and expected outputs
#| - rich connections to the larger programming environment
#| 
#| As the basic building block of most programming languages, user-defined
#| functions constitute "programming" as much as any single abstraction can. If
#| you have written a function, you are a computer programmer.
#| 
#| 
#| ::::::::::::::::::::::::::::::::::::::::::::::::::
#| 
#| ## Defining a function
#| 
#| Let's open a new R script file in the `functions/` directory and call it
#| functions-lesson.R.
#| 
#| Let's define a function `fahr_to_kelvin()` that converts temperatures from
#| Fahrenheit to Kelvin:
#| 
#| ```{r}
#| fahr_to_kelvin <- function(temp) {
````

## Reset

All changes can be reset to the initial state with the `$reset()`
method:

```` r
fun$reset()
cat(readLines(fs::path(d, fun$name), n = 70), sep = "\n")
#| ---
#| title: Functions Explained
#| teaching: 45
#| exercises: 15
#| source: Rmd
#| ---
#| 
#| ```{r, include=FALSE}
#| gapminder <- read.csv("data/gapminder_data.csv", header = TRUE)
#| ```
#| 
#| ::::::::::::::::::::::::::::::::::::::: objectives
#| 
#| ## Objectives
#| 
#| - Define a function that takes arguments.
#| - Return a value from a function.
#| - Check argument conditions with `stopifnot()` in functions.
#| - Test a function.
#| - Set default values for function arguments.
#| - Explain why we should divide programs into small, single-purpose functions.
#| 
#| ::::::::::::::::::::::::::::::::::::::::::::::::::
#| 
#| :::::::::::::::::::::::::::::::::::::::: questions
#| 
#| ## Questions
#| 
#| - How can I write a new function in R?
#| 
#| ::::::::::::::::::::::::::::::::::::::::::::::::::
#| 
#| If we only had one data set to analyze, it would probably be faster to load the
#| file into a spreadsheet and use that to plot simple statistics. However, the
#| gapminder data is updated periodically, and we may want to pull in that new
#| information later and re-run our analysis again. We may also obtain similar data
#| from a different source in the future.
#| 
#| In this lesson, we'll learn how to write a function so that we can repeat
#| several operations with a single command.
#| 
#| :::::::::::::::::::::::::::::::::::::::::  callout
#| 
#| ## What is a function?
#| 
#| Functions gather a sequence of operations into a whole, preserving it for
#| ongoing use. Functions provide:
#| 
#| - a name we can remember and invoke it by
#| - relief from the need to remember the individual operations
#| - a defined set of inputs and expected outputs
#| - rich connections to the larger programming environment
#| 
#| As the basic building block of most programming languages, user-defined
#| functions constitute "programming" as much as any single abstraction can. If
#| you have written a function, you are a computer programmer.
#| 
#| 
#| ::::::::::::::::::::::::::::::::::::::::::::::::::
#| 
#| ## Defining a function
#| 
#| Let's open a new R script file in the `functions/` directory and call it
#| functions-lesson.R.
#| 
#| Let's define a function `fahr_to_kelvin()` that converts temperatures from
#| Fahrenheit to Kelvin:
#| 
#| ```{r}
#| fahr_to_kelvin <- function(temp) {
````
