# Working with XML data

## Introduction

You will want to read this vignette if you are interested in
contributing to {pegboard}, or if you would like to understand how to
fine-tune the transition of a lesson from the styles infrastructure to
The Workbench (see
<https://github.com/carpentries/lesson-transition#readme>), or if you
want to know how to better inspect the output of some of {pegboard}’s
accessors. In this vignette, I assume that you are familiar with writing
R functions and that R will default to passing an object’s *value* to a
function and not a *reference* (though if you do not understand that
last part, do not worry, I will try to dispell this).

The {pegboard} package is an enhancement of the {tinkr} package, which
transforms Markdown to XML and back again. [XML is a markup language
that is derived from HTML](https://www.geeksforgeeks.org/html-vs-xml/)
designed to handle structured data. A more modern format for storing and
transporting data on the web is JSON, but the advantage of using XML is
that we are able to use the [XPath](https://en.wikipedia.org/wiki/XPath)
language to parse it (more on that later). Moreover, because XML has the
same structure as HTML, it can be parsed using the same tools, which is
advantageous for a suite of packages that transforms Markdown to HTML.
This transformation is facilitated by the
[{commonmark}](https://docs.ropensci.org/commonmark/) for transforming
Markdown to XML and [{xslt}](https://docs.ropensci.org/xslt/) for
transforming XML to Markdown.

## Motivating Example

During the lesson transition, I was often faced with situations that
required me to perform intricate replacements in documents while
preserving the structure. One such example is transitioning the
“workshop” or “overview” lessons that did not have any episodes and
relied on separate child documents to separate out redundant elements.
Let’s say we had a file called `setup.md` and two other files called
`setup-python.md` and `setup-r.md` that look like this:

`setup.md`:

``` markdown
## Setup Instructions

### Python

{% include setup-python.md%}

### R

{% include setup-r.md %}
```

`setup-python.md`:

``` markdown
Install _python_ from **anaconda**
```

`setup-r.md`:

``` markdown
Install _R_ from **CRAN**
```

The output of `setup.md` when its rendered would include the text from
both `setup-python.md` and `setup-r.md`, but the thing is, the
`{% include %}` tags are a syntax that is specific to Jekyll. Instead,
for The Workbench, we wanted to use the [R Markdown child document
declaration](https://bookdown.org/yihui/rmarkdown-cookbook/child-document.html),
so that `setup.md` would look like this:

`setup.md`:

```` default
## Setup Instructions

### Python

```{r child="files/setup-python.md"}
```

### R

```{r child="files/setup-r.md"}
```
````

``` r

setup_file <- tempfile(fileext=".md")
stp <- "## Setup Instructions

### Python

{% include setup-python.md%}

### R

{% include setup-r.md %}
"
writeLines(stp, setup_file)
```

By using the following function (originally in
[lesson-transition/datacarpentry/ecology-workshop.R](https://github.com/carpentries/lesson-transition/blob/f8edb10b2e13a926e3df9ba522983f930d0ee19b/datacarpentry/ecology-workshop.R#L23-L44)),
it was possible:

``` r

child_from_include <- function(from, to = NULL) {
  to <- if (is.null(to)) fs::path_ext_set(from, "Rmd") else to
  rlang::inform(c(i = from))
  ep <- pegboard::Episode$new(from)
  # find all the {% include file.ext %} statements
  includes <- xml2::xml_find_all(ep$body, 
    ".//md:text[starts-with(text(), '{% include')]", ns = ep$ns)
  # trim off everything but our precious file path
  f <- gsub("[%{ }]|include", "", xml2::xml_text(includes))
  # give it a name 
  fname <- paste0("include-", fs::path_ext_remove(f))
  # make sure the file path is correct
  f <- sQuote(fs::path("files", f), q = FALSE)
  p <- xml2::xml_parent(includes)
  # remove text node
  xml2::xml_remove(includes)
  # change paragraph node to a code block and add chunk attributes
  xml2::xml_set_name(p, "code_block")
  xml2::xml_set_attr(p, "language", "r")
  xml2::xml_set_attr(p, "child", f)
  xml2::xml_set_attr(p, "name", fname)
  fs::file_move(from, to)
  ep$write(fs::path_dir(to), format = "Rmd")
}
writeLines(readLines(setup_file)) # show the file 
#> ## Setup Instructions
#> 
#> ### Python
#> 
#> {% include setup-python.md%}
#> 
#> ### R
#> 
#> {% include setup-r.md %}
child_from_include(setup_file)
#> ℹ /tmp/RtmpmuYgpS/file1e154ac2ff31.md
writeLines(readLines(fs::path_ext_set(setup_file, "Rmd"))) # show the file 
```

    #> ## Setup Instructions
    #> 
    #> ### Python
    #> 
    #> ```{r include-setup-python, child='files/setup-python.md'}
    #> ```
    #> 
    #> ### R
    #> 
    #> ```{r include-setup-r, child='files/setup-r.md'}
    #> ```

This is only a small peek of what is possible with XML data and if you
are familiar with R, some of this may seem like strange syntax. If you
would like to understand a bit more, read on.

## Working with XML data

Each `Episode` object contains a field (you can think of each field as a
list element) called `$body`, which contains an {xml2} document. This is
the core of the `Episode` object and every function works in some way
with this field.

### The memory of XML objects

For the casual R user (and even for the more experienced), the way you
use this package may seem a little strange. This is because in R,
functions will not have side effects, but the vast majority of methods
in the `Episode` object will modify the object itself and this all has
to do with the way XML data is handled in R by the {xml2} package.

Normally in R, when you pass data to a function, it will make a copy of
the data and then apply the function to the copy of the data:

``` r

x <- 1:10
f <- function(x) {
  # insert 99 after the fourth position in a vector
  return(append(x, 99, after = 4))
}
print(f(x))
#>  [1]  1  2  3  4 99  5  6  7  8  9 10
# note that x is not modified
print(x)
#>  [1]  1  2  3  4  5  6  7  8  9 10
```

When working with XML in R, the {xml2} package is unparalleled, but it
leads to surprising outcomes because when you modify content within an
XML object, you are modifying the object in place:

``` r

x <- xml2::read_xml("<a><b></b></a>")
print(x)
#> {xml_document}
#> <a>
#> [1] <b/>
f <- function(x, new = "c") {
  xml2::xml_add_child(x, new, .where = xml2::xml_length(x))
  return(x)
}
y <- f(x)
# note that x and y are identical
print(x)
#> {xml_document}
#> <a>
#> [1] <b/>
#> [2] <c/>
print(y)
#> {xml_document}
#> <a>
#> [1] <b/>
#> [2] <c/>
```

It gets a bit stranger when you consider that in the above code, `y` and
`x` are *exactly the same object* as shown with the fact that if I
manipulate `y`, then `x` will also be modified:

``` r

f(y, "d")
#> {xml_document}
#> <a>
#> [1] <b/>
#> [2] <c/>
#> [3] <d/>
print(y)
#> {xml_document}
#> <a>
#> [1] <b/>
#> [2] <c/>
#> [3] <d/>
print(x)
#> {xml_document}
#> <a>
#> [1] <b/>
#> [2] <c/>
#> [3] <d/>
```

I can even extract child elements from the XML document and manipulate
*those* and have them be reflected in the parent. For example, if I
extract the second child of the document, and then apply the
`cool="verified"` attribute to the child, it will be reflected in the
parent document.

``` r

child <- xml2::xml_child(x, 2)
xml2::xml_set_attr(child, "cool", "verified")
print(child)
#> {xml_node}
#> <c cool="verified">
#> NULL
print(x)
#> {xml_document}
#> <a>
#> [1] <b/>
#> [2] <c cool="verified"/>
#> [3] <d/>
print(y)
#> {xml_document}
#> <a>
#> [1] <b/>
#> [2] <c cool="verified"/>
#> [3] <d/>
```

This persistance lends itself very well to using the {R6} package for
creating objects that work in a more object-oriented way (where methods
belong to classes instead of the other way around). If you are familiar
with how Python methods work, then you will be mostly familiar with how
the {R6} objects behave. It is worthwhile to read the [{R6} introduction
vignette](https://r6.r-lib.org/articles/Introduction.html) if you want
to understand how to program and modify this package.

In the example above, you notice that I use
[`xml2::xml_child()`](http://xml2.r-lib.org/reference/xml_children.md)
to extract child nodes, but the real power of XML comes with searching
for items using XPath syntax for traversing the XML nodes where I would
be able to do one of the following to get the child called “c”

``` r

xml2::xml_find_first(x, ".//c")
#> {xml_node}
#> <c cool="verified">
xml2::xml_find_first(x, "/a/c")
#> {xml_node}
#> <c cool="verified">
```

The next section will cover a bit of XPath and provide some resources on
how to practice and learn because this comes in very handy to quickly
traverse the XML nodes without relying on loops.

## Using XPath to parse XML

### The structure of XPath

In the section, we will talk about [XPath
syntax](https://en.wikipedia.org/wiki/XPath#Syntax_and_semantics_(XPath_1.0)),
but it will be non-exhaustive. Unfortunately, good tutorials on the web
are few and far between, but here are some that can help:

- The [MDN
  documentation](https://developer.mozilla.org/en-US/docs/Web/XPath) is
  *usually* pretty good, but instead, it’s better as a reference
  - [MDN XPath
    Axes](https://developer.mozilla.org/en-US/docs/Web/XPath/Axes) good
    for knowing how to navigate among nodes
  - [MDN XPath
    functions](https://developer.mozilla.org/en-US/docs/Web/XPath/Functions)
    good for knowing how to filter node matches
- The [w3schools tutorial on
  XPath](https://www.w3schools.com/xml/xpath_intro.asp) is actually one
  of the best out there, but this is an excpetion to the rule. Other
  than this tutorial, I would not trust any content from w3schools (they
  are not aligned at all with the web consortium).
- An [XPath tester](https://extendsclass.com/xpath-tester.html) like a
  regex tester to allow you to try out complex queries in a visual
  manner.

It’s important to remember that an XML document is a tree-like structure
that is similar to directories or folders on your computer. For example,
if you look at the source directory structure of this package, you would
see a folder called `R/` and a nested folder called `tests/testhat/`. If
you started from the root directory of this package, you would list the
R files in the `R/` folder with `ls R/*.R` similarly, if you wanted to
list the R files in the `tests/testthat/` folder, you would us
`ls tests/testthat/*.R`. In this respect, XPath has a very similar
syntax: to enter the next level of nesting, you add a slash (`/`). For
example, let’s take a look a what the file structure would look like in
XML form:

``` xml
<ROOT>
  <R>
    <file ext="R">one</file>
    <file ext="R">two</file>
  </R>
  <tests>
    <testthat>
      <data>
        <file ext="txt">test-data</file>
      </data>
      <file ext="R">test-one</file>
      <file ext="R">test-two</file>
    </testthat>
  </tests>
</ROOT>
```

The XPath syntax to find all files in the the R and testthat folders
would be the same if you started from the root: `R/file` and
`tests/testthat/file`.

``` r

xml2::xml_find_all(xml, "R/file")
#> {xml_nodeset (2)}
#> [1] <file ext="R">one</file>
#> [2] <file ext="R">two</file>
xml2::xml_find_all(xml, "tests/testthat/file")
#> {xml_nodeset (2)}
#> [1] <file ext="R">test-one</file>
#> [2] <file ext="R">test-two</file>
```

However, XPath has one advantage that normal command line syntax doesn’t
have: you can short-cut paths, so if we wanted to find all files in any
given folder, you can use the double slash (`//`) to recursively search
through nesting. By habit, I will normally use the precede these slashes
with a dot (`.`) so that I can be sure to start with the node that I
have in my variable:

``` r

xml2::xml_find_all(xml, ".//file")
#> {xml_nodeset (5)}
#> [1] <file ext="R">one</file>
#> [2] <file ext="R">two</file>
#> [3] <file ext="txt">test-data</file>
#> [4] <file ext="R">test-one</file>
#> [5] <file ext="R">test-two</file>
```

Of course, this method finds *all* files, so if you wanted to filter
them, you can use the bracket notation to create filters for our
selection based on the `ext` attribute, which are prefixed by `@`. With
the bracket notation, you add brackets to a node selection with a
condition. In this case, we want to test that the extension is ‘R’, so
we would use `[@ext='R']`:

``` r

xml2::xml_find_all(xml, ".//file[@ext='R']")
#> {xml_nodeset (4)}
#> [1] <file ext="R">one</file>
#> [2] <file ext="R">two</file>
#> [3] <file ext="R">test-one</file>
#> [4] <file ext="R">test-two</file>
```

In this scheme, I’ve put the file names as the text of the nodes, so we
can use the bracket notation again with [XPath
functions](https://developer.mozilla.org/en-US/docs/Web/XPath/Functions)
to filter for only files that contain “one”

``` r

xml2::xml_find_all(xml, ".//file[@ext='R'][contains(text(), 'one')]")
#> {xml_nodeset (2)}
#> [1] <file ext="R">one</file>
#> [2] <file ext="R">test-one</file>
```

If I only wanted to extract source files that contain “one”, I could
also use the `parent::` [XPath
axis](https://developer.mozilla.org/en-US/docs/Web/XPath/Axes):

``` r

xml2::xml_find_all(xml, ".//file[@ext='R'][contains(text(), 'one')][parent::R]")
#> {xml_nodeset (1)}
#> [1] <file ext="R">one</file>
```

Note that if I used a slash (`/`) instead of square brackets for the
parent, I would get the parent back:

``` r

xml2::xml_find_all(xml, ".//file[@ext='R'][contains(text(), 'one')]/parent::R")
#> {xml_nodeset (1)}
#> [1] <R>\n  <file ext="R">one</file>\n  <file ext="R">two</file>\n</R>
```

As you an see, many times, an XPath query can get kind of hairy, which
is why I often like to compose it into different parts during
programming with {glue}:

``` r

predicate <- "[@ext='R'][contains(text(), 'one')]"
XPath <- glue::glue(".//file{predicate}/parent::R")
xml2::xml_find_all(xml, XPath)
#> {xml_nodeset (1)}
#> [1] <R>\n  <file ext="R">one</file>\n  <file ext="R">two</file>\n</R>
```

In the next section, I will discuss how to extract and manipulate XML
that comes from Markdown with namespaces.

## XML data from Markdown using namespaces

The XML from markdown transformation is fully handled by the
{commonmark} package, which has the convenient
[`commonmark::markdown_xml()`](https://docs.ropensci.org/commonmark/reference/commonmark.html)
function. For example, this is how how the following markdown is
processed:

``` markdown
This is a bunch of [example markdown](https://example.com 'for example') text

- this
- is
- a **list**
```

> This is a bunch of [example
> markdown](https://example.com "for example") text
>
> - this
> - is
> - a **list**

``` r

md <- c("This is a bunch of [example markdown](https://example.com 'for example') text",
  "",
  "- this",
  "- is",
  "- a **list**"
)
xml_txt <- commonmark::markdown_xml(paste(md, collapse = "\n"))
class(xml_txt)
#> [1] "character"
writeLines(xml_txt)
#> <?xml version="1.0" encoding="UTF-8"?>
#> <!DOCTYPE document SYSTEM "CommonMark.dtd">
#> <document xmlns="http://commonmark.org/xml/1.0">
#>   <paragraph>
#>     <text xml:space="preserve">This is a bunch of </text>
#>     <link destination="https://example.com" title="for example">
#>       <text xml:space="preserve">example markdown</text>
#>     </link>
#>     <text xml:space="preserve"> text</text>
#>   </paragraph>
#>   <list type="bullet" tight="true">
#>     <item>
#>       <paragraph>
#>         <text xml:space="preserve">this</text>
#>       </paragraph>
#>     </item>
#>     <item>
#>       <paragraph>
#>         <text xml:space="preserve">is</text>
#>       </paragraph>
#>     </item>
#>     <item>
#>       <paragraph>
#>         <text xml:space="preserve">a </text>
#>         <strong>
#>           <text xml:space="preserve">list</text>
#>         </strong>
#>       </paragraph>
#>     </item>
#>   </list>
#> </document>
```

You can see that it has successfully parsed the markdown into a
paragraph and a list and then the various elements within.

### The default namespace

Now here’s the catch: The commonmark markdown always starts with this
basic skeleton which has the root node of
`<document xmlns="http://commonmark.org/xml/1.0">`. The `xmlns`
attribute defines the [default XML
namespace](https://developer.mozilla.org/en-US/docs/Web/SVG/Namespaces_Crash_Course):

    #> <?xml version="1.0" encoding="UTF-8"?>
    #> <!DOCTYPE document SYSTEM "CommonMark.dtd">
    #> <document xmlns="http://commonmark.org/xml/1.0">
    #> 
    #> MARKDOWN CONTENT HERE
    #> 
    #> </document>

In many XML applications, namespaces will come with prefixes, which are
defined in the `xmlns` attribute
(e.g. `xmlns:svg="http://www.w3.org/2000/svg"`). If a node has a
namespace, it needs to be selected with the namespace prefix like so:
`.//svg:circle`. For default namespaces, the same rule applies, but the
question becomes: how do you know what the namespace prefix is? In
{xml2}, the default namespace always begins with `d1` and increments up
as new namespaces are added. You can inspect the namespace with
[`xml2::xml_ns()`](http://xml2.r-lib.org/reference/xml_ns.md):

``` r

xml <- xml2::read_xml(xml_txt)
xml2::xml_ns(xml)
#> d1 <-> http://commonmark.org/xml/1.0
```

Thus, the XPath query you would use to select a paragraph would be
`.//d1:paragraph`:

``` r

# with namespace prefix
xml2::xml_find_all(xml, ".//d1:paragraph")
#> {xml_nodeset (4)}
#> [1] <paragraph>\n  <text xml:space="preserve">This is a bunch of </text>\n  < ...
#> [2] <paragraph>\n  <text xml:space="preserve">this</text>\n</paragraph>
#> [3] <paragraph>\n  <text xml:space="preserve">is</text>\n</paragraph>
#> [4] <paragraph>\n  <text xml:space="preserve">a </text>\n  <strong>\n    <tex ...
```

Of course, having a default namespace in {xml2} has some drawbacks in
that [adding new nodes will duplicate the namespace with a different
identifier](https://community.rstudio.com/t/adding-nodes-in-xml2-how-to-avoid-duplicate-default-namespaces/84870),
so one way we have avoided this in {tinkr} (the package that does the
basic conversion) is to define a namespace with a prefix in a function
so that we can use it when querying:

``` r

tinkr::md_ns()
#> md <-> http://commonmark.org/xml/1.0
xml2::xml_find_all(xml, ".//md:paragraph", ns = tinkr::md_ns())
#> {xml_nodeset (4)}
#> [1] <paragraph>\n  <text xml:space="preserve">This is a bunch of </text>\n  < ...
#> [2] <paragraph>\n  <text xml:space="preserve">this</text>\n</paragraph>
#> [3] <paragraph>\n  <text xml:space="preserve">is</text>\n</paragraph>
#> [4] <paragraph>\n  <text xml:space="preserve">a </text>\n  <strong>\n    <tex ...
```

It’s also important to remember that *all nodes* will require this
namespace prefix, so if we wanted to only select paragraphs that were
inside of a list, we would need to specify use
`.//md:list//md:paragraph`:

``` r

xml2::xml_find_all(xml, ".//md:list//md:paragraph", ns = tinkr::md_ns())
#> {xml_nodeset (3)}
#> [1] <paragraph>\n  <text xml:space="preserve">this</text>\n</paragraph>
#> [2] <paragraph>\n  <text xml:space="preserve">is</text>\n</paragraph>
#> [3] <paragraph>\n  <text xml:space="preserve">a </text>\n  <strong>\n    <tex ...
```

### Pegboard namespace

One of the reasons why we created pegboard was to handle markdown
content that also included [fenced
divs](https://pandoc.org/MANUAL.html#divs-and-spans), but we needed a
way to programmatically label and extract them without affecting the
stylesheet that is used to translate the XML back to Markdown (not
covered in this tutorial). To acheive this we place nodes under a
different namespace around the fences and define our own namespace.

Here’s an example:

``` markdown
This is markdown with fenced divs

::: discussion

This is a discussion

:::

::: spoiler

This is a spoiler that is hidden by default

:::
```

When it’s parsed by commonmark, the fenced divs are treated as
paragraphs:

``` r

md <- 'This is markdown with fenced divs

::: discussion

This is a discussion

:::

::: spoiler

This is a spoiler that is hidden by default

:::
'
fences <- xml2::read_xml(commonmark::markdown_xml(md))
fences
#> {xml_document}
#> <document xmlns="http://commonmark.org/xml/1.0">
#> [1] <paragraph>\n  <text xml:space="preserve">This is markdown with fenced di ...
#> [2] <paragraph>\n  <text xml:space="preserve">::: discussion</text>\n</paragr ...
#> [3] <paragraph>\n  <text xml:space="preserve">This is a discussion</text>\n</ ...
#> [4] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
#> [5] <paragraph>\n  <text xml:space="preserve">::: spoiler</text>\n</paragraph>
#> [6] <paragraph>\n  <text xml:space="preserve">This is a spoiler that is hidde ...
#> [7] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
```

In {pegboard}, we have an internal function called
[`label_div_tags()`](https://carpentries.github.io/pegboard/reference/div_labels.md)
that will allow us to label and parse these tags without affecting the
markdown document:

``` r

pb <- asNamespace("pegboard")
pb$label_div_tags(fences)
fences
#> {xml_document}
#> <document xmlns="http://commonmark.org/xml/1.0">
#>  [1] <paragraph>\n  <text xml:space="preserve">This is markdown with fenced d ...
#>  [2] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-discussion"/>
#>  [3] <paragraph>\n  <text xml:space="preserve">::: discussion</text>\n</parag ...
#>  [4] <paragraph>\n  <text xml:space="preserve">This is a discussion</text>\n< ...
#>  [5] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
#>  [6] <dtag xmlns="http://carpentries.org/pegboard/" label="div-1-discussion"/>
#>  [7] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-spoiler"/>
#>  [8] <paragraph>\n  <text xml:space="preserve">::: spoiler</text>\n</paragraph>
#>  [9] <paragraph>\n  <text xml:space="preserve">This is a spoiler that is hidd ...
#> [10] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
#> [11] <dtag xmlns="http://carpentries.org/pegboard/" label="div-2-spoiler"/>
```

Note that we have defined a `<dtag>` XML node that is defined under the
pegboard namespace. These sandwich the nodes that we want to query and
allow us to use
[`tinkr::find_between()`](https://docs.ropensci.org/tinkr/reference/find_between.html)
to search for specific tags:

``` r

ns <- pb$get_ns()
ns # both md and pegboard namespaces
#> md <-> http://commonmark.org/xml/1.0
#> pb <-> http://carpentries.org/pegboard/
tinkr::find_between(fences, ns = ns, pattern = "pb:dtag[@label='div-1-discussion']")
#> {xml_nodeset (3)}
#> [1] <paragraph>\n  <text xml:space="preserve">::: discussion</text>\n</paragr ...
#> [2] <paragraph>\n  <text xml:space="preserve">This is a discussion</text>\n</ ...
#> [3] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
```

This is automated in the
[`get_divs()`](https://carpentries.github.io/pegboard/reference/get_divs.md)
internal function:

``` r

pb$get_divs(fences)
#> $`div-1-discussion`
#> {xml_nodeset (3)}
#> [1] <paragraph>\n  <text xml:space="preserve">::: discussion</text>\n</paragr ...
#> [2] <paragraph>\n  <text xml:space="preserve">This is a discussion</text>\n</ ...
#> [3] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
#> 
#> $`div-2-spoiler`
#> {xml_nodeset (3)}
#> [1] <paragraph>\n  <text xml:space="preserve">::: spoiler</text>\n</paragraph>
#> [2] <paragraph>\n  <text xml:space="preserve">This is a spoiler that is hidde ...
#> [3] <paragraph>\n  <text xml:space="preserve">:::</text>\n</paragraph>
```

## Conclusion

This is but a short introduction to using XML with {pegboard}. You now
have the basics of what the structure of XML is, how to use XPath (with
further resources), how to use XPath with namespaces, and how we use
namespaces in {pegboard} to allow us to parse specific items. It is a
good idea to practices working with XPath because it is useful not only
for working with XML representations of markdown documents, but it is
also heavily used for post-processing of HTML in both {pkgdown} and the
{sandpaper} packages.
