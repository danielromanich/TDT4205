.section .data
str: .string "The result of f(8) (8!) is %d!\n"
.global main
.section .text
main:
	movq $8, %rax
	movq $1, %rbx
factorial:
	imulq %rax, %rbx
	decq %rax
	cmpq $1, %rax
	jne factorial

	movq %rbx, %rsi
	movq $str, %rdi
	call printf
	exit
