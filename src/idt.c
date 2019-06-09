#include "common.h"
#include "string.h"
#include "debug.h"
#include "idt.h"

interrupt_handler_t interrupt_handlers[256];
extern void idt_flush(uint32_t);
static void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags);
idt_entry_t idt_entries[256];
idt_ptr_t idt_ptr;
void init_idt(){

    //idt_set_gate(33, (uint32_t)irq1, 0x08, 0x8E);

}

void irq_handler(pt_regs *regs)
{
    if (regs->int_no >= 40) {
        outb(0xA0, 0x20);
    }
    outb(0x20, 0x20);
    if (interrupt_handlers[regs->int_no]) {
        interrupt_handlers[regs->int_no](regs);
    }
}

static void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags)
{
    idt_entries[num].base_lo = base & 0xFFFF;
    idt_entries[num].base_hi = (base >> 16) & 0xFFFF;

    idt_entries[num].sel     = sel;
    idt_entries[num].always0 = 0;

    idt_entries[num].flags = flags;
}
