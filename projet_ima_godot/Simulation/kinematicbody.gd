extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera_angle=0
var mouse_sensitivity=0.3
var speed=4
var right_click
var clicked = false
var fleche_obj : PackedScene
var button_hit : Spatial = null
#var Fleche = load("res://Fleche_deplacer.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	#var window = OS.get_screen_size()
	#get_viewport().warp_mouse(Vector2(window.x/2, window.y/2))
	if Input.is_action_just_pressed("left_click"):
		var ray_origin = $Camera.project_ray_origin(get_viewport().get_mouse_position())
		var ray_direction = $Camera.project_ray_normal(get_viewport().get_mouse_position())
		var from = ray_origin
		var to = ray_origin + ray_direction *1000
		var space_state = get_world().get_direct_space_state()
		
		var hit : Dictionary = space_state.intersect_ray(from, to)
		if hit.size() != 0:
			var obj = hit.collider
			if obj is Bouton:
				obj.activer()
				button_hit = obj
	
	if Input.is_action_just_released("left_click"):
		if (button_hit!=null):
			button_hit.desactiver()
			button_hit = null

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		translate(Vector3(1,0,0)*speed*delta)
	if Input.is_action_pressed("ui_left"):
		translate(Vector3(-1,0,0)*speed*delta)
	if Input.is_action_pressed("ui_up"):
		translate(Vector3(0,0,-1)*speed*delta)#.rotated(Vector3(1,0,0), deg2rad(camera_angle))*speed*delta)
	if Input.is_action_pressed("ui_down"):
		translate(Vector3(0,0,1)*speed*delta)#.rotated(Vector3(1,0,0), deg2rad(camera_angle))*speed*delta)
	if Input.is_action_pressed("ui_k"):
		translate(Vector3(0,1,0)*speed*delta)
	if Input.is_action_pressed("ui_j"):
		translate(Vector3(0,-1,0)*speed*delta)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
	
		var change =-event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Camera.rotate_x(deg2rad(change))
			camera_angle += change
		
				
	if event is InputEventMouseButton:
		if event.button_index==1 and event.doubleclick:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
