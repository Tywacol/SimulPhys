extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ip_reception
var port_reception
var ip_destination
var port_destination
var socket
var queue = []

func send(msg):
	socket.put_packet(msg.to_ascii())
	
func recv():
	if(socket.get_available_packet_count() > 0):
			return socket.get_packet().get_string_from_ascii()
	return null