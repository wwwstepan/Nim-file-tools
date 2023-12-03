import env,tables

let ttParams = newTable[string, string]()

readCfg(ttParams)
readCmdLine(ttParams)

#[
let runMode = if ttParams.contains("RUNMODE"):
  ttParams["RUNMODE"]
else:
  "?"
]#

let runMode = ttParams.getOrDefault("RUNMODE","??")
echo runMode
