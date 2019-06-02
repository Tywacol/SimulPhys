extends Camera

#var motion = Vector3()
var camera_angle=0
var mouse_sensitivity=0.3

var velocity = Vector3()
var direction = Vector3()

const FLY_SPEED = 1
const FLY_ACCEL = 1

onready var Body = get_parent()

func _ready():
	pass

func _physics_process(delta): 
	#reset the direction of the caracter
	direction = Vector3()
	
	if Input.is_action_pressed("ui_up"):
		direction.z = -1
	if Input.is_action_pressed("ui_down"):
		direction.z = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	
	direction = direction.normalized()
	
	direction.rotated(Vector3(0,1,0), Body.rotation.y)
	
	
	#move
	Body.move_and_slide(direction * FLY_SPEED)
	


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _input(event):
	if event is InputEventMouseMotion:
		Body.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var change =-event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			rotate_x(deg2rad(change))
			camera_angle += change