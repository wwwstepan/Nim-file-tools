import tables
from strutils import find
import std/unicode
from os import commandLineParams

import utf

type
  TableParams = TableRef[string, string]

proc parseId(str_par: string): tuple[id:string, val:string] = 
  let n = str_par.find("=")
  let n_len = str_par.len
  if n>0 and n<n_len:
    return (str_par.substr(0,n-1).strip.toUpper, str_par.substr(n+1).strip)
  return ("","")

proc readParams(params: seq, t: TableParams) =
  for str_par in params:
    let (id,val) = parseId(str_par)
    if id!="" and val!="":
      t[id] = val

proc readCfg*(t:TableParams) = 
  let params = UFTFileToStrAr("tt.cfg")
  readParams(params,t)

proc readCmdLine*(t:TableParams) =
  let params = commandLineParams()
  readParams(params,t)

when isMainModule:
  let t = newTable[string, string]()
  readCfg(t)
  echo t
  readCmdLine(t)
  echo t
