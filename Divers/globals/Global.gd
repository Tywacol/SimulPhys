extends Node

var nomFichier = ""
var current_scene = null
var liste_capteurs = []
var liste_actionneurs = []
var actionneur_dict = {}
var capteur_dict = {}

#test corto
var test_capt_dict = { 
  "capt1": 1,
  "capt2": 1,
  "capt3": 1,
  "capt4": 1,
  "capt5": 1,
  "capt6": 0,
  "capt7": 0,
  "capt8": 1,
}

var test_act_dict = { 
  "act1": 1,
  "act2": 1,
  "act3": 0,
  "act4": 0,
  "act5": 1,
  "act6": 0,
  "act7": 1,
  "act8": 0
}


#Le server modbus
var modbus = Modbusconnect.new()

var Default_object = preload("res://Hierarchie_objets/GlobalObject.gd")
var objet_parent : GlobalObject



func dic_to_int(dic):
    var val = 0
    var ind = 0
    var etat
    for etat in dic.values():
        if (etat) :
            val += 1<<ind
        ind+=1
    return val

func update_actionneurs(dic):
    var ind = 0
    var lec_act = modbus.read_actionneur()
    var etat
    for actio in dic.keys():
        if (lec_act & 1<<ind) :
            dic[actio]=1
        ind+=1
    return #void
	
func int_to_bin_str(n):
    var l = []
    while n:
        l.append(n & 1)
        n >>= 1
    var resu = ""
    for i in range(len(l)-1,-1, -1) :
        resu += str(l[i])
    return resu
    


#func dispay_bin_to_int(i) :
#    return int(str(i),2)

	#corto
func comm_PLC() :
	# Utile la premiere fois, a bouger
	modbus.write_actionneur(dic_to_int(test_act_dict)) 
	
	
	# Update l'automate sur l'etat des capteurs
	modbus.write_capteur(dic_to_int(test_capt_dict))
	# Update les actionneurs de la simulation en retour
	update_actionneurs(test_act_dict)
	
	
func comm_PLC_verbose() :
	print("__ Traitement capteurs __")
	print()
	var word_capt = dic_to_int(test_capt_dict)
	print("word_capt : "+str(word_capt))
	print("word_capt binaire: "+int_to_bin_str(word_capt))
	print("Ecriture de word_capt dans le registre.")
	modbus.write_capteur(word_capt)
	print("Lecture de word_capt dans le registre.")
	var lec_capt = modbus.read_capteur()
	print("Registre capteurs : "+str(lec_capt))
	print("Registre capteurs bin : "+int_to_bin_str(lec_capt))
	print()
	print("__ Traitement actionneurs __")
	print()
	var word_act = dic_to_int(test_act_dict)
	print("word_act : "+str(word_act))
	print("word_act binaire: "+int_to_bin_str(word_act))
	print("Ecriture de word_act dans le registre.")
	modbus.write_actionneur(word_act)
	print("Lecture de word_act dans le registre.")
	var lec_act = modbus.read_actionneur()
	print("Registre actionneurs : "+str(lec_act))
	print("Registre actionneurs bin : "+int_to_bin_str(lec_act))
	

func _ready():
	
	#Permet de se connecter au serveur Modbus
	print("Init modbus")
	modbus.init_modbus()
	
	comm_PLC_verbose()
	
	

	
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	objet_parent = Default_object.new()

func goto_scene(path):
    # This function will usually be called from a signal callback,
    # or some other function in the current scene.
    # Deleting the current scene at this point is
    # a bad idea, because it may still be executing code.
    # This will result in a crash or unexpected behavior.

    # The solution is to defer the load to a later time, when
    # we can be sure that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):

    # It is now safe to remove the current scene
    current_scene.free()

    # Load the new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    current_scene = s.instance()

    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(current_scene)
    

    # Optionally, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(current_scene)
