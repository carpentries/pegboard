% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_images.R
\name{get_images}
\alias{get_images}
\title{Get images from an Episode/yarn object}
\usage{
get_images(yrn, process = TRUE)
}
\arguments{
\item{yrn}{an Episode/yarn object}

\item{process}{if \code{TRUE} (default), images will be processed via
\code{\link[=process_images]{process_images()}} to add the alt attribute and extract images from HTML
blocks. \code{FALSE} will present the nodes as found by XPath search.}
}
\value{
an xml_nodelist
}
\description{
Get images from an Episode/yarn object
}
\details{
Markdown users can write images as either markdown or HTML. If they
write images as HTML, then the commonmark XML parser recognises these as
generic "HTML blocks" and they can't be found by just searching for
\verb{.//md:image}. This function searches both \code{md:html_block} and
\code{md:html_inline} for image content that it can extract for downstream
analysis.
}
\examples{
tmp <- tempfile()
on.exit(unlink(tmp))
txt <- '
![a kitten](https://placekitten.com/200/200){alt="a pretty kitten"}

<!-- an html image of a kitten -->
<img src="https://placekitten.com/200/200">

an inline html image of a kitten <img src="https://placekitten.com/50/50">
'
writeLines(txt, tmp)
ep <- Episode$new(tmp)
ep$show()
# without process = TRUE, images in HTML elements are not converted
ep$get_images() 
# setting process = TRUE will extract the HTML elements for analysis 
# (e.g to detect alt text)
ep$get_images(process = TRUE)
}
\keyword{internal}
