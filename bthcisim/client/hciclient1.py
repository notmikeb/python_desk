#client.py

import socket
port = 8081
host = "localhost"
#host = '192.168.99.18'
host = '192.168.99.19'
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.sendall('Hello,world'.encode('utf-8'))

data = s.recv(1024)
s.close()
print('received', repr(data))
