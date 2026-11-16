# Throw a validation report as a single message

Collapse a variable number of validation reports into a single message
that can be formatted for the CLI or GitHub.

## Usage

``` r
throw_heading_warnings(VAL)

throw_div_warnings(VAL)

throw_link_warnings(VAL)
```

## Arguments

- VAL:

  `[data.frame]` a validation report derived from one of the `validate`
  functions.

## Value

NULL, invisibly. This is used for it's side-effect of formatting and
issuing messages via
[`issue_warning()`](https://carpentries.github.io/pegboard/dev/reference/cli_helpers.md).

## Details

One of the key features of pegboard is the ability to parse and validate
markdown elements. These functions provide a standard way of creating
the reports that are for the user based on whether or not they are on
the CLI or on GitHub. The prerequisites of these functions are the input
data frame (generated from the actual validation function) and an
internal set of known templating vectors that contain templates for each
test to show the actual error along with general information that can
help correct the error (see below).

### Input Data Frame

The validations are initially reported in a data frame that has the
following properties:

- one row per element

- columns that indicate the parsed attributes of the element, source
  file, source position, and the actual element XML node object.

- boolean columns that indicate the tests for each element, used with
  [`collect_labels()`](https://carpentries.github.io/pegboard/dev/reference/collect_labels.md)
  to add a "labels" column to the data.

### Templating vectors

These vectors come in two forms `[thing]_tests` and `[thing]_info` (e.g.
for
[`validate_links()`](https://carpentries.github.io/pegboard/dev/reference/validate_links.md),
we have `link_tests` and `link_info`). These are named vectors that
match the boolean columns of the data frame produced by the validation
function. The `[thing]_tests` vector contains templates that describes
the error and shows the text that caused the error. The `[thing]_info`
contains general information about how to address that particular error.
For example, one common link error is that a link is not descriptive
(e.g. the link text says "click here"). The column in the `VAL` data
frame that contains the result of this test is called "descriptive", so
if we look at the values from the link info and tests vectors:

    link_info["descriptive"]
    #>                                                                                          descriptive
    #> "Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>"
    link_tests["descriptive"]
    #>                                   descriptive
    #> "[uninformative link text]: [{text}]({orig})"

If the `throw_*_warnings()` functions detect any errors, they will use
the info and tests vectors to construct a composite message.

### Process

The `throw_*_warnings()` functions all do the same basic procedure (and
indeed could be consolidated into a single function in the future)

1.  pass data to
    [`collect_labels()`](https://carpentries.github.io/pegboard/dev/reference/collect_labels.md),
    which will parse the `[thing]_tests` templating vector and label
    each failing element in `VAL` with the appropriate failure message

2.  gather the source information for each failure

3.  pass failures with the `[thing]_info` elements that matched the
    unique failures to
    [`issue_warning()`](https://carpentries.github.io/pegboard/dev/reference/cli_helpers.md)

## See also

[`validate_links()`](https://carpentries.github.io/pegboard/dev/reference/validate_links.md),
[`validate_divs()`](https://carpentries.github.io/pegboard/dev/reference/validate_divs.md),
and
[`validate_headings()`](https://carpentries.github.io/pegboard/dev/reference/validate_headings.md)
for input sources for these functions.
