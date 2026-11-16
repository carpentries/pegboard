# Fix relative and jekyll links to be compatible with sandpaper

This function will perform the transformation on three node types:

## Usage

``` r
fix_sandpaper_links(body, yml = list(), path = NULL, known = NULL)
```

## Arguments

- body:

  an XML document

- yml:

  the list of key/value pairs derived from the `_config.yml` file

- path:

  the path to the current episode

- known:

  a character vector of known episodes in the lesson, relative to the
  lesson root.

## Value

the body, invisibly

## Details

- image

- link

- html_node

The transformation will be to remove relative paths ("../") and replace
Jekyll templating (e.g. " page.root " and " site.swc_pages " with either
nothing or the link to software carpentry, respectively.

## Note

This is absolutely NOT comprehensive and some links will fail to be
converted. If this happens, please report an issue:
<https://github.com/carpentries/pegboard/issues/new/>

## Examples

``` r

loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
e <- Episode$new(loop)
pegboard:::make_link_table(e)$orig
#>  [1] "https://docs.python.org/3/library/glob.html#glob.glob"                                 
#>  [2] "https://docs.python.org/3/library/glob.html"                                           
#>  [3] "https://docs.python.org/3/library/glob.html"                                           
#>  [4] "https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.shape.html"
#>  [5] "https://docs.python.org/3/library/stdtypes.html#str.split"                             
#>  [6] "https://carpentries.org/assets/img/TheCarpentries.svg"                                 
#>  [7] "../no-workie.svg"                                                                      
#>  [8] "{{ page.root }}/index.html"                                                            
#>  [9] "{{ site.swc_pages }}/shell-novice"                                                     
#> [10] "https://carpentries.org/assets/img/TheCarpentries.svg"                                 
#> [11] "../no-workie.svg"                                                                      
#> [12] "{{ page.root }}/no-workie.svg"                                                         
#> [13] "{{ page.root }}{% link index.md %}"                                                    
e$use_sandpaper()
pegboard:::make_link_table(e)$orig
#>  [1] "https://docs.python.org/3/library/glob.html#glob.glob"                                 
#>  [2] "https://docs.python.org/3/library/glob.html"                                           
#>  [3] "https://docs.python.org/3/library/glob.html"                                           
#>  [4] "https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.shape.html"
#>  [5] "https://docs.python.org/3/library/stdtypes.html#str.split"                             
#>  [6] "https://carpentries.org/assets/img/TheCarpentries.svg"                                 
#>  [7] "no-workie.svg"                                                                         
#>  [8] "index.html"                                                                            
#>  [9] "https://swcarpentry.github.io/shell-novice"                                            
#> [10] "https://carpentries.org/assets/img/TheCarpentries.svg"                                 
#> [11] "no-workie.svg"                                                                         
#> [12] "no-workie.svg"                                                                         
#> [13] "index.md"                                                                              
```
