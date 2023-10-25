# ARP / RARP

import socket

UDP_IP = "localhost"
UDP_PORT = 8080

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

sock.bind((UDP_IP, UDP_PORT))

ip = [
    "172.16.1.9",
    "172.16.1.8"
]

mac = ["6A:08:AA:C2", "8A:BC:E3:FA"]

while True:
    data, addr = sock.recvfrom(1024)

    str_ = data.decode('utf-8')

    ln = len(data)

    if ln != 0:
        print("Received Message:", str_)

        for x in ip:
            if str_ in x:
                ind = ip.index(str_)
                print("The MAC Address is:", mac[ind])
