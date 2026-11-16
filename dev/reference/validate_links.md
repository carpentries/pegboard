# Validate Links in a markdown document

This function will validate that links do not throw an error in markdown
documents. This will include links to images and will respect robots.txt
for websites.

## Usage

``` r
validate_links(yrn)

allowed_uri_protocols

link_known_protocol(VAL)

link_enforce_https(VAL)

link_all_reachable(VAL)

link_img_alt_text(VAL)

link_length(VAL)

link_descriptive(VAL)

link_source_list(lt)

link_internal_anchor(VAL, source_list, headings, body)

link_internal_file(VAL, source_list, root)

link_internal_well_formed(VAL, source_list)

link_tests

link_info
```

## Format

- `allowed_uri_protocols` a character string of length 23

&nbsp;

- `link_tests` a character string of length 9 containing templates that
  use the output of `validate_links()` for formatting.

&nbsp;

- `link_info` a character string of length 9 that gives information and
  informative links for additional context for failures.

## Arguments

- yrn:

  a [tinkr::yarn](https://docs.ropensci.org/tinkr/reference/yarn.html)
  or
  [Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
  object.

- lt:

  the output of
  [`make_link_table()`](https://carpentries.github.io/pegboard/dev/reference/make_link_table.md)

- source_list:

  output of `link_source_list`

- headings:

  an `xml_nodeset` of headings

- body:

  an `xml_document`

- root:

  the root path to the folder containing the file OR containing the
  paths to the ultimate parent files.

## Value

a data frame with parsed information from
[`xml2::url_parse()`](http://xml2.r-lib.org/reference/url_parse.md) and
columns of logical values indicating the tests that passed.

## Details

### Link Validity

All links must resolve to a specific location. If it does not exist,
then the link is invalid. At the moment, we can only do local links.

#### External links

These links must start with a valid and secure protocol. Allowed
protocols are taken from the [allowed protocols in
Wordpress](https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return):
http, https, ftp, ftps, mailto, news, irc, irc6, ircs, gopher, nntp,
feed, telnet, mms, rtsp, sms, svn, tel, fax, xmpp, webcal, urn

Misspellings and unsupported protocols (e.g. `javascript:` and
`bitcoin:` will be flagged).

In addition, we will enforce the use of HTTPS over HTTP.

#### Cross-lesson links

These links will have no protocol, but should resolve to the HTML
version of a page and have the correct capitalisation.

#### Anchors (aka fragments)

Anchors are located at the end of URLs that start with a `#` sign. These
are used to indicate a section of the documenation or a span id.

### Accessibility (a11y)

Accessibillity ensures that your links are accurate and descriptive for
people who have slow connections or use screen reader technology.

#### Alt-text (for images)

All images must have associated alt-text. In pandoc, this is acheived by
writing the `alt` attribute in curly braces after the image:
`![image caption](link){alt='alt text'}`:
<https://webaim.org/techniques/alttext/>

#### Descriptive text

All links must have descriptive text associated with them, which is
beneficial for screen readers scanning the links on a page to not have a
list full of "link", "link", "link":
<https://webaim.org/techniques/hypertext/link_text#uninformative>

#### Text length

Link text length must be greater than 1:
<https://webaim.org/techniques/hypertext/link_text#link_length>

## Note

At the moment, we do not currently test if all links are reachable. This
is a feature planned for the future.

This function is internal. Please use the methods for the
[Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
and
[Lesson](https://carpentries.github.io/pegboard/dev/reference/Lesson.md)
classes.

## See also

[Episode](https://carpentries.github.io/pegboard/dev/reference/Episode.md)
and
[Lesson](https://carpentries.github.io/pegboard/dev/reference/Lesson.md)
for the methods that will throw warnings

## Examples

``` r
l <- Lesson$new(lesson_fragment())
e <- l$episodes[[3]]
# Our link validators run a series of tests on links and images and return a 
# data frame with information about the links (via xml2::url_parse), along 
# with the results of the tests
v <- asNamespace('pegboard')$validate_links(e)
names(v)
#>  [1] "scheme"               "server"               "port"                
#>  [4] "user"                 "path"                 "query"               
#>  [7] "fragment"             "orig"                 "text"                
#> [10] "alt"                  "title"                "type"                
#> [13] "rel"                  "anchor"               "sourcepos"           
#> [16] "filepath"             "parents"              "node"                
#> [19] "known_protocol"       "enforce_https"        "internal_anchor"     
#> [22] "internal_file"        "internal_well_formed" "all_reachable"       
#> [25] "img_alt_text"         "descriptive"          "link_length"         
v
#>    scheme            server        port user
#> 1   https   docs.python.org          NA     
#> 2   https   docs.python.org          NA     
#> 3   https   docs.python.org          NA     
#> 4   https pandas.pydata.org          NA     
#> 5   https   docs.python.org          NA     
#> 9   https   carpentries.org          NA     
#> 10                                   NA     
#> 6                                 25817     
#> 7                           -1848695440     
#> 11  https   carpentries.org          NA     
#> 12                                   NA     
#> 13                                    1     
#> 8                                 25817     
#>                                                             path query
#> 1                                           /3/library/glob.html      
#> 2                                           /3/library/glob.html      
#> 3                                           /3/library/glob.html      
#> 4  /pandas-docs/stable/reference/api/pandas.DataFrame.shape.html      
#> 5                                       /3/library/stdtypes.html      
#> 9                                 /assets/img/TheCarpentries.svg      
#> 10                                              ../no-workie.svg      
#> 6                                                                     
#> 7                                                                     
#> 11                                /assets/img/TheCarpentries.svg      
#> 12                                              ../no-workie.svg      
#> 13                                                                    
#> 8                                                                     
#>     fragment
#> 1  glob.glob
#> 2           
#> 3           
#> 4           
#> 5  str.split
#> 9           
#> 10          
#> 6           
#> 7           
#> 11          
#> 12          
#> 13          
#> 8           
#>                                                                                      orig
#> 1                                   https://docs.python.org/3/library/glob.html#glob.glob
#> 2                                             https://docs.python.org/3/library/glob.html
#> 3                                             https://docs.python.org/3/library/glob.html
#> 4  https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.shape.html
#> 5                               https://docs.python.org/3/library/stdtypes.html#str.split
#> 9                                   https://carpentries.org/assets/img/TheCarpentries.svg
#> 10                                                                       ../no-workie.svg
#> 6                                                              {{ page.root }}/index.html
#> 7                                                       {{ site.swc_pages }}/shell-novice
#> 11                                  https://carpentries.org/assets/img/TheCarpentries.svg
#> 12                                                                       ../no-workie.svg
#> 13                                                          {{ page.root }}/no-workie.svg
#> 8                                                      {{ page.root }}{% link index.md %}
#>                                              text            alt title  type
#> 1                                       glob.glob           <NA>        link
#> 2                                            glob           <NA>        link
#> 3                                            glob           <NA>        link
#> 4                                    shape method           <NA>        link
#> 5                                           split           <NA>        link
#> 9                                                 books as clubs  <NA>   img
#> 10                                                books as clubs  <NA>   img
#> 6                                            Home           <NA>  <NA>  link
#> 7                                           shell           <NA>  <NA>  link
#> 11                               Carpentries logo           <NA>       image
#> 12                              Non-working image           <NA>       image
#> 13           Non-working image with jekyll syntax           <NA>  <NA> image
#> 8  link that isn't parsed correctly by commonmark           <NA>  <NA>  link
#>     rel anchor sourcepos                          filepath parents         node
#> 1  <NA>  FALSE        51 _episodes/14-looping-data-sets.md         <link so....
#> 2  <NA>  FALSE        57 _episodes/14-looping-data-sets.md         <link so....
#> 3  <NA>  FALSE        58 _episodes/14-looping-data-sets.md         <link so....
#> 4  <NA>  FALSE       140 _episodes/14-looping-data-sets.md         <link so....
#> 5  <NA>  FALSE       163 _episodes/14-looping-data-sets.md         <link so....
#> 9  <NA>  FALSE       189 _episodes/14-looping-data-sets.md         <img src....
#> 10 <NA>  FALSE       191 _episodes/14-looping-data-sets.md         <img src....
#> 6  <NA>  FALSE       193 _episodes/14-looping-data-sets.md         <link de....
#> 7  <NA>  FALSE       193 _episodes/14-looping-data-sets.md         <link de....
#> 11 <NA>  FALSE       195 _episodes/14-looping-data-sets.md         <image s....
#> 12 <NA>  FALSE       197 _episodes/14-looping-data-sets.md         <image s....
#> 13 <NA>  FALSE       199 _episodes/14-looping-data-sets.md         <image d....
#> 8  <NA>  FALSE       201 _episodes/14-looping-data-sets.md         <link de....
#>    known_protocol enforce_https internal_anchor internal_file
#> 1            TRUE          TRUE            TRUE          TRUE
#> 2            TRUE          TRUE            TRUE          TRUE
#> 3            TRUE          TRUE            TRUE          TRUE
#> 4            TRUE          TRUE            TRUE          TRUE
#> 5            TRUE          TRUE            TRUE          TRUE
#> 9            TRUE          TRUE            TRUE          TRUE
#> 10           TRUE          TRUE            TRUE         FALSE
#> 6            TRUE          TRUE            TRUE          TRUE
#> 7            TRUE          TRUE            TRUE          TRUE
#> 11           TRUE          TRUE            TRUE          TRUE
#> 12           TRUE          TRUE            TRUE         FALSE
#> 13           TRUE          TRUE            TRUE          TRUE
#> 8            TRUE          TRUE            TRUE          TRUE
#>    internal_well_formed all_reachable img_alt_text descriptive link_length
#> 1                  TRUE          TRUE         TRUE        TRUE        TRUE
#> 2                  TRUE          TRUE         TRUE        TRUE        TRUE
#> 3                  TRUE          TRUE         TRUE        TRUE        TRUE
#> 4                  TRUE          TRUE         TRUE        TRUE        TRUE
#> 5                  TRUE          TRUE         TRUE        TRUE        TRUE
#> 9                  TRUE          TRUE         TRUE        TRUE        TRUE
#> 10                 TRUE          TRUE         TRUE        TRUE        TRUE
#> 6                  TRUE          TRUE         TRUE        TRUE        TRUE
#> 7                  TRUE          TRUE         TRUE        TRUE        TRUE
#> 11                 TRUE          TRUE        FALSE        TRUE        TRUE
#> 12                 TRUE          TRUE        FALSE        TRUE        TRUE
#> 13                 TRUE          TRUE        FALSE        TRUE        TRUE
#> 8                  TRUE          TRUE         TRUE        TRUE        TRUE
# URL protocols -----------------------------------------------------------
# To avoid potentially malicious situations, we have an explicit list of
# allwed URI protocols, which can be found in the `allowed_uri_protocols`
# character vector:
asNamespace('pegboard')$allowed_uri_protocols
#>  [1] ""       "http"   "https"  "ftp"    "ftps"   "mailto" "news"   "irc"   
#>  [9] "irc6"   "ircs"   "gopher" "nntp"   "feed"   "telnet" "mms"    "rtsp"  
#> [17] "sms"    "svn"    "tel"    "fax"    "xmpp"   "webcal" "urn"   
# note that we make an additional check for the http protocol.

# Creating Warnings from the table ----------------------------------------
# The validator does not produce any warnings or messages, but this data
# frame can be passed on to other functions that will throw them for us. We
# have a function that will throw a warning/message for each link that
# fails the tests. These messages are controlled by `link_tests` and 
# `link_info`.
asNamespace('pegboard')$link_tests
#>                                                 known_protocol 
#>                                 "[invalid protocol]: {scheme}" 
#>                                                  enforce_https 
#>                              "[needs HTTPS]: [{text}]({orig})" 
#>                                                internal_anchor 
#>                           "[missing anchor]: [{text}]({orig})" 
#>                                                  internal_file 
#>    "[missing file{format_parents(parents)}]: [{text}]({orig})" 
#>                                           internal_well_formed 
#> "[incorrect formatting]: [{text}][{orig}] -> [{text}]({orig})" 
#>                                                  all_reachable 
#>                                                             "" 
#>                                                   img_alt_text 
#>                             "[image missing alt-text]: {orig}" 
#>                                                    descriptive 
#>                  "[uninformative link text]: [{text}]({orig})" 
#>                                                    link_length 
#>                      "[link text too short]: [{text}]({orig})" 
asNamespace('pegboard')$link_info
#>                                                                                                                                                                               known_protocol 
#> "Links must have a known URL protocol (e.g. https, ftp, mailto). See <https://developer.wordpress.org/reference/functions/wp_allowed_protocols/#return> for a list of acceptable protocols." 
#>                                                                                                                                                                                enforce_https 
#>                                                                                                                                   "Links must use HTTPS <https://https.cio.gov/everything/>" 
#>                                                                                                                                                                              internal_anchor 
#>                                                                                                                     "Some link anchors for relative links (e.g. [anchor]: link) are missing" 
#>                                                                                                                                                                                internal_file 
#>                                            "Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>" 
#>                                                                                                                                                                         internal_well_formed 
#>                                                                                                                                                      "Some links were incorrectly formatted" 
#>                                                                                                                                                                                all_reachable 
#>                                                                                                                                                                                           "" 
#>                                                                                                                                                                                 img_alt_text 
#>                                                                                                          "Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>" 
#>                                                                                                                                                                                  descriptive 
#>                                                                                         "Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>" 
#>                                                                                                                                                                                  link_length 
#>                                                                                   "Avoid single-letter or missing link text <https://webaim.org/techniques/hypertext/link_text#link_length>" 
asNamespace('pegboard')$throw_link_warnings(v)
#> ! There were errors in 4/13 images
#> ◌ Some linked internal files do not exist <https://carpentries.github.io/sandpaper/articles/include-child-documents.html#workspace-consideration>
#> ◌ Images need alt-text <https://webaim.org/techniques/hypertext/link_text#alt_link>
#> 
#> ::warning file=_episodes/14-looping-data-sets.md,line=191:: [missing file]: [](../no-workie.svg)
#> ::warning file=_episodes/14-looping-data-sets.md,line=195:: [image missing alt-text]: https://carpentries.org/assets/img/TheCarpentries.svg
#> ::warning file=_episodes/14-looping-data-sets.md,line=197:: [missing file]: [Non-working image](../no-workie.svg) [image missing alt-text]: ../no-workie.svg
#> ::warning file=_episodes/14-looping-data-sets.md,line=199:: [image missing alt-text]: { page.root }/no-workie.svg
```
