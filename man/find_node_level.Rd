% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{find_node_level}
\alias{find_node_level}
\title{Find the level of the current node releative to the document}
\usage{
find_node_level(node)
}
\arguments{
\item{node}{an XML node object}
}
\value{
a number indicating how nested the current node is. 0 represents the
document itself, 1 represents all child elements of the document, etc.
}
\description{
Find the level of the current node releative to the document
}
\keyword{internal}
