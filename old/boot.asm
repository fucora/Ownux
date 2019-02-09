;这里只是一个加载器，并不是真正的内核！
;负责加载分区中的东西
mov AX,0x0820
mov ES,AX
mov CH,0                   ;柱面
mov DH,0                   ;磁头
mov CL,2                   ;扇区(注意扇区1是引导区，即MBR!)
mov AH,0x02                ;对硬盘的操作 (0x02是读取）
mov AL,1                   ;读取长度，单位:扇区
mov BX,0                   ;设置成0就对了
mov 

;MBOOT_MAGIC  equ 0x1BADB002  ; multiboot magic域，必须为此值
;MBOOT_FLAGS  equ 0x00        ; multiboot flag域, GRUB启动时是否要做一些特殊操作
;MBOOT_CHECKSUM  equ -(MBOOT_MAGIC + MBOOT_FLAGS) ; multiboot checksum域，校验上面两个域是否正确
;
;[BITS 32]                    ; 以32位编译
;
;section .text
;  dd  MBOOT_MAGIC
;  dd  MBOOT_FLAGS
;  dd  MBOOT_CHECKSUM
;  dd  start
;
;[GLOBAL start]
;[GLOBAL glb_mboot_ptr]       ; 全局的 struct multiboot * 变量
;[EXTERN cmain]         ; 内核入口函数, EXTERN表明此符号在外部定义
;
;start:
;    cli              ; 此时还没有设置好保护模式的中断处理，要关闭中断
;    mov esp, STACK_TOP       ; 设置内核栈地址
;    mov ebp, 0       ; 帧指针修改为 0
;    and esp, 0FFFFFFF0H  ; 栈地址按照16字节对齐
;    mov [glb_mboot_ptr], ebx ; 将 ebx 中存储的指针存入全局变量
;    call cmain      ; 调用内核入口函数
;stop:
;    hlt              ; 停机指令，什么也不做，可以降低 CPU 功耗
;    jmp stop         ; 到这里结束，关机什么的后面再说
;
;
;;-----------------------------------------------------------------------------
;
;section .bss             ; 未初始化的数据段从这里开始
;stack:
;    resb 32768       ; 这里作为内核栈
;glb_mboot_ptr:           ; 全局的 multiboot 结构体指针
;    resb 4
;
;
;STACK_TOP equ $-stack-1      ; 内核栈顶，$ 符指代是当前地址
