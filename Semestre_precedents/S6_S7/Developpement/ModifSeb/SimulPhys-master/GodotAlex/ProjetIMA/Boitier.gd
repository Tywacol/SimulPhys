extends Spatial

export var etage = 3

func _ready():
	pass

func activate():
	var obj = null
	for child in get_parent_spatial().get_children():
		if child.get_name() == "Ascenseur":
			obj = child
			break
	if obj:
		obj.open()