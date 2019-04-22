import socket

UDP_IP = "127.0.0.1"
UDP_PORT = 4242
MESSAGE = "Message depuis python script"

print("UDP target IP:", UDP_IP)
print("UDP target port:", UDP_PORT)
print("message:", MESSAGE)

fini = False
while not(fini) :
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
	sock.sendto(bytes(MESSAGE, "utf-8"), (UDP_IP, UDP_PORT))
	MESSAGE = input()
	if MESSAGE == "stop" :
		fini = True
