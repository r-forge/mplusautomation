\name{runModels_Interactive}
\Rdversion{1.1}
\alias{runModels_Interactive}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
runModels_Interactive(directory = getwd(), recursive = "0", showOutput = "1", replaceOutfile = "1", checkDate = "0")
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
  \item{checkDate}{
%%     ~~Describe \code{checkDate} here~~
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
function (directory = getwd(), recursive = "0", showOutput = "1", 
    replaceOutfile = "1", checkDate = "0") 
{
    tcltk <- require(tcltk)
    if (!tcltk) 
        stop("The tcltk package is absent. Interactive folder selection cannot function.")
    OnOK <- function() {
        recursiveChecked <- as.logical(as.numeric(tclvalue(recursiveChecked)))
        showOutputChecked <- as.logical(as.numeric(tclvalue(showOutputChecked)))
        replaceOutfileChecked <- as.logical(as.numeric(tclvalue(replaceOutfileChecked)))
        checkDateChecked <- as.logical(as.numeric(tclvalue(checkDateChecked)))
        directory <- tclvalue(directoryVariable)
        if (!replaceOutfileChecked) 
            checkDateChecked <- FALSE
        if (replaceOutfileChecked && checkDateChecked) 
            replaceOutfileStr <- "modifiedDate"
        else if (replaceOutfileChecked && !checkDateChecked) 
            replaceOutfileStr <- "always"
        else if (!replaceOutfileChecked) 
            replaceOutfileStr <- "never"
        tkgrab.release(top)
        tkdestroy(top)
        runModels(directory = directory, recursive = recursiveChecked, 
            showOutput = showOutputChecked, replaceOutfile = replaceOutfileStr)
    }
    onCancel <- function() {
        tkgrab.release(top)
        tkdestroy(top)
        return()
    }
    onBrowse <- function() {
        tclvalue(directoryVariable) <- tclvalue(tclVar(choose.dir()))
    }
    onReplace <- function() {
        curVal <- as.character(tclvalue(replaceOutfileChecked))
        if (curVal == "1") 
            tkconfigure(checkDateCB, state = "!disabled")
        else if (curVal == "0") {
            tkconfigure(checkDateCB, state = "disabled")
        }
    }
    top <- tktoplevel(borderwidth = 10)
    tkwm.title(top, "Select directory to run models")
    directoryVariable <- tclVar(directory)
    locationFrame <- ttkframe(top)
    locationField <- ttkentry(locationFrame, width = "100", textvariable = directoryVariable)
    Browse.but <- ttkbutton(locationFrame, text = "Browse", command = onBrowse)
    tkgrid(ttklabel(locationFrame, text = "Target directory:"), 
        locationField, Browse.but)
    tkgrid(locationFrame, sticky = "w")
    optionsFrame <- ttkframe(top)
    recursiveChecked <- tclVar(recursive)
    recurseCB <- ttkcheckbutton(optionsFrame, variable = recursiveChecked)
    tkgrid(ttklabel(optionsFrame, text = "Run models in nested subdirectories"), 
        recurseCB, sticky = "w")
    replaceOutfileChecked <- tclVar(replaceOutfile)
    replaceCB <- ttkcheckbutton(optionsFrame, variable = replaceOutfileChecked, 
        command = onReplace)
    tkgrid(ttklabel(optionsFrame, text = "Re-run models that have existing output files"), 
        replaceCB, sticky = "w")
    checkDateChecked <- tclVar(checkDate)
    if (as.logical(as.numeric(replaceOutfile)) == TRUE) 
        initialState <- "!disabled"
    else initialState <- "disabled"
    checkDateCB <- ttkcheckbutton(optionsFrame, variable = checkDateChecked, 
        state = initialState)
    tkgrid(ttklabel(optionsFrame, text = "    -> Only re-run if input file is newer than existing output (check date)   "), 
        checkDateCB, sticky = "w")
    showOutputChecked <- tclVar(showOutput)
    showOutputCB <- ttkcheckbutton(optionsFrame, variable = showOutputChecked)
    tkgrid(ttklabel(optionsFrame, text = "Show Mplus output on console"), 
        showOutputCB, sticky = "w")
    tkgrid(optionsFrame, sticky = "w")
    buttonsFrame <- ttkframe(top)
    OK.but <- ttkbutton(buttonsFrame, text = "OK", command = OnOK)
    Cancel.but <- ttkbutton(buttonsFrame, text = "Cancel", command = onCancel)
    tkgrid(OK.but, ttklabel(buttonsFrame, text = "   "), Cancel.but, 
        sticky = "w")
    tkgrid(buttonsFrame, sticky = "w")
    tkwm.resizable(top, 0, 0)
    tkbind(top, "<Return>", OnOK)
    tkwm.deiconify(top)
    tkgrab.set(top)
    tkfocus(top)
    tkwait.window(top)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
