extends Control


var node_objects : GlobalObject
var node_properties : Node
# dictionnaire (key : node_pathname(unique), value : node_object)
var objects_dictionary
var node_3DArea : Spatial
var node_treeItem : Control
var node_camera
var node_viewport : Viewport
var choose_item_popup : FileDialog
var object_selected_path : String = ""
var object_selected : GlobalObject = null

var Associate_bit = preload("res://Associate_bit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	unfocus_tree(self)
	node_viewport = $VBoxContainer/HBoxContainer/VBoxContainerLeft/HBoxContainer/ViewportContainer/Viewport
	node_3DArea = node_viewport.get_child(0)
	node_treeItem = $VBoxContainer/HBoxContainer/VBoxContainerRight/ObjectTreeContainer/ObjectTree
	node_treeItem.get_node("Tree").connect("item_selected", self, "update_properties_window")
	node_properties = $VBoxContainer/HBoxContainer/VBoxContainerRight/PanelContainer/Proprietes/VBoxContainer
	node_camera = node_3DArea.get_node("KinematicBody")
	choose_item_popup = $ChooseItem
	node_viewport.gui_disable_input = true
	node_objects = GlobalObject.new()
	node_objects.change_name("objects_node")
	objects_dictionary = Dictionary()
	node_treeItem.connect("_add_node", self, "open_choosing_item")
	node_treeItem.connect("_delete_node", self, "delete_node")
	node_treeItem.connect("_change_text", self, "_on_change_object_name")
	node_camera.connect("object_selected", self, "_on_camera_change_selection")
	node_camera.connect("send_text", self, "write_update")
	if Global.nomFichier != "":
		open_project_file(Global.nomFichier)

func _on_Button_pressed():
	Global.liste_actionneurs = []
	Global.liste_capteurs = []
	for child in $ConfirmationDialog/ScrollContainer/VBoxContainer/Capteurs.get_children():
		child.queue_free()
	for child in $ConfirmationDialog/ScrollContainer/VBoxContainer/Actionneurs.get_children():
		child.queue_free()
	creer_listes_simu(Global.objet_parent)
	var case
	for n in Global.liste_capteurs:
		case = Associate_bit.instance()
		case.get_node("Label").set_text(node_3DArea.get_path_to(n))
		$ConfirmationDialog/ScrollContainer/VBoxContainer/Capteurs.add_child(case)
	for n in Global.liste_actionneurs:
		case = Associate_bit.instance()
		case.get_node("Label").set_text(node_3DArea.get_path_to(n))
		$ConfirmationDialog/ScrollContainer/VBoxContainer/Actionneurs.add_child(case)
	$ConfirmationDialog.popup()

func open_simulation_scene():
	for n in $ConfirmationDialog/ScrollContainer/VBoxContainer/Capteurs.get_children():
		Global.capteur_dict[n.get_node("LineEdit").get_value()] = n.get_node("Label").get_text()
	for n in $ConfirmationDialog/ScrollContainer/VBoxContainer/Actionneurs.get_children():
		Global.actionneur_dict[n.get_node("LineEdit").get_value()] = n.get_node("Label").get_text()
	print(Global.capteur_dict)
	print(Global.actionneur_dict)
	Global.goto_scene("res://Simulation/Simulation.tscn")
	
func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("save_project"):
			save_project_tree()
		elif Input.is_action_just_pressed("open_project"):
			open_project_loader()

func _on_ViewportContainer_mouse_exited():
	node_viewport.gui_disable_input = true

func _on_ViewportContainer_mouse_entered():
	node_viewport.gui_disable_input = false

func add_node(parent_pathname : String, new_object : GlobalObject) -> void:
	node_treeItem.add_item_on_parent(parent_pathname, new_object.name)
	var parent_node = node_3DArea.get_node(parent_pathname)
	parent_node.add_child(new_object)
	if (parent_node.name == "CreatingArea"):
		Global.objet_parent.add_object_child(new_object)
	else:
		parent_node.add_object_child(new_object)
	change_focus(new_object.object_path)
	
func delete_node(object_pathname : String) -> void:
	if object_pathname != "":
		write_update("Object \"" + object_pathname + "\" delected.")
		node_treeItem.delete_selected()
		node_3DArea.get_node(object_pathname).queue_free()
		node_camera.remove_selection()
		Global.objet_parent.remove_object_child(object_pathname)

func unfocus_tree(n):
	var children = n.get_children()
	for child in children:
		if child.name == "Tree":
			child.set_focus_mode(FOCUS_NONE)
		else:
			unfocus_tree(child)

func open_project_file(file_pathname : String) -> void:
	var file = File.new()
	if file.open(file_pathname, File.READ) != 0:
		print("Error opening file")
		return
	Global.nomFichier = file_pathname

	var save_nodes = node_3DArea.get_tree().get_nodes_in_group("global_objects")
	for i in save_nodes:
		if (i.name != "CreatingArea"):
			i.queue_free()
	node_treeItem.reset()
	load_project_tree(file)

func load_project_tree(file : File) -> void:
	var content = parse_json(file.get_line())
	while content != null:
		var new_object : GlobalObject = load(content["filename"]).instance()
		new_object.translation = Vector3(content["posx"], content["posy"], content["posz"])
		new_object.rotation = Vector3(content["rotx"], content["roty"], content["rotz"])
		for i in content.keys():
			if i=="filename" or i=="parent" or i=="posx" or i=="posy" or i=="posz" or i=="rotx" or i=="roty" or i=="rotz":
				continue
			new_object.set(i, content[i])
		add_node(content["parent"], new_object)
		content = parse_json(file.get_line())
	file.close()

func open_project_loader():
	$OpenProject.popup()
	pass

func open_project_saver():
	$SaveProject.popup()
	pass

func save_project_tree():
	if Global.nomFichier == null or Global.nomFichier == "":
		open_project_saver()
		return
	else :
		var file = File.new()
		if file.open(Global.nomFichier, File.WRITE) != 0:
			print("Error opening file")
			return
		
		print_in_file(file, Global.objet_parent)
		file.close()

func print_in_file(file : File, obj : GlobalObject):
	print(obj.object_children)
	for child in obj.object_children:
		if child != null:
			print("child : ", child.object_path)
			file.store_line(to_json(child.call("save")))
			print_in_file(file, child)

func add_node_tree(parent_node, new_node):
	new_node = new_node.new()
	
	parent_node.add_child(new_node)
	new_node.set_owner(parent_node)
	pass

func open_choosing_item():
	choose_item_popup.popup()

func _on_ChooseItem_file_selected(path):
	var parent_path = node_treeItem.get_selected_path()
	var object_created : Spatial = load(path).instance()
	if object_created is GlobalObject:
		add_node(parent_path, object_created)
		#focus on object created

func _on_ChooseItem_popup_hide():
#	object_selected_path = ""
	pass

func _on_SaveProject_file_selected(path):
	Global.nomFichier = path
	save_project_tree()

func update_properties_window():
	var treeItem = node_treeItem.get_selected_item()
	var object3D : Spatial = node_3DArea.get_node(node_treeItem.get_selected_path())
	if object3D != null:
		node_3DArea.get_node("KinematicBody").change_selection(object3D)
	#	print(object3D.name)
		#var node_object = node_3DArea.get_node(node_treeItem.path_of_item(treeItem))
		#var object_transform = node_object.
		node_properties.get_node("ContainerName/LineEdit").text = treeItem.get_text(0)
		var position = node_properties.get_node("ContainerPosition/HBoxContainer")
		position.get_node("LineEditx").text = String(object3D.transform.origin.x)
		position.get_node("LineEdity").text = String(object3D.transform.origin.y)
		position.get_node("LineEditz").text = String(object3D.transform.origin.z)
		var rotation = node_properties.get_node("ContainerRotation/HBoxContainer")
		rotation.get_node("LineEditx").text = String(rad2deg(object3D.rotation.x))
		rotation.get_node("LineEdity").text = String(rad2deg(object3D.rotation.y))
		rotation.get_node("LineEditz").text = String(rad2deg(object3D.rotation.z))


func change_object_position_x(value):
	node_properties.get_node("ContainerPosition/HBoxContainer/LineEditx").text = String(value)
	node_3DArea.get_node(node_treeItem.get_selected_path()).transform.origin.x = float(value)
func change_object_position_y(value):
	node_properties.get_node("ContainerPosition/HBoxContainer/LineEdity").text = String(value)
	node_3DArea.get_node(node_treeItem.get_selected_path()).transform.origin.y = float(value)
func change_object_position_z(value):
	node_properties.get_node("ContainerPosition/HBoxContainer/LineEditz").text = String(value)
	node_3DArea.get_node(node_treeItem.get_selected_path()).transform.origin.z = float(value)
func change_object_rotation_x(value):
	node_properties.get_node("ContainerRotation/HBoxContainer/LineEditx").text = String(value)
	var angle = node_3DArea.get_node(node_treeItem.get_selected_path()).rotation.x
	node_3DArea.get_node(node_treeItem.get_selected_path()).rotation.x = deg2rad(float(value))
func change_object_rotation_y(value):
	node_properties.get_node("ContainerRotation/HBoxContainer/LineEdity").text = String(value)
	var angle = node_3DArea.get_node(node_treeItem.get_selected_path()).rotation.y
	node_3DArea.get_node(node_treeItem.get_selected_path()).rotation.y = deg2rad(float(value))
func change_object_rotation_z(value):
	node_properties.get_node("ContainerRotation/HBoxContainer/LineEditz").text = String(value)
	var angle = node_3DArea.get_node(node_treeItem.get_selected_path()).rotation.z
	node_3DArea.get_node(node_treeItem.get_selected_path()).rotation.z = deg2rad(float(value))

#func on_systemObject_selection(object_path):
#	node_treeItem.get_treeItem(object_path).select(0)
#	pass

func change_focus(object_path : String) -> void:
	pass

func on_treeItem_change_selection(object_path : String) -> void:
	pass

func _on_camera_change_selection(object_path : String) -> void:
	node_treeItem.select_item(object_path)
	node_camera.select_node(object_path)
	update_properties_window()
	pass

func _on_change_object_name(new_text):
	write_update("Object \"" + node_treeItem.get_selected_name() + "\" is renamed : " + new_text)
	print(node_treeItem.get_selected_path())
	var re = Global.objet_parent.get_object_child(node_treeItem.get_selected_path())
	print(re.object_path)
	node_3DArea.get_node(node_treeItem.get_selected_path()).name = new_text
	Global.objet_parent.get_object_child(node_treeItem.get_selected_path()).change_name(new_text)
	node_3DArea.get_node(node_treeItem.get_selected_path()).name = new_text
	node_treeItem.change_selected_text(new_text)

func write_update(text):
	$VBoxContainer/HBoxContainer/VBoxContainerLeft/PanelContainer/RichTextLabel.add_text(text)
	$VBoxContainer/HBoxContainer/VBoxContainerLeft/PanelContainer/RichTextLabel.newline()
	pass

func creer_listes_simu(node : GlobalObject) ->void :
	for n in node_3DArea.get_tree().get_nodes_in_group("global_objects"):
		if n is Capteur:
			Global.liste_capteurs.append(n)
		elif n is Actionneur:
			Global.liste_actionneurs.append(n)

