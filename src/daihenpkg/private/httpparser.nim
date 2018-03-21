import strutils

# Extract host string (hostname:port)
proc extractHost*(data: string) : tuple[ hostname: string, port: uint ] =
  result.hostname = ""
  result.port = 0

  var st = data.find("Host: ", 0)
  if st < 0 : return
  var ed = data.find("\n", st)
  var edCr = data.find("\r", st)

  # host string
  st = st + 6
  if edCr + 1 == ed : ed = edCr
  var hoststring = data.substr(st, ed - 1)

  # separate hostname and port
  var corron = hoststring.find(":")
  if corron == -1 :
    result.hostname = hoststring
  else :
    result.hostname = hoststring.substr(0, corron - 1)
    result.port = hoststring.substr(corron + 1).parseUInt()
