extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Center window on screen
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	get_viewport().warp_mouse(screen_size/2)
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
