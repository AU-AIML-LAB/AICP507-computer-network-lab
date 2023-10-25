# Remote Sender 


# Remote receiver

import socket
import wmi

UDP_IP = "10.1.61.152"
UDP_PORT = 8080

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
message = "notepad"

print("message:", message)

sock.sendto(bytes(message, "utf-8"), (UDP_IP, UDP_PORT))
