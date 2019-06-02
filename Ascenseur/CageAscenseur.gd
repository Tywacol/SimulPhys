extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar
var movement = "stop"
var speed = elevatorParam.get_elevator_speed()
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


sync func update(dir, etage):
	if etage == destination:
		if movement == dir:
			stop()
			actuel = etage


sync func appel(etage):
	print(self.get_path())
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


sync func stop():
	movement = "stop"
	open()

sync func open():
	print("path open cageascencseur  : "+get_path())
	$Portes.open()

sync func close():
    $Portes.close()