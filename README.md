
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
#| cloning into '/tmp/RtmpDlAWmb/PBREADME623e2d755f64/swcarpentry--r-novice-gapminder'...
#| Receiving objects:   1% (94/9360),   52 kb
#| Receiving objects:  11% (1030/9360),  424 kb
#| Receiving objects:  21% (1966/9360),  647 kb
#| Receiving objects:  31% (2902/9360), 8964 kb
#| Receiving objects:  41% (3838/9360), 14196 kb
#| Receiving objects:  51% (4774/9360), 21315 kb
#| Receiving objects:  61% (5710/9360), 26626 kb
#| Receiving objects:  71% (6646/9360), 30114 kb
#| Receiving objects:  81% (7582/9360), 32561 kb
#| Receiving objects:  91% (8518/9360), 36465 kb
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
#|     path: /tmp/RtmpDlAWmb/PBREADME623e2d755f64/swcarpentry--r-novi ...
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
#| [1] <block_quote sourcepos="350:1-386:14" ktag="{: .challenge}">\n  <heading sourcepos="350:3-350:16" ...
#| [2] <block_quote sourcepos="504:1-540:14" ktag="{: .challenge}">\n  <heading sourcepos="504:3-504:16" ...
#| [3] <block_quote sourcepos="543:1-556:14" ktag="{: .challenge}">\n  <heading sourcepos="543:3-543:16" ...
#| [4] <block_quote sourcepos="559:1-571:14" ktag="{: .challenge}">\n  <heading sourcepos="559:3-559:16" ...
#| [5] <block_quote sourcepos="573:1-591:14" ktag="{: .challenge}">\n  <heading sourcepos="573:3-573:16" ...
#| 
#| $`02-project-intro.Rmd`
#| {xml_nodeset (4)}
#| [1] <block_quote sourcepos="47:1-57:14" ktag="{: .challenge}">\n  <heading sourcepos="47:3-47:51" lev ...
#| [2] <block_quote sourcepos="68:1-74:14" ktag="{: .challenge}">\n  <heading sourcepos="68:3-68:68" lev ...
#| [3] <block_quote sourcepos="148:1-156:14" ktag="{: .challenge}">\n  <heading sourcepos="148:3-148:16" ...
#| [4] <block_quote sourcepos="158:1-182:14" ktag="{: .challenge}">\n  <heading sourcepos="158:3-158:16" ...
#| 
#| $`03-seeking-help.Rmd`
#| {xml_nodeset (3)}
#| [1] <block_quote sourcepos="105:1-121:14" ktag="{: .challenge}">\n  <heading sourcepos="105:3-105:16" ...
#| [2] <block_quote sourcepos="123:1-153:14" ktag="{: .challenge}">\n  <heading sourcepos="123:3-123:16" ...
#| [3] <block_quote sourcepos="155:1-172:14" ktag="{: .challenge}">\n  <heading sourcepos="155:3-155:16" ...
#| 
#| $`04-data-structures-part1.Rmd`
#| {xml_nodeset (7)}
#| [1] <block_quote sourcepos="329:1-343:14" ktag="{: .challenge}">\n  <heading sourcepos="329:3-329:16" ...
#| [2] <block_quote sourcepos="393:1-421:14" ktag="{: .challenge}">\n  <heading sourcepos="393:3-393:16" ...
#| [3] <block_quote sourcepos="482:1-541:14" ktag="{: .challenge}">\n  <heading sourcepos="482:3-482:16" ...
#| [4] <block_quote sourcepos="563:1-583:14" ktag="{: .challenge}">\n  <heading sourcepos="563:3-563:16" ...
#| [5] <block_quote sourcepos="586:1-609:14" ktag="{: .challenge}">\n  <heading sourcepos="586:3-586:16" ...
#| [6] <block_quote sourcepos="612:1-632:14" ktag="{: .challenge}">\n  <heading sourcepos="612:3-612:16" ...
#| [7] <block_quote sourcepos="635:1-663:14" ktag="{: .challenge}">\n  <heading sourcepos="635:3-635:16" ...
#| 
#| $`05-data-structures-part2.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="100:1-111:14" ktag="{: .challenge}">\n  <heading sourcepos="100:3-100:16" ...
#| [2] <block_quote sourcepos="183:1-211:14" ktag="{: .challenge}">\n  <heading sourcepos="183:3-183:16" ...
#| [3] <block_quote sourcepos="315:1-339:14" ktag="{: .challenge}">\n  <heading sourcepos="315:3-315:16" ...
#| [4] <block_quote sourcepos="345:1-374:14" ktag="{: .challenge}">\n  <heading sourcepos="345:3-345:16" ...
#| [5] <block_quote sourcepos="376:1-392:14" ktag="{: .challenge}">\n  <heading sourcepos="376:3-376:16" ...
#| 
#| $`06-data-subsetting.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="143:1-174:14" ktag="{: .challenge}">\n  <heading sourcepos="143:3-143:16" ...
#| [2] <block_quote sourcepos="245:1-264:14" ktag="{: .challenge}">\n  <heading sourcepos="245:3-245:16" ...
#| [3] <block_quote sourcepos="345:1-387:14" ktag="{: .challenge}">\n  <heading sourcepos="345:3-345:16" ...
#| [4] <block_quote sourcepos="497:1-520:14" ktag="{: .challenge}">\n  <heading sourcepos="497:3-497:16" ...
#| [5] <block_quote sourcepos="581:1-603:14" ktag="{: .challenge}">\n  <heading sourcepos="581:3-581:16" ...
#| [6] <block_quote sourcepos="606:1-624:14" ktag="{: .challenge}">\n  <heading sourcepos="606:3-606:16" ...
#| [7] <block_quote sourcepos="667:1-745:14" ktag="{: .challenge}">\n  <heading sourcepos="667:3-667:16" ...
#| [8] <block_quote sourcepos="747:1-765:14" ktag="{: .challenge}">\n  <heading sourcepos="747:3-747:16" ...

