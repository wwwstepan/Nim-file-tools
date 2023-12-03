import os,winlean,system/widestrs
import sugar

from log import nil
from myutil import pairValIsDiffer

proc DeleteExsistsFile(fname: string): bool = 
  try:
    if existsFile(fname):
      let fnW = newWideCString(fname)
      if not bool(deleteFileW(fnW)):
        log.t("File " & fname & "not deleted")
  except:
    log.err()

proc filesIsDiffer(src: string, dst:string): bool =
  if existsFile(src) and existsFile(dst):
    if not pairValIsDiffer(src,dst,(z)=>getFileSize(z)) and
       not pairValIsDiffer(src,dst,(z)=>getFileInfo(z).lastWriteTime):
      return false
  return true

proc CopyChngFile(src: string, dst:string): bool =
  result = false
  
  try:
    if not existsFile(src) or not filesIsDiffer(src, dst): return
    
    let srcW = newWideCString(src)
    let dstW = newWideCString(dst)
    if not bool(copyFileW(srcW,dstW,0'i32)): 
      discard DeleteExsistsFile(dst)
      return

    if pairValIsDiffer(src,dst,(z)=>getFileSize(z)): 
      discard DeleteExsistsFile(dst)
      return
  except:
    log.err()
    discard DeleteExsistsFile(dst)
    return

  result=true

when isMainModule:
  let res = CopyChngFile("myfiles.nim","tst")
  echo res
