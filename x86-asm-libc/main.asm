    global main
    extern printf

    section .text
main:
    mov rdi, format
    mov rsi, 64
    xor rax, rax
    call printf

    ret
    
format:
    db "0x%lx", 10, 0
