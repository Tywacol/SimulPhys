class_name Actionneur extends GlobalObject

func init():
	._init()
	self.object_type = "actionneur"
	pass

func _ready():
	._ready()
	self.add_to_group("actionneurs")

func get_class():
	return "Actionneur"
	
func save():
	var save_dict = .save()
	
	return save_dict