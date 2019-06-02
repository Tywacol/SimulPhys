extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready action")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ZeroButton_pressed():
	print("bouton0 pressed")
	print("path : "+get_path())
	get_node("Ascenseur").rpc("open")
	print("Sortie bouton 0")


func _on_OneButton_pressed():
	print("bouton1 pressed")
	get_node("Ascenseur/Portes")
