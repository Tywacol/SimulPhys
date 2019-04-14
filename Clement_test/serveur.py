# coding: utf-8
import socket

connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
connection.bind(('', 5000))
connection.listen(5)

if __name__ == '__main__':
    client, ip_client = connection.accept()
