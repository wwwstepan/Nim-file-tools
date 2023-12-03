import sugar

proc toString*(achar: openarray[char]): string =
  result = newStringOfCap(len(achar))
  for ch in achar:
    add(result, ch)

proc toString*(achar: openarray[uint8]): string =
  result = newStringOfCap(len(achar))
  for ch in achar:
    add(result, char(ch))

proc getPairVal*[T,R](a:T, b:T, fun: (T) -> R): tuple[val1: R, val2: R] = (fun(a),fun(b))

proc pairValIsDiffer*[T,R](a:T, b:T, fun: (T) -> R): bool = not(fun(a)==fun(b))
