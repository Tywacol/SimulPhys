extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var porte_etat

func _ready():
	porte_etat = "close"
	$Capteur.change_etat(1)

var movement = Vector3(-0.6, 0, 0)

func move_doors():
	if porte_etat == "opening":
		if $PorteGauche.translation.x > -1.8:
			$PorteGauche.move_and_slide(movement)
			$PorteDroite.move_and_slide(-movement)
		else:
			porte_etat = "open"
	elif porte_etat == "closing":
		if $PorteGauche.translation.x < -0.61:
			$PorteGauche.move_and_slide(-movement)
			$PorteDroite.move_and_slide(movement)
		else:
			porte_etat = "close"
			$Capteur.change_etat(1)

func _physics_process(delta):
	update()
	move_doors()

func update():
	if porte_etat == "close" and ($Actionneur.get_etat() == 1):
		porte_etat = "opening"
		$Capteur.change_etat(0)
	
	if porte_etat == "open" and ($Actionneur.get_etat() == 1):
		porte_etat = "closing"