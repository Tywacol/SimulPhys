extends CanvasLayer
 


func _ready():
	$Retour.connect("pressed",self,"buttonRetour")
	$Retour.connect("mouse_entered",self,"bipMenu")
	$vitesseDropdown.connect("item_selected",self,"onVitesseSelected")
	vitesseList()
	pass


func buttonRetour():
	get_tree().change_scene("res://Ground.tscn")
	pass

func bipMenu():
	$Bip.play()
	pass
	
func vitesseList():
	for i in range(1,21):
		$vitesseDropdown.add_item("%d"%i)
	$vitesseDropdown.select(global.speed-1)
	pass
	
func onVitesseSelected(id):
	global.speed = $vitesseDropdown.selected + 1