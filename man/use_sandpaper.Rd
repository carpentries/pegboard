% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/use_sandpaper.R
\name{use_sandpaper}
\alias{use_sandpaper}
\title{Convert a Jekyll-based lesson to a sandpaper-based lesson}
\usage{
use_sandpaper(body, rmd = TRUE, yml = list(), path = NULL, known_paths = NULL)
}
\arguments{
\item{body}{the xml body of an episode}

\item{rmd}{if \code{TRUE}, the chunks will be converted to RMarkdown chunks}

\item{yml}{a list derived from the \verb{_config.yml} file that defines the site
variables.}

\item{path}{the path to the source of the body. Defaults to NULL. This is
used in conjunction with \code{known_paths}}

\item{known_paths}{a character vector with the known paths in the lesson.
This is used to determine the correct path to other files in the lesson.}
}
\value{
the body
}
\description{
Convert a Jekyll-based lesson to a sandpaper-based lesson
}
\details{
A Jekyll episode is littered with kramdown inline attribute tags
and liquid-formatted links. Converting to sandpaper means the following:
\itemize{
\item links using liquid formatting (e.g. \verb{[text](\{\{ site.path \}\}/01-episode/)}
are replaced with their relative counterparts (\verb{[text](01-episode.md)}.
\item include statements for \code{links.md} and \code{base_path.md} are removed
\item image attributes have the kramdown \code{:} removed
\item code blocks with a kramdown inline attribute tag are converted to
commonmark via the internal \code{\link[=liquid_to_commonmark]{liquid_to_commonmark()}}.
\item Lesson template-specific code is removed from the setup chunk in R
Markdown files.
}
}
\keyword{internal}
