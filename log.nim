import times
from os import getFileSize,moveFile

var logfilename: string

proc initLog*(fname: string):void =
  logfilename=fname
  if getFileSize(fname)>500:
    try:
      moveFile(fname,fname & ".old")
    except:
      return

proc t*(t: string) =
  #echo t
  let f = open(logfilename,fmAppend)
  f.write(now().format("HH:mm:ss'.'fff "))
  f.writeLine(t)
  f.flushFile()
  f.close()

proc err*() = 
  let cur_e = getCurrentException()
  let t = "[Error] " & $cur_e.name & ": " & cur_e.msg
  t(t)

when isMainModule:
  initLog("uposup.log")
  t("sfd")
  try:
    let a = readFile("eqweq")
    echo a
  except:
    err()