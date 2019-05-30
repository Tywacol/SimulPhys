extends CanvasLayer



func _ready():
	$HostButton.connect("mouse_entered",self,"bipMenu")
	$LeaveButton.connect("mouse_entered",self,"bipMenu")
	#$HostButton.connect("pressed",self,"_on_HostButton_pressed")
	$LeaveButton.connect("pressed",self,"buttonLeaveGame")
	pass

func bipMenu():
	$Bip.play()
	pass

func buttonLaunchGame():
	$GameName.hide()
	$HostButton.hide()
	get_tree().change_scene("res://menu/selectSim.tscn")
	pass
	
func buttonLeaveGame():
	get_tree().quit()
	pass

func _on_HostButton_pressed():
  print("Host")
  var done = false
  var data = "hello"
 
  while(done != true):
      if(data == "quit"):
        done = true
      else:
        print("Data received: " + data)
  print("Exiting application")