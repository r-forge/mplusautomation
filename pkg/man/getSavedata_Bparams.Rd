\name{getSavedata_Bparams}
\Rdversion{1.1}
\alias{getSavedata_Bparams}
\title{Load the draws from the Bayesian model posterior distribution (SAVEDATA BPARAMETERS) command into an R data.frame}
\description{
This function reads a the BPARAMETERS output file from the Mplus SAVEDATA BPARAMETERS command
and returns an R \code{data.frame} object.
}
\usage{
getSavedata_Bparams(outfile)
}
\arguments{
  \item{outfile}{required. The name of the Mplus output file to read. Can be an absolute or relative path.
  If \code{outfile} is a relative path or just the filename, then it is assumed that the file resides in
  the working directory \code{getwd()}.}
}
\value{
a \code{data.frame} containing the draws from the posterior distribution for a Bayesian model that uses the 
SAVEDATA BPARAMETERS command. 
}
%\references{
%% ~put references to the literature/web site here ~
%}
\author{Michael Hallquist}
\note{
Note that the \code{outfile} parameter should refer to the Mplus output file (.out extension), not the
actual dataset generated by SAVEDATA. This function reads information about the dataset from the .out file
and loads the dataset accordingly.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{getSavedata_Fileinfo}}
\code{\link{getSavedata_Data}}
}
%\examples{
%fileInfo <- getSavedata_Data("C:/Program Files/Mplus/Test Output.out")
%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{interface}