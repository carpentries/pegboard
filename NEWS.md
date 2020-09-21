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
