CC = gcc
ASM = nasm
LD = ld
MOUNT_POINT = ./mnt

C_SOURCES = $(shell find . -name "*.c")
C_OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))
CC_FLAGS = -c -Wall -m32 -ggdb -gstabs+ -nostdinc -fno-builtin -fno-stack-protector -I include
LD_FLAGS = -T link.ld -m elf_i386 -nostdlib

all: boot.o $(C_OBJECTS) link update_kernel

.c.o:
	$(CC) $(CC_FLAGS) $< -o $@

boot.o: boot.asm
	$(ASM) -f elf boot.asm

.PHONY: kernel
link:
	$(LD) $(LD_FLAGS) boot.o  $(C_OBJECTS) -o kernel

.PHONY: update_kernel
update_kernel:
	@if [ ! -d $(MOUNT_POINT) ]; then mkdir $(MOUNT_POINT); fi
	sudo mount ownux.img ./mnt
	sudo cp kernel ./mnt/kernel
	sleep 1
	sudo umount ./mnt/

.PHONY:qemu
qemu:
	qemu -fda ownux.img -boot a

.PHONY: clean
clean:
	rm *.o kernel
	rm lib/*.o
