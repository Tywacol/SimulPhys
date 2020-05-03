#!/usr/bin/env python3

from pyModbusTCP.client import ModbusClient

# TCP auto connect on first modbus request
c = ModbusClient(host="127.0.0.1", port=502, auto_open=True)

if c.write_multiple_registers(0, [44,55]):
    print("write ok")
else:
    print("write error")