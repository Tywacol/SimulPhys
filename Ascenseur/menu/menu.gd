extends CanvasLayer




func _ready():
	# Center window on screen
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	get_viewport().warp_mouse(screen_size/2)
	
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