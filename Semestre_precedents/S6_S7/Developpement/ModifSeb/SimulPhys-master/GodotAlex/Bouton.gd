extends StaticBody

export var etage = 0

func _ready():
	pass

sync func activate():
	var obj = null
	var parent = get_parent()
	while parent != null && parent.get_name() != "MainScene":
		parent = parent.get_parent()
	if parent != null:
		for child in parent.get_children():
			if child.get_name() == "Ascenseur":
				obj = child
				break
		if obj:
			obj.appel(etage)