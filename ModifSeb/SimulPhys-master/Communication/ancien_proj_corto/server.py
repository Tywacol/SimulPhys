#!/usr/bin/env python3

import select, socket, sys, os, tools, webpage, signal

def handler(signal, ignore) :
    for client in IRCs :
        client.send(b'')
        client.close()
    server.close()
    websock.close()
    sys.exit(0)

def receive(source) :
    res = b''
    c = source.recv(1)
    if c == b'' : return c
    while c != b'\n' :
        res = res + c
        c = source.recv(1)
    return res + c

def readQuery(source) :
    line = receive(source)
    if line != b'GET / HTTP/1.1\r\n' :#on vérifie qu'il s'agit bien d'une requête GET
        return "bad request" #renvoyer des strings permet le traitement explicite d'autres erreurs
    while line != b'\r\n' :#lecture du reste de la requête
        line = receive(source)
    return "ok"

signal.signal(signal.SIGINT, handler)

host = ''

try :
    irc_port = int(sys.argv[1])
    web_port = int(sys.argv[2])
except IndexError :
    print("Invalid argument. Usage : ./server2.py irc_port web_port")
    sys.exit(1)

backlog = 5
size = 1024
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1) #permet de réutiliser l'addresse immédiatement après la fermeture
websock = socket.socket(socket.AF_INET, socket.SOCK_STREAM,0)
msg_log = tools.FIFO(10)

try :
    server.bind((host,irc_port))
except (PermissionError,OSError) :#erreur renvoyee si le irc_port est deja pris
        print("Error : failed to open irc port (port {} already in use)".format(irc_port))
        server.close()#fermeture des sockets
        websock.close()
        sys.exit(1)#sortie avec code d'erreur

try :
    websock.bind((host,web_port))
    websock.listen(5)
except PermissionError :
    print("Error : failed to open web port (port {} already in use)".format(web_port))
    server.close()
    websock.close()
    sys.exit(1)

server.listen(backlog)
server_input=[server,sys.stdin,websock]
running = True
IRCs = []
WEBs = []

while running :
    inputready, outputready, exceptready = select.select(server_input,[],[])
    for s in inputready :
        if s == server :#socket connexion
            client, address = server.accept()
            print(address)
            IRCs.append(client)
            server_input.append(client)
            for client in IRCs :
                client.send(b'Someone connected\n')
        elif s == websock :
            webclient, (addr,port) = websock.accept()
            WEBs.append(webclient)
            server_input.append(webclient)
   
        else :#socket dialogue
            if s in IRCs :
                data = receive(s)
                os.write(1,data)
                if len(data)>0 :
                    msg_log.addMsg(data)
                    for client in IRCs :
                        client.send(data)
                else :#si on recoit une chaine vide : le client s'est deconnecte
                    print("someone disconnected")
                    s.close()#fermeture du socket client
                    IRCs.remove(s)
                    server_input.remove(s)

            if s in WEBs :
                test = readQuery(webclient)
                if test == "ok" :
                    page = webpage.build(msg_log.getMsgs(),webpage.HEAD,webpage.TAIL)
                    s.send('HTTP/1.0 200 OK\n'.encode())
                    s.send('Connection: close\n'.encode())
                    s.send(('Content-length : {}'.format(len(page))).encode())
                elif test == "bad request" :
                    page = webpage.ERR400
                    s.send('HTTP/1.0 400 Bad Request\n'.encode())
                    s.send('Connection: close\n'.encode())
                    s.send(('Content-length : {}'.format(len(page))).encode())
                s.send('Content-type: text/html\r\n\r\n'.encode())
                s.send(page.encode())
                s.close()
                WEBs.remove(s)
                server_input.remove(s)

server.close()
websock.close()
sys.exit(0)
