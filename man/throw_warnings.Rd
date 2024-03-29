% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-validation.R
\name{throw_heading_warnings}
\alias{throw_heading_warnings}
\alias{throw_div_warnings}
\alias{throw_link_warnings}
\title{Throw a validation report as a single message}
\usage{
throw_heading_warnings(VAL)

throw_div_warnings(VAL)

throw_link_warnings(VAL)
}
\arguments{
\item{VAL}{\verb{[data.frame]} a validation report derived from one of the
\code{validate} functions.}
}
\value{
NULL, invisibly. This is used for it's side-effect of formatting and
issuing messages via \code{\link[=issue_warning]{issue_warning()}}.
}
\description{
Collapse a variable number of validation reports into a single message that
can be formatted for the CLI or GitHub.
}
\details{
One of the key features of {pegboard} is the ability to parse and
validate markdown elements. These functions provide a standard way of
creating the reports that are for the user based on whether or not they are
on the CLI or on GitHub. The prerequisites of these functions are the input
data frame (generated from the actual validation function) and an internal
set of known templating vectors that contain templates for each test to show
the actual error along with general information that can help correct the
error (see below).
\subsection{Input Data Frame}{

The validations are initially reported in a data frame that has the
following properties:
\itemize{
\item one row per element
\item columns that indicate the parsed attributes of the element, source
file, source position, and the actual element XML node object.
\item boolean columns that indicate the tests for each element, used with
\code{\link[=collect_labels]{collect_labels()}} to add a "labels" column to the data.
}
}

\subsection{Templating vectors}{

These vectors come in two forms \verb{[thing]_tests} and \verb{[thing]_info} (e.g.
for \code{\link[=validate_links]{validate_links()}}, we have \code{link_tests} and \code{link_info}). These are
named vectors that match the boolean columns of the data frame produced
by the validation function. The \verb{[thing]_tests} vector contains templates
that describes the error and shows the text that caused the error. The
\verb{[thing]_info} contains general information about how to address that
particular error. For example, one common link error is that a link is not
descriptive (e.g. the link text says "click here"). The column in the \code{VAL}
data frame that contains the result of this test is called "descriptive", so
if we look at the values from the link info and tests vectors:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{link_info["descriptive"]
#>                                                                                          descriptive 
#> "Avoid uninformative link phrases <https://webaim.org/techniques/hypertext/link_text#uninformative>"
link_tests["descriptive"]
#>                                   descriptive 
#> "[uninformative link text]: [\{text\}](\{orig\})"
}\if{html}{\out{</div>}}

If the \verb{throw_*_warnings()} functions detect any errors, they will use the
info and tests vectors to construct a composite message.
}

\subsection{Process}{

The \verb{throw_*_warnings()} functions all do the same basic procedure (and
indeed could be consolidated into a single function in the future)
\enumerate{
\item pass data to \code{\link[=collect_labels]{collect_labels()}}, which will parse the \verb{[thing]_tests}
templating vector and label each failing element in \code{VAL} with the
appropriate failure message
\item gather the source information for each failure
\item pass failures with the \verb{[thing]_info} elements that matched the unique
failures to  \code{\link[=issue_warning]{issue_warning()}}
}
}
}
\seealso{
\code{\link[=validate_links]{validate_links()}}, \code{\link[=validate_divs]{validate_divs()}}, and \code{\link[=validate_headings]{validate_headings()}} for
input sources for these functions.
}
