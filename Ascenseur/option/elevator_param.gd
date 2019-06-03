extends Node

var elevator_speed = 7
var door_speed = 0.6



func get_elevator_speed():
	return elevator_speed
	
func set_elevator_speed(value):
	elevator_speed = value
	pass
	
func get_door_speed():
	return door_speed
	
func set_door_speed(value):
	door_speed = float(value) / 10
	pass
	

	