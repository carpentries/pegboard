% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validate_divs.R
\docType{data}
\name{validate_divs}
\alias{validate_divs}
\alias{div_is_known}
\alias{KNOWN_DIVS}
\alias{div_tests}
\alias{div_info}
\title{Validate Callout Blocks for sandpaper episodes}
\format{
An object of class \code{character} of length 16.

An object of class \code{character} of length 1.

An object of class \code{character} of length 1.
}
\usage{
validate_divs(yrn)

div_is_known(div_table)

KNOWN_DIVS

div_tests

div_info
}
\arguments{
\item{yrn}{a \link[tinkr:yarn]{tinkr::yarn} or \link{Episode} object.}

\item{div_table}{a data frame derived from \code{\link[=make_div_table]{make_div_table()}}}
}
\value{
a data frame with the following columns:
\itemize{
\item div: the type of div
\item label: the label of the div
\item line: the line number of the div label
\item is_known: a logical value if the div is a known type (\code{TRUE}) or not (\code{FALSE})
}
}
\description{
The Carpentries Workbench uses \href{https://pandoc.org/MANUAL.html#extension-fenced_divs}{pandoc fenced divs} to create special
blocks within the lesson for learners and instructors to provide breaks in
the narrative flow for focus on specific tasks or caveats. These fenced divs
look something like this:
}
\details{
\if{html}{\out{<div class="sourceCode markdown">}}\preformatted{::: callout

### Hello!

This is a callout block

:::
}\if{html}{\out{</div>}}

Lessons created with The Carpentries Workbench are expected to have the
following fenced divs:
\itemize{
\item objectives (top)
\item questions (top)
\item keypoints (bottom)
}

The following fenced divs can occur in the lesson, but are not required:
\itemize{
\item prereq
\item callout
\item caution
\item challenge
\item solution (nested inside challenge)
\item hint (nested inside challenge)
\item discussion
\item checklist
\item testimonial
\item tab (can only contain text, images, and code blocks)
\item group-tab (can only contain text, images, and code blocks)
}

Any other div names will produce structure in the resulting DOM, but they
will not have any special visual styling.
}
\keyword{datasets}
