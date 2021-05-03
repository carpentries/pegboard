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
