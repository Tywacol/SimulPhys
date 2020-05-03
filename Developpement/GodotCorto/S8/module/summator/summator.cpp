/* summator.cpp */

#include "summator.h"
#include "modbus.h"

using namespace std;

void Summator::add(int p_value) {
    count += p_value;
}

void Summator::reset() {
    count = 0;
}

void Summator::write_file() {
	// Create and open a text file
  ofstream MyFile("filename.txt");

  // Write to the file
  MyFile << "Files can be tricky, but it is fun enough!";

  // Close the file
  MyFile.close();
}

int Summator::get_total() const {
    return count;
}

void Summator::init_modbus() {
    // set slave id
	uint16_t port = 502;
    mb = modbus("127.0.0.1", port);

    mb.modbus_set_slave_id(1);

    // connect with the server
    mb.modbus_connect();

}

// Idee : si uint16 pas compatible avec godot,
// faire un masque 0xFFFF sur l'argument et le retour
void Summator::write_etat(int p_etat) {
	uint16_t p_etat_conv = p_etat & 0xFFFF;
	mb.modbus_write_register(0, p_etat_conv);
}

int Summator::read_actionneurs() {
	//uint16_t read_holding_regs[1];
	uint16_t read_holding_regs[1];
	// read coil                        function 0x01
    mb.modbus_read_holding_registers(0, 1, read_holding_regs);
    std::cout<<"Lecture register : "<<read_holding_regs[0]<<"\n";
    return read_holding_regs[0];
}



void Summator::_bind_methods() {
    ClassDB::bind_method(D_METHOD("add", "value"), &Summator::add);
    ClassDB::bind_method(D_METHOD("reset"), &Summator::reset);
    ClassDB::bind_method(D_METHOD("get_total"), &Summator::get_total);
    ClassDB::bind_method(D_METHOD("write_file"), &Summator::write_file);
    ClassDB::bind_method(D_METHOD("init_modbus"), &Summator::init_modbus);
    ClassDB::bind_method(D_METHOD("write_etat", "etat"), &Summator::write_etat);
    ClassDB::bind_method(D_METHOD("read_actionneurs"), &Summator::read_actionneurs);
}

Summator::Summator() : mb(modbus("127.0.0.1", 502)) {
    count = 0;
    //uint16_t port = 502;
    //mb = modbus("127.0.0.1", port);
    // set slave id
    //mb.modbus_set_slave_id(1);
    // connect with the server
    //mb.modbus_connect();
}
