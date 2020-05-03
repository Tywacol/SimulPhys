/* register_types.cpp */

#include "register_types.h"

#include "core/class_db.h"
#include "modbusconnect.h"

void register_modbusconnect_types() {
    ClassDB::register_class<Modbusconnect>();
}

void unregister_modbusconnect_types() {
   // Nothing to do here in this example.
}
