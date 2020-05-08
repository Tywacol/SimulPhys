extends Control

func _ready():
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	get_viewport().warp_mouse(screen_size/2)

#func _process(delta):
#	pass

func _on_NewProject_pressed():
	$CreateProjectFile.popup()

func _on_OpenProject_pressed():
	$OpenProjectFile.popup()

func _on_Leave_pressed():
	get_tree().quit()

func _on_FileDialog_file_selected(path):
	$NewProject.hide()
	$OpenProject.hide()
	Global.nomFichier = path
	Global.goto_scene("res://App_window.tscn")

