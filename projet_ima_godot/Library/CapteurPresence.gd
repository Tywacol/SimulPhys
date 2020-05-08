extends Capteur

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var distance = 1
export var etage = 0
export var position = "haut"
var child = null

func _init():
	._init()

func _ready():
	._ready()
	$RayCast.set_cast_to(Vector3(0, distance, 0))

func _physics_process(delta):
	if (get_etat()!=1) and $RayCast.is_colliding():
		change_etat(1)
		print("changement etat : 1")
	if (get_etat()==1) and (not $RayCast.is_colliding()):
		print("changement etat : 0")
		change_etat(0)
