/* summator.h */

#ifndef SUMMATOR_H
#define SUMMATOR_H

#include "core/reference.h"
#include <iostream>
#include <fstream>
#include <cstdint> 
#include <unistd.h>
#include <string>
#include "modbus.h"



class Summator : public Reference {
    GDCLASS(Summator, Reference);

    int count;
    modbus mb;

protected:
    static void _bind_methods();

public:
    void add(int p_value);
    void reset();
    int get_total() const;
    void write_file();
    void init_modbus();
    void write_etat(int p_etat);
    int read_actionneurs();

    Summator();
};

#endif // SUMMATOR_H
