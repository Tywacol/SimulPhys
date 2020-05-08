
import socket, argparse, csv, datetime

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('-i','--ip', dest='UDP_IP', default="127.0.0.1",
	help='Specify UDP target IP. Default is 127.0.0.1')
parser.add_argument('-p','--port', dest='UDP_PORT', default=8910,
	help='Specify UDP port. Default is 8910')
parser.add_argument('-e','--export', dest='FILENAME', default=None,
	help='Specify the name of the CSV export file')

args = parser.parse_args()

UDP_IP = args.UDP_IP
UDP_PORT = int(args.UDP_PORT)
FILENAME = args.FILENAME

print("UDP listening IP:", UDP_IP)
print("UDP listening port:", UDP_PORT)

bufferSize = 1024

# Create a datagram socket

UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

# Bind to address and ip

UDPServerSocket.bind((UDP_IP, UDP_PORT))

print("UDP server up and listening")


if (FILENAME):
	employee_file = open(FILENAME, mode='w')
	employee_writer = csv.writer(employee_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

# Listen for incoming datagrams

while(True):

	bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)

	message = bytesAddressPair[0]
	address = bytesAddressPair[1]

	clientMsg = "{},{},{}".format(address[0],address[1],message.decode())
	#clientIP  = "Client IP Address:{}".format(address)
    
	print(clientMsg)
	if (FILENAME):
		employee_writer.writerow([address[0],address[1],message.decode(),str(datetime.datetime.now().time())])

    # Sending a reply to client
	#UDPServerSocket.sendto(bytesToSend, address)

close(employee_file)
	
