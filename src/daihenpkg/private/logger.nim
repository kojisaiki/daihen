import logging

proc setupLogger*(): void =
  var console = newConsoleLogger()
  console.fmtStr = "$levelname, [$datetime] -- $appname: "
  addHandler(console)
