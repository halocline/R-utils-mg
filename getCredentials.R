## getCredentials.R
##
##

getCredentials <- function () {
  library(tcltk)
  tt <- tktoplevel()
  usr <- tclVar("")
  pwd <- tclVar("")
  tkpack( tklabel(tt, text = "Username") )
  tkpack( tkentry(tt, textvariable = usr))
  tkpack( tklabel(tt, text = "Password") )
  tkpack( tkentry(tt, textvariable = pwd, show = "*") )
  tkpack( tkbutton(tt, text = "Enter", command = function() tkdestroy(tt)) )
  tkwait.window(tt)
  x <- c(tclvalue(usr), tclvalue(pwd))
}