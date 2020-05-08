import argparse, socket

if __name__ == '__main__':

	parser = argparse.ArgumentParser(description='Process some integers.')
	
	parser.add_argument('-p','--port', dest='UDP_PORT', default=4242,
		help='Specify UDP port. Default is 4242')
	parser.add_argument('-i','--ip', dest='UDP_IP', default="127.0.0.{}",
		help='Specify UDP target IP. Default is 127.0.0.1')
	
	args = parser.parse_args()

	UDP_IP = args.UDP_IP
	UDP_PORT = int(args.UDP_PORT)

	print("UDP target IP:", UDP_IP)
	print("UDP target port:", UDP_PORT)


	# Client
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
	line = "HELLO"

	sock.sendto(bytes(line, "utf-8"), ("127.0.0.0", UDP_PORT))
	print("Adresse testee : 127.0.0.0")

	for i in range(0,256) :
		try:
			ip_temp = UDP_IP.format(i)
			sock.sendto(bytes(line, "utf-8"), (UDP_IP.format(i), UDP_PORT))
			print(f"Adresse testee : {ip_temp}")
		except:
			continue
	sock.close()

