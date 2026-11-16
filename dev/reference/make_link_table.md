# Create a table of parsed URLs from a single Episode object.

Create a table of parsed URLs from a single Episode object.

## Usage

``` r
make_link_table(yrn)
```

## Arguments

- yrn:

  an Episode class object

## Value

a data frame containing the following columns:

- scheme The scheme for the URL (http, https, mailto, ftp, etc...)

- server The first part of the URL (e.g. doi.org or github.com)

- port the port number if it exists (note: liquid tags produce weird
  ports)

- user associated with port, usually blank

- path the path element of the link

- query anything after a "?" in a URL

- fragment navigation within a page; anything after "#" in a URL

- orig the original, unparsed URL

- text the text associated with the URL (stripped of markup)

- title the title (if any) of the URL

- type the type of URL (image or link)

- rel if it's a relative URL, the name of the anchor, otherwise NA.

- anchor logical if the URL is an anchor

- sourcepos the source position in the file

- filepath relative path to the source file

- parents list column of paths to the build parents

- node a list column of the nodes with the links

## Examples

``` r
loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
make_link_table(Episode$new(loop))
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
#> 13                                   -1     
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
```
