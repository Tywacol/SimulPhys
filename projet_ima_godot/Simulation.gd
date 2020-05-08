extends Spatial


var node_3DArea : Spatial

func _ready():
	#node_3DArea = $Spatial
	#open_project_file(Global.nomFichier)
	pass

func add_node(parent_pathname : String, new_object : GlobalObject) -> void:
	var parent_node = node_3DArea.get_node(parent_pathname)
	parent_node.add_child(new_object)
	parent_node.add_object_child(new_object)

func open_project_file(file_pathname : String) -> void:
	var file = File.new()
	if file.open(file_pathname, File.READ) != 0:
		print("Error opening file")
		return
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