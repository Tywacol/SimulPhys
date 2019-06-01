extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var done
var socket
var socket_send
var msg = ""

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)
	done = false
	UDPserver()
	
func UDPserver(port=4242, ip="127.0.0.1") :
	socket = PacketPeerUDP.new()
	if(socket.listen(4242,"127.0.0.1") != OK):
		print("An error occurred listening on port 4242")
		done = true;
	else:
		print("Listening on port 4242 on localhost")
	socket.set_dest_address("127.0.0.1",8910)



func _process(delta):
	if (done != true):
		#socket.put_packet("spam".to_ascii())
		if(socket.get_available_packet_count() > 0):
			var data = socket.get_packet().get_string_from_ascii()
			var data_split = data.split(' ')
			if (len(data_split) > 1) :
				if (data_split[0] == "Etage") :
					$Ascenseur.appel(int(data_split[1]))
					msg = "Appel Etage" + str(data_split[1])
					socket.put_packet(msg.to_ascii())
					
				# Augmentation d'une variable
				if (data_split[0] == "+") :
					if (data_split[1] == "vitesse_cage") :
						$"/root/MainScene/Ascenseur".speed += int(data_split[2])
						msg = "Augmentation de vitesse_cage a : " + str($"/root/MainScene/Ascenseur".speed)
						socket.put_packet(msg.to_ascii())
				
				# Diminution d'une variable
				if (data_split[0] == "-") :
					if (data_split[1] == "vitesse_cage") :
						$"/root/MainScene/Ascenseur".speed -= int(data_split[2])
						msg = "Augmentation de vitesse_cage a : " + str($"/root/MainScene/Ascenseur".speed)
						socket.put_packet(msg.to_ascii())
				# Set d'une variable
				if (data_split[0] == "set") :
					if (data_split[1] == "vitesse_cage") :
						$"/root/MainScene/Ascenseur".speed = int(data_split[2])
						msg = "vitesse_cage mise a : " + str($"/root/MainScene/Ascenseur".speed)
						socket.put_packet(msg.to_ascii())
				
				# Diminution d'une variable
				if (data_split[0] == "get") :
					if (data_split[1] == "vitesse_cage") :
						msg = "vitesse_cage : " + str($"/root/MainScene/Ascenseur".speed)
						socket.put_packet(msg.to_ascii())
						
			elif(data == "quit"):
				done = true
				socket.close()
			elif(data == "open") :
				socket.put_packet("Ouverture des portes".to_ascii())
				$Ascenseur.get_node("Portes").open()
				print(get_tree())
				print(self.get_path())
			elif(data == "close") :
				socket.put_packet("Fermeture des portes".to_ascii())
				$Ascenseur.get_node("Portes").close()
			elif(data == "vitesse_plus") :
				$"/root/MainScene/Ascenseur".speed *= 2
				msg = "Augmentation de la vitesse : " + str($"/root/MainScene/Ascenseur".speed)
				socket.put_packet(msg.to_ascii())
				
				
			elif(data == "vitesse_moins") :
				socket.put_packet("Division par 2 de la vitesse".to_ascii())
				$"/root/MainScene/Ascenseur".speed /= 2
			else:
				print("Data received: " + data)
				msg = "Commande inconnue : " + data 
				socket.put_packet(msg.to_ascii())
	

	
