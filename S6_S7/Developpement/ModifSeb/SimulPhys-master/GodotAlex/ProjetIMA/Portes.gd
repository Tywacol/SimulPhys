extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var etat

func _ready():
	etat = "close"

var movement = Vector3(-0.6, 0, 0)

func move_doors(dir):
	if $PorteGauche.translation.x > -1.8:
		$PorteGauche.move_and_slide(dir)
		$PorteDroite.move_and_slide(-dir)
	else:
		if etat == "closing":
			etat = "close"
		else:
			etat = "open"


func _physics_process(delta):
	if etat == "opening":
		move_doors(movement)
	elif etat == "closing":
		move_doors(-movement)


func open():
	print("ouverture")
	if etat == "close":
		etat = "opening"

func close():
	if etat == "open":
		etat = "closing"