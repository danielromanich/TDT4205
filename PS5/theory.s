    .data

fact_string: .asciz "The result of f(8) (8!) is %d!\n"
.text
    .global main
main:
	movq $8, %rax
	movq $1, %rbx
	factorial:
		imulq %rax, %rbx
		decq %rax
		cmpq $1, %rax
		jne factorial
	movq $0, %rax
	pushq %rax
	lea  fact_string(%rip), %rdi
	mov %ebx, %esi
	xor %eax, %eax
	call printf
	pop %rax
	ret
