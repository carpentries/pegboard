
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
#> cloning into '/tmp/RtmpQIHuQr/U2CREADME179a3293eb68/swcarpentry--r-novice-gapminder'...
#> Receiving objects:   1% (93/9259),   53 kb
#> Receiving objects:  11% (1019/9259),  418 kb
#> Receiving objects:  21% (1945/9259),  626 kb
#> Receiving objects:  31% (2871/9259), 8734 kb
#> Receiving objects:  41% (3797/9259), 16893 kb
#> Receiving objects:  51% (4723/9259), 21964 kb
#> Receiving objects:  61% (5648/9259), 27276 kb
#> Receiving objects:  71% (6574/9259), 30747 kb
#> Receiving objects:  81% (7500/9259), 33227 kb
#> Receiving objects:  91% (8426/9259), 37115 kb
#> Receiving objects: 100% (9259/9259), 44439 kb, done.
rng
#> <Lesson>
#>   Public:
#>     blocks: function (type = NULL, level = 0, path = FALSE) 
#>     challenges: function (path = FALSE, graph = FALSE, recurse = TRUE) 
#>     clone: function (deep = FALSE) 
#>     episodes: list
#>     files: active binding
#>     initialize: function (path = NULL, rmd = FALSE) 
#>     isolate_blocks: function () 
#>     n_problems: active binding
#>     path: /tmp/RtmpQIHuQr/U2CREADME179a3293eb68/swcarpentry--r-nov ...
#>     reset: function () 
#>     rmd: FALSE
#>     show_problems: active binding
#>     solutions: function (path = FALSE) 
#>     thin: function (verbose = TRUE) 
#>   Private:
#>     deep_clone: function (name, value)

# Find all challenges
head(rng$challenges())
#> $`01-rstudio-intro.md`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="509:1-553:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="752:1-798:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="801:1-823:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="826:1-840:14" ktag="{: .challenge}">\n  <heading  ...
#> [5] <block_quote sourcepos="842:1-857:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`02-project-intro.md`
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="44:1-54:14" ktag="{: .challenge}">\n  <heading so ...
#> [2] <block_quote sourcepos="129:1-137:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="139:1-202:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`03-seeking-help.md`
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="131:1-149:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="151:1-231:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="233:1-250:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`04-data-structures-part1.md`
#> {xml_nodeset (7)}
#> [1] <block_quote sourcepos="776:1-792:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="940:1-972:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="1179:1-1312:14" ktag="{: .challenge}">\n  <headin ...
#> [4] <block_quote sourcepos="1420:1-1449:14" ktag="{: .challenge}">\n  <headin ...
#> [5] <block_quote sourcepos="1452:1-1477:14" ktag="{: .challenge}">\n  <headin ...
#> [6] <block_quote sourcepos="1480:1-1502:14" ktag="{: .challenge}">\n  <headin ...
#> [7] <block_quote sourcepos="1505:1-1545:14" ktag="{: .challenge}">\n  <headin ...
#> 
#> $`05-data-structures-part2.md`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="232:1-243:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="415:1-447:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="756:1-780:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="786:1-819:14" ktag="{: .challenge}">\n  <heading  ...
#> [5] <block_quote sourcepos="821:1-837:14" ktag="{: .challenge}">\n  <heading  ...
#> 
#> $`06-data-subsetting.md`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="283:1-357:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="468:1-507:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="703:1-749:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="992:1-1027:14" ktag="{: .challenge}">\n  <heading ...
#> [5] <block_quote sourcepos="1162:1-1213:14" ktag="{: .challenge}">\n  <headin ...
#> [6] <block_quote sourcepos="1216:1-1240:14" ktag="{: .challenge}">\n  <headin ...
#> [7] <block_quote sourcepos="1338:1-1436:14" ktag="{: .challenge}">\n  <headin ...
#> [8] <block_quote sourcepos="1438:1-1458:14" ktag="{: .challenge}">\n  <headin ...

