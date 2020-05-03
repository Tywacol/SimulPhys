#!/usr/bin/env python
# -*- coding: utf-8 -*-

# write_bit
# write 4 bits to True, wait 2s, write False, restart...

from pyModbusTCP.client import ModbusClient
import time

SERVER_HOST = "localhost"
SERVER_PORT = 502

c = ModbusClient()

# uncomment this line to see debug message
#c.debug(True)

# define modbus server host, port
c.host(SERVER_HOST)
c.port(SERVER_PORT)

toggle = True
addr = 0

while True:
    # open or reconnect TCP to server
    if not c.is_open():
        if not c.open():
            print("unable to connect to "+SERVER_HOST+":"+str(SERVER_PORT))

    # if open() is ok, write coils (modbus function 0x01)
    if c.is_open():
        # write 4 bits in modbus address 0 to 3
        print("")
        print("write register")
        print("----------")
        print("")
        if (toggle) :
            is_ok = c.write_single_register(addr, 0xF0)
            if is_ok:
                print("register #" + str(addr) + ": write to " + str(0xF0))
            else:
                print("bit #" + str(addr) + ": unable to write " + str(0xF0))
            time.sleep(0.5)
        else :
            is_ok = c.write_single_register(addr, 0x0F)
            if is_ok:
                print("register #" + str(addr) + ": write to " + str(0x0F))
            else:
                print("bit #" + str(addr) + ": unable to write " + str(0x0F))
            time.sleep(0.5)

        time.sleep(1)

        print("")
        print("read register")
        print("---------")
        print("")
        bits = c.read_holding_registers(0)
        if bits:
            print("register: "+str(bits))
        else:
            print("unable to read")

    toggle = not toggle
    # sleep 2s before next polling
    time.sleep(2)