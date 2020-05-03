/* modbusconnect.cpp */

#include "modbusconnect.h"
#include "modbus.h"

using namespace std;


void Modbusconnect::init_modbus() {
	uint16_t port = 502;
    mb = modbus("127.0.0.1", port);
    // set slave id
    mb.modbus_set_slave_id(1);
    // connect with the server
    mb.modbus_connect();
}

int Modbusconnect::read_capteur() {
	uint16_t read_holding_regs[1];
	// read coil                        function 0x01
    mb.modbus_read_holding_registers(0, 1, read_holding_regs);
    return read_holding_regs[0];
}


// Idee : si uint16 pas compatible avec godot,
// faire un masque 0xFFFF sur l'argument et le retour
void Modbusconnect::write_capteur(int p_etat) {
	uint16_t p_etat_conv = p_etat & 0xFFFF;
	mb.modbus_write_register(0, p_etat_conv);
}


int Modbusconnect::read_actionneur() {
    uint16_t read_holding_regs[1];
    // read coil                        function 0x01
    mb.modbus_read_holding_registers(1, 1, read_holding_regs);
    return read_holding_regs[0];
}


void Modbusconnect::write_actionneur(int p_etat) {
    uint16_t p_etat_conv = p_etat & 0xFFFF;
    mb.modbus_write_register(1, p_etat_conv);
}





void Modbusconnect::_bind_methods() {
    ClassDB::bind_method(D_METHOD("init_modbus"), &Modbusconnect::init_modbus);
    ClassDB::bind_method(D_METHOD("read_capteur"), &Modbusconnect::read_capteur);
    ClassDB::bind_method(D_METHOD("write_capteur", "etat"), &Modbusconnect::write_capteur);
    ClassDB::bind_method(D_METHOD("read_actionneur"), &Modbusconnect::read_actionneur);
    ClassDB::bind_method(D_METHOD("write_actionneur", "etat"), &Modbusconnect::write_actionneur);
}

Modbusconnect::Modbusconnect() : mb(modbus("127.0.0.1", 502)) { 

}
