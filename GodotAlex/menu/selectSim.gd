extends CanvasLayer




func _ready():
	$Ascensor.connect("pressed",self,"ascensorSimLaunch")
	$BackButton.connect("pressed",self,"backMenu")
	$Ascensor.connect("mouse_entered",self,"bipMenu")
	$BackButton.connect("mouse_entered",self,"bipMenu")
	$validateBeep.play()
	pass



func ascensorSimLaunch():
	get_tree().change_scene("res://menu/menu_connect.tscn")
	pass
	
func backMenu():
	get_tree().change_scene("res://menu/menu.tscn")
	pass
	
func bipMenu():
	$Bip.play()
	pass
	
	
	
	
	