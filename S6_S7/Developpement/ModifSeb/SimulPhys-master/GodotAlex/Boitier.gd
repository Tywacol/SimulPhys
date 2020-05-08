extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var etage = 0

func _ready():
	$Bouton.etage = etage

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
