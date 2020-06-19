
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pegboard

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pegboard)](https://CRAN.R-project.org/package=pegboard)
[![Travis build
status](https://travis-ci.com/zkamvar/pegboard.svg?branch=master)](https://travis-ci.com/zkamvar/pegboard)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/zkamvar/pegboard?branch=master&svg=true)](https://ci.appveyor.com/project/zkamvar/pegboard)
[![Codecov test
coverage](https://codecov.io/gh/zkamvar/pegboard/branch/master/graph/badge.svg)](https://codecov.io/gh/zkamvar/pegboard?branch=master)
[![R build
status](https://github.com/zkamvar/pegboard/workflows/R-CMD-check/badge.svg)](https://github.com/zkamvar/pegboard/actions)
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
remotes::install_github("zkamvar/pegboard")
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

d <- fs::file_temp(pattern = "U2CREADME")
rng <- get_lesson("swcarpentry/r-novice-gapminder", path = d)
#> cloning into '/tmp/RtmpgOaoR9/U2CREADME32bb1e071ed3/swcarpentry--r-novice-gapminder'...
#> Receiving objects:   1% (94/9318),   49 kb
#> Receiving objects:  11% (1025/9318),  420 kb
#> Receiving objects:  21% (1957/9318),  627 kb
#> Receiving objects:  31% (2889/9318), 13954 kb
#> Receiving objects:  41% (3821/9318), 19125 kb
#> Receiving objects:  51% (4753/9318), 26256 kb
#> Receiving objects:  61% (5684/9318), 31549 kb
#> Receiving objects:  71% (6616/9318), 35052 kb
#> Receiving objects:  81% (7548/9318), 37500 kb
#> Receiving objects:  91% (8480/9318), 41403 kb
#> Receiving objects: 100% (9318/9318), 44687 kb, done.
rng
#> <Lesson>
#>   Public:
#>     blocks: function (type = NULL, level = 0, path = FALSE) 
#>     challenges: function (path = FALSE, graph = FALSE, recurse = TRUE) 
#>     clone: function (deep = FALSE) 
#>     episodes: list
#>     files: active binding
#>     initialize: function (path = NULL, rmd = FALSE, ...) 
#>     isolate_blocks: function () 
#>     n_problems: active binding
#>     path: /tmp/RtmpgOaoR9/U2CREADME32bb1e071ed3/swcarpentry--r-nov ...
#>     reset: function () 
#>     rmd: TRUE
#>     show_problems: active binding
#>     solutions: function (path = FALSE) 
#>     thin: function (verbose = TRUE) 
#>   Private:
#>     deep_clone: function (name, value)

# Find all challenges
head(rng$challenges())
#> $`01-rstudio-intro.Rmd`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="350:1-386:14" ktag="{: .challenge}">\n  <heading sourcepos="350:3-350 ...
#> [2] <block_quote sourcepos="504:1-540:14" ktag="{: .challenge}">\n  <heading sourcepos="504:3-504 ...
#> [3] <block_quote sourcepos="543:1-556:14" ktag="{: .challenge}">\n  <heading sourcepos="543:3-543 ...
#> [4] <block_quote sourcepos="559:1-571:14" ktag="{: .challenge}">\n  <heading sourcepos="559:3-559 ...
#> [5] <block_quote sourcepos="573:1-591:14" ktag="{: .challenge}">\n  <heading sourcepos="573:3-573 ...
#> 
#> $`02-project-intro.Rmd`
#> {xml_nodeset (4)}
#> [1] <block_quote sourcepos="47:1-57:14" ktag="{: .challenge}">\n  <heading sourcepos="47:3-47:51" ...
#> [2] <block_quote sourcepos="68:1-74:14" ktag="{: .challenge}">\n  <heading sourcepos="68:3-68:68" ...
#> [3] <block_quote sourcepos="148:1-156:14" ktag="{: .challenge}">\n  <heading sourcepos="148:3-148 ...
#> [4] <block_quote sourcepos="158:1-182:14" ktag="{: .challenge}">\n  <heading sourcepos="158:3-158 ...
#> 
#> $`03-seeking-help.Rmd`
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="105:1-121:14" ktag="{: .challenge}">\n  <heading sourcepos="105:3-105 ...
#> [2] <block_quote sourcepos="123:1-153:14" ktag="{: .challenge}">\n  <heading sourcepos="123:3-123 ...
#> [3] <block_quote sourcepos="155:1-172:14" ktag="{: .challenge}">\n  <heading sourcepos="155:3-155 ...
#> 
#> $`04-data-structures-part1.Rmd`
#> {xml_nodeset (7)}
#> [1] <block_quote sourcepos="329:1-343:14" ktag="{: .challenge}">\n  <heading sourcepos="329:3-329 ...
#> [2] <block_quote sourcepos="393:1-421:14" ktag="{: .challenge}">\n  <heading sourcepos="393:3-393 ...
#> [3] <block_quote sourcepos="482:1-541:14" ktag="{: .challenge}">\n  <heading sourcepos="482:3-482 ...
#> [4] <block_quote sourcepos="563:1-583:14" ktag="{: .challenge}">\n  <heading sourcepos="563:3-563 ...
#> [5] <block_quote sourcepos="586:1-609:14" ktag="{: .challenge}">\n  <heading sourcepos="586:3-586 ...
#> [6] <block_quote sourcepos="612:1-632:14" ktag="{: .challenge}">\n  <heading sourcepos="612:3-612 ...
#> [7] <block_quote sourcepos="635:1-663:14" ktag="{: .challenge}">\n  <heading sourcepos="635:3-635 ...
#> 
#> $`05-data-structures-part2.Rmd`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="100:1-111:14" ktag="{: .challenge}">\n  <heading sourcepos="100:3-100 ...
#> [2] <block_quote sourcepos="181:1-209:14" ktag="{: .challenge}">\n  <heading sourcepos="181:3-181 ...
#> [3] <block_quote sourcepos="313:1-337:14" ktag="{: .challenge}">\n  <heading sourcepos="313:3-313 ...
#> [4] <block_quote sourcepos="343:1-372:14" ktag="{: .challenge}">\n  <heading sourcepos="343:3-343 ...
#> [5] <block_quote sourcepos="374:1-390:14" ktag="{: .challenge}">\n  <heading sourcepos="374:3-374 ...
#> 
#> $`06-data-subsetting.Rmd`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="143:1-174:14" ktag="{: .challenge}">\n  <heading sourcepos="143:3-143 ...
#> [2] <block_quote sourcepos="245:1-264:14" ktag="{: .challenge}">\n  <heading sourcepos="245:3-245 ...
#> [3] <block_quote sourcepos="345:1-387:14" ktag="{: .challenge}">\n  <heading sourcepos="345:3-345 ...
#> [4] <block_quote sourcepos="497:1-520:14" ktag="{: .challenge}">\n  <heading sourcepos="497:3-497 ...
#> [5] <block_quote sourcepos="581:1-603:14" ktag="{: .challenge}">\n  <heading sourcepos="581:3-581 ...
#> [6] <block_quote sourcepos="606:1-624:14" ktag="{: .challenge}">\n  <heading sourcepos="606:3-606 ...
#> [7] <block_quote sourcepos="667:1-745:14" ktag="{: .challenge}">\n  <heading sourcepos="667:3-667 ...
#> [8] <block_quote sourcepos="747:1-765:14" ktag="{: .challenge}">\n  <heading sourcepos="747:3-747 ...

# Find all solutions
head(rng$solutions())
#> $`01-rstudio-intro.Rmd`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="364:3-384:7" ktag="{: .solution}">\n  <heading sourcepos="364:5-364:3 ...
#> [2] <block_quote sourcepos="516:3-540:14" ktag="{: .solution}">\n  <heading sourcepos="516:5-516: ...
#> [3] <block_quote sourcepos="548:3-556:14" ktag="{: .solution}">\n  <heading sourcepos="548:5-548: ...
#> [4] <block_quote sourcepos="564:3-569:7" ktag="{: .solution}">\n  <heading sourcepos="564:5-564:3 ...
#> [5] <block_quote sourcepos="577:3-589:6" ktag="{: .solution}">\n  <heading sourcepos="577:5-577:3 ...
#> 
#> $`02-project-intro.Rmd`
#> {xml_nodeset (1)}
#> [1] <block_quote sourcepos="167:3-180:7" ktag="{: .solution}">\n  <heading sourcepos="167:5-167:3 ...
#> 
#> $`03-seeking-help.Rmd`
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="114:3-121:14" ktag="{: .solution}">\n  <heading sourcepos="114:5-114: ...
#> [2] <block_quote sourcepos="128:3-153:14" ktag="{: .solution}">\n  <heading sourcepos="128:5-128: ...
#> [3] <block_quote sourcepos="163:3-172:14" ktag="{: .solution}">\n  <heading sourcepos="163:5-163: ...
#> 
#> $`04-data-structures-part1.Rmd`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="222:3-231:15" ktag="{: .solution}">\n  <heading sourcepos="222:5-222: ...
#> [2] <block_quote sourcepos="335:3-341:7" ktag="{: .solution}">\n  <heading sourcepos="335:5-335:3 ...
#> [3] <block_quote sourcepos="400:3-421:14" ktag="{: .solution}">\n  <heading sourcepos="400:5-400: ...
#> [4] <block_quote sourcepos="499:3-541:14" ktag="{: .solution}">\n  <heading sourcepos="499:5-499: ...
#> [5] <block_quote sourcepos="570:3-583:14" ktag="{: .solution}">\n  <heading sourcepos="570:5-570: ...
#> [6] <block_quote sourcepos="595:3-607:7" ktag="{: .solution}">\n  <heading sourcepos="595:5-595:3 ...
#> [7] <block_quote sourcepos="621:3-630:3" ktag="{: .solution}">\n  <heading sourcepos="621:5-621:3 ...
#> [8] <block_quote sourcepos="650:3-661:7" ktag="{: .solution}">\n  <heading sourcepos="650:5-650:3 ...
#> 
#> $`05-data-structures-part2.Rmd`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="106:3-111:14" ktag="{: .solution}">\n  <heading sourcepos="106:5-106: ...
#> [2] <block_quote sourcepos="199:3-207:7" ktag="{: .solution}">\n  <heading sourcepos="199:5-199:3 ...
#> [3] <block_quote sourcepos="319:3-337:14" ktag="{: .solution}">\n  <heading sourcepos="319:5-319: ...
#> [4] <block_quote sourcepos="352:3-370:7" ktag="{: .solution}">\n  <heading sourcepos="352:5-352:3 ...
#> [5] <block_quote sourcepos="382:3-388:3" ktag="{: .solution}">\n  <heading sourcepos="382:5-382:3 ...
#> 
#> $`06-data-subsetting.Rmd`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="161:3-172:3" ktag="{: .solution}">\n  <heading sourcepos="161:5-161:3 ...
#> [2] <block_quote sourcepos="257:3-262:6" ktag="{: .solution}">\n  <heading sourcepos="257:5-257:3 ...
#> [3] <block_quote sourcepos="370:3-387:14" ktag="{: .solution}">\n  <heading sourcepos="370:5-370: ...
#> [4] <block_quote sourcepos="516:3-520:14" ktag="{: .solution}">\n  <heading sourcepos="516:5-516: ...
#> [5] <block_quote sourcepos="591:3-601:7" ktag="{: .solution}">\n  <heading sourcepos="591:5-591:3 ...
#> [6] <block_quote sourcepos="615:3-622:7" ktag="{: .solution}">\n  <heading sourcepos="615:5-615:3 ...
#> [7] <block_quote sourcepos="703:3-743:11" ktag="{: .solution}">\n  <heading sourcepos="703:5-703: ...
#> [8] <block_quote sourcepos="755:3-763:7" ktag="{: .solution}">\n  <heading sourcepos="755:5-755:3 ...

# Find all discussion blocks
head(rng$blocks(".discussion"))
#> $`01-rstudio-intro.Rmd`
#> {xml_nodeset (0)}
#> 
#> $`02-project-intro.Rmd`
#> {xml_nodeset (0)}
#> 
#> $`03-seeking-help.Rmd`
#> {xml_nodeset (0)}
#> 
#> $`04-data-structures-part1.Rmd`
#> {xml_nodeset (1)}
#> [1] <block_quote sourcepos="217:1-231:15" ktag="{: .discussion}">\n  <heading sourcepos="217:3-21 ...
#> 
#> $`05-data-structures-part2.Rmd`
#> {xml_nodeset (0)}
#> 
#> $`06-data-subsetting.Rmd`
#> {xml_nodeset (0)}
```

## Lesson Manipulation

You can isolate all of the specialized block quotes in the lesson with
`isolate_blocks()`.

``` r
fun <- rng$episodes$`10-functions.Rmd`
fun$body %>% xml_length()
#> [1] 72
fun$isolate_blocks()$body %>% xml_length()
#> [1] 11
fun$write(d, format = "Rmd")
cat(readLines(fs::path(d, fun$name), n = 50)[(2 + length(fun$yaml)):50], sep = "\n")
#> > ## What is a function?
#> > 
#> > Functions gather a sequence of operations into a whole, preserving it for
#> > ongoing use. Functions provide:
#> > 
#> > - a name we can remember and invoke it by
#> > - relief from the need to remember the individual operations
#> > - a defined set of inputs and expected outputs
#> > - rich connections to the larger programming environment
#> > 
#> > As the basic building block of most programming languages, user-defined
#> > functions constitute "programming" as much as any single abstraction can. If
#> > you have written a function, you are a computer programmer.
#> > 
#> {: .callout}
#> 
#> > ## Tip
#> > 
#> > One feature unique to R is that the return statement is not required.
#> > R automatically returns whichever variable is on the last line of the body
#> > of the function. But for clarity, we will explicitly define the
#> > return statement.
#> > 
#> {: .callout}
#> 
#> > ## Challenge 1
#> > 
#> > Write a function called `kelvin_to_celsius()` that takes a temperature in
#> > Kelvin and returns that temperature in Celsius.
```

## Roxygen-style blocks

One experiment we are trying is to create a new formatting for challenge
blocks that we think may be easier to write for folks. To convert
lessons to this new format, we can use `$unblock()`, for example, here’s
a challenge block that was reformatted to remove the

```` r
cat(readLines(fs::path(d, fun$name), n = 70)[(27 + length(fun$yaml)):70], sep = "\n")
#> > ## Challenge 1
#> > 
#> > Write a function called `kelvin_to_celsius()` that takes a temperature in
#> > Kelvin and returns that temperature in Celsius.
#> > 
#> > Hint: To convert from Kelvin to Celsius you subtract 273.15
#> > 
#> > > ## Solution to challenge 1
#> > > 
#> > > Write a function called `kelvin_to_celsius` that takes a temperature in Kelvin
#> > > and returns that temperature in Celsius
#> > > 
#> > > ```{r}
#> > > kelvin_to_celsius <- function(temp) {
#> > >  celsius <- temp - 273.15
#> > >  return(celsius)
#> > > }
#> > > ```
#> > {: .solution}
#> {: .challenge}
#> 
#> > ## Challenge 2
#> > 
#> > Define the function to convert directly from Fahrenheit to Celsius,
fun$challenges
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="86:1-105:14" ktag="{: .challenge}">\n  <heading sourcepos="86:3-86:16 ...
#> [2] <block_quote sourcepos="127:1-148:14" ktag="{: .challenge}">\n  <heading sourcepos="127:3-127 ...
#> [3] <block_quote sourcepos="226:1-250:14" ktag="{: .challenge}">\n  <heading sourcepos="226:3-226 ...
#> [4] <block_quote sourcepos="409:1-423:14" ktag="{: .challenge}">\n  <heading sourcepos="409:3-409 ...
#> [5] <block_quote sourcepos="426:1-462:14" ktag="{: .challenge}">\n  <heading sourcepos="426:3-426 ...
fun$unblock(token = "#'")
fun$challenges
#> {xml_nodeset (0)}
fun$code
#> {xml_nodeset (11)}
#>  [1] <code_block sourcepos="19:1-32:12" language="callout" name="&quot;19:1-32:12&quot;">#' ## Wh ...
#>  [2] <code_block sourcepos="64:1-70:12" language="callout" name="&quot;64:1-70:12&quot;">#' ## Ti ...
#>  [3] <code_block sourcepos="86:1-105:14" language="challenge" name="&quot;86:1-105:14&quot;">#' # ...
#>  [4] <code_block sourcepos="127:1-148:14" language="challenge" name="&quot;127:1-148:14&quot;">#' ...
#>  [5] <code_block sourcepos="226:1-250:14" language="challenge" name="&quot;226:1-250:14&quot;">#' ...
#>  [6] <code_block sourcepos="375:1-385:12" language="callout" name="&quot;375:1-385:12&quot;">#' # ...
#>  [7] <code_block sourcepos="387:1-395:12" language="callout" name="&quot;387:1-395:12&quot;">#' # ...
#>  [8] <code_block sourcepos="409:1-423:14" language="challenge" name="&quot;409:1-423:14&quot;">#' ...
#>  [9] <code_block sourcepos="426:1-462:14" language="challenge" name="&quot;426:1-462:14&quot;">#' ...
#> [10] <code_block sourcepos="464:1-472:12" language="callout" name="&quot;464:1-472:12&quot;">#' # ...
#> [11] <code_block sourcepos="479:1-506:12" language="callout" name="&quot;479:1-506:12&quot;">#' # ...
fun$code[3] %>% xml_text() %>% cat()
#> #' ## Challenge 1
#> #' 
#> #' Write a function called `kelvin_to_celsius()` that takes a temperature in
#> #' Kelvin and returns that temperature in Celsius.
#> #' 
#> #' Hint: To convert from Kelvin to Celsius you subtract 273.15
#> #'
#> #' @solution Solution to challenge 1
#> #' 
#> #' Write a function called `kelvin_to_celsius` that takes a temperature in Kelvin
#> #' and returns that temperature in Celsius
#> #' 
#> #' ```{r}
#> kelvin_to_celsius <- function(temp) {
#>  celsius <- temp - 273.15
#>  return(celsius)
#> }
#> #' ```
````

## Reset

All changes can be reset to the initial state with the `$reset()`
method:

```` r
fun$reset()
fun$write(d, format = "Rmd")
cat(readLines(fs::path(d, fun$name), n = 50)[(2 + length(fun$yaml)):50], sep = "\n")
#> ```{r, include=FALSE}
#> source("../bin/chunk-options.R")
#> knitr_fig_path("10-")
#> # Silently load in the data so the rest of the lesson works
#> gapminder <- read.csv("data/gapminder_data.csv", header=TRUE)
#> ```
#> 
#> If we only had one data set to analyze, it would probably be faster to load the
#> file into a spreadsheet and use that to plot simple statistics. However, the
#> gapminder data is updated periodically, and we may want to pull in that new
#> information later and re-run our analysis again. We may also obtain similar data
#> from a different source in the future.
#> 
#> In this lesson, we'll learn how to write a function so that we can repeat
#> several operations with a single command.
#> 
#> > ## What is a function?
#> > 
#> > Functions gather a sequence of operations into a whole, preserving it for
#> > ongoing use. Functions provide:
#> > 
#> > - a name we can remember and invoke it by
#> > - relief from the need to remember the individual operations
#> > - a defined set of inputs and expected outputs
#> > - rich connections to the larger programming environment
#> > 
#> > As the basic building block of most programming languages, user-defined
#> > functions constitute "programming" as much as any single abstraction can. If
#> > you have written a function, you are a computer programmer.
````
