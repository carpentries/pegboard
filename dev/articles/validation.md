# Validation of Lesson Elements

## Introduction

This package is designed to parse the structure of the Markdown and R
Markdown files inside a Carpentries-style lesson. To ensure consistent
lesson structure, it has built-in validators that will inspect headings,
links, and callout sections. This document will help you become familiar
with the output of the validators and how they can be used to update a
lesson.

Lesson authors and contributors will likely only see the output of these
validators and not need to interact with them directly. For example, we
have a lesson that contains some mal-formed links and headings:

``` r

library(pegboard)
lsn <- Lesson$new(lesson_fragment())
# validation
lsn$validate_divs()
lsn$validate_links()
#| ! There were errors in 4/14 images
#| ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
#| ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
#| 
#| ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
#| ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
#| ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
#| ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg
lsn$validate_headings(verbose = FALSE)
#| ! There were errors in 13/37 headings
#| ◌ Headings must be unique
#| <https://webaim.org/techniques/semanticstructure/#headings>
#| 
#| ::warning file=_episodes/12-for-loops.md,line=183:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=200:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=227:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=252:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=270:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=289:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=305:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=336:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=371:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=400:: (duplicated)
#| ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
#| ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
#| ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)
```

We can see that there is informative and actionable output produced that
will allow lesson authors to make targeted changes in their files. The
next sections will detail how we can work with the output of these
methods.

## Link Validation

