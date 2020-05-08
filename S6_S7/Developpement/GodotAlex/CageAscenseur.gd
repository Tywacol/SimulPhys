extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar
var movement = "stop"
var speed = global.speed
export var destination = 0
export var actuel = 0



func _ready():
	pass

func _process(delta):
	if $Portes.etat == "close":
		if movement == "haut":
			translate(Vector3(0, speed, 0)*delta)
		elif movement == "bas":
			translate(Vector3(0, -speed, 0)*delta)


func update(dir, etage):
	if etage == destination:
		if movement == dir:
			stop()
			actuel = etage


func call(etage):
	if movement == "stop":
		destination = etage
		if etage > actuel:
			movement = "haut"
			close()
		elif etage < actuel:
			movement = "bas"
			close()
		else:
			open()


func stop():
	movement = "stop"
	open()

func open():
	$Portes.open()

func close():
	$Portes.close()
	
func set_speed(value):
	speed = value