# Find all solutions
head(rng$solutions())
#> $`01-rstudio-intro.md`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="525:3-553:14" ktag="{: .solution}">\n  <heading s ...
#> [2] <block_quote sourcepos="766:3-798:14" ktag="{: .solution}">\n  <heading s ...
#> [3] <block_quote sourcepos="806:3-823:14" ktag="{: .solution}">\n  <heading s ...
#> [4] <block_quote sourcepos="831:3-840:14" ktag="{: .solution}">\n  <heading s ...
#> [5] <block_quote sourcepos="846:3-857:14" ktag="{: .solution}">\n  <heading s ...
#> 
#> $`02-project-intro.md`
#> {xml_nodeset (1)}
#> [1] <block_quote sourcepos="148:3-202:14" ktag="{: .solution}">\n  <heading s ...
#> 
#> $`03-seeking-help.md`
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="142:3-149:14" ktag="{: .solution}">\n  <heading s ...
#> [2] <block_quote sourcepos="156:3-231:14" ktag="{: .solution}">\n  <heading s ...
#> [3] <block_quote sourcepos="241:3-250:14" ktag="{: .solution}">\n  <heading s ...
#> 
#> $`04-data-structures-part1.md`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="432:3-441:15" ktag="{: .solution}">\n  <heading s ...
#> [2] <block_quote sourcepos="782:3-792:14" ktag="{: .solution}">\n  <heading s ...
#> [3] <block_quote sourcepos="947:3-972:14" ktag="{: .solution}">\n  <heading s ...
#> [4] <block_quote sourcepos="1196:3-1312:14" ktag="{: .solution}">\n  <heading ...
#> [5] <block_quote sourcepos="1427:3-1449:14" ktag="{: .solution}">\n  <heading ...
#> [6] <block_quote sourcepos="1461:3-1477:14" ktag="{: .solution}">\n  <heading ...
#> [7] <block_quote sourcepos="1489:3-1500:3" ktag="{: .solution}">\n  <heading  ...
#> [8] <block_quote sourcepos="1525:3-1545:14" ktag="{: .solution}">\n  <heading ...
#> 
#> $`05-data-structures-part2.md`
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="238:3-243:14" ktag="{: .solution}">\n  <heading s ...
#> [2] <block_quote sourcepos="435:3-447:14" ktag="{: .solution}">\n  <heading s ...
#> [3] <block_quote sourcepos="762:3-780:14" ktag="{: .solution}">\n  <heading s ...
#> [4] <block_quote sourcepos="795:3-819:14" ktag="{: .solution}">\n  <heading s ...
#> [5] <block_quote sourcepos="829:3-835:3" ktag="{: .solution}">\n  <heading so ...
#> 
#> $`06-data-subsetting.md`
#> {xml_nodeset (8)}
#> [1] <block_quote sourcepos="314:3-355:3" ktag="{: .solution}">\n  <heading so ...
#> [2] <block_quote sourcepos="490:3-507:14" ktag="{: .solution}">\n  <heading s ...
#> [3] <block_quote sourcepos="730:3-749:14" ktag="{: .solution}">\n  <heading s ...
#> [4] <block_quote sourcepos="1023:3-1027:14" ktag="{: .solution}">\n  <heading ...
#> [5] <block_quote sourcepos="1174:3-1213:14" ktag="{: .solution}">\n  <heading ...
#> [6] <block_quote sourcepos="1227:3-1240:14" ktag="{: .solution}">\n  <heading ...
#> [7] <block_quote sourcepos="1384:3-1436:14" ktag="{: .solution}">\n  <heading ...
#> [8] <block_quote sourcepos="1446:3-1458:14" ktag="{: .solution}">\n  <heading ...

