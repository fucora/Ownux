C_SOURCES = $(shell find . -name "*.c")
C_OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))
S_SOURCES = $(shell find . -name "*.s")
S_OBJECTS = $(patsubst %.s, %.o, $(S_SOURCES))

CC = gcc
LD = ld
ASM = nasm

C_FLAGS = -c -Wall -m32 -ggdb -gstabs+ -nostdinc -fno-builtin -fno-stack-protector -I include
LD_FLAGS = -T scripts/kernel.ld -m elf_i386 -nostdlib
ASM_FLAGS = -f elf -g -F stabs

all: $(S_OBJECTS) $(C_OBJECTS) link update_image

.c.o:
	$(CC) $(C_FLAGS) $< -o $@
.s.o:
	$(ASM) $(ASM_FLAGS) $<
link:
	$(LD) $(LD_FLAGS) $(S_OBJECTS) $(C_OBJECTS) -o kernel
.PHONY:clean
clean:
	$(RM) $(S_OBJECTS) $(C_OBJECTS) kernel

.PHONY:update_image
update_image:
	sudo mount Ownux.img ./mnt/
	sudo cp kernel ./mnt/kernel
	sleep 1
	sudo umount ./mnt/
.PHONY:mount_image
mount_image:
	sudo mount Ownux.img ./mnt/

.PHONY:umount_image
umount_image:
	sudo umount ./mnt/

.PHONY:qemu
qemu:
	qemu -fda Ownux.img -boot a	
debug:
	qemu -S -s -fda Ownux.img -boot a &
	sleep 1
	cgdb -x scripts/gdbinit

