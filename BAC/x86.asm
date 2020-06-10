.586
.model flat, C
.stack 100h

.data
msg_hello db "Ok, I will try", 10, 0
msg_tf db "Number %s", 10, 0
msg_for_scanf db "%hu %hu", 0

number db "0000", 0

N dw 0 ; bulls
M dw 0 ; cows

free_char db '-'

not_free_chars db 4 dup('-'), 0

ans db 4 dup('-'), 0

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
end
