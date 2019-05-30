#!/usr/bin/env python3

###### TESTS #######

import time, os

# test de lancement du server
try :
    os.system('./server_launch_test.sh')
except :
    print("test de lancement du client : FAIL")
else :
    print("test de lancement du client : OK")
time.sleep(0.1) # nécéssaire pour le lancement du client

# test de connection et d'envoi d'un message au server
expected = "Someone connected\n"
os.system('./server_conn_test.sh')
nc_res = open('nc_res.txt')
result = nc_res.readlines()
conn_msg = result[0]
msg_sent = result[1]
nc_res.close()
if expected == conn_msg :
    print("test de connection au server : OK")
else:
    print("test de connection au server : FAIL")

expected = "toto\n"
if expected == msg_sent :
    print("envoi d'un message au server : OK")
else:
    print("envoi d'un message : FAIL")

# test de lancement de 3 clients
try :
    os.system('./3_client_launch.sh')
except :
    print("test de 3 connections simultanées au server : FAIL")
else :
    print("test de 3 connections simultanées au server : OK")

# test de déconnexion d'un client :



    
# test à un server incorrect
expected = "Unable to connect to server with parameters (localhost,666). Server possibly off or arguments are invalids.\n"
os.system('./client.py localhost 666 user | cat > serverOFF.txt')
serverOFF = open('serverOFF.txt')
result = serverOFF.read()
serverOFF.close()
if result == expected :
    print("Exception si mauvais paramètre serveur : OK")
else :
    print("Exception si mauvais paramètre serveur : FAIL")
