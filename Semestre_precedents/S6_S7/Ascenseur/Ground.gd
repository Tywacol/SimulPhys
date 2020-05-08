extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var a = []


var done
var msg
var data

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)
	done = false
	
func _process(delta):
	data = global.recv()
	if (data != null):
		print("data received : "+str(data))
		global.queue.append(data.split(' '))
	if(len(global.queue) > 0) :
		print("not elevatorParam.simulation_is_busy()" + str(not elevatorParam.simulation_is_busy()))
		if (not elevatorParam.simulation_is_busy()) :
			var data_split = global.queue.pop_front()
			if (len(data_split) > 1) :
				if (data_split[0] == "etage") :
					$Ascenseur.appel(int(data_split[1]))
					msg = "Appel Etage" + str(data_split[1])
	
				# Augmentation d'une variable
				elif (data_split[0] == "+") :
					if (data_split[1] == "vitesse") :
						elevatorParam.set_elevator_speed(elevatorParam.get_elevator_speed() + int(data_split[2]))
						msg = "Augmentation de vitesse a : " + str(elevatorParam.get_elevator_speed())
	
				# Diminution d'une variable
				elif (data_split[0] == "-") :
					if (data_split[1] == "vitesse") :
						elevatorParam.set_elevator_speed(elevatorParam.get_elevator_speed() - int(data_split[2]))
						msg = "Diminution de vitesse a : " + str(elevatorParam.get_elevator_speed())
	
				# Multiplication d'une variable
				elif (data_split[0] == "*") :
					if (data_split[1] == "vitesse") :
						elevatorParam.set_elevator_speed(elevatorParam.get_elevator_speed() * int(data_split[2]))
						msg = "Multiplication de vitesse a : " + str(elevatorParam.get_elevator_speed())
	
				# Division d'une variable
				elif (data_split[0] == "/") :
					if (data_split[1] == "vitesse") :
						elevatorParam.set_elevator_speed(elevatorParam.get_elevator_speed() / int(data_split[2]))
						msg = "Division de vitesse a : " + str(elevatorParam.get_elevator_speed())
				# Set d'une variable
				elif (data_split[0] == "set") :
					if (data_split[1] == "vitesse") :
						elevatorParam.set_elevator_speed(int(data_split[2]))
						#door speed?
						msg = "vitesse_cage mise a : " + str(elevatorParam.get_elevator_speed())
	
				# Get d'une variable
				elif (data_split[0] == "get") :
					if (data_split[1] == "vitesse") :
						msg = "vitesse = " + str(elevatorParam.get_elevator_speed())
					elif (data_split[1] == "destination") :
						msg = "destination = " + str($"/root/MainScene/Ascenseur".destination)
					elif (data_split[1] == "etat") :
						msg = "etat = " + str($"/root/MainScene/Ascenseur/Portes".etat)
					elif (data_split[1] == "etage") :
						msg = "etage = " + str($"/root/MainScene/Ascenseur".actuel)
					elif (data_split[1] == "hauteur") :
						msg = "hauteur = " + str($"/root/MainScene/Ascenseur".translation.y)
					elif (data_split[1] == "queue") :
						msg = "hauteur = " + str($"/root/MainScene/Ascenseur".translation.y)
					
	
			elif(data_split[0] == "quit"):
				done = true
				global.send("Exit")
				global.socket.close()
				get_tree().quit()
	
			elif(data_split[0] == "restart"):
				global.send("restarting the simulation")
				get_tree().change_scene("res://Ground.tscn")
	
			elif(data_split[0] == "open") :
				print("data is egal to open")
				msg = "Ouverture des portes"
				$Ascenseur.get_node("Portes").open()
			elif(data_split[0] == "close") :
				msg = "Fermeture des portes"
				$Ascenseur.get_node("Portes").close()
	
			else:
				print("Data received: " + data_split[0])
				msg = "Commande inconnue : " + data_split[0]
	
		else :
			print("lift is busy")

			
		global.send(msg)
	#global.send("Queue : " +str(global.queue))
	
	#Notes : 
	#Ajouter les priorites differentes pour les actions incompatibles et les setters/ getters
	# export param + valeurs variables
	# import variables

	
