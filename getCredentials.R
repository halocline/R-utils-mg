## getCredentials.R
## written by mdglissmann@gmail.com
## February 2015

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

getCredentialsDB <- function () {
  library(tcltk)
  tt <- tktoplevel()
  host <- tclVar("")
  dbname <- tclVar("")
  usr <- tclVar("")
  pwd <- tclVar("")
  tkpack( tklabel(tt, text = "Host") )
  tkpack( tkentry(tt, textvariable = host))
  tkpack( tklabel(tt, text = "Database Name") )
  tkpack( tkentry(tt, textvariable = dbname))
  tkpack( tklabel(tt, text = "Username") )
  tkpack( tkentry(tt, textvariable = usr))
  tkpack( tklabel(tt, text = "Password") )
  tkpack( tkentry(tt, textvariable = pwd, show = "*") )
  tkpack( tkbutton(tt, text = "Enter", command = function() tkdestroy(tt)) )
  tkwait.window(tt)
  x <- c(tclvalue(host), tclvalue(dbname), tclvalue(usr), tclvalue(pwd))
}