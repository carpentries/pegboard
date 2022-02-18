# pegboard 0.2.1

## MISC

 - The inline messages for link validation errors are more verbose (@tobyhodges, #79)

# pegboard 0.2.0

## NEW FEATURES

 - `validate_divs()` will validate that the divs in an Episode are ones we
   expect.

# pegboard 0.1.1

## MISC

 - Correct mis-attribution for LICENSE

# pegboard 0.1.0

This is a soft release of {pegboard} to coincide with the first announcement of
The Carpentries Workbench.

## IMPORTS

 - {lifecycle} is no longer an imported package. We were not using it, so it
   makes more sense to leave it out in production.

## BUG FIX

 - `get_list_block()` will now select the last block if there are multiple 
  "keypoints" blocks (@zkamvar, #75)
 - `get_list_block()` will now throw a warning if a block does not contain any
   list elements (@zkamvar, #74)

# pegboard 0.0.0.9034

## BUG FIX

 - `get_stylesheet()` now escapes spaces and normalizes the windows path to the
   tinkr stylesheet before embedding it (@zkamvar, #72)

# pegboard 0.0.0.9033

## BUG FIX

 - the `$move_*()` methods no longer create a redundant heading in the fenced
   div (@zkamvar, #26)

## DOCUMENTATION

 - The pkgdown site has been updated to be more complete.
 - the div family of functions uses the roxygen family tag to be more complete.

# pegboard 0.0.0.9032

## BUG FIX

 - The `$use_sandpaper()` method for Episode objects will now remove "root" and
   "layout" yaml directives (@zkamvar, #68)

# pegboard 0.0.0.9031

## BUG FIX

Images that had attributes added are now post-processed in `use_sandpaper()` and
will retain their original attributes. 

# pegboard 0.0.0.9030

## BUG FIX

 - replace `relative_root_path` with nothing instead on `.`, which fixes a bug
   introduced with 0.0.0.9028.

# pegboard 0.0.0.9029

## BUG FIX

 - fix for jekyll-based lessons using `base_path.html` to define 
  `relative_root_path` are now corrected to no longer include those directives
  for links.

# pegboard 0.0.0.9028

## BUG FIX

 - fix in jekyll-based lesson auto-detection of RMD lessons will not error
   for pure Rmd lessons

# pegboard 0.0.0.9027

## NEW FEATURES

 - Jekyll-based lessons will now auto-detect and read in R Markdown content if
   it exists. The `rmd` flag for the Lesson initializer now does nothing.

# pegboard 0.0.0.9026

## BUG FIX

- We now use the `_config.yml` file to parse site-specific liquid template links
  to fix #60

# pegboard 0.0.0.9025

## BUG FIX

- RMarkdown episodes that had a setup chunk without specifying `includes` are 
  now considered to have valid setup chunks and can have those chunks converted.

# pegboard 0.0.0.9024

## NEW FEATURES

- `Episode$handout()` will create trimmed-down R Markdown document with only
  challenge blocks and code chunks with `purl = TRUE`, that can be passed to
  `knitr::purl()` for processing into an R code handout. 
- `Lesson$handout()` will create a concatenated version of `Episode$handout()`.

# pegboard 0.0.0.9023

## MISC

- validation messages have been revamped to be more consistent across messages.
- All validation methods in `Episode` and `Lesson` now return data frames that 
  contain detailed information for each element and what tests were passed and
  what were failed for downstream analysis. Importantly, they all will contain
  a column called "node", which points to the exact XML node containing the
  link/image/heading for inspection/manipulation.
- validation reporting is no longer grouped by error
- link validation information has been switched to show the error message and
  then the problematic aspect/fix
- heading validation now works on continuous integration
- these functions no longer rely on dplyr being installed

# pegboard 0.0.0.9022

## NEW FEATURES

- The `Episode` class now gains the `$confirm_sandpaper()` method to bypass the
  assumption that all Episodes start as kramdown-formatted documents and will
  attempt to label divs in the episode (with a warning if there is no success).
- The `Lesson` class will now run the `$confirm_sandpaper()` method for all
  markdown files if `jekyll = FALSE`. 
- `Lesson$new()` will now default to the current working directory.

## MISC

- The internal `get_list_block()` will no longer auto-label divs. 

# pegboard 0.0.0.9021

## NEW FEATURES

- Link validation now checks for more general uninformative link text and empty
  links (@zkamvar, #49)
- `make_link_table()` will treat linebreaks in link text as a space character.

# pegboard 0.0.0.9020

## NEW FEATURES

- The `Lesson` class now has the `$validate_links()` and `$validate_headings()`
  methods. (@zkamvar, #48)

# pegboard 0.0.0.9019

NOTE: All of these are from (@zkamvar, #44)

## NEW FEATURES

- The Episode class now has the `$links` and `$images` active bindings that
  extracts the links and images (markdown and HTML) from the document.
- `make_link_table()` creates a table of links parsed via `xml2::url_parse()`
  with additional information about caption and alternative text (for images).
- The Episode class now has the `$validate_links()` method, which will validate
  links and images for common errors such as not using https and unresolved
  relative links. 
- `Episode$use_sandpaper()` now converts images to use alt text over captions.
  Images that had `![alt](link)` are converted to `![](link){alt='alt'}` because
  pandoc uses everything in square brackets to be caption text. NOTE: this now
  makes a copy of the XML document. 

## BUG FIXES

- `Episode$new()` gains the argument `fix_liquid`, which fixes liquid variables
  in relative links before they are passed to {tinkr} 
  (https://github.com/carpentries/pegboard/issues/46)
- Post-processed links via `fix_links()` retains their `sourcepos` attribute
  (fixed in e5508cc9c9a3821381293bdac12647edfbc0608e).
- `Episode$lesson` no longer assumes that the episode is inside a sub-folder
  (fixed in 63432ef83ecc41a6aab53fe768e8eaec107278d5).

# pegboard 0.0.0.9018

- `Episode$validate_headings()` now properly displays duplicated headings.
  (@zkamvar, #45)

# pegboard 0.0.0.9017

 - The Lesson class now respects the order of the contents in `config.yaml` 
   (#42 via #43)

# pegboard 0.0.0.9016

 - the Episode class now has the `$headings` active binding and the 
   `$validate_headings()` method to validate headings (#23 via #41)
 - We now use {testthat} 3e for our tests
 - Cloning an Episode object is now more reliable

# pegboard 0.0.0.9015

 - the Episode class is now a sub-class of the tinkr::yarn class and gains the
   `show()`, `head()`, `tail()`, and `protect_math()` methods.

# pegboard 0.0.0.9014

 - Innocent block quotes that have not been sullied by the ruthless kramdown
   postfix operators are kept as block quotes instead of failing on `$unblock()`
   conversion. 

# pegboard 0.0.0.9013

 - The omnipresent `{% include links.md %}` is now removed on sandpaper
   conversion.

# pegboard 0.0.0.9012

 - Lesson class will now work with {sandpaper} (#24) with a new parameter `jekyll`
 - Episode class gains new slot called `extras` to handle the sandpaper
   non-episodic things
 - A better error message is thrown with `Episode$label_divs()`.

# pegboard 0.0.0.9011

 - Swap {git2r} dependency for {gert}, which has a smoother interface and matches
   with the dependencies of {sandpaper}.

# pegboard 0.0.0.9010

 - Missing questions, objectives, or keypoints will no longer fail with a 
   cryptic error. An informative warning will be thrown and an empty character
   vector will be returned. This addresses an issue in {sandpaper}:
   https://github.com/carpentries/sandpaper/issues/79
 - The URI for pegboard tags is now "http://carpentries.org/pegboard/", which
   fixes https://github.com/carpentries/pegboard/issues/18

# pegboard 0.0.0.9009

 - Several Bug fixes, see https://github.com/carpentries/pegboard/pull/21 for
   details.
 - Travis hopefully banished

# pegboard 0.0.0.9008

 - `$label_divs()` no longer modifies the fenced divs.
 - `@dtag` labels attached to `html_block` and `paragraph` elements are now 
   replaced by `<dtag>` elements that live within a custom namespace called
   "pegboard". This allows us to avoid manipulating the document paragraph
   structure in the case of fenced divs.
 - `$get_divs()` now includes the div tags/fences in the output.
 - Internally, namespace handling has gotten marginally better where the 
   default namespace prefix is modified to `md:`. 
 - fenced divs are no longer manipulated on labelling.
 - A new test expectation, `expect_moved_yaml()` tests that a yaml element
   was successfully moved to the body of the document. 

# pegboard 0.0.0.9007

 - `$keypoints` and `$objectives` now are available and act like `$questions`
 - The `$move_*()` methods will now add an h2 header to the block
 - The `$move_*()` methods will use pandoc syntax instead of html div blocks. 
 - Internal changes to creation of elements no longer relies on complex
   namespace juggling

# pegboard 0.0.0.9006

 - `$label_divs()` method now will label any div tags in the episode
 - `$move_*` methods will now auto-label div tags
 - `$questions` field now returns the questions block or yaml header as a
   character vector.

# pegboard 0.0.0.9005

 - pandoc-style fenced divs are now processed the same as native div tags
 - `@dtag` labels are now in the format `div-{n}-{class}` where {n} is the 
   sequential number in the document and {class} is the type of div.
 - labelling of `@dtags` is more straightforward and will label the tags 
   sequentially. 

# pegboard 0.0.0.9004

The changes in this version largely are enhancements for handling div tags
and conversion. See #9 for details

 - `$unblock()` defaults to converting to div tags unless `$use_sandpaper()` has been called. 
 - `$unblock()` will auto-name ALL the divs with {class}-div-{number}
 - `$move_*` functions will now name the html_blocks
 - `$get_divs()` returns div tags in a named list
 - `$challenges` will now find either blocks, divs or code, depending on
   the mutations
 - `$soltuions` same as challenges (see above)
 - `$use_dovetail()` will warn the user if the body is empty
 - `$use_sandpaper()` will do the same


# pegboard 0.0.0.9003

Jekyll-specific and relative links are now converted as part of `use_sandpaper()`. 

## NEW FUNCTION

* `fix_sandpaper_links()` will fix relative paths and jekyll-specific links 
  inside of lessons that have not yet otherwise been converted.

# pegboard 0.0.0.9002

This version introduces conversions that work together and can be chained to
convert an episode from the old Jekyll style to the new {sandpaper} style. 
Things are still very much in development though.

* conversions for sandpaper and dovetail are clearly separated
* the Episode class understands what conversions have been performed with a
  private logical vector that tracks changes.
* pkgdown site is now built automatically from github actions

## NEW EPISODE METHODS

* `use_dovetail()` inserts a setup chunk at the top of the file
* `use_sandpaper()` converts chunks from their liquid/kramdown syntax to the 
  commonmark or RMD syntax
* `move_*()` will generate a dovetail block or just a plain div block depending
  on whether or not `use_dovetail()` has been called.
* `remove_output()` does what it says on the tin
* `remove_error()` removes error code blocks
* `$output` and `$error` can now grab output and error chunks that were converted
  via `use_sandpaper()`

# pegboard 0.0.0.9001

* Added a `NEWS.md` file to track changes to the package.
* Dependencies on {yaml} and {commonmark} now explicit
* Added methods to Episode class to move questions, objectives, and keypoints
  out of the YAML and into the lesson body.
