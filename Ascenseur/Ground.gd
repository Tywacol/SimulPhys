extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var done
var msg

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)
	done = false
	
func _process(delta):
	if (done != true):
		#socket.put_packet("spam".to_ascii())
		if(global.socket.get_available_packet_count() > 0):
			var data = global.socket.get_packet().get_string_from_ascii()
			var data_split = data.split(' ')
			if (len(data_split) > 1) :
				if (data_split[0] == "etage") :
					$Ascenseur.appel(int(data_split[1]))
					msg = "Appel Etage" + str(data_split[1])
					
				# Augmentation d'une variable
				elif (data_split[0] == "+") :
					if (data_split[1] == "vitesse") :
						$"/root/MainScene/Ascenseur".speed += int(data_split[2])
						msg = "Augmentation de vitesse a : " + str($"/root/MainScene/Ascenseur".speed)
				
				# Diminution d'une variable
				elif (data_split[0] == "-") :
					if (data_split[1] == "vitesse") :
						$"/root/MainScene/Ascenseur".speed -= int(data_split[2])
						msg = "Augmentation de vitesse a : " + str($"/root/MainScene/Ascenseur".speed)
						
				# Multiplication d'une variable
				elif (data_split[0] == "*") :
					if (data_split[1] == "vitesse") :
						$"/root/MainScene/Ascenseur".speed *= int(data_split[2])
						msg = "Multiplication de vitesse a : " + str($"/root/MainScene/Ascenseur".speed)
						
				# Division d'une variable
				elif (data_split[0] == "/") :
					if (data_split[1] == "vitesse") :
						$"/root/MainScene/Ascenseur".speed /= int(data_split[2])
						msg = "Division de vitesse a : " + str($"/root/MainScene/Ascenseur".speed)
				# Set d'une variable
				elif (data_split[0] == "set") :
					if (data_split[1] == "vitesse") :
						$"/root/MainScene/Ascenseur".speed = int(data_split[2])
						msg = "vitesse_cage mise a : " + str($"/root/MainScene/Ascenseur".speed)
				
				# Get d'une variable
				elif (data_split[0] == "get") :
					if (data_split[1] == "vitesse") :
						msg = "vitesse = " + str($"/root/MainScene/Ascenseur".speed)
					elif (data_split[1] == "destination") :
						msg = "destination = " + str($"/root/MainScene/Ascenseur".destination)
					elif (data_split[1] == "etat") :
						msg = "etat = " + str($"/root/MainScene/Ascenseur/Portes".etat)
					elif (data_split[1] == "etage") :
						msg = "etage = " + str($"/root/MainScene/Ascenseur".actuel)
					elif (data_split[1] == "position") :
						msg = "position = " + str($"/root/MainScene/Ascenseur".translation)
						
						
			elif(data == "quit"):
				done = true
				global.send("Exiting")
				global.socket.close()
				get_tree().quit()
				
			elif(data == "restart"):
				global.send("restarting the simulation")
				get_tree().change_scene("res://Ground.tscn")
				
			elif(data == "open") :
				msg = "Ouverture des portes"
				$Ascenseur.get_node("Portes").open()
				print(get_tree())
				print(self.get_path())
			elif(data == "close") :
				msg = "Fermeture des portes"
				$Ascenseur.get_node("Portes").close()
				
			else:
				print("Data received: " + data)
				msg = "Commande inconnue : " + data 
			global.send(msg)
	

	
