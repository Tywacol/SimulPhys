class_name GlobalObject extends Spatial

var object_type : String
var object_parent_path : String
var object_path : String
var object_children : Array
export var linked_script : Script

var etat : int = 0


func _init():
	object_type = "global_object"
	object_parent_path = ""
	object_path = ""
	object_children = []

func get_class():
	return "GlobalObject"

func _ready():
	object_path = object_parent_path + "/" + self.name if object_parent_path != "" else self.name
	self.add_to_group("global_objects", true)
	#remove_children_group(self, "global_objects")

func add_object_child(obj : Spatial):
	if obj.is_in_group("global_objects"):
		obj.object_parent_path = object_path
		obj.object_path = object_path + "/" + obj.name if object_path != "" else obj.name
		object_children.append(obj)
	#for child in obj.get_children():
	#	add_object_child(child)

func remove_object_child(child_path : String):
	var path_list = Array(child_path.split("/"))
	path_list.pop_back()
	var child = self
	print(path_list)
	for obj in path_list:
		if child != null:
			child = child.get_object_child(obj)
	print("remove : ", child.object_path)
	object_children.erase(child)
	child.queue_free()

func get_object_child(name):
	for obj in object_children:
		if obj.name == name:
			return obj
	return null

func get_object_path() -> String:
	return object_path
	pass

func change_name(s):
	update_parent_path_of_children(self.name, s)
	self.name = s
	self.object_path = object_parent_path + "/" + s if object_parent_path != "" else s

func update_parent_path_of_children(old_s, new_s):
	for child in self.object_children:
		var new_path : PoolStringArray = child.object_parent_path.split("/")
		for i in range(new_path.size()):
			if new_path[i] == old_s:
				new_path[i] = new_s
		child.object_parent_path = new_path.join("/")
		child.update_parent_path(old_s, new_s)

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_filename(),
		"parent" : object_parent_path,
		"name" : self.name,
		"posx" : translation.x,
		"posy" : translation.y,
		"posz" : translation.z,
		"rotx" : rotation.x,
		"roty" : rotation.y,
		"rotz" : rotation.z,
		"object_type" : object_type,
		"linked_script" : linked_script.get_instance_base_type() if linked_script != null else ""
	}
	return save_dict

func remove_children_group(node : Spatial, group : String):
	for child in node.get_children():
		if child.is_in_group(group):
			child.remove_from_group(group)
		remove_children_group(child, group)

func get_etat() -> int:
	return etat

func change_etat(value : int) -> void:
	etat = value