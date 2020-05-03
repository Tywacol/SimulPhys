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

class Timing (Chart):
    def __init__ (self):
        Chart.__init__ (self)
        
    def define (self):
        self.channel (world.plcSimModbus.blinkingTimer, red, 0, 12, 50)
        #self.channel (world.plcSimModbus.plcSimModbus, lime, 0, 1, 50)
        #self.channel (world.plcSimModbus.pulse, blue, 0, 1, 50)
        #self.channel (world.plcSimModbus.counter, yellow, 0, 20, 100)


        # Suivi evolution des capteurs
        self.channel (world.plcSimModbus.capt_register, white, 0, 100, 75)
        self.channel (world.plcSimModbus.capteur_0, lime, 0, 1, 50)
        self.channel (world.plcSimModbus.capteur_1, lime, 0, 1, 50)
        self.channel (world.plcSimModbus.capteur_2, lime, 0, 1, 50)
        self.channel (world.plcSimModbus.capteur_3, lime, 0, 1, 50)
        self.channel (world.plcSimModbus.capteur_4, lime, 0, 1, 50)
        self.channel (world.plcSimModbus.capteur_5, lime, 0, 1, 50)
        self.channel (world.plcSimModbus.capteur_6, lime, 0, 1, 50)
        self.channel (world.plcSimModbus.capteur_7, lime, 0, 1, 50)


        # Suivi evolution des actionneuurs
        self.channel (world.plcSimModbus.act_register, white, 0, 100, 75)
        self.channel (world.plcSimModbus.actionneur_0, red, 0, 1, 50)
        self.channel (world.plcSimModbus.actionneur_1, red, 0, 1, 50)
        self.channel (world.plcSimModbus.actionneur_2, red, 0, 1, 50)
        self.channel (world.plcSimModbus.actionneur_3, red, 0, 1, 50)
        self.channel (world.plcSimModbus.actionneur_4, red, 0, 1, 50)
        self.channel (world.plcSimModbus.actionneur_5, red, 0, 1, 50)
        self.channel (world.plcSimModbus.actionneur_6, red, 0, 1, 50)
        self.channel (world.plcSimModbus.actionneur_7, red, 0, 1, 50)





        