# ====== Legal notices
#
# Copyright (C) 2013 - 2018 GEATEC engineering
#
# This program is free software.
# You can use, redistribute and/or modify it, but only under the terms stated in the QQuickLicence.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the QQuickLicence for details.
#
# The QQuickLicense can be accessed at: http://www.qquick.org/license.html
#
# __________________________________________________________________________
#
#
#  THIS PROGRAM IS FUNDAMENTALLY UNSUITABLE FOR CONTROLLING REAL SYSTEMS !!
#
# __________________________________________________________________________
#
# It is meant for training purposes only.
#
# Removing this header ends your licence.
#

from SimPyLC import *
from pyModbusTCP.client import ModbusClient

class plcSimModbus (Module):
    SERVER_HOST = "localhost"
    SERVER_PORT = 502
    c = ModbusClient()

    def __init__ (self):
        Module.__init__ (self)
        self.blinkingTimer = Timer ()
        #self.blinkingLight = Marker ()
        self.pulse = Oneshot ()
        self.counter = Register ()
        self.run = Runner ()


        self.c.host(self.SERVER_HOST)
        self.c.port(self.SERVER_PORT)

        if not self.c.is_open():
            if not self.c.open():
                print("unable to connect to "+self.SERVER_HOST+":"+str(self.SERVER_PORT))

        #Test that the connection still open each frame. Pause it not
        # if not self.c.is_open():
        #     if not self.c.open():
        #         print("unable to connect to "+self.SERVER_HOST+":"+str(self.SERVER_PORT))
                #self.run = Runner(False)

        self.capt_register = Register()
        self.act_register = Register()

        self.capt_fermeture_portes = Marker ()
        self.capt_etage_0_bas = Marker ()
        self.capt_etage_0_haut = Marker ()
        self.capt_etage_1_bas = Marker ()
        self.capt_etage_1_haut = Marker ()
        self.capt_appel_0 = Marker ()
        self.capt_appel_1 = Marker ()

        self.act_portes = Marker ()
        self.act_mouvement = Marker ()
        self.act_direction_mouvement = Marker ()


        self.appel_etage_0 = Latch ()
        self.appel_etage_1 = Latch ()

        self.porte_charge = Latch ()
        self.porte_charge_bas = Latch()
        self.latch_intermediaire = Latch ()


    def input (self):   
        pass
    
    def sweep (self):
        self.blinkingTimer.reset (self.blinkingTimer > 8)
        #self.blinkingLight.mark (not self.blinkingLight, not self.blinkingTimer)
        self.pulse.trigger (self.blinkingTimer > 3)
        self.counter.set (self.counter + 1, self.pulse)   

        # Recuperation de la valeur des registre depuis godot par modbus
        self.capt_register.set(self.c.read_holding_registers(0)[0])
        self.act_register.set(self.c.read_holding_registers(1)[0])

        #Logique capteurs

        self.capt_fermeture_portes.mark(True, self.capt_register & 1 << 0, False)
        self.capt_etage_0_bas.mark(True, self.capt_register & 1 << 1, False)
        self.capt_etage_0_haut.mark(True, self.capt_register & 1 << 2, False)
        self.capt_etage_1_bas.mark(True, self.capt_register & 1 << 3, False)
        self.capt_etage_1_haut.mark(True, self.capt_register & 1 << 4, False)
        self.capt_appel_0.mark(True, self.capt_register & 1 << 5, False)
        self.capt_appel_1.mark(True, self.capt_register & 1 << 6, False)
   

        # Portes

        # __ Appel etage 1 __ 	

        self.appel_etage_1.latch(self.capt_appel_1)

        #Il y a un appel demande, il va falloir ouvrir les portes
        #self.porte_charge.latch(self.appel_etage_1 or self.appel_etage_0)
        self.porte_charge.latch(self.appel_etage_1)
        #on est en haut et on n'as pas encore ouvert les portes, on les ouvres
        #self.act_portes.mark(True, self.capt_etage_1_haut and self.porte_charge and not self.appel_etage_0, False)

        # Test
        self.latch_intermediaire.latch(self.capt_etage_1_haut and self.porte_charge and not self.appel_etage_0)


        # On consomme l'ouverture des portes, mais que si on bien arrive
        self.porte_charge.unlatch(self.porte_charge and self.capt_etage_1_haut)
        self.appel_etage_1.unlatch(self.capt_etage_1_haut)

        ## __ Appel etage 0 __

        self.appel_etage_0.latch(self.capt_appel_0)
        self.porte_charge_bas.latch(self.appel_etage_0)

        #self.act_portes.mark(True, self.capt_etage_0_bas and self.porte_charge_bas and not self.appel_etage_1, False)
        # Test
        self.latch_intermediaire.latch(self.capt_etage_0_bas and self.porte_charge_bas and not self.appel_etage_1)
        self.porte_charge_bas.unlatch(self.porte_charge_bas and self.capt_etage_0_bas)

        self.appel_etage_0.unlatch(self.capt_etage_0_bas)

        self.act_portes.mark(True, self.latch_intermediaire, False)
        self.latch_intermediaire.unlatch(self.latch_intermediaire)


        # Direction 1=haut 0=bas
        self.act_direction_mouvement.mark(True, self.appel_etage_1, False)

        # Movement ascenseur 1=true
        self.act_mouvement.mark(True, (self.appel_etage_1 or self.appel_etage_0), False)


        #self.act_register.set(evaluate((self.act_direction_mouvement << 2) & (self.act_mouvement << 1), self.act_direction_mouvement)#, self.act_register -)
        

        # Enregistrement des actionneurs dans act_register
        self.act_register.set(0, not self.act_portes and not self.act_mouvement and not self.act_direction_mouvement)
        self.act_register.set(1, self.act_portes and not self.act_mouvement and not self.act_direction_mouvement)
        self.act_register.set(2, not self.act_portes and self.act_mouvement and not self.act_direction_mouvement)
        self.act_register.set(3, self.act_portes and self.act_mouvement and not self.act_direction_mouvement)
        self.act_register.set(4, not self.act_portes and not self.act_mouvement and self.act_direction_mouvement)
        self.act_register.set(5, self.act_portes and not self.act_mouvement and self.act_direction_mouvement)
        self.act_register.set(6, not self.act_portes and self.act_mouvement and self.act_direction_mouvement)
        self.act_register.set(7, self.act_portes and self.act_mouvement and self.act_direction_mouvement)

        self.c.write_single_register(1, evaluate(self.act_register))

        #self.act_register.set(0)



        
        




        
        