import socket

def receive_data(host='0.0.0.0', port=12345):
    # Create a socket object
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((host, port))
    s.listen(1)
    print(f"Listening for incoming connections on {host}:{port}")

    conn, addr = s.accept()
    print(f"Connected by {addr}")

    try:
        while True:
            data = conn.recv(1024)
            if not data:
                break
            print(f"Received data: {data.decode()}")
    finally:
        conn.close()

if __name__ == "__main__":
    receive_data()
