% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/div.R
\name{label_div_tags}
\alias{label_div_tags}
\alias{find_div_tags}
\alias{clear_div_labels}
\title{Add labels to div tags in the form of a "dtag" node with a paired "label"
attribute.}
\usage{
label_div_tags(body)

find_div_tags(body)

clear_div_labels(body)
}
\arguments{
\item{body}{an xml document}
}
\value{
\itemize{
\item \code{label_div_tags()}: the document, modified
\item \code{clear_div_labels()}: the document, modified
\item \code{find_div_tags()}: a node list
}
}
\description{
Add labels to div tags in the form of a "dtag" node with a paired "label"
attribute.
}
\examples{
txt <- "# Example with a mix of div tags

> PLEASE NEVER DO THE LESSONS THIS WAY
>
> I AM LITERALLY JUST TESTING A TERRIBLE EXAMPLE.

--------------------------------------------------------------------------------

<div class='challenge'>
## Challenge

do that challenging thing.

```{r}
cat('it might be challenging to do this')
```
:::: solution
```{r}
It's not that challenging
```
:::
<div class='solution'>
We just have to try harder and use `<div>` tags

:::::: callout
```{r}
cat('better faster stronger with <div>')
```
::::
:::::: discussion
<img src='https://carpentries.org/logo.svg'/>
:::::
</div>
</div>

<div class='good'>

## Good divs

</div>
" 
tmp <- tempfile()
writeLines(txt, tmp)
ex <- tinkr::to_xml(tmp)
ex$body
pegboard:::label_div_tags(ex$body)
ex$body
pegboard:::clear_div_labels(ex$body)
}
\seealso{
Other div: 
\code{\link{clean_div_tags}()},
\code{\link{find_between_tags}()},
\code{\link{find_div_pairs}()},
\code{\link{get_divs}()},
\code{\link{label_pairs}()},
\code{\link{make_div_pairs}()},
\code{\link{make_div}()},
\code{\link{replace_with_div}()}
}
\concept{div}
\keyword{internal}
