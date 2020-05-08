class_name Bouton extends Capteur

export var etage = 0

func _init():
	._init()

func _ready():
	._ready()

func activer():
	if get_etat()==0:
		print("bouton pressed")
		change_etat(1)

func desactiver():
	if get_etat()!=0:
		print("bouton released")
		change_etat(0)
