import socket

HOST = "127.0.0.1"
PORT = 3306

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.settimeout(2)
    try:
        s.connect((HOST, PORT))
        print("DB is reachable")
    except Exception as e:
        print(f"DB is not reachable: {e}")
