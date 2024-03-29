% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_link_table.R
\name{make_link_table}
\alias{make_link_table}
\title{Create a table of parsed URLs from a single Episode object.}
\usage{
make_link_table(yrn)
}
\arguments{
\item{yrn}{an Episode class object}
}
\value{
a data frame containing the following columns:
\itemize{
\item scheme The scheme for the URL (http, https, mailto, ftp, etc...)
\item server The first part of the URL (e.g. doi.org or github.com)
\item port the port number if it exists (note: liquid tags produce weird ports)
\item user associated with port, usually blank
\item path the path element of the link
\item query anything after a "?" in a URL
\item fragment navigation within a page; anything after "#" in a URL
\item orig the original, unparsed URL
\item text the text associated with the URL (stripped of markup)
\item title the title (if any) of the URL
\item type the type of URL (image or link)
\item rel if it's a relative URL, the name of the anchor, otherwise NA.
\item anchor logical if the URL is an anchor
\item sourcepos the source position in the file
\item filepath relative path to the source file
\item parents list column of paths to the build parents
\item node a list column of the nodes with the links
}
}
\description{
Create a table of parsed URLs from a single Episode object.
}
\examples{
loop <- fs::path(lesson_fragment(), "_episodes", "14-looping-data-sets.md")
make_link_table(Episode$new(loop))
}
\keyword{internal}
