extends CanvasLayer



func _ready():
	$LaunchButton.connect("mouse_entered",self,"bipMenu")
	$LeaveButton.connect("mouse_entered",self,"bipMenu")
	$LaunchButton.connect("pressed",self,"buttonLaunchGame")
	$LeaveButton.connect("pressed",self,"buttonLeaveGame")
	pass

func bipMenu():
	$Bip.play()
	pass

func buttonLaunchGame():
	$GameName.hide()
	$LaunchButton.hide()
	get_tree().change_scene("res://menu/selectSim.tscn")
	pass
	
func buttonLeaveGame():
	get_tree().quit()
	pass
