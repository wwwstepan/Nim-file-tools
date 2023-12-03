from strutils import splitLines
from std/os import existsFile

proc isUTF8*(bom:openarray[uint8]):bool =
  bom[0]==239'u8 and bom[1]==187'u8 and bom[2]==191'u8

proc isUTF16BE*(bom:openarray[uint8]):bool=
  bom[0]==254'u8 and bom[1]==255'u8

proc isUTF16LE*(bom:openarray[uint8]):bool=
  bom[0]==255'u8 and bom[1]==254'u8

proc isUTF32BE*(bom:openarray[uint8]):bool=
  bom[0]==0'u8 and bom[1]==0'u8 and bom[2]==254'u8 and bom[3]==255'u8

proc isUTF32LE*(bom:openarray[uint8]):bool=
  bom[0]==255'u8 and bom[1]==254'u8 and bom[2]==0'u8 and bom[3]==0'u8

type
  FileTypeUTF* = enum
    NOUTF, UTF8, UTF16BE, UTF16LE, UTF32BE, UTF32LE

proc fileTypeUTF*(s: string): tuple[t: FileTypeUTF, offs: int] =
  let s_len=s.len
  var bom: array[4,uint8]
  for i in 0..min(3,s_len-1):
    bom[i]=uint8(s[i])

  if s_len>=3 and isUTF8(bom): return (UTF8, 3)
  if s_len>=2 and isUTF16BE(bom): return (UTF16BE, 2)
  if s_len>=2 and isUTF16LE(bom): return (UTF16LE, 2)
  if s_len>=4 and isUTF32BE(bom): return (UTF32BE, 4)
  if s_len>=4 and isUTF32LE(bom): return (UTF32LE, 4)
  return (NOUTF, 0)

proc UFTFileToStrAr*(fname: string): seq[string] = 
  result = @[]
  if not existsFile(fname): return 
  var params = readFile(fname).splitLines
  if params.len<1: return

  let (typ,offs) = fileTypeUTF(params[0])
  if typ==NOUTF: return

  params[0]=params[0].substr(offs)
  return params

