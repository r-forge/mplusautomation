\name{getSavedata_Fileinfo}
\Rdversion{1.1}
\alias{getSavedata_Fileinfo}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getSavedata_Fileinfo(outfile)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{outfile}{
%%     ~~Describe \code{outfile} here~~
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
function (outfile) 
{
    require(gsubfn)
    if (!file.exists(outfile)) {
        stop("Cannot locate outfile: ", outfile)
    }
    readfile <- scan(outfile, what = "character", sep = "\n", 
        strip.white = TRUE)
    if (length(readfile) == 0) {
        warning("Empty outfile")
        return(NULL)
    }
    savedataStart <- grep("^\\s*SAVEDATA INFORMATION\\s*$", readfile, 
        ignore.case = TRUE, perl = TRUE)
    savedataEnd <- grep("^\\s*Save file record length\\s+\\d+$", 
        readfile, ignore.case = TRUE, perl = TRUE)
    stopifnot(savedataStart > 0, savedataEnd > 0)
    savedataSection <- readfile[savedataStart:savedataEnd]
    orderStart <- grep("^\\s*Order and format of variables\\s*$", 
        savedataSection, ignore.case = TRUE, perl = TRUE)
    saveFileStart <- grep("^\\s*Save file\\s*$", savedataSection, 
        ignore.case = TRUE, perl = TRUE)
    variablesToParse <- savedataSection[(orderStart + 1):(saveFileStart - 
        1)]
    variableNames <- sub("^([\\w\\d\\.]+)\\s+[\\w\\d\\.]+\\s*$", 
        "\\1", variablesToParse, perl = TRUE)
    variableFormats <- sub("^[\\w\\d\\.]+\\s+([\\w\\d\\.]+)\\s*$", 
        "\\1", variablesToParse, perl = TRUE)
    variableWidths <- strapply(variableFormats, "[EFG]+(\\d+)\\.\\d+", 
        as.numeric, perl = TRUE, simplify = TRUE)
    fileName <- sub("^\\s*", "", savedataSection[saveFileStart + 
        1], perl = TRUE)
    fileName <- sub("\\s*$", "", fileName, perl = TRUE)
    return(list(fileName = fileName, varNames = variableNames, 
        varFormats = variableFormats, varWidths = variableWidths))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
