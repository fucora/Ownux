#ifndef INCLUDE_IDT_H_
#define INCLUDE_IDT_H_

#include "types.h"

void init_idt();


typedef
struct idt_entry_t {
	uint16_t base_lo;
	uint16_t sel;
	uint8_t  always0;
	uint8_t  flags; 
	uint16_t base_hi;
}__attribute__((packed)) idt_entry_t;


typedef
struct idt_ptr_t {
	uint16_t limit;
	uint32_t base;
} __attribute__((packed)) idt_ptr_t;


typedef
struct pt_regs_t {
	uint32_t ds;
	uint32_t edi;
	uint32_t esi; 
	uint32_t ebp;
	uint32_t esp;
	uint32_t ebx;
	uint32_t edx;
	uint32_t ecx;
	uint32_t eax;
	uint32_t int_no;
	uint32_t err_code;
	uint32_t eip;
	uint32_t cs;
	uint32_t eflags;
	uint32_t useresp;
	uint32_t ss;
} pt_regs;

void isr0();
void isr1();
void isr2();
void isr3();
void isr4(); 
void isr5(); 
void isr6(); 
void isr7(); 
void isr8(); 
void isr9(); 
void isr10(); 
void isr11();
void isr12();
void isr13();
void isr14(); 
void isr15();
void isr16();
void isr17();
void isr18();
void isr19(); 
typedef void (*interrupt_handler_t)(pt_regs *);


void register_interrupt_handler(uint8_t n, interrupt_handler_t h);


void isr_handler(pt_regs *regs);


#endif 	// INCLUDE_IDT_H_
