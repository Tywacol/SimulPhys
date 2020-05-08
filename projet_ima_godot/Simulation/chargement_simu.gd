extends Node
var savefile_path : String
var node_objects : Node
var node_properties : Node
var node_3DArea : Spatial
var node_treeItem : Control
# dictionnaire (key : node_pathname(unique), value : node_object)
var objects_dictionary





func open_project_file(file_pathname : String) -> void:
	var file = File.new()
	if file.open(file_pathname, File.READ) != 0:
		print("Error opening file")
		return
	savefile_path = file_pathname

	var save_nodes = node_3DArea.get_tree().get_nodes_in_group("global_objects")
	for i in save_nodes:
		i.queue_free()
	
	load_project_tree(file)

func load_project_tree(file : File) -> void:
	var content = parse_json(file.get_line())
	while content != null:
		var new_object : GlobalObject = load(content["filename"]).instance()
		add_node(content["parent"], new_object)
		new_object.translation = Vector3(content["posx"], content["posy"], content["posz"])
		new_object.rotation = Vector3(content["rotx"], content["roty"], content["rotz"])
		for i in content.keys():
			if i=="filename" or i=="parent" or i=="posx" or i=="posy" or i=="posz" or i=="rotx" or i=="roty" or i=="rotz":
				continue
			new_object.set(i, content[i])
		content = parse_json(file.get_line())
	file.close()
	
func add_node(parent_pathname : String, new_object : GlobalObject) -> void:
	node_treeItem.add_item(new_object.name)
	#print(object_pathname)
	var parent_node = node_3DArea.get_node(parent_pathname)
	parent_node.add_child(new_object)
	parent_node.add_object_child(new_object)
	change_focus(new_object.object_path)	

func change_focus(object_path : String) -> void:
	pass
