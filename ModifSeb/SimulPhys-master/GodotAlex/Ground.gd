extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var done
var socket

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)
	done = false
	socket = PacketPeerUDP.new()
	if(socket.listen(4242,"127.0.0.1") != OK):
		print("An error occurred listening on port 4242")
		done = true;
	else:
		print("Listening on port 4242 on localhost")

var cnt = 0

func _process(delta):
	
	print("frame : " + str(cnt))
	cnt += 1
	if (done != true):
		if(socket.get_available_packet_count() > 0):
			var data = socket.get_packet().get_string_from_ascii()
			if(data == "quit"):
				done = true
				socket.close()
			elif(data == "Etage 5") :
				$Ascenseur.appel(5)
			elif(data == "open") :
				$Ascenseur.get_node("Portes").open()
			else:
				print("Data received: " + data)
	

	
