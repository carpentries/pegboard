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
