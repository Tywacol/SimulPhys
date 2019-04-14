# coding: utf-8


if __name__ == '__main__':
    print("Bienvenue sur le programme de l'ascenseur\n")
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
