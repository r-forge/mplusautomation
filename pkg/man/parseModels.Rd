\name{parseModels}
\Rdversion{1.1}
\alias{parseModels}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
parseModels(directory = getwd(), recursive = FALSE, filefilter)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{directory}{
%%     ~~Describe \code{directory} here~~
}
  \item{recursive}{
%%     ~~Describe \code{recursive} here~~
}
  \item{filefilter}{
%%     ~~Describe \code{filefilter} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (directory = getwd(), recursive = FALSE, filefilter) 
{
    curdir <- getwd()
    setwd(directory)
    filelist <- list.files(recursive = recursive)
    outfiles <- filelist[grep(".*\\.out", filelist, ignore.case = TRUE)]
    if (!missing(filefilter)) {
        dropOutExtensions <- sapply(outfiles, function(x) {
            if (nchar(x) >= 4) 
                return(tolower(substr(x, 1, (nchar(x) - 4))))
        })
        outfiles <- outfiles[grep(paste(".*", filefilter, ".*", 
            sep = ""), dropOutExtensions, ignore.case = TRUE, 
            perl = TRUE)]
    }
    if (length(outfiles) == 0) {
        warning("No output files detected in this directory.")
        return(NULL)
    }
    details <- c()
    for (i in 1:length(outfiles)) {
        readfile <- scan(outfiles[i], what = "character", sep = "\n", 
            strip.white = TRUE)
        details <- rbind(details, modelParams(readfile, outfiles[i]))
    }
    setwd(curdir)
    return(details)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
