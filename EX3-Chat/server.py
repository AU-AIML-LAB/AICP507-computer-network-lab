# Chat server

import socket 


def server_program():

    host = socket.gethostname()
    port = 5000

    server_socket = socket.socket()
    server_socket.bind((host, port))

    server_socket.listen(2)
    conn, addr = server_socket.accept()

    while True:
        data = conn.recv(1024).decode()

        if not data: break
        print("From connected user: "+ str(data))

        data = input('->')
        conn.send(data.encode())
    conn.close()

if __name__ == "__main__":
    server_program()
