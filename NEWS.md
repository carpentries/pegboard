# pegboard 0.0.0.9002

This version introduces conversions that work together and can be chained to
convert an episode from the old Jekyll style to the new {sandpaper} style. 
Things are still very much in development though.

* Conversions for sandpaper and dovetail are clearly separated
* pkgdown site is now built automatically from github actions

## NEW EPISODE METHODS

* `use_dovetail()` inserts a setup chunk at the top of the file
* `use_sandpaper()` converts chunks from their liquid/kramdown syntax to the 
  commonmark or RMD syntax
* `move_*()` methods gain a `dovetail` boolean argument to indicate if they
  should generate a dovetail block or just a plain div block
* `remove_output()` does what it says on the tin
* `remove_error()` removes error code blocks

# pegboard 0.0.0.9001

* Added a `NEWS.md` file to track changes to the package.
* Dependencies on {yaml} and {commonmark} now explicit
* Added methods to Episode class to move questions, objectives, and keypoints
  out of the YAML and into the lesson body.