Each of the validation methods will produce messages (aka stderr) for
the user, but they also produce a data frame as output that contains
detailed information about each link and what tests it passed or did not
pass. You can find out what tests are run on links by accessing the help
page for `validate_links` by typing
[`?validate_links`](https://carpentries.github.io/pegboard/dev/reference/validate_links.md)
in your R console.

If we want to inspect this data frame, we can assign it to a new
variable:

``` r

links <- lsn$validate_links()
#| ! There were errors in 4/14 images
#| ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
#| ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
#| 
#| ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
#| ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
#| ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
#| ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg
str(links, max.level = 1)
#| 'data.frame':    14 obs. of  28 variables:
#|  $ episodes            : chr  "12-for-loops.md" "14-looping-data-sets.md" "14-looping-data-sets.m"..
#|  $ scheme              : chr  "https" "https" "https" "https" ...
#|  $ server              : chr  "docs.python.org" "docs.python.org" "docs.python.org" "docs.python."..
#|  $ port                : int  NA NA NA NA NA NA NA NA 6 7 ...
#|  $ user                : chr  "" "" "" "" ...
#|  $ path                : chr  "/3/library/stdtypes.html" "/3/library/glob.html" "/3/library/glob."..
#|  $ query               : chr  "" "" "" "" ...
#|  $ fragment            : chr  "range" "glob.glob" "" "" ...
#|  $ orig                : chr  "https://docs.python.org/3/library/stdtypes.html#range" "https://do"..
#|  $ text                : chr  "range" "glob.glob" "glob" "glob" ...
#|  $ alt                 : chr  NA NA NA NA ...
#|  $ title               : chr  "" "" "" "" ...
#|  $ type                : chr  "link" "link" "link" "link" ...
#|  $ rel                 : chr  NA NA NA NA ...
#|  $ anchor              : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#|  $ sourcepos           : int  135 51 57 58 140 163 189 191 193 193 ...
#|  $ filepath            : 'fs_path' chr  "_episodes/12-for-loops.md" "_episodes/14-looping-data-se"..
#|  $ parents             :List of 14
#|  $ node                :List of 14
#|   ..- attr(*, "class")= chr "AsIs"
#|  $ known_protocol      : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ enforce_https       : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ internal_anchor     : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ internal_file       : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ internal_well_formed: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ all_reachable       : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ img_alt_text        : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ descriptive         : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ link_length         : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
```

This data frame is combined output of three sources:

1.  the output of \[xml2::url_parse()\]
2.  the source data containing the original source file (filepath), line
    number (pos), and XML node (node)
3.  the tests performed as logical vectors, which can be extracted
    programmatically

Here, we can see the nodes that did not pass our tests by using the
`link_tests` vector, which is an internal vector defining the inline
messages printed for each failed test, to filter the output:

``` r

# get the subset of rows that did not pass all the tests
invalid <- !apply(links[names(link_tests)], MARGIN = 1L, all)
# return the nodes
links$node[invalid]
#| [[1]]
#| {html_node}
#| <img src="../no-workie.svg" alt="books as clubs" destination="../no-workie.svg" sourcepos="176:1-176:49">
#| 
#| [[2]]
#| {xml_node}
#| <image sourcepos="180:1-180:74" destination="https://carpentries.org/assets/img/TheCarpentries.svg" title="">
#| [1] <text sourcepos="180:3-180:18" xml:space="preserve">Carpentries logo</text>
#| 
#| [[3]]
#| {xml_node}
#| <image sourcepos="182:1-182:38" destination="../no-workie.svg" title="">
#| [1] <text sourcepos="182:3-182:19" xml:space="preserve">Non-working image</text>
#| 
#| [[4]]
#| {xml_node}
#| <image destination="{{ page.root }}/no-workie.svg" sourcepos="184:1-184:70">
#| [1] <text>Non-working image with jekyll syntax</text>
```

For context, this is what the document looks like at those positions:

    #| <img src="https://carpentries.org/assets/img/TheCarpentries.svg" alt="books as clubs">
    #| 
    #| <img src="../no-workie.svg" alt="books as clubs">
    #| 
    #| Link to [Home]({{ page.root }}/index.html) and to [shell]({{ site.swc_pages }}/shell-novice)
    #| 
    #| ![Carpentries logo](https://carpentries.org/assets/img/TheCarpentries.svg)
    #| 
    #| ![Non-working image](../no-workie.svg)
    #| 
    #| ![Non-working image with jekyll syntax]({{ page.root }}/no-workie.svg)
    #| 
    #| This text includes a [link that isn't parsed correctly by commonmark]({{ page.root }}{% link index.md %})
    #| . The rest of the text should be properly parsed.
    #| 
    #| {% include links.md %}

## Fenced Div Validation

Validation of fenced divs (aka callout blocks) *at the moment* checks
for whether or not the section divs we encouter in the lessons are the
ones we expect, [to avoid issues where a div class is
mis-typed](https://github.com/carpentries/sandpaper/issues/254).

The divs we expect are in the object
[`pegboard::KNOWN_DIVS`](https://carpentries.github.io/pegboard/dev/reference/validate_divs.md):
callout, objectives, questions, challenge, prereq, checklist, solution,
hint, discussion, testimonial, keypoints, instructor, spoiler, tab,
group-tab, and caution.

Our example lesson is from the old styles repository, so it does not
have any fenced divs, but we can use a lesson fragment from {sandpaper}:

``` r

snd <- Lesson$new(lesson_fragment(name = "sandpaper-fragment"), jekyll = FALSE)
snd_divs <- snd$validate_divs()
```

Notice that no message was produced indicating that the divs in our
lesson fragment were okay. When we look at the data frame that was
produced, we can see that there are six divs:

``` r

snd_divs
#|                   episodes               path        div         pb_label pos is_known
#| div-1-questions  intro.Rmd episodes/intro.Rmd  questions  div-1-questions   7     TRUE
#| div-2-objectives intro.Rmd episodes/intro.Rmd objectives div-2-objectives  13     TRUE
#| div-3-challenge  intro.Rmd episodes/intro.Rmd  challenge  div-3-challenge  37     TRUE
#| div-4-solution   intro.Rmd episodes/intro.Rmd   solution   div-4-solution  47     TRUE
#| div-5-solution   intro.Rmd episodes/intro.Rmd   solution   div-5-solution  60     TRUE
#| div-6-keypoints  intro.Rmd episodes/intro.Rmd  keypoints  div-6-keypoints  90     TRUE
#| div-1-instructor  setup.md  learners/setup.md instructor div-1-instructor   6     TRUE
#| div-2-solution    setup.md  learners/setup.md   solution   div-2-solution  14     TRUE
#| div-3-solution    setup.md  learners/setup.md   solution   div-3-solution  22     TRUE
```

If there are invalid div names in the lesson, they will be reported. For
example, the lesson we have right now, does not have any improper fenced
div classes, but if we were to add an invalid fenced div (via the
`add_md()` method in the
[`tinkr::yarn()`](https://docs.ropensci.org/tinkr/reference/yarn.html)
class), we would be able to find out very quickly:

``` r

our_div <- c("::: exercise", "\nthis is an invalid div\n", ":::")
snd$episodes[["intro.Rmd"]]$add_md(our_div)
snd_divs <- snd$validate_divs()
#| ! There were errors in 1/10 fenced divs
#| ◌ The Carpentries Workbench knows the following div types callout, objectives, questions, challenge, prereq, checklist, solution, hint, discussion, testimonial, keypoints, instructor, spoiler, tab, group-tab, caution
#| 
#| ::warning file=episodes/intro.Rmd,line=NA:: [unknown div] exercise
```

You can see from the table that the `is_known` column now has a `FALSE`
value:

``` r

snd_divs
#|                   episodes               path        div         pb_label pos is_known
#| div-1-exercise   intro.Rmd episodes/intro.Rmd   exercise   div-1-exercise  NA    FALSE
#| div-2-questions  intro.Rmd episodes/intro.Rmd  questions  div-2-questions   7     TRUE
#| div-3-objectives intro.Rmd episodes/intro.Rmd objectives div-3-objectives  13     TRUE
#| div-4-challenge  intro.Rmd episodes/intro.Rmd  challenge  div-4-challenge  37     TRUE
#| div-5-solution   intro.Rmd episodes/intro.Rmd   solution   div-5-solution  47     TRUE
#| div-6-solution   intro.Rmd episodes/intro.Rmd   solution   div-6-solution  60     TRUE
#| div-7-keypoints  intro.Rmd episodes/intro.Rmd  keypoints  div-7-keypoints  90     TRUE
#| div-1-instructor  setup.md  learners/setup.md instructor div-1-instructor   6     TRUE
#| div-2-solution    setup.md  learners/setup.md   solution   div-2-solution  14     TRUE
#| div-3-solution    setup.md  learners/setup.md   solution   div-3-solution  22     TRUE
```

## Heading Validation

**NOTE: We are rethinking the exact specifications for heading
validation at this time**

Validation of headings operate similarly to links as it produces a data
frame along with the message output that can be further inspected and
manipulated. You can find out more by accessing the help documentation
for `validate_headings` by typing
[`?validate_headings`](https://carpentries.github.io/pegboard/dev/reference/validate_headings.md)
in your R console.

``` r

headings <- lsn$validate_headings(verbose = TRUE)
#| ── Heading structure ───────────────────────────────────────────────────────────────────────────────
#| # Episode: "For Loops" 
#| ├─## A for loop executes commands once for each value in a collection. 
#| ├─## A for loop is made up of a collection, a loop variable, and a body. 
#| ├─## The first line of the for loop must end with a colon, and the body must be indented. 
#| ├─## Loop variables can be called anything. 
#| ├─## The body of a loop can contain many statements. 
#| ├─## Use range to iterate over a sequence of numbers. 
#| ├─## The Accumulator pattern turns many values into one. 
#| ├─## Classifying Errors 
#| ├─## Solution  (duplicated)
#| ├─## Tracing Execution 
#| ├─## Solution  (duplicated)
#| ├─## Reversing a String 
#| ├─## Solution  (duplicated)
#| ├─## Practice Accumulating 
#| ├─## Solution  (duplicated)
#| ├─## Solution  (duplicated)
#| ├─## Solution  (duplicated)
#| ├─## Solution  (duplicated)
#| ├─## Cumulative Sum 
#| ├─## Solution  (duplicated)
#| ├─## Identifying Variable Name Errors 
#| ├─## Solution  (duplicated)
#| ├─## Identifying Item Errors 
#| └─## Solution  (duplicated)
#| ────────────────────────────────────────────────────────────────────────────────────────────────────
#| ── Heading structure ───────────────────────────────────────────────────────────────────────────────
#| # Episode: "Looping Over Data Sets" 
#| ├─## Use a for loop to process files given a list of their names. 
#| ├─## Use glob.glob to find sets of files whose names match a pattern. 
#| ├─## Use glob and for to process batches of files. 
#| ├─## Determining Matches 
#| ├─## Solution  (duplicated)
#| ├─## Minimum File Size 
#| ├─## Solution  (duplicated)
#| ├─## Comparing Data 
#| └─## Solution  (duplicated)
#|   └─### ZNK test links and images
#| ────────────────────────────────────────────────────────────────────────────────────────────────────
#| ! There were errors in 13/37 headings
#| ◌ Headings must be unique
#| <https://webaim.org/techniques/semanticstructure/#headings>
#| 
#| ::warning file=_episodes/12-for-loops.md,line=183:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=200:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=227:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=252:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=270:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=289:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=305:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=336:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=371:: (duplicated)
#| ::warning file=_episodes/12-for-loops.md,line=400:: (duplicated)
#| ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
#| ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
#| ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)
str(headings, max.level = 1)
#| 'data.frame':    37 obs. of  11 variables:
#|  $ episodes                     : chr  "12-for-loops.md" "12-for-loops.md" "12-for-loops.md" "12-"..
#|  $ heading                      : chr  "A for loop executes commands once for each value in a col"..
#|  $ level                        : int  2 2 2 2 2 2 2 2 2 2 ...
#|  $ pos                          : int  21 54 67 101 113 133 155 180 183 189 ...
#|  $ node                         :List of 37
#|   ..- attr(*, "class")= chr "AsIs"
#|  $ first_heading_is_second_level: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ greater_than_first_level     : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ are_sequential               : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ have_names                   : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ are_unique                   : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#|  $ path                         : chr  "_episodes/12-for-loops.md" "_episodes/12-for-loops.md" "_"..
```

This particular data frame has fewer rows because there are fewer moving
parts to headings than links, but they are indeed important. The process
for getting the subset of invalid headings is similar: use the
`heading_tests` vector from pegboard to subset the rows that failed:

``` r

# get the subset of rows that did not pass all the tests
invalid <- !apply(headings[names(heading_tests)], MARGIN = 1L, all)
# return the nodes
headings$node[invalid]
#| [[1]]
#| {xml_node}
#| <heading sourcepos="163:5-163:15" level="2">
#| [1] <text sourcepos="163:8-163:15" xml:space="preserve">Solution</text>
#| 
#| [[2]]
#| {xml_node}
#| <heading sourcepos="180:5-180:15" level="2">
#| [1] <text sourcepos="180:8-180:15" xml:space="preserve">Solution</text>
#| 
#| [[3]]
#| {xml_node}
#| <heading sourcepos="207:5-207:15" level="2">
#| [1] <text sourcepos="207:8-207:15" xml:space="preserve">Solution</text>
#| 
#| [[4]]
#| {xml_node}
#| <heading sourcepos="232:5-232:15" level="2">
#| [1] <text sourcepos="232:8-232:15" xml:space="preserve">Solution</text>
#| 
#| [[5]]
#| {xml_node}
#| <heading sourcepos="250:5-250:15" level="2">
#| [1] <text sourcepos="250:8-250:15" xml:space="preserve">Solution</text>
#| 
#| [[6]]
#| {xml_node}
#| <heading sourcepos="269:5-269:15" level="2">
#| [1] <text sourcepos="269:8-269:15" xml:space="preserve">Solution</text>
#| 
#| [[7]]
#| {xml_node}
#| <heading sourcepos="285:5-285:15" level="2">
#| [1] <text sourcepos="285:8-285:15" xml:space="preserve">Solution</text>
#| 
#| [[8]]
#| {xml_node}
#| <heading sourcepos="316:5-316:15" level="2">
#| [1] <text sourcepos="316:8-316:15" xml:space="preserve">Solution</text>
#| 
#| [[9]]
#| {xml_node}
#| <heading sourcepos="351:5-351:15" level="2">
#| [1] <text sourcepos="351:8-351:15" xml:space="preserve">Solution</text>
#| 
#| [[10]]
#| {xml_node}
#| <heading sourcepos="380:5-380:15" level="2">
#| [1] <text sourcepos="380:8-380:15" xml:space="preserve">Solution</text>
#| 
#| [[11]]
#| {xml_node}
#| <heading sourcepos="104:5-104:15" level="2">
#| [1] <text sourcepos="104:8-104:15" xml:space="preserve">Solution</text>
#| 
#| [[12]]
#| {xml_node}
#| <heading sourcepos="128:5-128:15" level="2">
#| [1] <text sourcepos="128:8-128:15" xml:space="preserve">Solution</text>
#| 
#| [[13]]
#| {xml_node}
#| <heading sourcepos="147:5-147:15" level="2">
#| [1] <text sourcepos="147:8-147:15" xml:space="preserve">Solution</text>
```

## Internal testing

For testing, we have created some documents that have extreme cases of
links and headings that failed to show all the features of our examples:

``` r

ex  <- here::here("tests/testthat/examples")
lnk <- Episode$new(fs::path(ex, "link-test.md"))
hd  <- Episode$new(fs::path(ex, "validation-headings.md"))
```

### Links

The links example has *several* mistakes covering our possibilities:

``` r

lnk$show()
#| ---
#| title: Link Tests
#| ---
#| 
#| ## Internal links {#internal}
#| 
#| ### :crystal\_ball: Heading with Emoji
#| 
#| ### Heading with long name that has a label {#label-1}
#| 
#| ### Another heading with a long name that has a label {#label-2}
#| 
#| ### Heading with a class, but no label {.challenge}
#| 
#| ### Heading with class and a label {.solution #label-3}
#| 
#| This is a [link to the Heading with Emoji](#heading-with-emoji) and a [link to
#| label 1][rel-label-1] and a [link](#label-2) and [this link](#label-2).
#| 
#| This link goes to [the heading with class and a label](#label-3).
#| 
#| This link is [absolutely incorrect](#bad-fragment)
#| 
#| This [relative link goes to label 1][rel-label-1]
#| 
#| ## Cross-Lesson links {#cross-lesson}
#| 
#| This [link will go to the image test][rel-image], but [this link is
#| wrong](incorrect-link.html).
#| 
#| [This link also goes to image test](image-test) and [*this* link goes to
#| image test as well](./image-test.html)
#| [This link also goes to image test, but with a slash](image-test/), though this
#| may not work for us because it implies that there is an `index.html` hiding in
#| there.
#| 
#| This link [should be a relative link](rel-image).
#| This link [is a relative link that works][rel-image]
#| 
#| This link [goes to an internal nested file](files/thing.txt), but this internal
#| link [does not exist](files/ohno.txt)
#| 
#| ## Invalid protocols
#| 
#| This is a [link with a typo](gttps://example.com)
#| 
#| This is a [bitcoin link](bitcoin:FAKE-EXAMPLE)
#| and this is a [javascript example](javascript:alert%28%27JavaScript%20Link!%27%29),
#| both of which should never appear in lessons.
#| 
#| ## HTTP links
#| 
#| This [link uses http, which is no bueno](http://example.com)
#| 
#| ## Link text
#| 
#| If we have [link text that is informative](https://example.com/link-text#good),
#| it will pass.
#| 
#| If we have links like
#| [this][bad-link-text]
#| [link][bad-link-text]
#| [this link][bad-link-text]
#| [a link][bad-link-text]
#| [link to][bad-link-text]
#| [here][bad-link-text]
#| [here for][bad-link-text]
#| [click here for][bad-link-text]
#| [over here for][bad-link-text]
#| [more][bad-link-text]
#| [more about][bad-link-text]
#| [for more about][bad-link-text]
#| [for more info about][bad-link-text]
#| [for more information about][bad-link-text]
#| [read more about][bad-link-text]
#| [read more][bad-link-text]
#| [read on][bad-link-text]
#| [read on about][bad-link-text],
#| [a][bad-link-text],
#| [][bad-link-text]
#| they will fail, but [link text that is descriptive][1], albiet with a numeric
#| anchor will work.
#| 
#| ## Spans
#| 
#| This is an [internal span]{#spanny style='color: red'} that we might want to
#| link to.
#| 
#| [definition list]{#deffy .anchored}
#| : This is a definition list item that has an anchor
#| 
#| We have examples of [spans](#spanny) and [definition lists](#deffy).
#| We also have an example of a [missing anchor pointing to float](#floaty)
#| 
#| [rel-label-1]: #label-1
#| [rel-image]: image-test.html
#| [bad-link-text]: https://example.com/link-text#bad
#| [1]: https://example.com/link-text#descriptive
lnk$validate_links()
#| ! There were errors in 31/45 links
#| ◌ Links must have a known URL protocol (e.g. https, ftp, mailto). See <https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return> for a list of acceptable protocols.
#| ◌ Links must use HTTPS <https://https.cio.gov/everything/>
#| ◌ Some link anchors for relative links (e.g. [anchor]: link) are missing
#| ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
#| ◌ Some links were incorrectly formatted
#| ◌ Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>
#| ◌ Avoid single-letter or missing link text <https://webaim.org/techniques/hypertext/link_text#link_length>
#| 
#| ::warning file=link-test.md,line=18:: [uninformative link text]: [link](#label-2)
#| ::warning file=link-test.md,line=18:: [uninformative link text]: [this link](#label-2)
#| ::warning file=link-test.md,line=22:: [missing anchor]: [absolutely incorrect](#bad-fragment)
#| ::warning file=link-test.md,line=29:: [missing file]: [this link is wrong](incorrect-link.html)
#| ::warning file=link-test.md,line=37:: [incorrect formatting]: [should be a relative link][rel-image] -> [should be a relative link](rel-image)
#| ::warning file=link-test.md,line=41:: [missing file]: [does not exist](files/ohno.txt)
#| ::warning file=link-test.md,line=45:: [invalid protocol]: gttps [needs HTTPS]: [link with a typo](gttps://example.com)
#| ::warning file=link-test.md,line=47:: [invalid protocol]: bitcoin [needs HTTPS]: [bitcoin link](bitcoin:FAKE-EXAMPLE)
#| ::warning file=link-test.md,line=48:: [invalid protocol]: javascript [needs HTTPS]: [javascript example](javascript:alert%28%27JavaScript%20Link!%27%29)
#| ::warning file=link-test.md,line=53:: [needs HTTPS]: [link uses http, which is no bueno](http://example.com)
#| ::warning file=link-test.md,line=61:: [uninformative link text]: [this](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=62:: [uninformative link text]: [link](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=63:: [uninformative link text]: [this link](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=64:: [uninformative link text]: [a link](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=65:: [uninformative link text]: [link to](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=66:: [uninformative link text]: [here](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=67:: [uninformative link text]: [here for](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=68:: [uninformative link text]: [click here for](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=69:: [uninformative link text]: [over here for](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=70:: [uninformative link text]: [more](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=71:: [uninformative link text]: [more about](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=72:: [uninformative link text]: [for more about](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=73:: [uninformative link text]: [for more info about](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=74:: [uninformative link text]: [for more information about](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=75:: [uninformative link text]: [read more about](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=76:: [uninformative link text]: [read more](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=77:: [uninformative link text]: [read on](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=78:: [uninformative link text]: [read on about](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=79:: [link text too short]: [a](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=80:: [link text too short]: [](https://example.com/link-text#bad)
#| ::warning file=link-test.md,line=93:: [missing anchor]: [missing anchor pointing to float](#floaty)
```

### Headings

The headings example also has several mistakes, and demonstrates the
value of having a visual heading tree displayed on output when
`verbose = TRUE`

``` r

hd$show()
#| ---
#| title: "Errors in Headings"
#| ---
#| 
#| # First heading throws an error
#| 
#| ### This heading throws another error
#| 
#| ## This heading is okay
#| 
#| ## This heading is okay
#| 
#| The above heading is not okay
#| 
#| ### This heading is okay
#| 
#| ## 
#| 
#| The abve heading doesn't make sense
#| 
#| ## This last heading is okay
hd$validate_headings(verbose = TRUE)
#| ! There were errors in 5/7 headings
#| ◌ First heading must be level 2
#| ◌ Level 1 headings are not allowed
#| ◌ Headings must be sequential
#| ◌ Headings must be named
#| ◌ Headings must be unique
#| <https://webaim.org/techniques/semanticstructure/#headings>
#| 
#| ::warning file=validation-headings.md,line=5:: (must be level 2) (first level heading)
#| ::warning file=validation-headings.md,line=7:: (non-sequential heading jump)
#| ::warning file=validation-headings.md,line=9:: (duplicated)
#| ::warning file=validation-headings.md,line=11:: (duplicated)
#| ::warning file=validation-headings.md,line=18:: (no name)
#| ── Heading structure ───────────────────────────────────────────────────────────────────────────────
#| # Episode: "Errors in Headings" 
#| ├─# First heading throws an error  (must be level 2) (first level heading)
#| │ ├─### This heading throws another error  (non-sequential heading jump)
#| │ ├─## This heading is okay  (duplicated)
#| │ ├─## This heading is okay  (duplicated)
#| │ │ └─### This heading is okay 
#| │ ├─##   (no name)
#| │ └─## This last heading is okay
#| ────────────────────────────────────────────────────────────────────────────────────────────────────
```
