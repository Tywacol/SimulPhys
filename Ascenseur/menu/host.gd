extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pb = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func UDPserver(ip_destination="127.0.0.1", port_destination=8910,ip_reception="127.0.0.1", port_reception=4242) :
	global.socket = PacketPeerUDP.new()
	if(global.socket.listen(port_reception,ip_reception) != OK):
		print("An error occurred listening on port 4242")
	else:
		print("Listening on port 4242 on localhost")
		
	if(global.socket.set_dest_address(ip_destination,port_destination) != OK):
		print("An error setting destination_adresse")
	else:
		print("dest_adress on port 4242 on localhost")


func _on_HostButton_pressed():
	global.ip_reception = get_node("ip_reception").get_text()
	global.ip_destination = get_node("ip_destination").get_text()
	global.port_reception = int(get_node("port_reception").get_text())
	global.port_destination = int(get_node("port_destination").get_text())
	if (not global.ip_destination.is_valid_ip_address()):
		get_node("ip_destination/status_fail_destination").set_text("IP address is invalid")
		pb = true
	if (not global.ip_reception.is_valid_ip_address()):
		get_node("ip_reception/status_fail_reception").set_text("IP address is invalid")
		pb = true
	if(pb) :
		return
		
	UDPserver(global.ip_destination,global.port_destination,global.ip_reception,global.port_reception)
	
	get_tree().change_scene("res://Ground.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://menu/menu.tscn")
