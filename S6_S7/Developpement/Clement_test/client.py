# coding: utf-8
import socket

serveur = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

if __name__ == '__main__':
    serveur.connect(("localhost", 5000))
    msg_rec = serveur.recv(1024)
    print("Bienvenue sur le programme de l'ascenseur\n")
    print(msg_rec)
    fin_prog = False
    while not fin_prog:
        choix = raw_input("Appuyer sur (M)onter ou (D)escendre ou (Q)uit pour quitter\n")
        if choix in ("Monter", 'M', 'm'):
            print("Vous avez décidez de faire monter l'ascenseur")
        elif choix in ("Descendre", 'D', 'd'):
            print("Vous avez décidez de faire descendre l'ascenseur")
        elif choix in ("Quit", 'Q', 'q'):
            print("Au revoir")
        else:
            print("Commande invalide")
            continue
        fin_prog = True
    serveur.close()
