import nake
import os
import ospaths
import strutils

proc exe*(path: string): string = path.addFileExt(ExeExt)

task "build", "":
  discard execShellCmd "nim c -d:release main.nim"
  moveFile "main".exe, "dist/daihen".exe
