extends CanvasLayer
 
const convert_in_ms =0.45

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
	for i in range(1,41,2):
		$vitesseDropdown.add_item("%.3f m/s"% (convert_in_ms*i))
	$vitesseDropdown.select(global.speed/ 2)
	pass
	
func onVitesseSelected(id):
	global.speed = $vitesseDropdown.selected*2 + 1
	pass