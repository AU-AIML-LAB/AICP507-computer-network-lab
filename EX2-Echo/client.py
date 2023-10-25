
import socket

HOST = '127.0.0.1'
PORT = 9999
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, 5000))
s.connect((HOST, PORT))
str_ = "Hello, world "
b = str_.encode('UTF-8')
s.send(b)
data = s.recv(1024)
s.close()
print('Received' , data)
