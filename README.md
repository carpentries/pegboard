
# {pegboard}: Parse Source Files in The Carpentries Workbench <img src='man/figures/logo.png' align='right' alt='' width=120 />

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pegboard)](https://CRAN.R-project.org/package=pegboard)
[![Codecov test
coverage](https://codecov.io/gh/carpentries/pegboard/branch/main/graph/badge.svg)](https://codecov.io/gh/carpentries/pegboard?branch=main)
[![R build
status](https://github.com/carpentries/pegboard/workflows/R-CMD-check/badge.svg)](https://github.com/carpentries/pegboard/actions)
<!-- badges: end -->

> \[pegboard\] is tempered hardboard which is pre-drilled with evenly
> spaced holes. The holes are used to accept pegs or hooks to support
> various items, such as tools in a workshop.
>
> <https://en.wikipedia.org/wiki/Pegboard>

The {pegboard} package is a way to explore the Carpentries’ lessons via
their XML representation. This package makes heavy use of rOpenSci’s
[{tinkr}](https://docs.ropensci.org/tinkr/) and
[{xml2}](https://cran.r-project.org/package=xml2).

There are two [{R6}](https://cran.r-project.org/package=R6) objects in
the package:

-   Episode: stores the xml content of a single episode
-   Lesson: stores all Episodes within a lesson

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

The first way to get started is to use the `get_lesson()` function,
which will use [{gert}](https://r-lib.github.io/gert/) to clone a lesson
repository to your computer.

``` r
library(pegboard)
library(purrr)
library(xml2)
library(fs)

d <- fs::file_temp(pattern = "PBREADME")
rng <- get_lesson("swcarpentry/r-novice-gapminder", path = d)
rng
#| <Lesson>
#|   Public:
#|     blocks: function (type = NULL, level = 0, path = FALSE) 
#|     challenges: function (path = FALSE, graph = FALSE, recurse = TRUE) 
#|     clone: function (deep = FALSE) 
#|     episodes: list
#|     extra: NULL
#|     files: active binding
#|     handout: function (path = NULL, solution = FALSE) 
#|     initialize: function (path = ".", rmd = FALSE, jekyll = TRUE, ...) 
#|     isolate_blocks: function () 
#|     n_problems: active binding
#|     path: /tmp/RtmpPdPaMd/PBREADME8b1f19d96940/swcarpentry--r-novi ...
#|     reset: function () 
#|     rmd: TRUE
#|     show_problems: active binding
#|     solutions: function (path = FALSE) 
#|     thin: function (verbose = TRUE) 
#|     validate_headings: function (verbose = TRUE) 
#|     validate_links: function () 
#|   Private:
#|     deep_clone: function (name, value)

# Find all challenges
head(rng$challenges())
#| $`01-rstudio-intro.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="357:1-393:14" ktag="{: .challenge}">\n  <heading sourcepos="357:3 ...
#| [2] <block_quote sourcepos="511:1-547:14" ktag="{: .challenge}">\n  <heading sourcepos="511:3 ...
#| [3] <block_quote sourcepos="550:1-563:14" ktag="{: .challenge}">\n  <heading sourcepos="550:3 ...
#| [4] <block_quote sourcepos="566:1-578:14" ktag="{: .challenge}">\n  <heading sourcepos="566:3 ...
#| [5] <block_quote sourcepos="581:1-599:14" ktag="{: .challenge}">\n  <heading sourcepos="581:3 ...
#| 
#| $`02-project-intro.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="47:1-57:14" ktag="{: .challenge}">\n  <heading sourcepos="47:3-47 ...
#| [2] <block_quote sourcepos="68:1-74:14" ktag="{: .challenge}">\n  <heading sourcepos="68:3-68 ...
#| [3] <block_quote sourcepos="148:1-156:14" ktag="{: .challenge}">\n  <heading sourcepos="148:3 ...
#| [4] <block_quote sourcepos="158:1-182:14" ktag="{: .challenge}">\n  <heading sourcepos="158:3 ...
#| [5] <block_quote sourcepos="196:1-207:14" ktag="{: .challenge}">\n  <heading sourcepos="196:3 ...
#| 
#| $`03-seeking-help.Rmd`
#| {xml_nodeset (3)}
#| [1] <block_quote sourcepos="119:1-135:14" ktag="{: .challenge}">\n  <heading sourcepos="119:3 ...
#| [2] <block_quote sourcepos="137:1-167:14" ktag="{: .challenge}">\n  <heading sourcepos="137:3 ...
#| [3] <block_quote sourcepos="169:1-186:14" ktag="{: .challenge}">\n  <heading sourcepos="169:3 ...
#| 
#| $`04-data-structures-part1.Rmd`
#| {xml_nodeset (7)}
#| [1] <block_quote sourcepos="333:1-347:14" ktag="{: .challenge}">\n  <heading sourcepos="333:3 ...
#| [2] <block_quote sourcepos="417:1-445:14" ktag="{: .challenge}">\n  <heading sourcepos="417:3 ...
#| [3] <block_quote sourcepos="507:1-566:14" ktag="{: .challenge}">\n  <heading sourcepos="507:3 ...
#| [4] <block_quote sourcepos="588:1-608:14" ktag="{: .challenge}">\n  <heading sourcepos="588:3 ...
#| [5] <block_quote sourcepos="611:1-634:14" ktag="{: .challenge}">\n  <heading sourcepos="611:3 ...
#| [6] <block_quote sourcepos="637:1-657:14" ktag="{: .challenge}">\n  <heading sourcepos="637:3 ...
#| [7] <block_quote sourcepos="660:1-688:14" ktag="{: .challenge}">\n  <heading sourcepos="660:3 ...
#| 
#| $`05-data-structures-part2.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="100:1-111:14" ktag="{: .challenge}">\n  <heading sourcepos="100:3 ...
#| [2] <block_quote sourcepos="183:1-211:14" ktag="{: .challenge}">\n  <heading sourcepos="183:3 ...
#| [3] <block_quote sourcepos="315:1-339:14" ktag="{: .challenge}">\n  <heading sourcepos="315:3 ...
#| [4] <block_quote sourcepos="345:1-374:14" ktag="{: .challenge}">\n  <heading sourcepos="345:3 ...
#| [5] <block_quote sourcepos="376:1-392:14" ktag="{: .challenge}">\n  <heading sourcepos="376:3 ...
#| 
#| $`06-data-subsetting.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="143:1-174:14" ktag="{: .challenge}">\n  <heading sourcepos="143:3 ...
#| [2] <block_quote sourcepos="245:1-264:14" ktag="{: .challenge}">\n  <heading sourcepos="245:3 ...
#| [3] <block_quote sourcepos="345:1-387:14" ktag="{: .challenge}">\n  <heading sourcepos="345:3 ...
#| [4] <block_quote sourcepos="497:1-520:14" ktag="{: .challenge}">\n  <heading sourcepos="497:3 ...
#| [5] <block_quote sourcepos="581:1-603:14" ktag="{: .challenge}">\n  <heading sourcepos="581:3 ...
#| [6] <block_quote sourcepos="606:1-624:14" ktag="{: .challenge}">\n  <heading sourcepos="606:3 ...
#| [7] <block_quote sourcepos="667:1-745:14" ktag="{: .challenge}">\n  <heading sourcepos="667:3 ...
#| [8] <block_quote sourcepos="747:1-765:14" ktag="{: .challenge}">\n  <heading sourcepos="747:3 ...

# Find all solutions
head(rng$solutions())
#| $`01-rstudio-intro.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="371:3-391:7" ktag="{: .solution}">\n  <heading sourcepos="371:5-3 ...
#| [2] <block_quote sourcepos="523:3-547:14" ktag="{: .solution}">\n  <heading sourcepos="523:5- ...
#| [3] <block_quote sourcepos="555:3-563:14" ktag="{: .solution}">\n  <heading sourcepos="555:5- ...
#| [4] <block_quote sourcepos="571:3-576:7" ktag="{: .solution}">\n  <heading sourcepos="571:5-5 ...
#| [5] <block_quote sourcepos="585:3-597:7" ktag="{: .solution}">\n  <heading sourcepos="585:5-5 ...
#| 
#| $`02-project-intro.Rmd`
#| {xml_nodeset (1)}
#| [1] <block_quote sourcepos="167:3-180:7" ktag="{: .solution}">\n  <heading sourcepos="167:5-1 ...
#| 
#| $`03-seeking-help.Rmd`
#| {xml_nodeset (3)}
#| [1] <block_quote sourcepos="128:3-135:14" ktag="{: .solution}">\n  <heading sourcepos="128:5- ...
#| [2] <block_quote sourcepos="142:3-167:14" ktag="{: .solution}">\n  <heading sourcepos="142:5- ...
#| [3] <block_quote sourcepos="177:3-186:14" ktag="{: .solution}">\n  <heading sourcepos="177:5- ...
#| 
#| $`04-data-structures-part1.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="226:3-235:15" ktag="{: .solution}">\n  <heading sourcepos="226:5- ...
#| [2] <block_quote sourcepos="339:3-345:7" ktag="{: .solution}">\n  <heading sourcepos="339:5-3 ...
#| [3] <block_quote sourcepos="424:3-445:14" ktag="{: .solution}">\n  <heading sourcepos="424:5- ...
#| [4] <block_quote sourcepos="524:3-566:14" ktag="{: .solution}">\n  <heading sourcepos="524:5- ...
#| [5] <block_quote sourcepos="595:3-608:14" ktag="{: .solution}">\n  <heading sourcepos="595:5- ...
#| [6] <block_quote sourcepos="620:3-632:7" ktag="{: .solution}">\n  <heading sourcepos="620:5-6 ...
#| [7] <block_quote sourcepos="646:3-655:3" ktag="{: .solution}">\n  <heading sourcepos="646:5-6 ...
#| [8] <block_quote sourcepos="675:3-686:7" ktag="{: .solution}">\n  <heading sourcepos="675:5-6 ...
#| 
#| $`05-data-structures-part2.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="106:3-111:14" ktag="{: .solution}">\n  <heading sourcepos="106:5- ...
#| [2] <block_quote sourcepos="201:3-209:7" ktag="{: .solution}">\n  <heading sourcepos="201:5-2 ...
#| [3] <block_quote sourcepos="321:3-339:14" ktag="{: .solution}">\n  <heading sourcepos="321:5- ...
#| [4] <block_quote sourcepos="354:3-372:7" ktag="{: .solution}">\n  <heading sourcepos="354:5-3 ...
#| [5] <block_quote sourcepos="384:3-390:3" ktag="{: .solution}">\n  <heading sourcepos="384:5-3 ...
#| 
#| $`06-data-subsetting.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="161:3-172:3" ktag="{: .solution}">\n  <heading sourcepos="161:5-1 ...
#| [2] <block_quote sourcepos="257:3-262:7" ktag="{: .solution}">\n  <heading sourcepos="257:5-2 ...
#| [3] <block_quote sourcepos="370:3-387:14" ktag="{: .solution}">\n  <heading sourcepos="370:5- ...
#| [4] <block_quote sourcepos="516:3-520:14" ktag="{: .solution}">\n  <heading sourcepos="516:5- ...
#| [5] <block_quote sourcepos="591:3-601:7" ktag="{: .solution}">\n  <heading sourcepos="591:5-5 ...
#| [6] <block_quote sourcepos="615:3-622:7" ktag="{: .solution}">\n  <heading sourcepos="615:5-6 ...
#| [7] <block_quote sourcepos="703:3-743:11" ktag="{: .solution}">\n  <heading sourcepos="703:5- ...
#| [8] <block_quote sourcepos="755:3-763:7" ktag="{: .solution}">\n  <heading sourcepos="755:5-7 ...

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
#| [1] <block_quote sourcepos="221:1-235:15" ktag="{: .discussion}">\n  <heading sourcepos="221: ...
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

``` r
fun <- rng$episodes$`10-functions.Rmd`
fun$head(70)
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
#| The general structure of a function is:
#| 
#| ```{r}
#| my_function <- function(parameters) {
#|   # perform action
#|   # return value
#| }
#| ```
#| 
#| Let's define a function `fahr_to_kelvin()` that converts temperatures from
#| Fahrenheit to Kelvin:
```

Now, we can apply the transformation chain in the order we specifed:

``` r
fun$
  unblock()$         # transform block quotes
  use_sandpaper()$   # convert code block decorators and modify setup chunk
  move_questions()$  # ...
  move_objectives()$
  move_keypoints()$
  head(70)
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
#| The general structure of a function is:
#| 
#| ```{r}
#| my_function <- function(parameters) {
#|   # perform action
#|   # return value
#| }
#| ```
```

## Reset

All changes can be reset to the initial state with the `$reset()`
method:

``` r
fun$
  reset()$
  head(70)
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
#| The general structure of a function is:
#| 
#| ```{r}
#| my_function <- function(parameters) {
#|   # perform action
#|   # return value
#| }
#| ```
#| 
#| Let's define a function `fahr_to_kelvin()` that converts temperatures from
#| Fahrenheit to Kelvin:
```
