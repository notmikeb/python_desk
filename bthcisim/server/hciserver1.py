#!/usr/bin/python
import socket
port = 8081
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(("", port))
print("waiting on port:", port)
s.listen(1)
while 1:
  conn, addr = s.accept()
  print('connected by', addr)
  while 1:
    try:
      data = conn.recv(1024)
    except:
      conn.close()
      break
#    if not data: break
    if not data:
      conn.close()
      break
    print('get ', len(data), ' length data')
    conn.sendall(data)
  conn.close()
