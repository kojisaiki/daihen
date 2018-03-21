import asyncnet, asyncdispatch, re, strutils, logging

import private/logger, private/httpparser

type PacketData* = ref object
  isHttp: bool
  fromLocalhost: bool
  host: tuple[ hostname: string, port: uint ]

var clients {.threadvar.}: seq[AsyncSocket]

proc processClient(client: AsyncSocket) {.async.} =
  #result = new PacketData

  var buf = ""
  debug("read buffer start")
  while(buf.find("\r\n") < 0) :
    let line = await client.recvLine()
    debug("read")
    if line.len == 0 : break
    buf.add(line)

  debug("read buffer end")

  debug("send")
  await client.send("HTTP/1.0 200 OK Content-Length: 39\r\n\r\n<html><body>You are Http!</body></html>\r\n\r\n")

proc serve() {.async.} =
  var socket = newAsyncSocket()
  socket.bindAddr(Port(12345))
  socket.listen()
  var client = new AsyncSocket
  while true:
    debug("wait")
    let client = await socket.accept()
    #clients.add(client)
    debug("accept")
    asyncCheck processClient(client)

proc main*() : void =
  setupLogger()
  asyncCheck serve()
  runForever()
