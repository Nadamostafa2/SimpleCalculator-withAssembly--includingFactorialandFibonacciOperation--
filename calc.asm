segment .rodata
    help db 0xa,'USAGE:', 0xa, './calc "[ Equation ]"', 0xa
    lhelp equ $ - help

    break db 0xa
    lbreak equ $ - break

segment .data
    op1 dw 00
    op2 dw 00
    ans dw 00
segment .bss
    total resb 0x400

section .text

    global _start:
_start:
    cmp byte [esp], 0x01
    je Error


    ;; GETTING THE Equation
    mov edx, [esp+0x08]     ; get the string

    ;; GET THE SIZE OF PARAM STRING
    call equation

    ;; edx ---> equation
    ;; ebx ---> string size

    mov esi, ebx  ; string size to esi
    xor ebx, ebx  ; empty ebx
    call find_mul
    call find_div
    call find_sum
    call find_sub




    






    
















find_mul:
    inc ebx
    cmp esi , ebx
    je ret
    cmp byte [edx+ebx] , '*'
    je mult


    mult:
        dec ebx
        call char_to_int
        mov ecx , eax
        add ebx, 2
        call char_to_int
        mul ecx ; eax = ecx * eax
        push eax
        jmp find_mul





equation:
    cmp byte [edx+ebx], '='    ; compare the char with null
    jne _lgs                    ; if not null -> jmp _lgs
    ret                         ; ret

    _lgs:
        inc ebx                 ; increment ebx
        jmp equation size            ; check the next char jumping to equation size





Error:
    push lhelp
    push help

    call _print

    jmp end


char_to_int:
    
    mov al, [edx+ebx]
    cmp al , '0'
    jl done
    cmp al , '9'
    jg done
    sub al , '0'
    ret
    done:
        cmp ebx, 0
        je Error
        ret
        



_print:
    mov edx, [esp+0x08]
    mov ecx, [esp+0x04]
    mov ebx, 0x01
    mov eax, 0x04
    int 0x80

    ret

end:
    mov eax, 0x01
    xor ebx, ebx
    int 0x80
