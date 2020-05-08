extends GlobalObject

# class member variables go here, for example:
# var a = 2
# var b = "textvar
var movement = "stop"
var speed = 5


func _process(delta):
	update()
	if movement == "haut":
		translate(Vector3(0, speed, 0)*delta)
	elif movement == "bas":
		translate(Vector3(0, -speed, 0)*delta)


func update():
	if movement == "stop":
		if $Marche.get_etat() == 1:
			if $Direction.get_etat() == 1:
				movement = "haut"
			else:
				movement = "bas"
	else:
		if $Marche.get_etat() == 0:
			movement = "stop"
