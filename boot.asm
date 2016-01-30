section .text
   use16
   org 0x7C00

start:
   mov ax, cs
   mov ds, ax
   mov si, hw
cld
   mov ah, 0x0E
   mov bh, 0
   jmp print
print:
   mov al, 0
   lodsb
   test al, al
   jz input
   int 10h
   jmp print

input:
   mov ah, 0
   int 16h
   cmp ah, 0Eh
   cmp ah, 1Ch
   jz check
   jz backspace
   mov ah, 0x0E
   mov bh, 0
   int 10h
   mov [under], al
   mov al, 1
   add [bg], al
   jmp input

backspace:
  mov ah, 0x0E
  mov bh, 0
  mov al, 8
  int 10h
   
  mov ah, 0x0E
  mov bh, 0
  mov al, 0
  int 10h

  mov ah, 0x0E
  mov bh, 0
  mov al, 8
  int 10h
   
  mov al, 1
  sub [bg], al

  jmp input

check:
  mov al, [under]
  cmp al, 'h'
  jz help_code
cld
  mov si, command_not_found
  mov ah, 0x0E
  mov bh, 0
  jmp print

help_code:
  mov ah, 0x0E
  mov bh, 0
  mov si, help_text
cld
  mov ah, 0x0E
  mov bh, 0
  jmp print

jmp input

section .data
hw db 'LimeOS v0.1 ALPHA',10,13
bg db 0
under db 0
selector db 10,13,'>>> ',0
command_not_found db 10,13,'Error! Command not found',10,13
help_text db 10, 13, '1. reboot - reboot your PC, 2. shutdown - off your PC',10,13
