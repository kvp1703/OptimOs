ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop

times 33 db 0 ; Visit: https://wiki.osdev.org/FAT : Offset 11 to 32 inclusive: size is 33

start:
    jmp 0:step2

step2:
    cli
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ;enable interrupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

; GDT

gdt_start:
get_null:
    dd 0x0
    dd 0x0

; offset 8:
gdt_code:      ; CS should point to this.
    dw 0xffff  ; segment limit first 15 bits.
    dw 0       ; base first 15 bits
    db 0       ; base first 116-23 bits
    db 0x9a    ; Access byte
    db 11001111b ; High 4 bit flag and low 4 bit flag
    db 0       ; base 24-31 bits

; offset 10:
gdt_data:      ; DS, SS, ES, FS, GS 
    dw 0xffff  ; segment limit first 15 bits.
    dw 0       ; base first 15 bits
    db 0       ; base first 116-23 bits
    db 0x92    ; Access byte
    db 11001111b ; High 4 bit flag and low 4 bit flag
    db 0       ; base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size of the descriptor
    dd gdt_start

[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    jmp $

times 510-($ - $$) db 0 
dw 0xAA55
