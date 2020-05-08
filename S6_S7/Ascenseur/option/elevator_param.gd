extends Node

var elevator_speed = 7
var door_speed = 0.6

var movement_lift
var movement_doors



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
	
func get_movement_lift():
	return movement_lift
	
func get_movement_doors():
	return movement_doors
	
func set_movement_lift(b):
	 movement_lift = b
	
func set_movement_doors(b):
	 movement_doors = b
	
func simulation_is_busy():
	print("get movement_lift : "+str(get_movement_lift()))
	print("get movement_doors : "+str(get_movement_doors()))
	print("get_movement_lift() or get_movement_doors() : "+str(get_movement_lift() or get_movement_doors()))
	return get_movement_lift() or get_movement_doors()


	
	

	