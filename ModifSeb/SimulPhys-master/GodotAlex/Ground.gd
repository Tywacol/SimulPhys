extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
