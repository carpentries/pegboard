# Class to contain a single Lesson by the Carpentries

This is a wrapper for several
[Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
class objects.

## Details

This class contains and keeps track of relationships between
[Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
objects contained within [Carpentries
Workbench](https://carpentries.github.io/workbench) and [Carpentries
styles](https://carpentries.github.io/lesson-example) lessons.

Read more about how to use this class in
[`vignette("intro-lesson", package = "pegboard")`](https://carpentries.github.io/pegboard/articles/intro-lesson.md)

## Public fields

- `path`:

  \[`character`\] path to Lesson directory

- `episodes`:

  \[`list`\] list of
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
  class objects representing the episodes of the lesson.

- `built`:

  \[`list`\] list of
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
  class objects representing the markdown artefacts rendered from
  RMarkdown files.

- `extra`:

  \[`list`\] list of
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
  class objects representing the extra markdown components including
  index, setup, information for learners, information for instructors,
  and learner profiles. This is not processed for the jekyll lessons.

- `children`:

  \[`list`\] list of
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
  class objects representing child files that are needed by any of the
  components to be built This is not processed for the jekyll lessons.

- `sandpaper`:

  \[`logical`\] when `TRUE`, the episodes in the lesson are written in
  pandoc flavoured markdown. `FALSE` would indicate a jekyll-based
  lesson written in kramdown.

- `rmd`:

  \[`logical`\] when `TRUE`, the episodes represent RMarkdown files,
  default is `FALSE` for markdown files (deprecated and unused).

- `overview`:

  \[`logical`\] when `TRUE`, the lesson is an overview lesson and does
  not necessarly contain any episodes. Defaults to `FALSE`

## Active bindings

- `n_problems`:

  number of problems per episode

- `show_problems`:

  contents of the problems per episode

- `files`:

  the source files for each episode

- `has_children`:

  a logical indicating the presence (`TRUE`) or absence (`FALSE`) of
  child files within the main files of the lesson

## Methods

### Public methods

- [`Lesson$new()`](#method-Lesson-new)

- [`Lesson$load_built()`](#method-Lesson-load_built)

- [`Lesson$get()`](#method-Lesson-get)

- [`Lesson$summary()`](#method-Lesson-summary)

- [`Lesson$blocks()`](#method-Lesson-blocks)

- [`Lesson$challenges()`](#method-Lesson-challenges)

- [`Lesson$solutions()`](#method-Lesson-solutions)

- [`Lesson$thin()`](#method-Lesson-thin)

- [`Lesson$reset()`](#method-Lesson-reset)

- [`Lesson$isolate_blocks()`](#method-Lesson-isolate_blocks)

- [`Lesson$handout()`](#method-Lesson-handout)

- [`Lesson$validate_headings()`](#method-Lesson-validate_headings)

- [`Lesson$validate_divs()`](#method-Lesson-validate_divs)

- [`Lesson$validate_links()`](#method-Lesson-validate_links)

- [`Lesson$trace_lineage()`](#method-Lesson-trace_lineage)

- [`Lesson$clone()`](#method-Lesson-clone)

------------------------------------------------------------------------

### Method `new()`

create a new Lesson object from a directory

#### Usage

    Lesson$new(path = ".", rmd = FALSE, jekyll = TRUE, ...)

#### Arguments

- `path`:

  \[`character`\] path to a lesson directory. This must have a folder
  called `_episodes` within that contains markdown episodes. Defaults to
  the current working directory.

- `rmd`:

  \[`logical`\] when `TRUE`, the imported files will be the source
  RMarkdown files. Defaults to `FALSE`, which reads the rendered
  markdown files.

- `jekyll`:

  \[`logical`\] when `TRUE` (default), the structure of the lesson is
  assumed to be derived from the carpentries/styles repository. When
  `FALSE`, The structure is assumed to be a sandpaper lesson and extra
  content for learners, instructors, and profiles will be populated.

- `...`:

  arguments passed on to
  [Episode\$new](https://carpentries.github.io/pegboard/reference/Episode.md)

#### Returns

a new Lesson object that contains a list of
[Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
objects in `$episodes`

#### Examples

    frg <- Lesson$new(lesson_fragment())
    frg$path
    frg$episodes

------------------------------------------------------------------------

### Method `load_built()`

read in the markdown content generated from RMarkdown sources and load
load them into memory

#### Usage

    Lesson$load_built()

------------------------------------------------------------------------

### Method [`get()`](https://rdrr.io/r/base/get.html)

A getter for various active bindings in the
[Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
class of objects. In practice this is syntactic sugar around
`purrr::map(l$episodes, ~.x$element)`

#### Usage

    Lesson$get(element = NULL, collection = "episodes")

#### Arguments

- `element`:

  \[`character`\] a defined element from the active bindings in the
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
  class. Defaults to NULL, which will return nothing. Elements that do
  not exist in the
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
  class will return NULL

- `collection`:

  \[`character`\] one or more of "episodes" (default), "extra", or
  "built". Select `TRUE` to collect information from all files.

#### Examples

    frg <- Lesson$new(lesson_fragment())
    frg$get("error") # error code blocks
    frg$get("links") # links

------------------------------------------------------------------------

### Method [`summary()`](https://rdrr.io/r/base/summary.html)

summary of element counts in each episode. This can be useful for
assessing a broad overview of the lesson dynamics

#### Usage

    Lesson$summary(collection = "episodes")

#### Arguments

- `collection`:

  \[`character`\] one or more of "episodes" (default), "extra", or
  "built". Select `TRUE` to collect information from all files.

#### Examples

    frg <- Lesson$new(lesson_fragment())
    frg$summary() # episode summary (default)

------------------------------------------------------------------------

### Method `blocks()`

Gather all of the blocks from the lesson in a list of xml_nodeset
objects

#### Usage

    Lesson$blocks(type = NULL, level = 0, path = FALSE)

#### Arguments

- `type`:

  the type of block quote in the Jekyll syntax like ".challenge",
  ".discussion", or ".solution"

- `level`:

  the level of the block within the document. Defaults to `0`, which
  represents all of the block_quotes within the document regardless of
  nesting level.

- `path`:

  \[`logical`\] if `TRUE`, the names of each element will be equivalent
  to the path. The default is `FALSE`, which gives the name of each
  episode.

- `body`:

  the XML body of a carpentries lesson (an xml2 object)

------------------------------------------------------------------------

### Method `challenges()`

Gather all of the challenges from the lesson in a list of xml_nodeset
objects

#### Usage

    Lesson$challenges(path = FALSE, graph = FALSE, recurse = TRUE)

#### Arguments

- `path`:

  \[`logical`\] if `TRUE`, the names of each element will be equivalent
  to the path. The default is `FALSE`, which gives the name of each
  episode.

- `graph`:

  \[`logical`\] if `TRUE`, the output will be a data frame representing
  the directed graph of elements within the challenges. See the
  `get_challenge_graph()` method in
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md).

- `recurse`:

  \[`logical`\] when `graph = TRUE`, this will include the solutions in
  the output. See
  [Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
  for more details.

------------------------------------------------------------------------

### Method `solutions()`

Gather all of the solutions from the lesson in a list of xml_nodeset
objects

#### Usage

    Lesson$solutions(path = FALSE)

#### Arguments

- `path`:

  \[`logical`\] if `TRUE`, the names of each element will be equivalent
  to the path. The default is `FALSE`, which gives the name of each
  episode.

------------------------------------------------------------------------

### Method `thin()`

Remove episodes that have no challenges

#### Usage

    Lesson$thin(verbose = TRUE)

#### Arguments

- `verbose`:

  \[`logical`\] if `TRUE` (default), the names of each episode removed
  is reported. Set to `FALSE` to remove this behavior.

#### Returns

the Lesson object, invisibly

#### Examples

    frg <- Lesson$new(lesson_fragment())
    frg$thin()

------------------------------------------------------------------------

### Method `reset()`

Re-read all Episodes from disk

#### Usage

    Lesson$reset()

#### Returns

the Lesson object

#### Examples

    frg <- Lesson$new(lesson_fragment())
    frg$episodes[[1]]$body
    frg$isolate_blocks()$episodes[[1]]$body # empty
    frg$reset()$episodes[[1]]$body # reset

------------------------------------------------------------------------

### Method `isolate_blocks()`

Remove all elements except for those within block quotes that have a
kramdown tag. Note that this is a destructive process.

#### Usage

    Lesson$isolate_blocks()

#### Returns

the Episode object, invisibly

#### Examples

    frg <- Lesson$new(lesson_fragment())
    frg$isolate_blocks()$body # only one challenge block_quote

------------------------------------------------------------------------

### Method `handout()`

create a handout for all episodes in the lesson

#### Usage

    Lesson$handout(path = NULL, solution = FALSE)

#### Arguments

- `path`:

  the path to the R Markdown file to be written. If `NULL` (default), no
  file will be written and the lines of the output document will be
  returned.

- `solution`:

  if `TRUE` solutions will be retained. Defaults to `FALSE`

#### Returns

if `path = NULL`, a character vector, otherwise, the object itself is
returned.

#### Examples

    lsn <- Lesson$new(lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
    cat(lsn$handout())
    cat(lsn$handout(solution = TRUE))

------------------------------------------------------------------------

### Method [`validate_headings()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)

Validate that the heading elements meet minimum accessibility
requirements. See the internal
[`validate_headings()`](https://carpentries.github.io/pegboard/reference/validate_headings.md)
for deails.

This will validate the following aspects of all headings:

- first heading starts at level 2 (`first_heading_is_second_level`)

- greater than level 1 (`greater_than_first_level`)

- increse sequentially (e.g. no jumps from 2 to 4) (`are_sequential`)

- have names (`have_names`)

- unique in their own hierarchy (`are_unique`)

#### Usage

    Lesson$validate_headings(verbose = TRUE)

#### Arguments

- `verbose`:

  if `TRUE`, the heading tree will be printed to the console with any
  warnings assocated with the validators

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

    frg <- Lesson$new(lesson_fragment())
    frg$validate_headings()

------------------------------------------------------------------------

### Method [`validate_divs()`](https://carpentries.github.io/pegboard/reference/validate_divs.md)

Validate that the divs are known. See the internal
[`validate_divs()`](https://carpentries.github.io/pegboard/reference/validate_divs.md)
for details.

#### Validation variables

- divs are known (`is_known`)

#### Usage

    Lesson$validate_divs()

#### Arguments

- `verbose`:

  if `TRUE` (default), Any failed tests will be printed to the console
  as a message giving information of where in the document the failing
  divs appear.

#### Returns

a wide data frame with five rows and the number of columns equal to the
number of episodes in the lesson with an extra column indicating the
type of validation. See the same method in the
[Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
class for details.

#### Examples

    frg <- Lesson$new(lesson_fragment())
    frg$validate_divs()

------------------------------------------------------------------------

### Method [`validate_links()`](https://carpentries.github.io/pegboard/reference/validate_links.md)

Validate that the links and images are valid and accessible. See the
internal
[`validate_links()`](https://carpentries.github.io/pegboard/reference/validate_links.md)
for details.

#### Validation variables

- External links use HTTPS (`enforce_https`)

- Internal links exist (`internal_okay`)

- External links are reachable (`all_reachable`) (planned)

- Images have alt text (`img_alt_text`)

- Link text is descriptive (`descriptive`)

- Link text is more than a single letter (`link_length`)

#### Usage

    Lesson$validate_links()

#### Arguments

- `verbose`:

  if `TRUE` (default), Any failed tests will be printed to the console
  as a message giving information of where in the document the failing
  links/images appear.

#### Returns

a wide data frame with five rows and the number of columns equal to the
number of episodes in the lesson with an extra column indicating the
type of validation. See the same method in the
[Episode](https://carpentries.github.io/pegboard/reference/Episode.md)
class for details.

#### Examples

    frg <- Lesson$new(lesson_fragment())
    frg$validate_links()

------------------------------------------------------------------------

### Method `trace_lineage()`

find all the children of a single source file

#### Usage

    Lesson$trace_lineage(episode_path)

#### Arguments

- `episode_path`:

  the path to an episode or extra file

#### Returns

a character vector of the full lineage of files starting with a single
source file. Note: this assumes a sandpaper lesson that has child files.
If there are no child files, it will return the path

#### Examples

    frag <- lesson_fragment("sandpaper-fragment-with-child")
    lsn <- Lesson$new(frag, jekyll = FALSE)
    lsn$has_children # TRUE
    lsn$episodes[[1]]$children # first episode shows 1 immediate child
    lsn$trace_lineage(lsn$files[[1]]) # find recursive children of 1st episode

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Lesson$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r

## ------------------------------------------------
## Method `Lesson$new`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$path
#> [1] "/home/runner/work/_temp/Library/pegboard/lesson-fragment"
frg$episodes
#> $`10-lunch.md`
#> <Episode>
#>   Inherits from: <yarn>
#>   Public:
#>     add_md: function (md, where = 0L) 
#>     append_md: function (md, nodes = NULL, space = TRUE) 
#>     body: xml_document, xml_node
#>     build_parents: 
#>     challenges: active binding
#>     children: 
#>     clone: function (deep = FALSE) 
#>     code: active binding
#>     confirm_sandpaper: function () 
#>     error: active binding
#>     frontmatter: --- layout: break title: "Lunch" teaching: 0 exercises:  ...
#>     frontmatter_format: YAML
#>     get_blocks: function (type = NULL, level = 1L) 
#>     get_challenge_graph: function (recurse = TRUE) 
#>     get_divs: function (type = NULL, include = FALSE) 
#>     get_images: function (process = FALSE) 
#>     get_protected: function (type = NULL) 
#>     get_yaml: function () 
#>     handout: function (path = NULL, solutions = FALSE) 
#>     has_children: active binding
#>     has_parents: active binding
#>     head: function (n = 6L) 
#>     headings: active binding
#>     images: active binding
#>     initialize: function (path = NULL, process_tags = TRUE, fix_links = TRUE, 
#>     isolate_blocks: function () 
#>     keypoints: active binding
#>     label_divs: function () 
#>     lesson: active binding
#>     links: active binding
#>     md_vec: function (xpath = NULL, stylesheet_path = stylesheet()) 
#>     move_keypoints: function () 
#>     move_objectives: function () 
#>     move_questions: function () 
#>     name: active binding
#>     ns: http://commonmark.org/xml/1.0
#>     objectives: active binding
#>     output: active binding
#>     parents: 
#>     path: /home/runner/work/_temp/Library/pegboard/lesson-fragment ...
#>     prepend_md: function (md, nodes = NULL, space = TRUE) 
#>     protect_curly: function () 
#>     protect_fences: function () 
#>     protect_math: function () 
#>     protect_unescaped: function () 
#>     questions: active binding
#>     remove_error: function () 
#>     remove_output: function () 
#>     reset: function () 
#>     show: function (n = TRUE) 
#>     show_problems: active binding
#>     solutions: active binding
#>     summary: function () 
#>     tags: active binding
#>     tail: function (n = 6L) 
#>     unblock: function (token = "#'", force = FALSE) 
#>     use_dovetail: function () 
#>     use_sandpaper: function (rmd = FALSE, yml = list()) 
#>     validate_divs: function (warn = TRUE) 
#>     validate_headings: function (verbose = TRUE, warn = TRUE) 
#>     validate_links: function (warn = TRUE) 
#>     warning: active binding
#>     write: function (path = NULL, format = "md", edit = FALSE) 
#>     yaml: active binding
#>   Private:
#>     clear_yaml_item: function (what) 
#>     deep_clone: function (name, value) 
#>     encoding: UTF-8
#>     md_lines: function (path = NULL, stylesheet = NULL) 
#>     mutations: FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>     problems: list
#>     record_problem: function (x) 
#>     sourcepos: TRUE
#> 
#> $`12-for-loops.md`
#> <Episode>
#>   Inherits from: <yarn>
#>   Public:
#>     add_md: function (md, where = 0L) 
#>     append_md: function (md, nodes = NULL, space = TRUE) 
#>     body: xml_document, xml_node
#>     build_parents: 
#>     challenges: active binding
#>     children: 
#>     clone: function (deep = FALSE) 
#>     code: active binding
#>     confirm_sandpaper: function () 
#>     error: active binding
#>     frontmatter: --- title: "For Loops" teaching: 10 exercises: 15 questi ...
#>     frontmatter_format: YAML
#>     get_blocks: function (type = NULL, level = 1L) 
#>     get_challenge_graph: function (recurse = TRUE) 
#>     get_divs: function (type = NULL, include = FALSE) 
#>     get_images: function (process = FALSE) 
#>     get_protected: function (type = NULL) 
#>     get_yaml: function () 
#>     handout: function (path = NULL, solutions = FALSE) 
#>     has_children: active binding
#>     has_parents: active binding
#>     head: function (n = 6L) 
#>     headings: active binding
#>     images: active binding
#>     initialize: function (path = NULL, process_tags = TRUE, fix_links = TRUE, 
#>     isolate_blocks: function () 
#>     keypoints: active binding
#>     label_divs: function () 
#>     lesson: active binding
#>     links: active binding
#>     md_vec: function (xpath = NULL, stylesheet_path = stylesheet()) 
#>     move_keypoints: function () 
#>     move_objectives: function () 
#>     move_questions: function () 
#>     name: active binding
#>     ns: http://commonmark.org/xml/1.0
#>     objectives: active binding
#>     output: active binding
#>     parents: 
#>     path: /home/runner/work/_temp/Library/pegboard/lesson-fragment ...
#>     prepend_md: function (md, nodes = NULL, space = TRUE) 
#>     protect_curly: function () 
#>     protect_fences: function () 
#>     protect_math: function () 
#>     protect_unescaped: function () 
#>     questions: active binding
#>     remove_error: function () 
#>     remove_output: function () 
#>     reset: function () 
#>     show: function (n = TRUE) 
#>     show_problems: active binding
#>     solutions: active binding
#>     summary: function () 
#>     tags: active binding
#>     tail: function (n = 6L) 
#>     unblock: function (token = "#'", force = FALSE) 
#>     use_dovetail: function () 
#>     use_sandpaper: function (rmd = FALSE, yml = list()) 
#>     validate_divs: function (warn = TRUE) 
#>     validate_headings: function (verbose = TRUE, warn = TRUE) 
#>     validate_links: function (warn = TRUE) 
#>     warning: active binding
#>     write: function (path = NULL, format = "md", edit = FALSE) 
#>     yaml: active binding
#>   Private:
#>     clear_yaml_item: function (what) 
#>     deep_clone: function (name, value) 
#>     encoding: UTF-8
#>     md_lines: function (path = NULL, stylesheet = NULL) 
#>     mutations: FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>     problems: list
#>     record_problem: function (x) 
#>     sourcepos: TRUE
#> 
#> $`14-looping-data-sets.md`
#> <Episode>
#>   Inherits from: <yarn>
#>   Public:
#>     add_md: function (md, where = 0L) 
#>     append_md: function (md, nodes = NULL, space = TRUE) 
#>     body: xml_document, xml_node
#>     build_parents: 
#>     challenges: active binding
#>     children: 
#>     clone: function (deep = FALSE) 
#>     code: active binding
#>     confirm_sandpaper: function () 
#>     error: active binding
#>     frontmatter: --- title: "Looping Over Data Sets" teaching: 5 exercise ...
#>     frontmatter_format: YAML
#>     get_blocks: function (type = NULL, level = 1L) 
#>     get_challenge_graph: function (recurse = TRUE) 
#>     get_divs: function (type = NULL, include = FALSE) 
#>     get_images: function (process = FALSE) 
#>     get_protected: function (type = NULL) 
#>     get_yaml: function () 
#>     handout: function (path = NULL, solutions = FALSE) 
#>     has_children: active binding
#>     has_parents: active binding
#>     head: function (n = 6L) 
#>     headings: active binding
#>     images: active binding
#>     initialize: function (path = NULL, process_tags = TRUE, fix_links = TRUE, 
#>     isolate_blocks: function () 
#>     keypoints: active binding
#>     label_divs: function () 
#>     lesson: active binding
#>     links: active binding
#>     md_vec: function (xpath = NULL, stylesheet_path = stylesheet()) 
#>     move_keypoints: function () 
#>     move_objectives: function () 
#>     move_questions: function () 
#>     name: active binding
#>     ns: http://commonmark.org/xml/1.0
#>     objectives: active binding
#>     output: active binding
#>     parents: 
#>     path: /home/runner/work/_temp/Library/pegboard/lesson-fragment ...
#>     prepend_md: function (md, nodes = NULL, space = TRUE) 
#>     protect_curly: function () 
#>     protect_fences: function () 
#>     protect_math: function () 
#>     protect_unescaped: function () 
#>     questions: active binding
#>     remove_error: function () 
#>     remove_output: function () 
#>     reset: function () 
#>     show: function (n = TRUE) 
#>     show_problems: active binding
#>     solutions: active binding
#>     summary: function () 
#>     tags: active binding
#>     tail: function (n = 6L) 
#>     unblock: function (token = "#'", force = FALSE) 
#>     use_dovetail: function () 
#>     use_sandpaper: function (rmd = FALSE, yml = list()) 
#>     validate_divs: function (warn = TRUE) 
#>     validate_headings: function (verbose = TRUE, warn = TRUE) 
#>     validate_links: function (warn = TRUE) 
#>     warning: active binding
#>     write: function (path = NULL, format = "md", edit = FALSE) 
#>     yaml: active binding
#>   Private:
#>     clear_yaml_item: function (what) 
#>     deep_clone: function (name, value) 
#>     encoding: UTF-8
#>     md_lines: function (path = NULL, stylesheet = NULL) 
#>     mutations: FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>     problems: list
#>     record_problem: function (x) 
#>     sourcepos: TRUE
#> 
#> $`17-scope.md`
#> <Episode>
#>   Inherits from: <yarn>
#>   Public:
#>     add_md: function (md, where = 0L) 
#>     append_md: function (md, nodes = NULL, space = TRUE) 
#>     body: xml_document, xml_node
#>     build_parents: 
#>     challenges: active binding
#>     children: 
#>     clone: function (deep = FALSE) 
#>     code: active binding
#>     confirm_sandpaper: function () 
#>     error: active binding
#>     frontmatter: --- title: "Variable Scope" teaching: 10 exercises: 10 q ...
#>     frontmatter_format: YAML
#>     get_blocks: function (type = NULL, level = 1L) 
#>     get_challenge_graph: function (recurse = TRUE) 
#>     get_divs: function (type = NULL, include = FALSE) 
#>     get_images: function (process = FALSE) 
#>     get_protected: function (type = NULL) 
#>     get_yaml: function () 
#>     handout: function (path = NULL, solutions = FALSE) 
#>     has_children: active binding
#>     has_parents: active binding
#>     head: function (n = 6L) 
#>     headings: active binding
#>     images: active binding
#>     initialize: function (path = NULL, process_tags = TRUE, fix_links = TRUE, 
#>     isolate_blocks: function () 
#>     keypoints: active binding
#>     label_divs: function () 
#>     lesson: active binding
#>     links: active binding
#>     md_vec: function (xpath = NULL, stylesheet_path = stylesheet()) 
#>     move_keypoints: function () 
#>     move_objectives: function () 
#>     move_questions: function () 
#>     name: active binding
#>     ns: http://commonmark.org/xml/1.0
#>     objectives: active binding
#>     output: active binding
#>     parents: 
#>     path: /home/runner/work/_temp/Library/pegboard/lesson-fragment ...
#>     prepend_md: function (md, nodes = NULL, space = TRUE) 
#>     protect_curly: function () 
#>     protect_fences: function () 
#>     protect_math: function () 
#>     protect_unescaped: function () 
#>     questions: active binding
#>     remove_error: function () 
#>     remove_output: function () 
#>     reset: function () 
#>     show: function (n = TRUE) 
#>     show_problems: active binding
#>     solutions: active binding
#>     summary: function () 
#>     tags: active binding
#>     tail: function (n = 6L) 
#>     unblock: function (token = "#'", force = FALSE) 
#>     use_dovetail: function () 
#>     use_sandpaper: function (rmd = FALSE, yml = list()) 
#>     validate_divs: function (warn = TRUE) 
#>     validate_headings: function (verbose = TRUE, warn = TRUE) 
#>     validate_links: function (warn = TRUE) 
#>     warning: active binding
#>     write: function (path = NULL, format = "md", edit = FALSE) 
#>     yaml: active binding
#>   Private:
#>     clear_yaml_item: function (what) 
#>     deep_clone: function (name, value) 
#>     encoding: UTF-8
#>     md_lines: function (path = NULL, stylesheet = NULL) 
#>     mutations: FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>     problems: list
#>     record_problem: function (x) 
#>     sourcepos: TRUE
#> 

## ------------------------------------------------
## Method `Lesson$get`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$get("error") # error code blocks
#> $`10-lunch.md`
#> {xml_nodeset (0)}
#> 
#> $`12-for-loops.md`
#> {xml_nodeset (2)}
#> [1] <code_block sourcepos="58:1-60:3" xml:space="preserve" name="" ktag="{: . ...
#> [2] <code_block sourcepos="70:1-75:3" xml:space="preserve" name="" ktag="{: . ...
#> 
#> $`14-looping-data-sets.md`
#> {xml_nodeset (0)}
#> 
#> $`17-scope.md`
#> {xml_nodeset (2)}
#> [1] <code_block sourcepos="37:1-42:3" xml:space="preserve" name="" ktag="{: . ...
#> [2] <code_block sourcepos="73:3-93:5" xml:space="preserve" name="" ktag="{: . ...
#> 
frg$get("links") # links
#> $`10-lunch.md`
#> {xml_nodeset (0)}
#> 
#> $`12-for-loops.md`
#> {xml_nodeset (1)}
#> [1] <link sourcepos="115:27-115:90" destination="https://docs.python.org/3/li ...
#> 
#> $`14-looping-data-sets.md`
#> {xml_nodeset (8)}
#> [1] <link sourcepos="36:8-36:75" destination="https://docs.python.org/3/libra ...
#> [2] <link sourcepos="42:25-42:77" destination="https://docs.python.org/3/libr ...
#> [3] <link sourcepos="43:9-43:61" destination="https://docs.python.org/3/libra ...
#> [4] <link sourcepos="125:17-125:118" destination="https://pandas.pydata.org/p ...
#> [5] <link sourcepos="148:62-148:129" destination="https://docs.python.org/3/l ...
#> [6] <link destination="{{ page.root }}/index.html" sourcepos="178:1-178:92">\ ...
#> [7] <link destination="{{ site.swc_pages }}/shell-novice" sourcepos="178:1-17 ...
#> [8] <link destination="{{ page.root }}{% link index.md %}" sourcepos="186:1-1 ...
#> 
#> $`17-scope.md`
#> {xml_nodeset (0)}
#> 

## ------------------------------------------------
## Method `Lesson$summary`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$summary() # episode summary (default)
#> ! Summary not guaranteed for styles-based lessons
#> # A tibble: 4 × 12
#>   page      sections headings callouts challenges solutions  code output warning
#>   <chr>        <int>    <int>    <int>      <int>     <int> <int>  <int>   <int>
#> 1 10-lunch…        0        0        0          0         0     0      0       0
#> 2 12-for-l…       24       24        7          7        10    32      4       0
#> 3 14-loopi…        9       10        3          3         3    11      4       0
#> 4 17-scope…        3        3        2          2         0     6      1       0
#> # ℹ 3 more variables: error <int>, images <int>, links <int>

## ------------------------------------------------
## Method `Lesson$thin`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$thin()
#> Removing 1 episode: 10-lunch.md

## ------------------------------------------------
## Method `Lesson$reset`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$episodes[[1]]$body
#> {xml_document}
#> <document sourcepos="1:1-4:131" xmlns="http://commonmark.org/xml/1.0">
#> [1] <paragraph sourcepos="1:1-1:49">\n  <text sourcepos="1:1-1:49" xml:space= ...
#> [2] <list sourcepos="2:1-4:131" type="bullet" tight="true">\n  <item sourcepo ...
frg$isolate_blocks()$episodes[[1]]$body # empty
#> {xml_document}
#> <document sourcepos="1:1-4:131" xmlns="http://commonmark.org/xml/1.0">
frg$reset()$episodes[[1]]$body # reset
#> {xml_document}
#> <document sourcepos="1:1-4:131" xmlns="http://commonmark.org/xml/1.0">
#> [1] <paragraph sourcepos="1:1-1:49">\n  <text sourcepos="1:1-1:49" xml:space= ...
#> [2] <list sourcepos="2:1-4:131" type="bullet" tight="true">\n  <item sourcepo ...

## ------------------------------------------------
## Method `Lesson$isolate_blocks`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$isolate_blocks()$body # only one challenge block_quote
#> NULL

## ------------------------------------------------
## Method `Lesson$handout`
## ------------------------------------------------

lsn <- Lesson$new(lesson_fragment("sandpaper-fragment"), jekyll = FALSE)
cat(lsn$handout())
#> ## Using RMarkdown
#> 
#> ## Challenge 1: Can you do it?
#> 
#> What is the output of this command?
#> 
#> ```{r, eval=FALSE}
#> paste("This", "new", "template", "looks", "good")
#> ```
cat(lsn$handout(solution = TRUE))
#> ## Using RMarkdown
#> 
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
## Method `Lesson$validate_headings`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$validate_headings()
#> ── Heading structure ───────────────────────────────────────────────────────────
#> # Episode: “For Loops” 
#> ├─## A for loop executes commands once for each value in a collection. 
#> ├─## A for loop is made up of a collection, a loop variable, and a body. 
#> ├─## The first line of the for loop must end with a colon, and the body must be 
#> ├─## Loop variables can be called anything. 
#> ├─## The body of a loop can contain many statements. 
#> ├─## Use range to iterate over a sequence of numbers. 
#> ├─## The Accumulator pattern turns many values into one. 
#> ├─## Classifying Errors 
#> ├─## Solution  (duplicated)
#> ├─## Tracing Execution 
#> ├─## Solution  (duplicated)
#> ├─## Reversing a String 
#> ├─## Solution  (duplicated)
#> ├─## Practice Accumulating 
#> ├─## Solution  (duplicated)
#> ├─## Solution  (duplicated)
#> ├─## Solution  (duplicated)
#> ├─## Solution  (duplicated)
#> ├─## Cumulative Sum 
#> ├─## Solution  (duplicated)
#> ├─## Identifying Variable Name Errors 
#> ├─## Solution  (duplicated)
#> ├─## Identifying Item Errors 
#> └─## Solution  (duplicated)
#> ────────────────────────────────────────────────────────────────────────────────
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
#> ! There were errors in 13/37 headings
#> ◌ Headings must be unique
#> <https://webaim.org/techniques/semanticstructure/#headings>
#> 
#> ::warning file=_episodes/12-for-loops.md,line=183:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=200:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=227:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=252:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=270:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=289:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=305:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=336:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=371:: (duplicated)
#> ::warning file=_episodes/12-for-loops.md,line=400:: (duplicated)
#> ::warning file=_episodes/14-looping-data-sets.md,line=119:: (duplicated)
#> ::warning file=_episodes/14-looping-data-sets.md,line=143:: (duplicated)
#> ::warning file=_episodes/14-looping-data-sets.md,line=162:: (duplicated)

## ------------------------------------------------
## Method `Lesson$validate_divs`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$validate_divs()

## ------------------------------------------------
## Method `Lesson$validate_links`
## ------------------------------------------------

frg <- Lesson$new(lesson_fragment())
frg$validate_links()
#> ! There were errors in 4/14 images
#> ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
#> ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
#> 
#> ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
#> ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
#> ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
#> ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg

## ------------------------------------------------
## Method `Lesson$trace_lineage`
## ------------------------------------------------

frag <- lesson_fragment("sandpaper-fragment-with-child")
lsn <- Lesson$new(frag, jekyll = FALSE)
lsn$has_children # TRUE
#> [1] TRUE
lsn$episodes[[1]]$children # first episode shows 1 immediate child
#> /home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd
lsn$trace_lineage(lsn$files[[1]]) # find recursive children of 1st episode
#> [1] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/intro.Rmd"        
#> [2] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/cat.Rmd"    
#> [3] "/home/runner/work/_temp/Library/pegboard/sandpaper-fragment-with-child/episodes/files/session.Rmd"
```
