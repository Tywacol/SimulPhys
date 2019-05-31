extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	pass # Replace with function body.

func _on_etage1_pressed():
	rpc("open")


func _on_etage0_pressed():
	print("etage0pressed")
	rpc("open")
