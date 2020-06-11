.586
.model flat, C
.stack 100h

.data
; common data
number db "0000", 0
N dw 0 ; bulls
M dw 0 ; cows

; data for guess function
msg_hello db "Ok, I will try", 10, 0
msg_tf db "Number %s", 10, 0
msg_for_scanf db "%hu %hu", 0

free_char db '-'

not_free_chars db 4 dup('-'), 0

ans db 4 dup('-'), 0
; end of data for guess function
; data for figure_out function
msg_hello_fo db "Ok, good luck", 10, 0
msg_ask_fo db "Enter four digit number : ", 0
msg_ask_fo_2 db "%s", 0
msg_for_bc_count db "Bulls : %d, cows : %d", 10, 0

numbers_for_check db "0000000000"
numbers_for_check_copy db "0000000000"

; end of ALL data
.code

extern printf :PROC
extern scanf :PROC

ask proc

; ASK user
lea eax, number
push eax
lea eax, msg_tf
push eax
call printf

; POP stuff
pop eax
pop eax

; Read user input
lea eax, M
push eax
lea eax, N
push eax
lea eax, msg_for_scanf
push eax
call scanf

; POP stuff
pop eax
pop eax
pop eax

ret
ask endp

find_free_and_not_free_chars proc
mov cl, '0'
dec cl

mov ebx, 0

@@local_loop:

cmp bl, 4
jne @@end_of_check
mov dl, [free_char]
cmp dl, '-'
je @@end_of_check
ret
@@end_of_check:
inc cl
lea eax, number
mov [eax], cl
mov [eax + 1], cl
mov [eax + 2], cl
mov [eax + 3], cl

push ecx
call ask
pop ecx

; if computer won
mov ax, N
cmp ax, 4
jz @@COMPUTER_IS_TOO_GOOD

; if not
mov ax, N
cmp ax, 0
jnz @@local_next

mov free_char, cl
jmp @@local_loop

@@local_next:

; if not free
mov ax, N
cmp ax, 0
jng @@local_loop

; ax is greater or equal to 0
xchg ax, cx

@@local_local_loop: ; I know, my skill of naming marks is 'the best'
mov [not_free_chars + ebx], al
lea esi, not_free_chars
inc ebx

dec cl
cmp cl, 0
jg @@local_local_loop
xchg ax, cx

jmp @@local_loop

@@COMPUTER_IS_TOO_GOOD:
mov al, -1
ret
find_free_and_not_free_chars endp

public guess
guess PROC

; Say hello to user
lea eax, msg_hello
push eax
call printf
pop eax

call find_free_and_not_free_chars
cmp al, -1
jz COMPUTER_IS_TOO_GOOD

mov esi, 0

next_char:

; check if we found it
cmp esi, 4
je COMPUTER_IS_GOOD

mov bl, [not_free_chars + esi]
mov ecx, 0 ; position of char in ans

inc esi
next:

mov al, [ans + ecx]
cmp al, '-'
je fine
inc ecx
jmp next
fine:
lea eax, number
mov dl, free_char
mov [eax], dl
mov [eax + 1], dl
mov [eax + 2], dl
mov [eax + 3], dl

mov [eax + ecx], bl
push eax
push ebx
push ecx
call ask
pop ecx
pop ebx
pop eax

inc ecx
mov ax, N
cmp ax, 1
jne next

mov [ans + ecx - 1], bl
jmp next_char

COMPUTER_IS_GOOD:
lea eax, ans
ret
COMPUTER_IS_TOO_GOOD:
lea eax, number
ret
guess ENDP

; or get number function
ask_fo proc
lea eax, msg_ask_fo
push eax
call printf

pop eax

lea eax, number
push eax
lea eax, msg_ask_fo_2
push eax
call scanf
pop eax
pop eax
ret
ask_fo endp

public figure_out
figure_out PROC
push ebp
mov ebp, esp

mov esi, [ebp + 8] ; there is a pointer to COMPUTER number int ESI
lea eax, msg_hello_fo
push eax
call printf
pop eax

mov ecx, 4
mov eax, 0
tmp_loop:
mov al, [esi + ecx - 1]
sub al, '0'
mov bl, [numbers_for_check + eax]
inc bl
mov [numbers_for_check + eax], bl
loop tmp_loop



main_loop_fo:
mov N, 0
mov M, 0

call ask_fo

; if player won (check)
mov ecx, 4
check_player_won_f:
mov al, [esi + ecx - 1]
cmp al, [number + ecx - 1]
jne end_of_player_won_check
cmp ecx, 1
je PLAYER_IS_NOT_BAD
loop check_player_won_f
end_of_player_won_check:

; if player is CO CO CO
; calc bulls count
mov ecx, 4
calc_bulls_count:
mov al, [esi + ecx - 1]
cmp al, [number + ecx - 1]
jne next_calc_bulls_count_it
mov ax, N
inc ax
mov N, ax
next_calc_bulls_count_it:
loop calc_bulls_count

mov al, [numbers_for_check]
mov [numbers_for_check_copy], al
mov al, [numbers_for_check + 1]
mov [numbers_for_check_copy + 1], al
mov al, [numbers_for_check + 2]
mov [numbers_for_check_copy + 2], al
mov al, [numbers_for_check + 3]
mov [numbers_for_check_copy + 3], al
mov al, [numbers_for_check + 4]
mov [numbers_for_check_copy + 4], al
mov al, [numbers_for_check + 5]
mov [numbers_for_check_copy + 5], al
mov al, [numbers_for_check + 6]
mov [numbers_for_check_copy + 6], al
mov al, [numbers_for_check + 7]
mov [numbers_for_check_copy + 7], al
mov al, [numbers_for_check + 8]
mov [numbers_for_check_copy + 8], al
mov al, [numbers_for_check + 9]
mov [numbers_for_check_copy + 9], al


mov ecx, 4
mov eax, 0
mov ebx, 0
mov M, 0
calc_cows_count:
mov al, [number + ecx - 1]
sub al, '0'
mov bl, [numbers_for_check_copy + eax]
mov [numbers_for_check_copy + eax], '0'
sub bl, '0'
mov dx, M
add dx, bx
mov M, dx
loop calc_cows_count

mov ax, M
mov bx, N
sub ax, bx
mov M, ax

; show bulls and cows count
mov eax, 0
mov ax, M
push eax
mov ax, N
push eax
lea eax, msg_for_bc_count
push eax
call printf
pop eax
pop eax
pop eax

jmp main_loop_fo

PLAYER_IS_NOT_BAD:
pop ebp
ret
figure_out endp

end
