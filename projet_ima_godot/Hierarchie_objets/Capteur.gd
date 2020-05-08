class_name Capteur extends GlobalObject

var liste_actionneurs : Array

func _init():
	._init()
	self.object_type = "capteur"
	liste_actionneurs = []

func _ready():
	._ready()
	self.add_to_group("capteurs")

func get_class():
	return "Capteur"
	
func save():
	var save_dict = .save()
	save_dict["liste_actionneurs"] = liste_actionneurs
	return save_dict

func add_actionneur(node):
	liste_actionneurs.append(node)