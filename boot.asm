ORG 0 
BITS 16 

_start:
    jmp short start
    nop

times 33 db 0 ; Visit: https://wiki.osdev.org/FAT : Offset 11 to 32 inclusive: size is 33

start:
    jmp 0x7c0:step2

step2:
    cli
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov sp, 0x7c00
    sti

    mov si, message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    mov ah, 0eh
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    int 0x10 
    ret

message: db 'Hello World!', 0

times 510-($ - $$) db 0 
dw 0xAA55

