extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera_angle=0
var mouse_sensitivity=0.3
var speed=5
var focus_camera = false
var right_click
var clicked = false
var clicking = false
var fleche_x : PackedScene
var fleche_y : PackedScene
var fleche_z : PackedScene
var object_with_arrows : Spatial
var object_selected : Spatial = null
var fleche_selected : Fleche = null
var camera
var viewport : Control
#var Fleche = load("res://Fleche_deplacer.gd")

signal object_selected(node)
signal send_text(text)

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_node("Camera")
	fleche_x = load("res://Fleche_deplacer.tscn")
	fleche_y = load("res://Fleche_deplacer.tscn")
	fleche_z = load("res://Fleche_deplacer.tscn")
	viewport = get_parent().get_parent()
	pass

func select_node(object_path : String):
	var selected_object = get_parent().get_node(object_path)
	if selected_object != null and selected_object.is_in_group("global_objects"):
		change_selection(selected_object)
	else:
		remove_selection()

func change_selection(object_node : Spatial):
	print("change selection")
	
	remove_selection()
	if object_node != null and object_node.name != "CreatingArea":
		object_selected = object_node
		object_with_arrows = object_node
		var fl = fleche_x.instance()
		object_node.add_child(fl)
		fl.set_direction("x")
		
		fl = fleche_y.instance()
		object_node.add_child(fl)
		fl.set_direction("y")
		
		fl = fleche_z.instance()
		object_node.add_child(fl)
		fl.set_direction("z")

func remove_selection():
	if object_with_arrows != null:
		for obj in object_with_arrows.get_children():
			if obj is Fleche:
				obj.queue_free()
	object_selected = null
	object_with_arrows = null
	fleche_selected = null

func find_instance_parent(node : Spatial) -> Spatial:
	var rrrr : Spatial = node
	while (node != null) and ((not node.is_in_group("global_objects")) and (not(node is Fleche))):
		node = node.get_parent()
	if (node == null) or (node.name == "Creating3DArea"):
		return rrrr
	else:
		return node

func get_all_children(node):
	var tab = Array()
	for child in node.get_children():
		if ((fleche_selected == null) and not (child is Fleche)) or ((fleche_selected != null) and (child != fleche_selected)):
			if child is CollisionObject:
				tab.append(child)
			else:
				for o in get_all_children(child):
					tab.append(o)
	return tab

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and not viewport.gui_disable_input:
		var ray_origin = camera.project_ray_origin(get_viewport().get_mouse_position())
		var ray_direction = camera.project_ray_normal(get_viewport().get_mouse_position())
		var from = ray_origin
		var to = ray_origin + ray_direction *1000
		var space_state = get_world().get_direct_space_state()
		
		var hit
		if object_selected != null:
			var reject = get_all_children(object_selected)
			if fleche_selected != null:
				hit = space_state.intersect_ray(from, to, reject, 16)
			else:
				hit = space_state.intersect_ray(from, to, reject)

		else:
			hit = space_state.intersect_ray(from, to)

		if hit.size()==0:
			if not clicking:
				remove_selection()

		else:
			var object_hit = find_instance_parent(hit.collider)
			var object_name = object_hit.name
			if not clicking:
				clicking = true
				if object_hit is Fleche: # si on clique sur une des fleche
					object_hit.set_initial_position(hit.position)
					fleche_selected = object_hit
					fleche_selected.take_focus(ray_origin)
				
				elif object_hit!=object_selected: # si on clique sur un autre objet on crée les fleche
					change_selection(object_hit)
					emit_signal("object_selected", object_hit.object_path)
			else:
				if object_hit == fleche_selected:
					object_hit.move(hit.position)
	
	if Input.is_action_just_released("left_click"):
		clicking = false
		if fleche_selected != null:
			emit_signal("send_text", "Translation of " + object_selected.name)
			fleche_selected.loose_focus()
			fleche_selected = null

func _physics_process(delta):
	if focus_camera:
		if Input.is_action_pressed("ui_right"):
			translate(Vector3(1,0,0)*speed*delta)
		if Input.is_action_pressed("ui_left"):
			translate(Vector3(-1,0,0)*speed*delta)
		if Input.is_action_pressed("ui_up"):
			translate(Vector3(0,0,-1).rotated(Vector3(1,0,0), deg2rad(camera_angle))*speed*delta)
		if Input.is_action_pressed("ui_down"):
			translate(Vector3(0,0,1).rotated(Vector3(1,0,0), deg2rad(camera_angle))*speed*delta)
		if Input.is_action_pressed("ui_k"):
			translate(Vector3(0,1,0)*speed*delta)
		if Input.is_action_pressed("ui_j"):
			translate(Vector3(0,-1,0)*speed*delta)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(0)
			focus_camera = false
	#if event is InputEventMouseButton:
	#	pass
	if Input.is_action_pressed("ui_rotate"):
		right_click = true
	else:
		right_click = false
	if Input.is_action_just_pressed("ui_rotate"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("ui_rotate"):
		Input.set_mouse_mode(0)
		
	
	if event is InputEventMouseMotion:
		if focus_camera or right_click:
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
			var change =-event.relative.y * mouse_sensitivity
			if change + camera_angle < 90 and change + camera_angle > -90:
				$Camera.rotate_x(deg2rad(change))
				camera_angle += change
				
	if event is InputEventMouseButton:
		if event.button_index==1 and event.doubleclick:
			print("press")
			focus_camera = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)