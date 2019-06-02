extends CanvasLayer

var pauseLabel
var reprendreButton
var menuButton
var leaveButton
var background

func _ready():
	pauseLabel = get_node("pauseLabel")
	reprendreButton = get_node("reprendreButton")
	menuButton = get_node("menuButton")
	leaveButton = get_node("leaveButton")
	background = get_node("background")
	hideMenu()
	reprendreButton.connect("pressed",self,"hideMenu")
	menuButton.connect("pressed",self,"buttonMenuGame")
	leaveButton.connect("pressed",self,"buttonLeaveGame")
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		if pauseLabel.is_visible():
			hideMenu()
		else:
			displayMenu()
	pass


	
func buttonMenuGame():
	get_tree().change_scene("res://menu/menu.tscn")
	pass
	
func buttonLeaveGame():
	get_tree().quit()
	pass
	
func displayMenu():
	Input.set_mouse_mode(0)
	background.show()
	pauseLabel.show()
	reprendreButton.show()
	menuButton.show()
	leaveButton.show()
	pass
	
func hideMenu():
	Input.set_mouse_mode(1)
	background.hide()
	pauseLabel.hide()
	reprendreButton.hide()
	menuButton.hide()
	leaveButton.hide()
	pass
	