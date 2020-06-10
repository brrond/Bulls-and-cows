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



COMPUTER_IS_TOO_GOOD:
ret
guess ENDP
end
