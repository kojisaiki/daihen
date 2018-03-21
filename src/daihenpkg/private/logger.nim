import logging

proc setupLogger*(): void =
  echo "setupLogger!"
  var console = newConsoleLogger()
  console.fmtStr = "$levelname, [$datetime] -- $appname: "
  addHandler(console)
