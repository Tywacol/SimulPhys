extends CanvasLayer

signal reprendre

func _ready():
	hideMenu()
	$reprendreButton.connect("pressed",self,"buttonReprendreGame")
	$menuButton.connect("pressed",self,"buttonMenuGame")
	$leaveButton.connect("pressed",self,"buttonLeaveGame")
	$reprendreButton.connect("mouse_entered",self,"bipMenu")
	$menuButton.connect("mouse_entered",self,"bipMenu")
	$leaveButton.connect("mouse_entered",self,"bipMenu")
	pass

func bipMenu():
	$Bip.play()
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		if $pauseLabel.is_visible():
			hideMenu()
		else:
			displayMenu()
	pass

func buttonReprendreGame():
	emit_signal("reprendre")
	hideMenu()
	pass
	
func buttonMenuGame():
	get_tree().change_scene("res://menu/menu.tscn")
	pass
	
func buttonLeaveGame():
	get_tree().quit()
	pass
	
func displayMenu():
	Input.set_mouse_mode(0)
	$reprendreButton.show()
	$pauseLabel.show()
	$menuButton.show()
	$leaveButton.show()
	$background.show()
	pass
	
func hideMenu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$reprendreButton.hide()
	$pauseLabel.hide()
	$menuButton.hide()
	$leaveButton.hide()
	$background.hide()
	pass

