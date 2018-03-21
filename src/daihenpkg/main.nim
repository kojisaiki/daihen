import net, re, strutils, logging

import private/logger, private/httpparser

type PacketData* = ref object
  isHttp: bool
  fromLocalhost: bool
  sourceAddr: string
  host: tuple[ hostname: string, port: uint ]

proc acceptAndParse(socket: Socket, client: var Socket) : PacketData =
  result = new PacketData
  var buf = ""
  debug("Start accept")
  while(buf.find("\r\n") < 0) :
    socket.acceptAddr(client, result.sourceAddr)
    buf.add(client.recv(10000))
    debug("Wait for continue request")
  debug("Accept one request")
  if buf.find(re"HTTP") >= 0 :
    result.isHttp = true
  result.host = extractHost(buf)
  if result.sourceAddr == "127.0.0.1" or result.host.hostname == "localhost" :
    result.fromLocalhost = true

proc main*() : void =
  setupLogger()
  var socket = newSocket()
  socket.bindAddr(Port(12345))
  socket.listen()
  var client = new Socket
  while true:
    var packet = socket.acceptAndParse(client)
    debug("accept")
    if packet.isHttp :
      echo "http!"
      if client.trySend("""
HTTP/1.0 200 OK Content-Length: 39

<html><body>You are Http!</body></html>""") :
        debug("send success!")
      else :
        debug("send error...")
      debug("send data")
      client.close()
    else :
      debug("else")
      client.send("Who are you?")
      client.close()
