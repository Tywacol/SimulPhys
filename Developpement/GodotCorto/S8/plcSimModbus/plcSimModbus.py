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

        self.act_register = Register()
        self.capt_register = Register()

        self.capteur_0 = Marker ()
        self.capteur_1 = Marker ()
        self.capteur_2 = Marker ()
        self.capteur_3 = Marker ()
        self.capteur_4 = Marker ()
        self.capteur_5 = Marker ()
        self.capteur_6 = Marker ()
        self.capteur_7 = Marker ()

        self.actionneur_0 = Marker ()
        self.actionneur_1 = Marker ()
        self.actionneur_2 = Marker ()
        self.actionneur_3 = Marker ()
        self.actionneur_4 = Marker ()
        self.actionneur_5 = Marker ()
        self.actionneur_6 = Marker ()
        self.actionneur_7 = Marker ()
        

    def input (self):   
        pass
    
    def sweep (self):

        self.blinkingTimer.reset (self.blinkingTimer > 8)
        #self.blinkingLight.mark (not self.blinkingLight, not self.blinkingTimer)
        self.pulse.trigger (self.blinkingTimer > 3)
        self.counter.set (self.counter + 1, self.pulse)


        #Test that the connection still open each frame. Pause it not
        if not self.c.is_open():
            if not self.c.open():
                print("unable to connect to "+self.SERVER_HOST+":"+str(self.SERVER_PORT))
                #self.run = Runner(False)

        # Recuperation de la valeur des registre depuis godot par modbus
        self.capt_register.set(self.c.read_holding_registers(0)[0])
        self.act_register.set(self.c.read_holding_registers(1)[0])

        #Logique capteurs

        self.capteur_0.mark(True, self.capt_register & 1 << 0, False)
        self.capteur_1.mark(True, self.capt_register & 1 << 1, False)
        self.capteur_2.mark(True, self.capt_register & 1 << 2, False)
        self.capteur_3.mark(True, self.capt_register & 1 << 3, False)
        self.capteur_4.mark(True, self.capt_register & 1 << 4, False)
        self.capteur_5.mark(True, self.capt_register & 1 << 5, False)
        self.capteur_6.mark(True, self.capt_register & 1 << 6, False)
        self.capteur_7.mark(True, self.capt_register & 1 << 7, False)

        #Logique actionneurs

        #normal
        #self.actionneur_0.mark(True, self.act_register & 1 << 0, False)
        #self.actionneur_1.mark(True, self.act_register & 1 << 1, False)

        self.actionneur_0.mark(True, self.act_register & 1 << 0, False)
        self.actionneur_1.mark(True, self.act_register & 1 << 1, False)

        self.actionneur_2.mark(True, self.capteur_2, False)

        #self.act_register.set(evaluate((self.actionneur_2 << 2) & (self.actionneur_1 << 1), self.actionneur_2)#, self.act_register -)
        self.act_register.set(6, self.actionneur_2, 0)

        self.actionneur_3.mark(True, self.act_register & 1 << 3, False)
        self.actionneur_4.mark(True, self.act_register & 1 << 4, False)
        self.actionneur_5.mark(True, self.act_register & 1 << 5, False)
        self.actionneur_6.mark(True, self.act_register & 1 << 6, False)
        self.actionneur_7.mark(True, self.act_register & 1 << 7, False)

        self.c.write_single_register(1, evaluate(self.act_register))



        
        




        
        