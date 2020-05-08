extends StaticBody

class_name Fleche

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var last_pos : Vector3
var direction : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	var mat = $MeshInstance.get_mesh().surface_get_material(0).duplicate()
	$MeshInstance.get_mesh().set_material(mat)
	$MeshInstance2.get_mesh().set_material(mat)
	pass # Replace with function body.

func set_direction(dir : String):
	var rot
	if dir == "x":
		rot = Vector3(0, 0, deg2rad(-90))
		direction = Vector3(1, 0, 0)
		set_color(1, 0, 0)
	if dir == "y":
		rot = Vector3(0, 0, 0)
		direction = Vector3(0, 1, 0)
		set_color(0, 1, 0)
	if dir == "z":
		rot = Vector3(deg2rad(90), 0, 0)
		direction = Vector3(0, 0, 1)
		set_color(0, 0, 1)
	global_transform.basis = Basis(rot)

func set_color(red : float, blue : float, green : float):
	$MeshInstance.get_mesh().surface_get_material(0).set_albedo(Color(red, blue, green))
	$MeshInstance2.get_mesh().surface_get_material(0).set_albedo(Color(red, blue, green))

func set_initial_position(pos : Vector3):
	last_pos = pos

func move(pos : Vector3):
	if $CollisionPlane.disabled:
		set_initial_position(pos)
	else:
		get_parent().global_translate((pos-last_pos)*direction)
		last_pos = pos
		#print(pos)

#warning-ignore:unused_argument
func take_focus(view_pos):
	$CollisionPlane.disabled = false
	$CollisionShape.disabled = true
	var calc = (-(view_pos-global_transform.origin).cross(direction).cross(direction)).normalized()
	$CollisionPlane.shape.set_plane(Plane(calc, 0.07))
	print(calc)
	pass

func loose_focus():
	$CollisionPlane.disabled = true
	$CollisionShape.disabled = false
	pass