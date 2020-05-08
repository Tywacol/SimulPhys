extends PanelContainer

var capteur = null
var etat : int
var etat_on : Texture
var etat_off : Texture

func _ready():
	etat = 0
	etat_on = load("res://Simulation/capteurOn.png")
	etat_off = load("res://Simulation/capteurOff.png")

func a_jour():
	if etat != capteur.get_etat():
		etat = capteur.get_etat()
		if etat == 1:
			get_node("VBoxContainer/TextureRect").texture = etat_on
		else:
			get_node("VBoxContainer/TextureRect").texture = etat_off