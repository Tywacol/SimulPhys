extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar
var movement = "stop"
var speed = 0
export var destination = 0
var actuel = 0


func _ready():
	pass

func _process(delta):
	if movement == "haut":
		move(10)
	elif movement == "bas":
		move(-10)


func update(dir, etage):
	if etage == destination:
		if movement == dir:
			stop()
		elif movement != "stop":
			speed = speed/2


func call(etage):
	if movement == "stop":
		if etage > actuel:
			movement = "haut"
		elif etage < actuel:
			movement = "bas"
		else:
			movement = "stop"


func stop():
	movement = "stop"

func open():
	print("appele")
	$Portes.open()

func close():
	$Portes.close()