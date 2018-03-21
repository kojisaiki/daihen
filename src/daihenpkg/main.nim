import asyncnet, asyncdispatch, re, strutils, logging

import private/logger, private/httpparser

type PacketData* = ref object
  isHttp: bool
  fromLocalhost: bool
  host: tuple[ hostname: string, port: uint ]

proc processClient(client: AsyncSocket) {.async.} =
  #result = new PacketData
  var buf = ""
  debug("process client start")
  while(buf.find("\r\n") < 0) :
    let line = await client.recvLine()
    if line.len == 0 : break
    buf.add(line)
  debug("read buffer len: " & buf.len.intToStr)

  await client.send("HTTP/1.0 200 OK Content-Length: 39\r\n\r\n<html><body>You are Http!</body></html>\n")
  client.close()
  debug("process client end")

proc serve() {.async.} =
  var socket = newAsyncSocket()
  socket.bindAddr(Port(12345))
  var client = new AsyncSocket

  debug("serve start")
  socket.listen()
  while true:
    let client = await socket.accept()
    asyncCheck processClient(client)

proc main*() : void =
  setupLogger()
  asyncCheck serve()
  runForever()
