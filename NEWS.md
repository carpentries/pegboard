# pegboard 0.7.0 (unreleased)

This release introduces automated processing of {knitr} child files, which
enables them to be automatically available for validation and processing.

NEW FEATURES
------------

* `Episode` class objects gain the `children`, `parents`, and `build_parents`
  fields which will contain the known relationships between files. Both
  `children` and `parents` represent _immediate_ relationships while 
  `build_parents` represent the most distant ancestor of the object that would
  trigger it to build. Note that the `parents` fields are only populated for
  an `Episode` in the context of a `Lesson` object. 
- `Lesson` class objects gain the `children` field which is a list that stores
  `Episode` objects derived from child files. 
- `Episode` objects gain the `$has_parents` active binding reporting if the
  object has a parent object. This is only used in the context of a `Lesson`.
- Both `Episode` and `Lesson` objects gain the `$has_children` active binding,
  reporting if there are any child episodes in the lesson or episode. 
- `Lesson` objects gain the `$trace_lineage()` method to find _all child
  files_ from the source path of a given episode. 

# pegboard 0.6.1 (2023-09-06)

NEW FEATURES
------------

* `$validate_divs()` method now recognises the `spoiler` class of fenced divs
  which allow optional/expandable items that are not automatically shown to the
  learner (implemented: @tobyhodges, #134)

# pegboard 0.6.0 (2023-08-29)

NEW FEATURES
------------

- Workshop overview pages are now able to be processed into `Lesson` objects.
  For Jekyll- based lessons, the directory name must end with `-workshop` (as
  is the standard for workshop overview lessons without episodes), for
  sandpaper- based lessons, the `config.yaml` file must contain the `overview:
  true` tag (reported: @zkamvar, #118; fixed: @zkamvar, #132, reviewed by
  @klbarnes20). These pages are indicated by the `$overview` field in the
  `Lesson` object. For lessons that are not workshop overview lessons, nothing
  will change.

BUG FIX
-------

- Lessons that underwent an incomplete conversion from Jekyll to sandpaper will
  now have a more appropriate error message provided.

# pegboard 0.5.3 (2023-07-08)

BUG FIX
-------

* `$validate_links()` no longer throws an error when there are HTML images
  embedded in comments (reported: @beastyblacksmith, #130; fixed: @zkamvar,
  #131, reviewed by @ErinBecker)
* (transition) `$move_objectives()` and `$move_questions()` methods no longer
  place these blocks as the _second_ element in the markdown. This was
  originally implemented when we thought {dovetail} would be our solution to
  the lesson infrastructure (and thus needed a setup chunk before any blocks).
* (transition) liquid-formatted links with markdown inside them are now parsed
  correctly. This leads lessons to be more accurately transitioned to use
  {sandpaper} (reported: @uschille,
  https://github.com/carpentries/lesson-transition/issues/46; fixed: @zkamvar,
  #121)
- (transition) images with kramdown attributes that are on a new line are now
  more accurately transitioned to use {sandpaper} (reported: @uschille,
  https://github.com/carpentries/lesson-transition/issues/46; fixed: @zkamvar,
  #121)

TESTS
-----

* A failing test due to the workbench transition was fixed (reported:
  @zkamvar, #125; fixed: @zkamvar, #127)


# pegboard 0.5.2 (2023-04-05)

BUG FIX
-------

* The README file is no longer run through validation as it is not generally a
  part of the website and more often than not, creates distractions.

# pegboard 0.5.1 (2023-03-31)

BUG FIX
-------

* Fenced divs with attributes are now properly parsed (@zkamvar, #115).

# pegboard 0.5.0 (2023-03-31)

NEW FEATURES
------------

* `Lesson` object validators now validate non-episode files
  (reported: @zkamvar #110; fixed: @zkamvar #113).
- `$validate_links()` will now respect links to anchors in spans.
* validators will no longer truncate on GitHub actions (reported: @zkamvar #111,
  fixed: @zkamvar: #114).
* validators will provide full context for invalid links (not just link or
  text, but link with text).

DEPENDENCIES
------------

* `{tinkr}`'s minimum version has been set to 0.2.0 to recognise the release to
  CRAN and bring in new bugfixes.

# pegboard 0.4.3 (2023-01-26)

NEW FEATURES
------------

* `$validate_links()` now checks if the URL protocol in an external link matches
  a known list of protocols. Those that do not match (e.g. `javascript:` and
  `bitcoin:`) will be flagged. (@zkamvar #109)

BUG FIX
-------

* A bug where attributes following an image would cause missing alt text to not
  be reported was fixed. (discovered: @dpshelio and @karenword; 
  reported: @zkamvar #106; fixed: @zkamvar #108). This fix also makes the alt
  text parsing and validation more robust
- A bug where an unknown protocol was not recognised as invalid was fixed.
  (discovered: @ndporter; reported: @zkamvar, #107; fixed: @zkamvar, #109)

INTERNALS
---------

* New internal function `find_between_nodes()` will get all nodes between two
  sibling nodes.

# pegboard 0.4.2 (2023-01-10)

## TESTS

* A test that depended on an upstream resource was once again fixed.
* Tests were modified to account for a new case for image fixing.

## DOCUMENTATION

* Internal `fix_links()` function has improved documentation.

# pegboard 0.4.1 (2023-01-06)

## TESTS

* A test that dependend on an upstream resource was fixed.

# pegboard 0.4.0 (2023-01-06)

## DEPENDENCIES

* The {tinkr} minimum version has been upgraded to 0.1.0.9000 to address the
  square bracket protection implemented in that version.

## BUG FIX

* Jekyll links with spaces are once again processed correctly. They were broken
  in the update to {tinkr} (reported: @zkamvar, #100; fixed: @zkamvar, #102)

## MISC

* GitHub workflows have been updated to run weekly.


# pegboard 0.3.2 (2022-09-14)

## DEPENDENCIES

 - Soft dependencty {cli} has been recommended at 0.3.4 to prevent reporting
   issues (see #97)
 - Soft dependencies ggraph, ggplot2, and tidygraph have been removed. These
   dependencies were only needed for producing a now-out-of-date survey document

# pegboard 0.3.1 (2022-08-16)

## MISC

In preparation for {tinkr} 0.1.0, which changes the path of the default
stylesheet, we are using the `tinkr::stylesheet()` convenience function to
access it. 

# pegboard 0.3.0 (2022-05-25)

## NEW FEATURES

### Episode class objects

 - `$summary()` method which can summarise counts of elements in the episode.
 - fixes for `$error` and `$output` active bindings
 - new `$warning` active binding that will show code blocks with the `warning`
   class.

### Lesson class objects

 - new public field "built" that will contain XML representations of 
   markdown files built from RMarkdown files in sandpaper lessons.
 - new public field "sandpaper" is a boolean that indicates if a lesson can be
   built with sandpaper.
 - new `$load_built()` method will load the built files if they exist in a
   sandpaper lesson.
 - new `$get()` method which will get any element from any Episode class object
   contained within.
 - new `$summary()` method which will call the `$summary()` method for any
   Episode class object.

### Messages

 - `muffle_messages()` is an internal function that will muffle any messages
   that originate from the {cli} or {pegboard} packages.
 - If the {cli} package is not available, messages will have the class of
   `pbMessage`, which will allow end users/package authors to catch and
   manipulate any messages that originate from {pegboard}

# pegboard 0.2.7 (unreleased, no user-visible changes)

## TRANSFORMATION

 - `make_pandoc_alt()` (an internal converter function) will no longer create alt
   text from a caption if it contains a URL. This messes with the downstream
   validation of image links.
 - `fix_sandpaper_links()` now also fixes links that use `{{ site.baseurl }}`.

# pegboard 0.2.6 (2022-05-11)

## BUG FIX

 - `fix_links()` now processes links in headers and links with unescaped ampersands
    - internal function `text_to_links()` now processes unescaped ampersands
    - internal function `find_lesson_links()` no longer expects links to be 
      strictly in paragraph elements.

# pegboard 0.2.5 (2022-05-10)

## MISC

 - `validate_links()` will no longer flag `alt=""` as errors. These indicate
   decorative images. That being said, these should be rare in our lessons, but
   this is here just in case it's needed.
   Source: https://webaim.org/techniques/alttext/#decorative

# pegboard 0.2.4 (2022-02-25)

## DEPENDENCIES

 - The {fs} package needs to be >= 1.5.0 (#83, @sstevens2)

# pegboard 0.2.3 (2022-02-23)

## BUG FIX

 - footnotes with no trailing newline are no longer accidentally appended with
   relative link anchors when `getOption('sandpaper.links')` is not NULL.

# pegboard 0.2.2 (2022-02-23)

## NEW FEATURES

 - If `getOption("sandpaper.links")` is not NULL (in the context of a {sandpaper}
   lesson) and is a valid file, it will be appended to any file read in via 
   `Episode$new()`

## BUG FIX

 - `$validate_links()` no longer throws warnings about short or uninformative
   text for link anchors (@zkamvar, #81)

# pegboard 0.2.1 (2022-02-18)

## MISC

 - The inline messages for link validation errors are more verbose (@tobyhodges, #79)

# pegboard 0.2.0 (2022-02-17)

## NEW FEATURES

 - `validate_divs()` will validate that the divs in an Episode are ones we
   expect.

# pegboard 0.1.1 (2022-02-02)

## MISC

 - Correct mis-attribution for LICENSE

# pegboard 0.1.0 (2022-02-01)

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