# Find all discussion blocks
head(rng$blocks(".discussion"))
#> $`01-rstudio-intro.md`
#> {xml_nodeset (0)}
#> 
#> $`02-project-intro.md`
#> {xml_nodeset (0)}
#> 
#> $`03-seeking-help.md`
#> {xml_nodeset (0)}
#> 
#> $`04-data-structures-part1.md`
#> {xml_nodeset (1)}
#> [1] <block_quote sourcepos="427:1-441:15" ktag="{: .discussion}">\n  <heading ...
#> 
#> $`05-data-structures-part2.md`
#> {xml_nodeset (0)}
#> 
#> $`06-data-subsetting.md`
#> {xml_nodeset (0)}
```

## Lesson Manipulation

You can isolate all of the specialized block quotes in the lesson with
`isolate_blocks()`.

``` r
fun <- rng$episodes$`10-functions.md`
fun$body %>% xml_length()
#> [1] 79
fun$isolate_blocks()$body %>% xml_length()
#> [1] 11
fun$write(d)
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
#> > > ```
#> > > kelvin_to_celsius <- function(temp) {
#> > >  celsius <- temp - 273.15
#> > >  return(celsius)
#> > > }
#> > > ```
#> > > {: .language-r}
#> > {: .solution}
#> {: .challenge}
fun$challenges
#> {xml_nodeset (5)}
#> [1] <block_quote sourcepos="101:1-122:14" ktag="{: .challenge}">\n  <heading  ...
#> [2] <block_quote sourcepos="146:1-169:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="271:1-297:14" ktag="{: .challenge}">\n  <heading  ...
#> [4] <block_quote sourcepos="523:1-539:14" ktag="{: .challenge}">\n  <heading  ...
#> [5] <block_quote sourcepos="542:1-598:14" ktag="{: .challenge}">\n  <heading  ...
fun$unblock(token = "#'")
fun$challenges
#> {xml_nodeset (0)}
fun$code
#> {xml_nodeset (11)}
#>  [1] <code_block sourcepos="14:1-27:12" ktag="{: .callout}" info="callout">#' ...
#>  [2] <code_block sourcepos="61:1-67:12" ktag="{: .callout}" info="callout">#' ...
#>  [3] <code_block sourcepos="101:1-122:14" ktag="{: .challenge}" info="challen ...
#>  [4] <code_block sourcepos="146:1-169:14" ktag="{: .challenge}" info="challen ...
#>  [5] <code_block sourcepos="271:1-297:14" ktag="{: .challenge}" info="challen ...
#>  [6] <code_block sourcepos="487:1-497:12" ktag="{: .callout}" info="callout"> ...
#>  [7] <code_block sourcepos="499:1-507:12" ktag="{: .callout}" info="callout"> ...
#>  [8] <code_block sourcepos="523:1-539:14" ktag="{: .challenge}" info="challen ...
#>  [9] <code_block sourcepos="542:1-598:14" ktag="{: .challenge}" info="challen ...
#> [10] <code_block sourcepos="600:1-608:12" ktag="{: .callout}" info="callout"> ...
#> [11] <code_block sourcepos="615:1-642:12" ktag="{: .callout}" info="callout"> ...
fun$code[3] %>% xml_text() %>% cat()
#> #' @challenge
#> #' ## Challenge 1
#> #' 
#> #' Write a function called `kelvin_to_celsius()` that takes a temperature in
#> #' Kelvin and returns that temperature in Celsius.
#> #' 
#> #' Hint: To convert from Kelvin to Celsius you subtract 273.15
#> #'
#> #' @solution
#> #' 
#> #' ## Solution to challenge 1
#> #' 
#> #' Write a function called `kelvin_to_celsius` that takes a temperature in Kelvin
#> #' and returns that temperature in Celsius
#> #+
#> kelvin_to_celsius <- function(temp) {
#>  celsius <- temp - 273.15
#>  return(celsius)
#> }
#> #'
````

## Reset

All changes can be reset to the initial state with the `$reset()`
method:

``` r
fun$reset()
fun$write(d)
cat(readLines(fs::path(d, fun$name), n = 50)[(2 + length(fun$yaml)):50], sep = "\n")
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
#> > 
#> {: .callout}
#> 
#> ## Defining a function
```
