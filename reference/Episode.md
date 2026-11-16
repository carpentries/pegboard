# Class representing XML source of a Carpentries episode

Wrapper around an xml document to manipulate and inspect Carpentries
episodes

## Details

The Episode class is a superclass of
[`tinkr::yarn()`](https://docs.ropensci.org/tinkr/reference/yarn.html),
which transforms (commonmark-formatted) Markdown to XML and back again.
The extension that the Episode class provides is support for both
[Pandoc](https://pandoc.org) and
[kramdown](https://kramdown.gettalong.org/) flavours of Markdown.

Read more about this class in
[`vignette("intro-episode", package = "pegboard")`](https://carpentries.github.io/pegboard/articles/intro-episode.md).

## Note

The current XLST spec for tinkr does not support kramdown, which the
Carpentries Episodes are styled with, thus some block tags will be
destructively modified in the conversion.

## Super class

[`tinkr::yarn`](https://docs.ropensci.org/tinkr/reference/yarn.html) -\>
`Episode`

## Public fields

- `children`:

  \[`character`\] a vector of absolute paths to child files if they
  exist.

- `parents`:

  \[`character`\] a vector of absolute paths to immediate parent files
  if they exist

- `build_parents`:

  \[`character`\] a vector of absolute paths to the final parent files
  that will trigger this child file to build

## Active bindings

- `show_problems`:

  \[`list`\] a list of all the problems that occurred in parsing the
  episode

- `headings`:

  \[`xml_nodeset`\] all headings in the document

- `links`:

  \[`xml_nodeset`\] all links (not images) in the document

- `images`:

  \[`xml_nodeset`\] all image sources in the document

- `tags`:

  \[`xml_nodeset`\] all the kramdown tags from the episode

- `questions`:

  \[`character`\] the questions from the episode

- `keypoints`:

  \[`character`\] the keypoints from the episode

- `objectives`:

  \[`character`\] the objectives from the episode

- `challenges`:

  \[`xml_nodeset`\] all the challenges blocks from the episode

- `solutions`:

  \[`xml_nodeset`\] all the solutions blocks from the episode

- `output`:

  \[`xml_nodeset`\] all the output blocks from the episode

- `error`:

  \[`xml_nodeset`\] all the error blocks from the episode

- `warning`:

  \[`xml_nodeset`\] all the warning blocks from the episode

- `code`:

  \[`xml_nodeset`\] all the code blocks from the episode

- `name`:

  \[`character`\] the name of the source file without the path

- `lesson`:

  \[`character`\] the path to the lesson where the episode is from

- `has_children`:

  \[`logical`\] an indicator of the presence of child files (`TRUE`) or
  their absence (`FALSE`)

- `has_parents`:

  \[`logical`\] an indicator of the presence of parent files (`TRUE`) or
  their absence (`FALSE`)

## Methods

### Public methods

- [`Episode$new()`](#method-Episode-new)

- [`Episode$confirm_sandpaper()`](#method-Episode-confirm_sandpaper)

- [`Episode$get_blocks()`](#method-Episode-get_blocks)

- [`Episode$get_images()`](#method-Episode-get_images)

- [`Episode$label_divs()`](#method-Episode-label_divs)

- [`Episode$get_divs()`](#method-Episode-get_divs)

- [`Episode$get_yaml()`](#method-Episode-get_yaml)

- [`Episode$use_dovetail()`](#method-Episode-use_dovetail)

- [`Episode$use_sandpaper()`](#method-Episode-use_sandpaper)

- [`Episode$remove_error()`](#method-Episode-remove_error)

- [`Episode$remove_output()`](#method-Episode-remove_output)

- [`Episode$move_objectives()`](#method-Episode-move_objectives)

- [`Episode$move_keypoints()`](#method-Episode-move_keypoints)

- [`Episode$move_questions()`](#method-Episode-move_questions)

- [`Episode$get_challenge_graph()`](#method-Episode-get_challenge_graph)

- [`Episode$show()`](#method-Episode-show)

- [`Episode$head()`](#method-Episode-head)

- [`Episode$tail()`](#method-Episode-tail)

- [`Episode$write()`](#method-Episode-write)

- [`Episode$handout()`](#method-Episode-handout)

- [`Episode$reset()`](#method-Episode-reset)

- [`Episode$isolate_blocks()`](#method-Episode-isolate_blocks)

- [`Episode$unblock()`](#method-Episode-unblock)

- [`Episode$summary()`](#method-Episode-summary)

- [`Episode$validate_headings()`](#method-Episode-validate_headings)

- [`Episode$validate_divs()`](#method-Episode-validate_divs)

- [`Episode$validate_links()`](#method-Episode-validate_links)

- [`Episode$clone()`](#method-Episode-clone)

Inherited methods

- [`tinkr::yarn$add_md()`](https://docs.ropensci.org/tinkr/reference/yarn.html#method-add_md)
- [`tinkr::yarn$get_protected()`](https://docs.ropensci.org/tinkr/reference/yarn.html#method-get_protected)
- [`tinkr::yarn$md_vec()`](https://docs.ropensci.org/tinkr/reference/yarn.html#method-md_vec)
- [`tinkr::yarn$protect_curly()`](https://docs.ropensci.org/tinkr/reference/yarn.html#method-protect_curly)
- [`tinkr::yarn$protect_math()`](https://docs.ropensci.org/tinkr/reference/yarn.html#method-protect_math)
- [`tinkr::yarn$protect_unescaped()`](https://docs.ropensci.org/tinkr/reference/yarn.html#method-protect_unescaped)

------------------------------------------------------------------------

### Method `new()`

Create a new Episode

#### Usage

    Episode$new(
      path = NULL,
      process_tags = TRUE,
      fix_links = TRUE,
      fix_liquid = FALSE,
      parents = NULL,
      ...
    )

#### Arguments

- `path`:

  \[`character`\] path to a markdown episode file on disk

- `process_tags`:

  \[`logical`\] if `TRUE` (default), kramdown tags will be processed
  into attributes of the parent nodes. If `FALSE`, these tags will be
  treated as text

- `fix_links`:

  \[`logical`\] if `TRUE` (default), links pointing to liquid tags (e.g.
  `{{ page.root }}`) and included links (those supplied by a call to
  `{\% import links.md \%}`) will be appropriately processed as valid
  links.

- `fix_liquid`:

  \[`logical`\] defaults to `FALSE`, which means data is immediately
  passed to
  [tinkr::yarn](https://docs.ropensci.org/tinkr/reference/yarn.html). If
  `TRUE`, all liquid variables in relative links have spaces removed to
  allow the commonmark parser to interpret them as links.

- `parents`:

  \[`list`\] a list of `Episode` objects that represent the immediate
  parents of this child

- `...`:

  arguments passed on to
  [tinkr::yarn](https://docs.ropensci.org/tinkr/reference/yarn.html) and
  [`tinkr::to_xml()`](https://docs.ropensci.org/tinkr/reference/to_xml.html)

#### Returns

A new Episode object with extracted XML data

#### Examples

    scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    scope$name
    scope$lesson
    scope$challenges

------------------------------------------------------------------------

### Method `confirm_sandpaper()`

enforce that the episode is a sandpaper episode withtout going through
the conversion steps. The default Episodes from pegboard were assumed to
be generated using Jekyll with kramdown syntax. This is a bit of a
kludge to bypass the normal checks for kramdown syntax and just assume
pandoc syntax

#### Usage

    Episode$confirm_sandpaper()

------------------------------------------------------------------------

### Method [`get_blocks()`](https://carpentries.github.io/pegboard/reference/get_blocks.md)

return all `block_quote` elements within the Episode

#### Usage

    Episode$get_blocks(type = NULL, level = 1L)

#### Arguments

- `type`:

  the type of block quote in the Jekyll syntax like ".challenge",
  ".discussion", or ".solution"

- `level`:

  the level of the block within the document. Defaults to `1`, which
  represents all of the block_quotes are not nested within any other
  block quotes. Increase the nubmer to increase the level of nesting.

#### Returns

\[`xml_nodeset`\] all the blocks from the episode with the given tag and
level.

#### Examples

    scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    # get all the challenges
    scope$get_blocks(".challenge")
    # get the solutions
    scope$get_blocks(".solution", level = 2)
    \dontrun{

      # download the source files for r-novice-gampinder into a Lesson object
      rng <- get_lesson("swcarpentry/r-novice-gapminder")
      dsp1 <- rng$episodes[["04-data-structures-part1.md"]]
      # There are 9 blocks in total
      dsp1$get_blocks()
      # One is a callout block
      dsp1$get_blocks(".callout")
      # One is a discussion block
      dsp1$get_blocks(".discussion")
      # Seven are Challenge blocks
      dsp1$get_blocks(".challenge")
      # There are eight solution blocks:
      dsp1$get_blocks(".solution", level = 2L)
    }

------------------------------------------------------------------------

### Method [`get_images()`](https://carpentries.github.io/pegboard/reference/get_images.md)

fetch the image sources and optionally process them for easier parsing.
The default version of this function is equivalent to the active binding
`$images`.

#### Usage

    Episode$get_images(process = FALSE)

#### Arguments

- `process`:

  if `TRUE`, images will be processed via the internal function
  [`process_images()`](https://carpentries.github.io/pegboard/reference/process_images.md),
  which will add the `alt` attribute, if available and extract img nodes
  from HTML blocks.

#### Returns

an `xml_nodelist`

#### Examples


    loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    loop$get_images()
    loop$get_images(process = TRUE)

------------------------------------------------------------------------

### Method `label_divs()`

label all the div elements within the Episode to extract them with
`$get_divs()`

#### Usage

    Episode$label_divs()

------------------------------------------------------------------------

### Method [`get_divs()`](https://carpentries.github.io/pegboard/reference/get_divs.md)

return all div elements within the Episode

#### Usage

    Episode$get_divs(type = NULL, include = FALSE)

#### Arguments

- `type`:

  the type of div tag (e.g. 'challenge' or 'solution')

- `include`:

  `\[logical\]` if `TRUE`, the div tags will be included in the output.
  Defaults to `FALSE`, which will only return the text between the div
  tags.

------------------------------------------------------------------------

### Method `get_yaml()`

Extract the yaml metadata from the episode

#### Usage

    Episode$get_yaml()

------------------------------------------------------------------------

### Method `use_dovetail()`

Ammend or add a setup code block to use `{dovetail}`

This will convert your lesson to use the dovetail R package for
processing specialized block quotes which will do two things:

1.  convert your lesson from md to Rmd

2.  add to your setup chunk the following code

        library('dovetail')
        source(dvt_opts())

If there is no setup chunk, one will be created. If there is a setup
chunk, then the `source` and `knitr_fig_path` calls will be removed.

#### Usage

    Episode$use_dovetail()

------------------------------------------------------------------------

### Method [`use_sandpaper()`](https://carpentries.github.io/pegboard/reference/use_sandpaper.md)

Use the sandpaper package for processing

This will convert your lesson to use the `{sandpaper}` R package for
processing the lesson instead of Jekyll (default). Doing this will have
the following effects:

1.  code blocks that were marked with liquid tags (e.g.
    `{: .language-r}` are converted to standard code blocks or Rmarkdown
    chunks (with language information at the top of the code block)

2.  If rmarkdown is used and the lesson contains python code,
    [`library('reticulate')`](https://rstudio.github.io/reticulate/)
    will be added to the setup chunk of the lesson.

#### Usage

    Episode$use_sandpaper(rmd = FALSE, yml = list())

#### Arguments

- `rmd`:

  if `TRUE`, lessons will be converted to RMarkdown documents

- `yml`:

  the list derived from the yml file for the episode

------------------------------------------------------------------------

### Method `remove_error()`

Remove error blocks

#### Usage

    Episode$remove_error()

------------------------------------------------------------------------

### Method `remove_output()`

Remove output blocks

#### Usage

    Episode$remove_output()

------------------------------------------------------------------------

### Method `move_objectives()`

move the objectives yaml item to the body

#### Usage

    Episode$move_objectives()

------------------------------------------------------------------------

### Method `move_keypoints()`

move the keypoints yaml item to the body

#### Usage

    Episode$move_keypoints()

------------------------------------------------------------------------

### Method `move_questions()`

move the questions yaml item to the body

#### Usage

    Episode$move_questions()

------------------------------------------------------------------------

### Method `get_challenge_graph()`

Create a graph of the top-level elements for the challenges.

#### Usage

    Episode$get_challenge_graph(recurse = TRUE)

#### Arguments

- `recurse`:

  if `TRUE` (default), the content of the solutions will be included in
  the graph; `FALSE` will keep the solutions as `block_quote` elements.

#### Returns

a data frame with four columns representing all the elements within the
challenges in the Episode:

- Block: The sequential number of the challenge block

- from: the inward elements

- to: the outward elements

- pos: the position in the markdown document

Note that there are three special node names:

- challenge: start or end of the challenge block

- solution: start of the solution block

- lesson: start of the lesson block

#### Examples

    scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    scope$get_challenge_graph()

------------------------------------------------------------------------

### Method `show()`

show the markdown contents on the screen

#### Usage

    Episode$show(n = TRUE)

#### Arguments

- `n`:

  a subset of elements to show, default TRUE for all lines

#### Returns

a character vector with one line for each line of output

#### Examples

    scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    scope$head()
    scope$tail()
    scope$show()

------------------------------------------------------------------------

### Method [`head()`](https://rdrr.io/r/utils/head.html)

show the first n lines of markdown contents on the screen

#### Usage

    Episode$head(n = 6L)

#### Arguments

- `n`:

  the number of lines to show from the top

#### Returns

a character vector with one line for each line of output

------------------------------------------------------------------------

### Method [`tail()`](https://rdrr.io/r/utils/head.html)

show the first n lines of markdown contents on the screen

#### Usage

    Episode$tail(n = 6L)

#### Arguments

- `n`:

  the number of lines to show from the top

#### Returns

a character vector with one line for each line of output

------------------------------------------------------------------------

### Method [`write()`](https://rdrr.io/r/base/write.html)

write the episode to disk as markdown

#### Usage

    Episode$write(path = NULL, format = "md", edit = FALSE)

#### Arguments

- `path`:

  the path to write your file to. Defaults to an empty directory in your
  temporary folder

- `format`:

  one of "md" (default) or "xml". This will create a file with the
  correct extension in the path

- `edit`:

  if `TRUE`, the file will open in an editor. Defaults to `FALSE`.

#### Returns

the episode object

#### Examples

    scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    scope$write()

------------------------------------------------------------------------

### Method `handout()`

Create a trimmed-down RMarkdown document that strips prose and contains
only important code chunks and challenge blocks without solutions.

#### Usage

    Episode$handout(path = NULL, solutions = FALSE)

#### Arguments

- `path`:

  (handout) a path to an R Markdown file to write. If this is `NULL`, no
  file will be written and the lines of the output will be returned.

- `solutions`:

  if `TRUE`, include solutions in the output. Defaults to `FALSE`, which
  removes the solution blocks.

#### Returns

a character vector if `path = NULL`, otherwise, it is called for the
side effect of creating a file.

#### Examples

    lsn <- Lesson$new(lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
    e <- lsn$episodes[[1]]
    cat(e$handout())
    cat(e$handout(solution = TRUE))

------------------------------------------------------------------------

### Method `reset()`

Re-read episode from disk

#### Usage

    Episode$reset()

#### Returns

the episode object

#### Examples

    scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    xml2::xml_text(scope$tags[1])
    xml2::xml_set_text(scope$tags[1], "{: .code}")
    xml2::xml_text(scope$tags[1])
    scope$reset()
    xml2::xml_text(scope$tags[1])

------------------------------------------------------------------------

### Method `isolate_blocks()`

Remove all elements except for those within block quotes that have a
kramdown tag. Note that this is a destructive process.

#### Usage

    Episode$isolate_blocks()

#### Returns

the Episode object, invisibly

#### Examples

    scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
    scope$body # a full document with block quotes and code blocks, etc
    scope$isolate_blocks()$body # only one challenge block_quote

------------------------------------------------------------------------

### Method `unblock()`

convert challenge blocks to roxygen-like code blocks

#### Usage

    Episode$unblock(token = "#'", force = FALSE)

#### Arguments

- `token`:

  the token to use to indicate non-code, Defaults to "#'"

- `force`:

  force the conversion even if the conversion has already taken place

#### Returns

the Episode object, invisibly

#### Examples

    loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    loop$body # a full document with block quotes and code blocks, etc
    loop$get_blocks() # all the blocks in the episode
    loop$unblock()
    loop$get_blocks() # no blocks
    loop$code # now there are two blocks with challenge tags

------------------------------------------------------------------------

### Method [`summary()`](https://rdrr.io/r/base/summary.html)

Get a high-level summary of the elements in the episode

#### Usage

    Episode$summary()

#### Returns

a data frame with counts of the following elements per page:

- sections: level 2 headings

- headings: all headings

- callouts: all callouts

- challenges: subset of callouts

- solutions: subset of callouts

- code: all code block elements (excluding inline code)

- output: subset of code that is displayed as output

- warnining: subset of code that is displayed as a warning

- error: subset of code that is displayed as an error

- images: all images in markdown or HTML

- links: all links in markdown or HTML

------------------------------------------------------------------------

### Method [`validate_headings()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)

perform validation on headings in a document.

This will validate the following aspects of all headings:

- first heading starts at level 2 (`first_heading_is_second_level`)

- greater than level 1 (`greater_than_first_level`)

- increse sequentially (e.g. no jumps from 2 to 4) (`are_sequential`)

- have names (`have_names`)

- unique in their own hierarchy (`are_unique`)

#### Usage

    Episode$validate_headings(verbose = TRUE, warn = TRUE)

#### Arguments

- `verbose`:

  if `TRUE` (default), a message for each rule broken will be issued to
  the stderr. if `FALSE`, this will be silent.

- `warn`:

  if `TRUE` (default), a warning will be issued if there are any
  failures in the tests.

#### Returns

a data frame with a variable number of rows and the follwoing columns:

- **episode** the filename of the episode

- **heading** the text from a heading

- **level** the heading level

- **pos** the position of the heading in the document

- **node** the XML node that represents the heading

- (the next five columns are the tests listed above)

- **path** the path to the file.

Each row in the data frame represents an individual heading across the
Lesson. See
[`validate_headings()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
for more details.

#### Examples

    # Example: There are multiple headings called "Solution" that are not
    # nested within a higher-level heading and will throw an error
    loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    loop$validate_headings()

------------------------------------------------------------------------

### Method [`validate_divs()`](https://carpentries.github.io/pegboard/reference/validate_divs.md)

perform validation on divs in a document.

This will validate the following aspects of divs. See
[`validate_divs()`](https://carpentries.github.io/pegboard/reference/validate_divs.md)
for details.

- divs are of a known type (`is_known`)

#### Usage

    Episode$validate_divs(warn = TRUE)

#### Arguments

- `warn`:

  if `TRUE` (default), a warning message will be if there are any divs
  determined to be invalid. Set to `FALSE` if you want the table for
  processing later.

#### Returns

a logical `TRUE` for valid divs and `FALSE` for invalid divs.

#### Examples

    loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    loop$validate_divs()

------------------------------------------------------------------------

### Method [`validate_links()`](https://carpentries.github.io/pegboard/reference/validate_links.md)

perform validation on links and images in a document.

This will validate the following aspects of links. See
[`validate_links()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
for details.

- External links use HTTPS (`enforce_https`)

- Internal links exist (`internal_okay`)

- External links are reachable (`all_reachable`) (planned)

- Images have alt text (`img_alt_text`)

- Link text is descriptive (`descriptive`)

- Link text is more than a single letter (`link_length`)

#### Usage

    Episode$validate_links(warn = TRUE)

#### Arguments

- `warn`:

  if `TRUE` (default), a warning message will be if there are any links
  determined to be invalid. Set to `FALSE` if you want the table for
  processing later.

#### Returns

a logical `TRUE` for valid links and `FALSE` for invalid links.

#### Examples

    loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
    loop$validate_links()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Episode$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r

## ------------------------------------------------
## Method `Episode$new`
## ------------------------------------------------

scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
scope$name
#> [1] "17-scope.md"
scope$lesson
#> [1] "/home/runner/work/_temp/Library/pegboard/lesson-fragment"
scope$challenges
#> {xml_nodeset (2)}
#> [1] <block_quote sourcepos="45:1-60:14" ktag="{: .challenge}">\n  <heading so ...
#> [2] <block_quote sourcepos="62:1-95:14" ktag="{: .challenge}">\n  <heading so ...

## ------------------------------------------------
## Method `Episode$get_blocks`
## ------------------------------------------------

scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
# get all the challenges
scope$get_blocks(".challenge")
#> {xml_nodeset (2)}
#> [1] <block_quote sourcepos="45:1-60:14" ktag="{: .challenge}">\n  <heading so ...
#> [2] <block_quote sourcepos="62:1-95:14" ktag="{: .challenge}">\n  <heading so ...
# get the solutions
scope$get_blocks(".solution", level = 2)
#> {xml_nodeset (0)}
if (FALSE) { # \dontrun{

  # download the source files for r-novice-gampinder into a Lesson object
  rng <- get_lesson("swcarpentry/r-novice-gapminder")
  dsp1 <- rng$episodes[["04-data-structures-part1.md"]]
  # There are 9 blocks in total
  dsp1$get_blocks()
  # One is a callout block
  dsp1$get_blocks(".callout")
  # One is a discussion block
  dsp1$get_blocks(".discussion")
  # Seven are Challenge blocks
  dsp1$get_blocks(".challenge")
  # There are eight solution blocks:
  dsp1$get_blocks(".solution", level = 2L)
} # }

## ------------------------------------------------
## Method `Episode$get_images`
## ------------------------------------------------


loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
loop$get_images()
#> {xml_nodeset (5)}
#> [1] <html_block sourcepos="174:1-174:86" xml:space="preserve">&lt;img src="ht ...
#> [2] <html_block sourcepos="176:1-176:49" xml:space="preserve">&lt;img src=".. ...
#> [3] <image sourcepos="180:1-180:74" destination="https://carpentries.org/asse ...
#> [4] <image sourcepos="182:1-182:38" destination="../no-workie.svg" title="">\ ...
#> [5] <image destination="{{ page.root }}/no-workie.svg" sourcepos="184:1-184:7 ...
loop$get_images(process = TRUE)
#> {xml_nodeset (5)}
#> [1] <img src="https://carpentries.org/assets/img/TheCarpentries.svg" alt="boo ...
#> [2] <img src="../no-workie.svg" alt="books as clubs" destination="../no-worki ...
#> [3] <image sourcepos="180:1-180:74" destination="https://carpentries.org/asse ...
#> [4] <image sourcepos="182:1-182:38" destination="../no-workie.svg" title="">\ ...
#> [5] <image destination="{{ page.root }}/no-workie.svg" sourcepos="184:1-184:7 ...

## ------------------------------------------------
## Method `Episode$get_challenge_graph`
## ------------------------------------------------

scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
scope$get_challenge_graph()
#>   Block       from         to        pos level
#> 1     1  challenge    heading 45:1-60:14     1
#> 2     1    heading  paragraph 45:3-45:34     1
#> 3     1  paragraph code_block 47:3-48:68     1
#> 4     1 code_block     lesson  50:3-58:5     1
#> 5     2  challenge    heading 62:1-95:14     1
#> 6     2    heading  paragraph 62:3-62:27     1
#> 7     2  paragraph       list 64:3-64:55     1
#> 8     2       list code_block  66:3-72:1     1
#> 9     2 code_block     lesson  73:3-93:5     1

## ------------------------------------------------
## Method `Episode$show`
## ------------------------------------------------

scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
scope$head()
#> ---
#> title: "Variable Scope"
#> teaching: 10
#> exercises: 10
#> questions:
#> - "How do function calls actually work?"
scope$tail()
#> > 
#> > KeyError: 'Friday'
#> > ```
#> > {: .error}
#> {: .challenge}
#> 
scope$show()
#> ---
#> title: "Variable Scope"
#> teaching: 10
#> exercises: 10
#> questions:
#> - "How do function calls actually work?"
#> - "How can I determine where errors occurred?"
#> objectives:
#> - "Identify local and global variables."
#> - "Identify parameters as local variables."
#> - "Read a traceback and determine the file, function, and line number on which the error occurred, the type of error, and the error message."
#> keypoints:
#> - "The scope of a variable is the part of a program that can 'see' that variable."
#> ---
#> 
#> ## The scope of a variable is the part of a program that can 'see' that variable.
#> 
#> - There are only so many sensible names for variables.
#> - People using functions shouldn't have to worry about
#>   what variable names the author of the function used.
#> - People writing functions shouldn't have to worry about
#>   what variable names the function's caller uses.
#> - The part of a program in which a variable is visible is called its *scope*.
#> 
#> ```
#> pressure = 103.9
#> 
#> def adjust(t):
#>     temperature = t * 1.43 / pressure
#>     return temperature
#> ```
#> {: .language-python}
#> 
#> - `pressure` is a *global variable*.
#>   - Defined outside any particular function.
#>   - Visible everywhere.
#> - `t` and `temperature` are *local variables* in `adjust`.
#>   - Defined in the function.
#>   - Not visible in the main program.
#>   - Remember: a function parameter is a variable
#>     that is automatically assigned a value when the function is called.
#> 
#> ```
#> print('adjusted:', adjust(0.9))
#> print('temperature after call:', temperature)
#> ```
#> {: .language-python}
#> 
#> ```
#> adjusted: 0.01238691049085659
#> ```
#> {: .output}
#> 
#> ```
#> Traceback (most recent call last):
#>   File "/Users/swcarpentry/foo.py", line 8, in <module>
#>     print('temperature after call:', temperature)
#> NameError: name 'temperature' is not defined
#> ```
#> {: .error}
#> 
#> > ## Local and Global Variable Use
#> > 
#> > Trace the values of all variables in this program as it is executed.
#> > (Use '---' as the value of variables before and after they exist.)
#> > 
#> > ```
#> > limit = 100
#> > 
#> > def clip(value):
#> >     return min(max(0.0, value), limit)
#> > 
#> > value = -22.5
#> > print(clip(value))
#> > ```
#> > {: .language-python}
#> {: .challenge}
#> 
#> > ## Reading Error Messages
#> > 
#> > Read the traceback below, and identify the following:
#> > 
#> > 1. How many levels does the traceback have?
#> > 2. What is the file name where the error occurred?
#> > 3. What is the function name where the error occurred?
#> > 4. On which line number in this function did the error occur?
#> > 5. What is the type of error?
#> > 6. What is the error message?
#> > 
#> > ```
#> > ---------------------------------------------------------------------------
#> > KeyError                                  Traceback (most recent call last)
#> > <ipython-input-2-e4c4cbafeeb5> in <module>()
#> >       1 import errors_02
#> > ----> 2 errors_02.print_friday_message()
#> > 
#> > /Users/ghopper/thesis/code/errors_02.py in print_friday_message()
#> >      13
#> >      14 def print_friday_message():
#> > ---> 15     print_message("Friday")
#> > 
#> > /Users/ghopper/thesis/code/errors_02.py in print_message(day)
#> >       9         "sunday": "Aw, the weekend is almost over."
#> >      10     }
#> > ---> 11     print(messages[day])
#> >      12
#> >      13
#> > 
#> > KeyError: 'Friday'
#> > ```
#> > {: .error}
#> {: .challenge}
#> 

## ------------------------------------------------
## Method `Episode$write`
## ------------------------------------------------

scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
scope$write()
#> Creating temporary directory '/tmp/RtmpVqyDYw/dir19183e19bd39'

## ------------------------------------------------
## Method `Episode$handout`
## ------------------------------------------------

lsn <- Lesson$new(lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
e <- lsn$episodes[[1]]
cat(e$handout())
#> ## Challenge 1: Can you do it?
#> 
#> What is the output of this command?
#> 
#> ```{r, eval=FALSE}
#> paste("This", "new", "template", "looks", "good")
#> ```
cat(e$handout(solution = TRUE))
#> ## Challenge 1: Can you do it?
#> 
#> What is the output of this command?
#> 
#> ```{r, eval=FALSE}
#> paste("This", "new", "template", "looks", "good")
#> ```
#> 
#> :::::::::::::::::::::::: solution
#> 
#> ## Output
#> 
#> ```{r, echo=FALSE}
#> paste("This", "new", "template", "looks", "good")
#> ```
#> 
#> ::::::::::::::::::::::::::::::::::
#> 
#> ## Challenge 2: how do you nest solutions within challenge blocks?
#> 
#> :::::::::::::::::::::::: solution
#> 
#> You can add a line with at least three colons and a `solution` tag.

## ------------------------------------------------
## Method `Episode$reset`
## ------------------------------------------------

scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
xml2::xml_text(scope$tags[1])
#> [1] "{: .language-python}"
xml2::xml_set_text(scope$tags[1], "{: .code}")
#> {xml_nodeset (1)}
#> [1]  ktag="{: .language-python}{: .code}"
xml2::xml_text(scope$tags[1])
#> [1] "{: .language-python}{: .code}"
scope$reset()
xml2::xml_text(scope$tags[1])
#> [1] "{: .language-python}"

## ------------------------------------------------
## Method `Episode$isolate_blocks`
## ------------------------------------------------

scope <- Episode$new(file.path(lesson_fragment(), "_episodes", "17-scope.md"))
scope$body # a full document with block quotes and code blocks, etc
#> {xml_document}
#> <document sourcepos="1:1-95:14" xmlns="http://commonmark.org/xml/1.0">
#> [1] <heading sourcepos="1:1-1:81" level="2">\n  <text sourcepos="1:4-1:81" xm ...
#> [2] <list sourcepos="3:1-9:0" type="bullet" tight="true">\n  <item sourcepos= ...
#> [3] <code_block sourcepos="10:1-16:3" xml:space="preserve" name="" ktag="{: . ...
#> [4] <list sourcepos="19:1-27:0" type="bullet" tight="true">\n  <item sourcepo ...
#> [5] <code_block sourcepos="28:1-31:3" xml:space="preserve" name="" ktag="{: . ...
#> [6] <code_block sourcepos="33:1-35:3" xml:space="preserve" name="" ktag="{: . ...
#> [7] <code_block sourcepos="37:1-42:3" xml:space="preserve" name="" ktag="{: . ...
#> [8] <block_quote sourcepos="45:1-60:14" ktag="{: .challenge}">\n  <heading so ...
#> [9] <block_quote sourcepos="62:1-95:14" ktag="{: .challenge}">\n  <heading so ...
scope$isolate_blocks()$body # only one challenge block_quote
#> {xml_document}
#> <document sourcepos="1:1-95:14" xmlns="http://commonmark.org/xml/1.0">
#> [1] <block_quote sourcepos="45:1-60:14" ktag="{: .challenge}">\n  <heading so ...
#> [2] <block_quote sourcepos="62:1-95:14" ktag="{: .challenge}">\n  <heading so ...

## ------------------------------------------------
## Method `Episode$unblock`
## ------------------------------------------------

loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
loop$body # a full document with block quotes and code blocks, etc
#> {xml_document}
#> <document sourcepos="1:1-190:22" xmlns="http://commonmark.org/xml/1.0">
#>  [1] <heading sourcepos="2:1-2:65" level="2">\n  <text sourcepos="2:4-2:9" xm ...
#>  [2] <list sourcepos="4:1-6:0" type="bullet" tight="true">\n  <item sourcepos ...
#>  [3] <code_block sourcepos="7:1-12:3" xml:space="preserve" name="" ktag="{: . ...
#>  [4] <code_block sourcepos="14:1-33:3" xml:space="preserve" name="" ktag="{:  ...
#>  [5] <heading sourcepos="36:1-36:126" level="2">\n  <text sourcepos="36:4-36: ...
#>  [6] <list sourcepos="38:1-47:0" type="bullet" tight="true">\n  <item sourcep ...
#>  [7] <code_block sourcepos="48:1-51:3" xml:space="preserve" name="" ktag="{:  ...
#>  [8] <code_block sourcepos="53:1-57:3" xml:space="preserve" name="" ktag="{:  ...
#>  [9] <code_block sourcepos="60:1-62:3" xml:space="preserve" name="" ktag="{:  ...
#> [10] <code_block sourcepos="64:1-66:3" xml:space="preserve" name="" ktag="{:  ...
#> [11] <heading sourcepos="69:1-69:52" level="2">\n  <text sourcepos="69:4-69:7 ...
#> [12] <list sourcepos="71:1-73:0" type="bullet" tight="true">\n  <item sourcep ...
#> [13] <code_block sourcepos="74:1-78:3" xml:space="preserve" name="" ktag="{:  ...
#> [14] <code_block sourcepos="80:1-87:3" xml:space="preserve" name="" ktag="{:  ...
#> [15] <list sourcepos="90:1-94:0" type="bullet" tight="true">\n  <item sourcep ...
#> [16] <block_quote sourcepos="95:1-108:14" ktag="{: .challenge}">\n  <heading  ...
#> [17] <block_quote sourcepos="110:1-140:14" ktag="{: .challenge}">\n  <heading ...
#> [18] <block_quote sourcepos="142:1-170:14" ktag="{: .challenge}">\n  <heading ...
#> [19] <heading sourcepos="172:1-172:29" level="3">\n  <text sourcepos="172:5-1 ...
#> [20] <html_block sourcepos="174:1-174:86" xml:space="preserve">&lt;img src="h ...
#> ...
loop$get_blocks() # all the blocks in the episode
#> {xml_nodeset (3)}
#> [1] <block_quote sourcepos="95:1-108:14" ktag="{: .challenge}">\n  <heading s ...
#> [2] <block_quote sourcepos="110:1-140:14" ktag="{: .challenge}">\n  <heading  ...
#> [3] <block_quote sourcepos="142:1-170:14" ktag="{: .challenge}">\n  <heading  ...
loop$unblock()
loop$get_blocks() # no blocks
#> {xml_nodeset (0)}
loop$code # now there are two blocks with challenge tags
#> {xml_nodeset (11)}
#>  [1] <code_block sourcepos="7:1-12:3" xml:space="preserve" name="" ktag="{: . ...
#>  [2] <code_block sourcepos="14:1-33:3" xml:space="preserve" name="" ktag="{:  ...
#>  [3] <code_block sourcepos="48:1-51:3" xml:space="preserve" name="" ktag="{:  ...
#>  [4] <code_block sourcepos="53:1-57:3" xml:space="preserve" name="" ktag="{:  ...
#>  [5] <code_block sourcepos="60:1-62:3" xml:space="preserve" name="" ktag="{:  ...
#>  [6] <code_block sourcepos="64:1-66:3" xml:space="preserve" name="" ktag="{:  ...
#>  [7] <code_block sourcepos="74:1-78:3" xml:space="preserve" name="" ktag="{:  ...
#>  [8] <code_block sourcepos="80:1-87:3" xml:space="preserve" name="" ktag="{:  ...
#>  [9] <code_block sourcepos="115:3-123:5" xml:space="preserve" name="" ktag="{ ...
#> [10] <code_block sourcepos="129:5-137:7" xml:space="preserve" name="" ktag="{ ...
#> [11] <code_block sourcepos="152:5-167:7" xml:space="preserve" name="" ktag="{ ...

## ------------------------------------------------
## Method `Episode$validate_headings`
## ------------------------------------------------

# Example: There are multiple headings called "Solution" that are not
# nested within a higher-level heading and will throw an error
loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
loop$validate_headings()
#> ! There were errors in 3/10 headings
#> ◌ Headings must be unique
#> <https://webaim.org/techniques/semanticstructure/#headings>
#> 
#> ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
#> ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
#> ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)
#> ── Heading structure ───────────────────────────────────────────────────────────
#> # Episode: “Looping Over Data Sets” 
#> ├─## Use a for loop to process files given a list of their names. 
#> ├─## Use glob.glob to find sets of files whose names match a pattern. 
#> ├─## Use glob and for to process batches of files. 
#> ├─## Determining Matches 
#> ├─## Solution  (duplicated)
#> ├─## Minimum File Size 
#> ├─## Solution  (duplicated)
#> ├─## Comparing Data 
#> └─## Solution  (duplicated)
#>   └─### ZNK test links and images 
#> ────────────────────────────────────────────────────────────────────────────────

## ------------------------------------------------
## Method `Episode$validate_divs`
## ------------------------------------------------

loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
loop$validate_divs()

## ------------------------------------------------
## Method `Episode$validate_links`
## ------------------------------------------------

loop <- Episode$new(file.path(lesson_fragment(), "_episodes", "14-looping-data-sets.md"))
loop$validate_links()
#> ! There were errors in 4/13 images
#> ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
#> ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
#> 
#> ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
#> ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
#> ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
#> ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg
```
