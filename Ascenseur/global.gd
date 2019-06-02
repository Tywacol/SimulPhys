extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ip_reception
var port_reception
var ip_destination
var port_destination
var socket
var speed = 5

func send(msg):
	socket.put_packet(msg.to_ascii())