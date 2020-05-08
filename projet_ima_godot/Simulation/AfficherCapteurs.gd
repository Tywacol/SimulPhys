extends HBoxContainer

var etat_scene = preload("res://Simulation/EtatCapteur.tscn")

func _ready():
	pass

func go_capteurs():
	for obj in Global.capteur_dict:
		var child = etat_scene.instance()
		child.get_node("VBoxContainer/Label").text = str(obj)
		var cap = Global.capteur_dict[obj]
		child.capteur = Global.capteur_dict[obj]
		#child.get_node("VBoxContainer/TextureRect")
		add_child(child)

func go_actionneurs():
	for obj in Global.actionneur_dict:
		var child = etat_scene.instance()
		child.get_node("VBoxContainer/Label").text = str(obj)
		var cap = Global.actionneur_dict[obj]
		child.capteur = Global.actionneur_dict[obj]
		#child.get_node("VBoxContainer/TextureRect")
		add_child(child)

func _process(delta):
	for child in get_children():
		child.a_jour()