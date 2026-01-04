format binary
org 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, welcome_msg
    call print_string

main_loop:
    mov di, cmd_buffer
    mov cx, 16
    xor al, al
    rep stosb
    
    mov di, cmd_buffer
    mov bx, 0

input_loop:
    xor ah, ah
    int 0x16

    cmp al, 0x0D    ; Enter
    je check_command

    cmp al, 0x08    ; Backspace
    je backspace

    cmp bx, 15      ; Лимит 15 символов
    jae input_loop

    mov ah, 0x0E
    int 0x10
    stosb
    inc bx
    jmp input_loop

backspace:
    test bx, bx
    jz input_loop
    dec bx
    dec di
    mov byte [di], 0
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp input_loop

check_command:
    call print_newline
    
    ; Проверка на "exit"
    mov si, cmd_buffer
    mov di, exit_cmd
    mov cx, 4
    repe cmpsb
    je shutdown_system

    mov si, welcome_msg
    call print_string
    jmp main_loop

shutdown_system:
    ; Команда выключения для QEMU (версия после 2.0)
    mov ax, 0x2000
    mov dx, 0x604
    out dx, ax
    
    ; Если не сработало (старый QEMU), пробуем через Bochs/старый QEMU порт
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15
    
    jmp $ ; Если ничего не помогло, просто зависнуть

; --- ФУНКЦИИ ---
print_string:
    mov ah, 0x0E
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

print_newline:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

; --- ДАННЫЕ ---
welcome_msg db 'hOS> ', 0
exit_cmd    db 'exit', 0
cmd_buffer  rb 16

rb 510-($-$$)
dw 0xAA55