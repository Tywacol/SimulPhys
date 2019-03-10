import socket
import time

HOST = '127.0.0.1'    # The remote host
PORT = 5011              # The same port as used by the server

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

while True:
    cmd = raw_input('(L)ecture, (E)criture ou (Q)uitter:')
    if len(cmd) == 0 : continue
    if cmd[0] in ('L','l'):
        s.sendall('val')
        data = s.recv(1024)
        print '  valeur=',data.strip()
    elif cmd[0] in ('E','e'):
        val = raw_input(' val=')
        if True:
            i=int(val)
            print "  Envoi de : val=%d" % i
            s.sendall('val=%d' % i)
            data = s.recv(1024)
            print "  Reponse :",data.strip()
        else:
            print "  Erreur"
    elif cmd[0] in ('Q','q'):
        print "Au revoir"
        break
    else:
        print "  Pas compris, recommencez"
        
s.close()

