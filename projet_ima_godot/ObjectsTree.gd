extends Control


signal _add_node()
signal _delete_node(node_pathname)
signal _change_text(new_text)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tree.set_focus_mode(FOCUS_NONE)
	
	$PopupMenu.add_item("Add object")
	$PopupMenu.add_item("Delete")
	$PopupMenu.add_item("Rename")
	$PopupMenu.add_item("Hide")
	
	var root = $Tree.create_item()
	root.set_text(0, "CreatingArea")
	$Tree.get_root().select(0)

func reset():
	$Tree.clear()
	var root = $Tree.create_item()
	root.set_text(0, "CreatingArea")
	$Tree.get_root().select(0)

func get_selected_item() -> TreeItem:
	return $Tree.get_selected()

func get_selected_name() -> String:
	return get_selected_item().get_text(0)

func get_selected_path() -> String:
	return path_of_item(get_selected_item())

func delete_selected():
	get_selected_item().get_parent().remove_child(get_selected_item())
	pass

func get_treeItem(complete_name : String) -> TreeItem:
	var res = $Tree.get_root()
	var item = $Tree.get_root().get_children()
	var path_list = complete_name.split("/")
	for item_name in path_list:
		if item_name == "":
			break
		while (item!=null) and (item.get_text(0)!=item_name):
			item = item.get_next()
		if item!=null:
			res = item
			item = item.get_children()
		else:
			return null
	return res

func path_of_item(item : TreeItem) -> String:
	var path_string = ""
	while item != $Tree.get_root():
		if path_string=="":
			path_string = item.get_text(0)
		else:
			path_string = item.get_text(0) + "/" + path_string
		item = item.get_parent()
	return path_string

func add_item(name : String) -> void:
	$Tree.create_item($Tree.get_selected()).set_text(0, name)

func add_item_on_parent(parent_name, item_name):
	$Tree.create_item(get_treeItem(parent_name)).set_text(0, item_name)
	pass

func delete_item(path_name : String) -> void:
	var object = get_treeItem(path_name)
	pass

func _on_Tree_item_rmb_selected(position):
	$PopupMenu.popup()
	$PopupMenu.margin_left = get_global_mouse_position().x
	$PopupMenu.margin_top = get_global_mouse_position().y

func _on_PopupMenu_id_pressed(ID):
	var action = $PopupMenu.get_item_text(ID)
	if action == "Delete":
		emit_signal("_delete_node", get_selected_path())
	elif action == "Rename":
		popup_rename_window($Tree.get_selected())
	elif action == "Add object":
		emit_signal("_add_node")
		pass
	elif action == "Hide": #Hides object in 3D view
		pass

func popup_rename_window(item_selected):
	var text = item_selected.get_text(0)
	$WindowDialog/LineEdit.text = text
	$WindowDialog.popup_centered()
	$WindowDialog/LineEdit.grab_focus()
	#emit_signal("_rename_node")

func _on_text_entered(new_text):
	$WindowDialog.hide()
	emit_signal("_change_text", new_text)

func change_selected_text(new_text):
	$Tree.get_selected().set_text(0, new_text)

func deselect_item():
	get_selected_item().deselect(0)

func select_item(object_path : String):
	deselect_item()
	var i = get_treeItem(object_path)
	if i != null:
		i.select(0)

func _on_WindowDialog_Button_pressed():
	_on_text_entered($WindowDialog/LineEdit.text)
