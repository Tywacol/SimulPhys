extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var etage = 0

func _ready():
	$Bouton.etage = etage

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
#		"pos_x" : position.x, # Vector2 is not supported by JSON
#		"pos_y" : position.y,
	}
	return save_dict

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
