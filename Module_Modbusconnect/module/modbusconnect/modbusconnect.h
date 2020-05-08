/* modbusconnect.h */

#ifndef MODBUSCONNECT_H
#define MODBUSCONNECT_H

#include "core/reference.h"
#include <cstdint> 
#include <unistd.h>
#include <string>
#include "modbus.h"



class Modbusconnect : public Reference {
    GDCLASS(Modbusconnect, Reference);

    modbus mb;

protected:
    static void _bind_methods();

public:
    void init_modbus();
    void write_capteur(int p_etat);
    void write_actionneur(int p_etat);
    int read_capteur();
    int read_actionneur();

    Modbusconnect();
};

#endif // MODBUSCONNECT_H
