extends CanvasLayer

var selectSim
var AscensorButton
var backButton


func _ready():
	selectSim = get_node("GameName")
	backButton = get_node("BackButton")
	AscensorButton = get_node("Ascensor")
	AscensorButton.connect("pressed",self,"ascensorSimLaunch")
	backButton.connect("pressed",self,"backMenu")
	pass

func ascensorSimLaunch():
	get_tree().change_scene("res://Ground.tscn")
	pass
	
func backMenu():
	get_tree().change_scene("res://menu/menu.tscn")
	pass