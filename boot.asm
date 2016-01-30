section .text
   use16
   org 0x7C00

start:
   mov ax, cs
   mov ds, ax
   mov si, hw
   cld
   mov ah, 0x0e
   mov bh, 0

t_looper_func:
   lodsb
   cmp al, 0
   jz ent
   int 10h
   jmp t_looper_func
   
ent:
   mov edi, keyDown
   mov di, 0
   cld

down_key_press:
   mov ah, 0h
   int 16h
   cmp ah, 0x0e
   jz backspace
   cmp ah, 0x1c
   jz input
   mov ah, 0x0e
   int 10h
   inc dl
   stosb
   jmp down_key_press

backspace:
   cmp dl, 0
   jz down_key_press
   mov ah, 0x0e
   mov al, 8
   int 10h
   mov al, 0
   int 10h
   mov al, 8
   int 10h
   dec dl
   mov dh, 0
   mov esi, keyDown
   mov edi, keyDown
   mov al, 0
   mov ah, dl
   rep movsb
   jmp down_key_press
input:
   mov esi, command_not_found
   cld
   mov ah, 0x0e
   mov al, 13
   int 10h
   mov al, 10
   int 10h
input_loop:
   lodsb
   cmp al, 0
   jz input_end
   int 10h
   jmp imput_loop

input_end:
   mov esi, keyDown
   cld
   mov ah, 0x0e
   mov dh, 0

input_text:
   lodsb
   cmp dh, dl
   jz input_loop
   inc dh
   int 10h
   jmp input_text

input_noloop_end:
   mov edi, keyDown
   mov dl, 0h
   mov al, 13
   mov ah, 0x0e
   int 10h
   mov al, 10
   int 10h
   jmp down_key_press

fuck_off:
  mov ax, 5307h
  xor bx, bx
  inc bx
  mov cx, 3
  int 15h

section .data
hw db 'LimeOS v0.1 ALPHA',10,13
keyDown db 0
selector db 10,13,'>>> ',0
command_not_found db 10,13,'Error! Command not found',10,13
help_text db 10, 13, '1. reboot - reboot your PC, 2. shutdown - off your PC',10,13
