#!/usr/bin/env python3
import sys, os, socket, tools, signal

def handler(signal, ignore) :
    client_socket.send(b'')
    client_socket.close()
    sys.exit(0)

signal.signal(signal.SIGINT, handler)

def readStr() :
    res = b''
    c = os.read(0,1)
    while c != b'\n' :
        if c == b'' :
            return c
        res = res + c
        c = os.read(0,1)
    return username+res+c

def getStr() :
    res = b''
    c = client_socket.recv(1)
    while c != b'\n' :
        if c == b'' :
            return c
        res = res + c
        c = client_socket.recv(1)
    return res+c

#le programme doit être lancé avec l'hôte, le port et un nom d'utilisateur en argument
try :
    host,port,username = sys.argv[1],int(sys.argv[2]),bytes(sys.argv[3]+' : ',encoding='utf-8')
except IndexError :
    print("Invalid argument. Usage : ./client2.py host port username")
    sys.exit(1)

client_socket = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
client_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1) #Permet de réutiliser l'addresse immédiatement après la fermeture socket. 
try :
    client_socket.connect((host,port))
except : #impossible de rejoindre le serveur
    print("Unable to connect to server with parameters (",host,",",port,"). Server possibly off or arguments are invalids.",sep='')
    sys.exit(0)

#print('Connected to remote host. Start sending messages')
running = True
pid = os.fork()


while running :
    if (pid != 0) :#envoyer le message
        data = readStr()
        try :
            client_socket.send(data)
        except BrokenPipeError : #si le serveur n'est plus connecté
            print("Mesage hasn't been sent : Unable to reach the server. Disconnecting..")
            client_socket.close()
            sys.exit(0)
        if data == b'' :
            print("shutting down")
            client_socket.close()
            sys.exit(0)
    else :
        data = getStr()
        #l'ajout du if est un test
        if data == b'' :
            print("Server have closed. Disconnecting.. ")
            client_socket.close()
            sys.exit(0) # le père reste cependant ouvert
            running = False 
        else :
            os.write(1, data)

client_socket.close()
sys.exit(0)
