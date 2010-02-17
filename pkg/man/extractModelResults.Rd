\name{extractModelResults}
\Rdversion{1.1}
\alias{extractModelResults}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
extractModelResults(outfile)
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
    require(plyr)
    readfile <- scan(outfile, what = "character", sep = "\n", 
        strip.white = TRUE, blank.lines.skip = FALSE)
    beginModel <- grep("^MODEL RESULTS$", readfile)
    endModel <- 0
    for (row in beginModel + 1:length(readfile)) {
        if (row < length(readfile) && readfile[row] == "" && 
            readfile[row + 1] == "") {
            endModel <- row
            break
        }
    }
    stopifnot(length(beginModel) == 1, endModel > 0)
    if (!readfile[beginModel + 1] == "") 
        warning("no blank line following MODEL RESULTS")
    if (!readfile[beginModel + 2] == "Two-Tailed") 
        warning("model results + 2 != two-tailed")
    if (!regexpr("^\\s*Estimate\\s+S\\.E\\.\\s+Est\\./S\\.E\\.\\s+P-Value\\s*$", 
        readfile[beginModel + 3], perl = TRUE) > 0) {
        warning("model results + 3 is not the estimate s.e. line")
    }
    modelSection <- readfile[(beginModel + 1):(endModel - 1)]
    matches <- gregexpr("^\\s*((Means|Thresholds|Intercepts|Variances|Residual Variances)|([\\w_\\d+\\.]+\\s+(BY|WITH|ON|\\|)))\\s*$", 
        modelSection, perl = TRUE)
    convertMatches <- ldply(matches, function(row) data.frame(start = row, 
        end = attr(row, "match.length")))
    convertMatches$line <- 1:nrow(convertMatches)
    convertMatches <- subset(convertMatches, start > 0)
    convertMatches <- ddply(convertMatches, .(line), function(row) {
        match <- substr(modelSection[row$line], row$start, row$end)
        if (match \%in\% c("Means", "Thresholds", "Intercepts", 
            "Variances", "Residual Variances")) {
            return(data.frame(line = row$line, keyword = make.names(match), 
                varname = NA_character_, operator = NA_character_))
        }
        else if (length(variable <- strapply(match, "^\\s*([\\w_\\d+\\.]+)\\s+(BY|WITH|ON|\\|)\\s*$", 
            c, perl = TRUE)[[1]]) > 0) {
            return(data.frame(line = row$line, keyword = NA_character_, 
                varname = variable[1], operator = variable[2]))
        }
        else stop("failure to match keyword: ", match)
    })
    extractParameters <- function(section) {
        sectionType <- section[1]
        if (length(keywordMatch <- grep("(Means|Intercepts|Variances|Residual Variances)", 
            sectionType, perl = TRUE, value = TRUE)) > 0) {
            resultsList <- list(name = keywordMatch)
        }
        measuredBy <- "^\\s*([\\w_\\d+\\.]+)\\s+(BY|WITH|ON|\\|)\\s*$"
        variableKeywordMatch <- strapply(readfile[curLine], measuredBy, 
            c, perl = TRUE)[[1]]
    }
    curLine <- beginModel + 4
    sectionMarkers <- grep("^\\s*((Means|Thresholds|Intercepts|Variances|Residual Variances)|([\\w_\\d+\\.]+\\s+(BY|WITH|ON|\\|)))\\s*$", 
        modelSection, perl = TRUE)
    for (i in 1:length(sectionMarkers)) {
        if (i < length(sectionMarkers)) 
            section <- modelSection[sectionMarkers[i]:(sectionMarkers[i + 
                1] - 1)]
        else section <- modelSection[sectionMarkers[i]:length(modelSection)]
        extractParameters(section)
    }
    while (!(readfile[curLine] == "" && readfile[curLine + 1] == 
        "")) {
        measuredBy <- "^\\s*([\\w_\\d+\\.]+)\\s+(BY|WITH|ON|\\|)\\s*$"
        variableKeywordMatch <- strapply(readfile[curLine], measuredBy, 
            c, perl = TRUE)[[1]]
        if (!is.null(variableKeywordMatch[[1]])) {
            print(variableKeywordMatch)
            curLine <- curLine + 1
        }
        else if (length(keywordMatch <- grep("(Means|Intercepts|Variances|Residual Variances)", 
            readfile[curLine], perl = TRUE, value = TRUE)) > 
            0) {
            print(keywordMatch)
            curLine <- curLine + 1
        }
        else curLine <- curLine + 1
    }
    cat("finished model results section\n")
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
