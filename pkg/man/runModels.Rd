\name{runModels}
\Rdversion{1.1}
\alias{runModels}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
runModels(directory = getwd(), recursive = FALSE, showOutput = FALSE, replaceOutfile = "always", mplusLogFile = "Mplus Run Models.log")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{directory}{
%%     ~~Describe \code{directory} here~~
}
  \item{recursive}{
%%     ~~Describe \code{recursive} here~~
}
  \item{showOutput}{
%%     ~~Describe \code{showOutput} here~~
}
  \item{replaceOutfile}{
%%     ~~Describe \code{replaceOutfile} here~~
}
  \item{mplusLogFile}{
%%     ~~Describe \code{mplusLogFile} here~~
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
function (directory = getwd(), recursive = FALSE, showOutput = FALSE, 
    replaceOutfile = "always", mplusLogFile = "Mplus Run Models.log") 
{
    translate <- TRUE
    if (!is.null(mplusLogFile)) {
        logTarget <- file(description = mplusLogFile, open = "wt", 
            blocking = TRUE)
        writeLines(c(paste("------Begin Mplus Model Run: ", format(Sys.time(), 
            "\%d\%b\%Y \%H:\%M:\%S"), "------", sep = ""), paste("Target directory: ", 
            directory, sep = ""), "Run options:", paste("\tRecursive (run models in subdirectories):", 
            as.character(recursive)), paste("\tShow output on console:", 
            as.character(showOutput)), paste("\tReplace existing outfile:", 
            replaceOutfile), "------"), con = logTarget)
    }
    splitFilePath <- function(abspath) {
        components <- strsplit(abspath, split = "[\\/]")[[1]]
        lcom <- length(components)
        stopifnot(lcom > 0)
        relFilename <- components[lcom]
        if (lcom == 1) {
            dirpart <- NA_character_
        }
        else if (lcom > 1) {
            components <- components[-lcom]
            dirpart <- do.call("file.path", as.list(components))
        }
        return(list(directory = dirpart, filename = relFilename))
    }
    isLogOpen <- function() {
        connections <- data.frame(showConnections(all = FALSE))
        if (length(grep(splitFilePath(mplusLogFile)$filename, 
            connections$description, ignore.case = TRUE)) > 0) 
            return(TRUE)
        else return(FALSE)
    }
    exitRun <- function() {
        require(plyr)
        if (isLogOpen()) 
            writeLines("Run terminated abnormally", logTarget)
        processList <- ldply(strsplit(shell("wmic process get caption, processid", 
            intern = TRUE), split = "\\s+", perl = TRUE), function(element) {
            return(data.frame(procname = element[1], pid = element[2], 
                stringsAsFactors = FALSE))
        })
        if (length(grep("mplus.exe", processList$procname, ignore.case = TRUE)) > 
            0) {
            if (isLogOpen()) 
                writeLines("Killing wayward Mplus processes", 
                  logTarget)
            shell("taskkill /f /im mplus.exe")
        }
        close(logTarget)
        setwd(curdir)
    }
    on.exit(exitRun())
    curdir <- getwd()
    setwd(directory)
    filelist <- list.files(recursive = recursive)
    inpfiles <- filelist[grep(".*\\.inp", filelist, ignore.case = TRUE)]
    outfiles <- filelist[grep(".*\\.out", filelist, ignore.case = TRUE)]
    if (length(inpfiles) < 1) 
        stop("No Mplus input files detected in the target directory: ", 
            directory)
    dropOutExtensions <- sapply(outfiles, function(x) {
        if (nchar(x) >= 4) 
            return(tolower(substr(x, 1, (nchar(x) - 4))))
    })
    for (i in 1:length(inpfiles)) {
        if (!replaceOutfile == "always") {
            if (tolower(substr(inpfiles[i], 1, (nchar(inpfiles[i]) - 
                4))) \%in\% dropOutExtensions) {
                if (replaceOutfile == "modifiedDate") {
                  inpmtime <- file.info(inpfiles[i])$mtime
                  matchPos <- grep(tolower(substr(inpfiles[i], 
                    1, (nchar(inpfiles[i]) - 4))), dropOutExtensions)
                  if (length(matchPos) < 1) 
                    warning("Could not locate matching outfile")
                  outmtime <- file.info(outfiles[matchPos[1]])$mtime
                  if (inpmtime <= outmtime) {
                    if (isLogOpen()) 
                      writeLines(paste("Skipping model because output file is newer than input file:", 
                        inpfiles[i]), logTarget)
                    next
                  }
                }
                else if (replaceOutfile == "never") {
                  if (isLogOpen()) 
                    writeLines(paste("Skipping model because output file already exists:", 
                      inpfiles[i]), logTarget)
                  next
                }
            }
        }
        components <- strsplit(inpfiles[i], split = "[\\/]")[[1]]
        lcom <- length(components)
        if (lcom == 1) {
            dirtocd <- directory
        }
        else if (lcom > 1) {
            components <- components[-lcom]
            dirtocd <- c(directory, components)
            dirtocd <- paste(dirtocd, sep = "", collapse = .Platform$file.sep)
        }
        relFilename <- components[lcom]
        absFilename <- paste(directory, inpfiles[i], sep = "/")
        command <- paste("cd \"", dirtocd, "\" && Mplus \"", 
            absFilename, "\"", sep = "")
        if (translate == TRUE) {
            command <- chartr("/", "\\", command)
        }
        if (isLogOpen()) 
            writeLines(paste("Currently running model:", relFilename), 
                logTarget)
        shellcommand <- Sys.getenv("COMSPEC")
        flag <- "/c"
        command <- paste(shellcommand, flag, command)
        system(command, show.output.on.console = showOutput, 
            invisible = (!showOutput), wait = TRUE)
    }
    setwd(curdir)
    if (isLogOpen()) {
        writeLines(c("", paste("------End Mplus Model Run: ", 
            format(Sys.time(), "\%d\%b\%Y \%H:\%M:\%S"), "------", 
            sep = "")), logTarget)
        close(logTarget)
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
