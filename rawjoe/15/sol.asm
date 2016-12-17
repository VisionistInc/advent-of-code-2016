section .data
    large   EQU 10000000
    pos1    EQU 13
    start1  EQU 1
    pos2    EQU 19
    start2  EQU 10
    pos3    EQU 3
    start3  EQU 2
    pos4    EQU 7
    start4  EQU 1
    pos5    EQU 5
    start5  EQU 3
    pos6    EQU 17
    start6  EQU 5
    pos7    EQU 11
    start7  EQU 0
    msg     db  "                               "
    eol     db  10

section .text
    global _start
_start:
    mov     rbp, -1

loop:
    inc     rbp

disc1:
    mov     rax, start1
    add     rax, rbp
    add     rax, 1
    mov     rdx, 0
    mov     rcx, pos1
    div     rcx
    test    rdx, rdx
    jnz     loop

disc2:
    mov     rax, start2
    add     rax, rbp
    add     rax, 2
    mov     rdx, 0
    mov     rcx, pos2
    div     rcx
    test    rdx, rdx
    jnz     loop

disc3:
    mov     rax, start3
    add     rax, rbp
    add     rax, 3
    mov     rdx, 0
    mov     rcx, pos3
    div     rcx
    test    rdx, rdx
    jnz     loop

disc4:
    mov     rax, start4
    add     rax, rbp
    add     rax, 4
    mov     rdx, 0
    mov     rcx, pos4
    div     rcx
    test    rdx, rdx
    jnz     loop

disc5:
    mov     rax, start5
    add     rax, rbp
    add     rax, 5
    mov     rdx, 0
    mov     rcx, pos5
    div     rcx
    test    rdx, rdx
    jnz     loop

disc6:
    mov     rax, start6
    add     rax, rbp
    add     rax, 6
    mov     rdx, 0
    mov     rcx, pos6
    div     rcx
    test    rdx, rdx
    jnz     loop

    test    r15,r15
    jnz     disc7
    mov     r15, rbp

disc7:
    mov     rax, start7
    add     rax, rbp
    add     rax, 7
    mov     rdx, 0
    mov     rcx, pos7
    div     rcx
    test    rdx, rdx
    jnz     loop

    mov     r11, rbp

doneFind:
    mov     r13, large
    mov     r12, 0

saveSol:
    mov     rax, r15
    mov     rdx, 0
    div     r13
    add     rax, 48
    mov     r14, $msg
    add     r14, r12
    mov     [r14], rax
    mov     r15, rdx
    mov     rdx, 0
    mov     rax, r13
    mov     r13, 10
    div     r13
    mov     r13, rax
    inc     r12
    cmp     r12, 8
    jl      saveSol
    jg      sol2

    mov     r14, $msg
    add     r14, r12
    mov     r15, 32
    mov     [r14], r15
    inc     r12
    mov     r13, large
    mov     r15, r11

sol2:
    cmp     r12, 17
    jl      saveSol

printSol:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg
    mov     rdx, 17
    syscall
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, eol
    mov     rdx, 1
    syscall

end:
    mov    rax, 60
    mov    rdi, 0
    syscall
