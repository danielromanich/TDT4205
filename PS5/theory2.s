.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
.globl main
.section .text
main:
pushq %rbp
movq %rsp, %rbp
movq $1, %rsi
movq $intout, %rdi
call printf
movq $0, %rax
leave
ret