# Find all solutions
head(rng$solutions())
#| $`01-rstudio-intro.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="364:3-384:7" ktag="{: .solution}">\n  <heading sourcepos="364:5-364:30" l ...
#| [2] <block_quote sourcepos="516:3-540:14" ktag="{: .solution}">\n  <heading sourcepos="516:5-516:30"  ...
#| [3] <block_quote sourcepos="548:3-556:14" ktag="{: .solution}">\n  <heading sourcepos="548:5-548:30"  ...
#| [4] <block_quote sourcepos="564:3-569:7" ktag="{: .solution}">\n  <heading sourcepos="564:5-564:30" l ...
#| [5] <block_quote sourcepos="577:3-589:6" ktag="{: .solution}">\n  <heading sourcepos="577:5-577:30" l ...
#| 
#| $`02-project-intro.Rmd`
#| {xml_nodeset (1)}
#| [1] <block_quote sourcepos="167:3-180:7" ktag="{: .solution}">\n  <heading sourcepos="167:5-167:30" l ...
#| 
#| $`03-seeking-help.Rmd`
#| {xml_nodeset (3)}
#| [1] <block_quote sourcepos="114:3-121:14" ktag="{: .solution}">\n  <heading sourcepos="114:5-114:30"  ...
#| [2] <block_quote sourcepos="128:3-153:14" ktag="{: .solution}">\n  <heading sourcepos="128:5-128:30"  ...
#| [3] <block_quote sourcepos="163:3-172:14" ktag="{: .solution}">\n  <heading sourcepos="163:5-163:30"  ...
#| 
#| $`04-data-structures-part1.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="222:3-231:15" ktag="{: .solution}">\n  <heading sourcepos="222:5-222:19"  ...
#| [2] <block_quote sourcepos="335:3-341:7" ktag="{: .solution}">\n  <heading sourcepos="335:5-335:30" l ...
#| [3] <block_quote sourcepos="400:3-421:14" ktag="{: .solution}">\n  <heading sourcepos="400:5-400:30"  ...
#| [4] <block_quote sourcepos="499:3-541:14" ktag="{: .solution}">\n  <heading sourcepos="499:5-499:30"  ...
#| [5] <block_quote sourcepos="570:3-583:14" ktag="{: .solution}">\n  <heading sourcepos="570:5-570:30"  ...
#| [6] <block_quote sourcepos="595:3-607:7" ktag="{: .solution}">\n  <heading sourcepos="595:5-595:30" l ...
#| [7] <block_quote sourcepos="621:3-630:3" ktag="{: .solution}">\n  <heading sourcepos="621:5-621:30" l ...
#| [8] <block_quote sourcepos="650:3-661:7" ktag="{: .solution}">\n  <heading sourcepos="650:5-650:30" l ...
#| 
#| $`05-data-structures-part2.Rmd`
#| {xml_nodeset (5)}
#| [1] <block_quote sourcepos="106:3-111:14" ktag="{: .solution}">\n  <heading sourcepos="106:5-106:30"  ...
#| [2] <block_quote sourcepos="201:3-209:7" ktag="{: .solution}">\n  <heading sourcepos="201:5-201:30" l ...
#| [3] <block_quote sourcepos="321:3-339:14" ktag="{: .solution}">\n  <heading sourcepos="321:5-321:30"  ...
#| [4] <block_quote sourcepos="354:3-372:7" ktag="{: .solution}">\n  <heading sourcepos="354:5-354:30" l ...
#| [5] <block_quote sourcepos="384:3-390:3" ktag="{: .solution}">\n  <heading sourcepos="384:5-384:30" l ...
#| 
#| $`06-data-subsetting.Rmd`
#| {xml_nodeset (8)}
#| [1] <block_quote sourcepos="161:3-172:3" ktag="{: .solution}">\n  <heading sourcepos="161:5-161:30" l ...
#| [2] <block_quote sourcepos="257:3-262:6" ktag="{: .solution}">\n  <heading sourcepos="257:5-257:30" l ...
#| [3] <block_quote sourcepos="370:3-387:14" ktag="{: .solution}">\n  <heading sourcepos="370:5-370:30"  ...
#| [4] <block_quote sourcepos="516:3-520:14" ktag="{: .solution}">\n  <heading sourcepos="516:5-516:30"  ...
#| [5] <block_quote sourcepos="591:3-601:7" ktag="{: .solution}">\n  <heading sourcepos="591:5-591:30" l ...
#| [6] <block_quote sourcepos="615:3-622:7" ktag="{: .solution}">\n  <heading sourcepos="615:5-615:30" l ...
#| [7] <block_quote sourcepos="703:3-743:11" ktag="{: .solution}">\n  <heading sourcepos="703:5-703:30"  ...
#| [8] <block_quote sourcepos="755:3-763:7" ktag="{: .solution}">\n  <heading sourcepos="755:5-755:30" l ...

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
#| [1] <block_quote sourcepos="217:1-231:15" ktag="{: .discussion}">\n  <heading sourcepos="217:3-217:17 ...
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
cat(readLines(fs::path(d, fun$name), n = 70), sep = "\n")
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
#| 
#| ```{r}
#| fahr_to_kelvin <- function(temp) {
#|   kelvin <- ((temp - 32) * (5 / 9)) + 273.15
#|   return(kelvin)
#| }
#| ```
#| 
#| We define `fahr_to_kelvin()` by assigning it to the output of `function`. The
#| list of argument names are contained within parentheses.   Next, the
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
fun$
  reset()$
  write(d, format = "Rmd")
cat(readLines(fs::path(d, fun$name), n = 70), sep = "\n")
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
#| 
#| ```{r}
#| fahr_to_kelvin <- function(temp) {
#|   kelvin <- ((temp - 32) * (5 / 9)) + 273.15
#|   return(kelvin)
#| }
#| ```
#| 
#| We define `fahr_to_kelvin()` by assigning it to the output of `function`. The
#| list of argument names are contained within parentheses.   Next, the
````
