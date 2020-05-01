extends SceneTree

func _init():
  #var socket = PacketPeerUDP.new()
  
  #socket.set_dest_address("127.0.0.1",4242)
  #socket.put_packet("Texte depuis client".to_ascii())
  print("Entering application...")   
  var s = Summator.new()
  s.init_modbus()
  var act
  while (true) :
    act = s.read_actionneurs()
    print("Lecture godot : " + str(act & (1 << 1)))
    OS.delay_msec(500)
    act +=1
    s.write_etat(act)
    
  print("Exiting application...")    
  self.quit()