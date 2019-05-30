extends KinematicBody

#var motion = Vector3()
var camera_angle=0
var mouse_sensitivity=0.3

var velocity = Vector3()
var direction = Vector3()

const FLY_SPEED = 1.1
const FLY_ACCEL = 100
var RAY_LENGTH = 20
var menu = false


func _ready():
	pass

func _physics_process(delta): 
	#reset the direction of the caracter
	$pause.connect("reprendre",self,"menuOnOff")
	if Input.is_action_just_pressed("ui_quit"):
		menuOnOff()
	
	direction = Vector3()
	
	#get the rotation of the camera
	var aim = $Camera.get_global_transform().basis
	if Input.is_action_pressed("ui_up"):
		direction -= aim.z
	if Input.is_action_pressed("ui_down"):
		direction += aim.z
	if Input.is_action_pressed("ui_left"):
		direction -= aim.x
	if Input.is_action_pressed("ui_right"):
		direction += aim.x
		
	direction = direction.normalized()
	
	#where would the player go at max speed
	var target = direction * FLY_SPEED
	
	velocity = velocity * FLY_SPEED
	
	# calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	#move
	if menu == true:
		return
	move_and_slide(velocity)



func _input(event):
	if menu == true:
		return
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var change =-event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Camera.rotate_x(deg2rad(change))
			camera_angle += change

	if event is InputEventMouseButton:
		if event.is_pressed():
			var obj = get_object_under_mouse()
			if obj.empty():
				print("aucun bouton en vue")
			else:
				obj.collider.activate()
				print(str("etage ",obj.collider.etage))


func get_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = $Camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + $Camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to, [self], 2)
	return selection

func menuOnOff():
	if menu == false:
		menu = true
	else:
		menu = false
	pass