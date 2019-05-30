extends CanvasLayer

var gameName
var launchButton
var leaveButton

func _ready():
	gameName = get_node("GameName")
	launchButton = get_node("LaunchButton")
	leaveButton = get_node("LeaveButton")
	launchButton.connect("pressed",self,"buttonLaunchGame")
	leaveButton.connect("pressed",self,"buttonLeaveGame")
	pass

func buttonLaunchGame():
	gameName.hide()
	launchButton.hide()
	get_tree().change_scene("res://menu/selectSim.tscn")
	pass
	
func buttonLeaveGame():
	get_tree().quit()
	pass
