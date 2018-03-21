import net, re, logging

import private/logger

proc main*() : void =
  setupLogger()

  var socket = newSocket()
  socket.bindAddr(Port(12345))
  socket.listen()

  var client = new Socket
  while true:
    socket.accept(client)

    var data = client.recv(10000)
    debug("readLine: ", data)

    if data.find(re"HTTP") >= 0 :
      echo("----- it is http!")

    if data.find(re"POST") >= 0 :
      echo("----- it is post request!")

    if data.find(re"GET") >= 0 :
      echo("----- it is get request!")

    if data.find(re"\r\n") >= 0 :
      echo("----- it is request end!")
