extends CanvasLayer
 
const convert_in_ms =0.45

func _ready():
	$Retour.connect("pressed",self,"buttonRetour")
	$Retour.connect("mouse_entered",self,"bipMenu")
	$elevator_speed_select.connect("item_selected",self,"onElevatorSpeed")
	$door_speed_select.connect("item_selected",self,"onDoorSpeed")
	vitesseList()
	doorList()
	pass


func buttonRetour():
	get_tree().change_scene("res://Ground.tscn")
	pass

func bipMenu():
	$Bip.play()
	pass
	
func vitesseList():
	for i in range(1,41,2):
		$elevator_speed_select.add_item("%.3f ms (%d)"%[(convert_in_ms*i), i] )
	$elevator_speed_select.select(elevatorParam.get_elevator_speed()/ 2)
	pass
	
func onElevatorSpeed(id):
	elevatorParam.set_elevator_speed($elevator_speed_select.selected*2 + 1)
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