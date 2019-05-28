extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var distance = 1
export var etage = 0
export var position = "haut"
var child = null

func _ready():
	$RayCast.set_cast_to(Vector3(0, distance, 0))

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if $RayCast.is_colliding():
		print("presence detectee")
		for child in get_parent_spatial().get_childen():
			if child.get_name() == "Ascenseur":
				break
		if child:
			child.update(position, etage)
