;==GRUB MB的设定
MBOOT_HEADER_MAGIC 	equ 	0x1BADB002
MBOOT_PAGE_ALIGN 	equ 	1 << 0 
MBOOT_MEM_INFO 		equ 	1 << 1
MBOOT_HEADER_FLAGS 	equ 	MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM 		equ 	- (MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)
;==代码的开始
[BITS 32]
section .text
;======MB的标记
dd MBOOT_HEADER_MAGIC
dd MBOOT_HEADER_FLAGS
dd MBOOT_CHECKSUM
;======GLOBAL
[GLOBAL start]
[GLOBAL glb_mboot_ptr]
;======这鬼函数让链接器自己找去!
[EXTERN cmain]
;======start函数
start:
    cli
    mov esp,STACK_TOP
    mov ebp,0
    and esp,0FFFFFFF0H
    mov [glb_mboot_ptr],ebx
    call cmain
stop:
    ;CPU休眠
    hlt
    jmp stop
section .bss
stack:
	resb 32768
glb_mboot_ptr: 	
	resb 4

STACK_TOP equ $-stack-1
