
<!-- README.md is generated from README.Rmd. Please edit that file -->

# up2code

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/up2code)](https://CRAN.R-project.org/package=up2code)
[![Travis build
status](https://travis-ci.com/zkamvar/up2code.svg?branch=master)](https://travis-ci.com/zkamvar/up2code)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/zkamvar/up2code?branch=master&svg=true)](https://ci.appveyor.com/project/zkamvar/up2code)
[![Codecov test
coverage](https://codecov.io/gh/zkamvar/up2code/branch/master/graph/badge.svg)](https://codecov.io/gh/zkamvar/up2code?branch=master)
[![R build
status](https://github.com/zkamvar/up2code/workflows/R-CMD-check/badge.svg)](https://github.com/zkamvar/up2code/actions)
<!-- badges: end -->

The goal of up2code is to …

## Installation

You can install the released version of up2code from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("up2code")
```

## Example

The {up2code} package is a way to explore the Carpentries’ lessons via
their XML representation. This package makes heavy use of rOpenSci’s
[{tinkr}](https://docs.ropensci.org/tinkr/) and
[{xml2}](https://cran.r-project.org/package=xml2).

There are two [{R6}](https://cran.r-project.org/package=R6) objects in
the package:

  - Episode: stores the xml content of a single episode
  - Lesson: stores all Episodes within a lesson

The first way to get started is to use the `get_lesson()` function,
which will use [{git2r}](https://cran.r-project.org/package=git2r) to
clone a lesson repository to your computer.

``` r
library(up2code)
library(purrr)
library(xml2)
library(fs)

d <- fs::file_temp(pattern = "U2CREADME")
rng <- get_lesson("swcarpentry/r-novice-gapminder", path = d)
#> cloning into '/tmp/RtmpWfmxfW/U2CREADME6e6c59d718e7/swcarpentry--r-novice-gapminder'...
#> Receiving objects:   1% (94/9312),   49 kb
#> Receiving objects:  11% (1025/9312),  418 kb
#> Receiving objects:  21% (1956/9312),  626 kb
#> Receiving objects:  31% (2887/9312), 13918 kb
#> Receiving objects:  41% (3818/9312), 19133 kb
#> Receiving objects:  51% (4750/9312), 26251 kb
#> Receiving objects:  61% (5681/9312), 31563 kb
#> Receiving objects:  71% (6612/9312), 35050 kb
#> Receiving objects:  81% (7543/9312), 37498 kb
#> Receiving objects:  91% (8474/9312), 41402 kb
#> Receiving objects: 100% (9312/9312), 44680 kb, done.
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
#>     path: /tmp/RtmpWfmxfW/U2CREADME6e6c59d718e7/swcarpentry--r-nov ...
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
#> [1] <block_quote sourcepos="350:1-386:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="504:1-540:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="543:1-556:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="559:1-571:14" ktag="{: .challenge}">\n  <heading  ...
#> [5] <block_quote sourcepos="573:1-591:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`02-project-intro.Rmd`
#> {xml_nodeset (4)}
#> [1] <block_quote sourcepos="47:1-57:14" ktag="{: .challenge}">\n  <heading so ...
#> [2] <block_quote sourcepos="68:1-74:14" ktag="{: .challenge}">\n  <heading so ...
#> [3] <block_quote sourcepos="148:1-156:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="158:1-182:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`03-seeking-help.Rmd`
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="105:1-121:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="123:1-153:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="155:1-172:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`04-data-structures-part1.Rmd`
#> {xml_nodeset (7)}
#> [1] <block_quote sourcepos="329:1-343:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="393:1-421:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="482:1-541:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="563:1-583:14" ktag="{: .challenge}">\n  <heading  ...
#> [5] <block_quote sourcepos="586:1-609:14" ktag="{: .challenge}">\n  <heading  ...
#> [6] <block_quote sourcepos="612:1-632:14" ktag="{: .challenge}">\n  <heading  ...
#> [7] <block_quote sourcepos="635:1-663:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`05-data-structures-part2.Rmd`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="100:1-111:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="181:1-209:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="313:1-337:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="343:1-372:14" ktag="{: .challenge}">\n  <heading  ...
#> [5] <block_quote sourcepos="374:1-390:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`06-data-subsetting.Rmd`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="143:1-174:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="245:1-264:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="345:1-387:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="497:1-520:14" ktag="{: .challenge}">\n  <heading  ...
#> [5] <block_quote sourcepos="581:1-603:14" ktag="{: .challenge}">\n  <heading  ...
#> [6] <block_quote sourcepos="606:1-624:14" ktag="{: .challenge}">\n  <heading  ...
#> [7] <block_quote sourcepos="667:1-745:14" ktag="{: .challenge}">\n  <heading  ...
#> [8] <block_quote sourcepos="747:1-765:14" ktag="{: .challenge}">\n  <heading  ...

# Find all solutions
head(rng$solutions())
#> $`01-rstudio-intro.Rmd`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="364:3-384:7" ktag="{: .solution}">\n  <heading so ...
#> [2] <block_quote sourcepos="516:3-540:14" ktag="{: .solution}">\n  <heading s ...
#> [3] <block_quote sourcepos="548:3-556:14" ktag="{: .solution}">\n  <heading s ...
#> [4] <block_quote sourcepos="564:3-569:7" ktag="{: .solution}">\n  <heading so ...
#> [5] <block_quote sourcepos="577:3-589:6" ktag="{: .solution}">\n  <heading so ...
#> 
#> $`02-project-intro.Rmd`
#> {xml_nodeset (1)}
#> [1] <block_quote sourcepos="167:3-180:7" ktag="{: .solution}">\n  <heading so ...
#> 
#> $`03-seeking-help.Rmd`
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="114:3-121:14" ktag="{: .solution}">\n  <heading s ...
#> [2] <block_quote sourcepos="128:3-153:14" ktag="{: .solution}">\n  <heading s ...
#> [3] <block_quote sourcepos="163:3-172:14" ktag="{: .solution}">\n  <heading s ...
#> 
#> $`04-data-structures-part1.Rmd`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="222:3-231:15" ktag="{: .solution}">\n  <heading s ...
#> [2] <block_quote sourcepos="335:3-341:7" ktag="{: .solution}">\n  <heading so ...
#> [3] <block_quote sourcepos="400:3-421:14" ktag="{: .solution}">\n  <heading s ...
#> [4] <block_quote sourcepos="499:3-541:14" ktag="{: .solution}">\n  <heading s ...
#> [5] <block_quote sourcepos="570:3-583:14" ktag="{: .solution}">\n  <heading s ...
#> [6] <block_quote sourcepos="595:3-607:7" ktag="{: .solution}">\n  <heading so ...
#> [7] <block_quote sourcepos="621:3-630:3" ktag="{: .solution}">\n  <heading so ...
#> [8] <block_quote sourcepos="650:3-661:7" ktag="{: .solution}">\n  <heading so ...
#> 
#> $`05-data-structures-part2.Rmd`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="106:3-111:14" ktag="{: .solution}">\n  <heading s ...
#> [2] <block_quote sourcepos="199:3-207:7" ktag="{: .solution}">\n  <heading so ...
#> [3] <block_quote sourcepos="319:3-337:14" ktag="{: .solution}">\n  <heading s ...
#> [4] <block_quote sourcepos="352:3-370:7" ktag="{: .solution}">\n  <heading so ...
#> [5] <block_quote sourcepos="382:3-388:3" ktag="{: .solution}">\n  <heading so ...
#> 
#> $`06-data-subsetting.Rmd`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="161:3-172:3" ktag="{: .solution}">\n  <heading so ...
#> [2] <block_quote sourcepos="257:3-262:6" ktag="{: .solution}">\n  <heading so ...
#> [3] <block_quote sourcepos="370:3-387:14" ktag="{: .solution}">\n  <heading s ...
#> [4] <block_quote sourcepos="516:3-520:14" ktag="{: .solution}">\n  <heading s ...
#> [5] <block_quote sourcepos="591:3-601:7" ktag="{: .solution}">\n  <heading so ...
#> [6] <block_quote sourcepos="615:3-622:7" ktag="{: .solution}">\n  <heading so ...
#> [7] <block_quote sourcepos="703:3-743:11" ktag="{: .solution}">\n  <heading s ...
#> [8] <block_quote sourcepos="755:3-763:7" ktag="{: .solution}">\n  <heading so ...

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
#> [1] <block_quote sourcepos="217:1-231:15" ktag="{: .discussion}">\n  <heading ...
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
#> [1] <block_quote sourcepos="86:1-105:14" ktag="{: .challenge}">\n  <heading s ...
#> [2] <block_quote sourcepos="127:1-148:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="226:1-250:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="409:1-423:14" ktag="{: .challenge}">\n  <heading  ...
#> [5] <block_quote sourcepos="426:1-462:14" ktag="{: .challenge}">\n  <heading  ...
fun$unblock(token = "#'")
fun$challenges
#> {xml_nodeset (0)}
fun$code
#> {xml_nodeset (11)}
#>  [1] <code_block sourcepos="19:1-32:12" language="callout" name="&quot;19:1-3 ...
#>  [2] <code_block sourcepos="64:1-70:12" language="callout" name="&quot;64:1-7 ...
#>  [3] <code_block sourcepos="86:1-105:14" language="challenge" name="&quot;86: ...
#>  [4] <code_block sourcepos="127:1-148:14" language="challenge" name="&quot;12 ...
#>  [5] <code_block sourcepos="226:1-250:14" language="challenge" name="&quot;22 ...
#>  [6] <code_block sourcepos="375:1-385:12" language="callout" name="&quot;375: ...
#>  [7] <code_block sourcepos="387:1-395:12" language="callout" name="&quot;387: ...
#>  [8] <code_block sourcepos="409:1-423:14" language="challenge" name="&quot;40 ...
#>  [9] <code_block sourcepos="426:1-462:14" language="challenge" name="&quot;42 ...
#> [10] <code_block sourcepos="464:1-472:12" language="callout" name="&quot;464: ...
#> [11] <code_block sourcepos="479:1-506:12" language="callout" name="&quot;479: ...
fun$code[3] %>% xml_text() %>% cat()
#> #' @challenge Challenge 1
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
