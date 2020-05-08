extends KinematicBody

#var motion = Vector3()
var camera_angle=0
var mouse_sensitivity=0.3

var velocity = Vector3()
var direction = Vector3()

const FLY_SPEED = 40
const FLY_ACCEL = 4


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta): 
	#reset the direction of the caracter
	direction = Vector3()
	
	#get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_rifgt"):
		direction += aim.x
		
	direction = direction.normalized()
	
	#where would the player go at max speed
	var target = direction * FLY_SPEED
	
	velocity = velocity * FLY_SPEED
	
	# calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	#move
	move_and_slide(velocity)



#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _input(event):
	if event is InputEventMouseMotion:
		$Head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var change =-event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change