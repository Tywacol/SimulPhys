extends CanvasLayer
 
const convert_in_ms =0.45

func _ready():
	$Retour.connect("pressed",self,"buttonRetour")
	$Retour.connect("mouse_entered",self,"bipMenu")
	$door_speed_select.connect("item_selected",self,"onDoorSpeed")
	$elevatorSpeedValue.connect("text_entered",self,"onElevatorSpeed")
	$elevatorSpeedValue.set_text(str(elevatorParam.get_elevator_speed()))
	doorList()
	pass



func buttonRetour():
	get_tree().change_scene("res://Ground.tscn")
	pass

func bipMenu():
	$Bip.play()
	pass
	

func onElevatorSpeed(id):
	elevatorParam.set_elevator_speed(int($elevatorSpeedValue.get_text()))
	global.send("vitesse_cage mise a : " + str(elevatorParam.get_elevator_speed()))
	pass
	
func doorList():
	for i in range(1,11):
		$door_speed_select.add_item("%.1f"%(float(i)/10))
	$door_speed_select.select(elevatorParam.get_door_speed()*10 -1)
	pass

	
func onDoorSpeed(id):
	elevatorParam.set_door_speed($door_speed_select.selected+1)
	print(float(elevatorParam.get_door_speed()))
	pass