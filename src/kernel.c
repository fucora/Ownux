#include "basic.h"
#include "debug.h"
#include "idt.h"
#include "gdt.h"
int cmain(){
    init_debug();
    init_gdt();
    init_idt();
    return 0;
}
