% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{fix_liquid_relative_link}
\alias{fix_liquid_relative_link}
\title{Remove spaces in relative links with liquid variables}
\usage{
fix_liquid_relative_link(path, encoding = "UTF-8")
}
\arguments{
\item{path}{path to an MD file}

\item{encoding}{encoding of the text, defaults to UTF-8}
}
\description{
Liquid has a syntax that wraps variables in double moustache braces that may
or may not have spaces within the moustaches. For example, to get the link
of the page root, you would use {{ page.root }} to make it more readable.
However, this violates the expectation of the commonmark parser and makes it
think “oh, this is just ordinary text”.
}
\details{
This function fixes the issue by removing the spaces within the braces.
}
