extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var etat

func _ready():
	etat = "close"

var movement = Vector3(-0.6, 0, 0)

func move_doors(dir):
	if dir == 1 && $PorteGauche.translation.x > -1.8:
		$PorteGauche.move_and_slide(movement)
		$PorteDroite.move_and_slide(-movement)
	elif dir == -1 && $PorteGauche.translation.x < -0.6:
		print("closing")
		$PorteGauche.move_and_slide(-movement)
		$PorteDroite.move_and_slide(movement)
	else:
		print("over")
		if etat == "closing":
			etat = "close"
			print("Doors closed")
		elif etat == "opening":
			etat = "open"
			print("Doors opened")


func _physics_process(delta):
	if etat == "opening":
		move_doors(1)
	elif etat == "closing":
		move_doors(-1)


func open():
	if etat == "close":
		print("ouverture")
		etat = "opening"

func close():
	if etat == "open":
		print("fermeture")
		etat = "closing"