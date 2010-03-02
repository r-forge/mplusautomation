\name{extractModelResults}
\Rdversion{1.1}
\alias{extractModelResults}
\title{Extract Model Parameters from MODEL RESULTS section.}
\description{
Extracts the model parameters from the MODEL RESULTS section of a given Mplus output file.
Parameters include the parameter estimate, std. err, param/s.e., and two-tailed p-value.
Model results are returned as a \code{data.frame} object. 
}
\usage{
extractModelResults(outfile)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{outfile}{the output file to be parsed for model parameters. May be a full path, relative path, or a filename within
  the working directory. Example: "C:/Users/Michael/Mplus Runs/Model 23.out"}
}

\value{returns a \code{data.frame} containing the MODEL RESULTS section of \code{outfile}. Variables include
\item{paramHeader}{The header that begins a given parameter set. Example: "FACTOR1 BY"}
\item{param}{The particular parameter being measured (within \code{paramHeader}). Example: "ITEM1"}
\item{paramest}{Parameter estimate value.}
\item{se}{Standard error of the estimate}
\item{est_se}{Quotient of \code{paramest/se}, representing z-test/t-test in large samples}
\item{pval}{Two-tailed p-value for the \code{est_se} quotient.}
}
\author{Michael Hallquist}
\seealso{
\code{\link{parseModels}}
}
\keyword{interface}