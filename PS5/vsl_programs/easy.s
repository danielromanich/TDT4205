.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"Testing plain call/return and expression evaluation"
STR1:	.string	"The function returned y:="
STR2:	.string	"My parameters are a:="
STR3:	.string	"and b:="
STR4:	.string	"Their sum is c:="
STR5:	.string	"Their difference is c:="
STR6:	.string	"Their product is c:="
STR7:	.string	"Their ratio is c:="
STR8:	.string	"(-c):="
STR9:	.string	"The sum of their squares is "
.globl main
.section .text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$1,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $8, %rsi
PARSE_ARGV:
	pushq %rcx
	pushq %rsi
	movq (%rsi), %rdi
	movq $0, %rsi
	movq $10, %rdx
	call strtol
	popq %rsi
	popq %rcx
	pushq %rax
	subq $8, %rsi
	loop PARSE_ARGV
	popq	%rdi
SKIP_ARGS:
	call	_main
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_main:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $24, %rsp
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $15, %rax
	movq %rax, -16(%rbp)
	movq $5, %rax
	movq %rax, -32(%rbp)
	movq -16(%rbp), %rdi
	movq -32(%rbp), %rsi
	call _test
	movq %rax, -24(%rbp)
	movq $STR1, %rsi
	movq $strout, %rdi
	call printf
	movq -24(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
_test:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $8, %rsp
	pushq $0
	movq $STR2, %rsi
	movq $strout, %rdi
	call printf
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR3, %rsi
	movq $strout, %rdi
	call printf
	movq -16(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	pushq %rax
	movq -16(%rbp), %rax
	addq %rax, (%rsp)
	popq %rax
	movq %rax, -24(%rbp)
	movq $STR4, %rsi
	movq $strout, %rdi
	call printf
	movq -24(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	pushq %rax
	movq -16(%rbp), %rax
	subq %rax, (%rsp)
	popq %rax
	movq %rax, -24(%rbp)
	movq $STR5, %rsi
	movq $strout, %rdi
	call printf
	movq -24(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	pushq %rdx
	movq -16(%rbp), %rax
	pushq %rax
	movq -8(%rbp), %rax
	mulq (%rsp)
	popq %rdx
	popq %rdx
	movq %rax, -24(%rbp)
	movq $STR6, %rsi
	movq $strout, %rdi
	call printf
	movq -24(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	pushq %rdx
	movq -16(%rbp), %rax
	pushq %rax
	movq -8(%rbp), %rax
	cqo
	idivq (%rsp)
	popq %rdx
	popq %rdx
	movq %rax, -24(%rbp)
	movq $STR7, %rsi
	movq $strout, %rdi
	call printf
	movq -24(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $STR8, %rsi
	movq $strout, %rdi
	call printf
	movq -24(%rbp), %rax
	negq %rax
	movq %rax, %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $STR9, %rsi
	movq $strout, %rdi
	call printf
	pushq %rdx
	movq -8(%rbp), %rax
	pushq %rax
	movq -8(%rbp), %rax
	mulq (%rsp)
	popq %rdx
	popq %rdx
	pushq %rax
	pushq %rdx
	movq -16(%rbp), %rax
	pushq %rax
	movq -16(%rbp), %rax
	mulq (%rsp)
	popq %rdx
	popq %rdx
	addq %rax, (%rsp)
	popq %rax
	movq %rax, %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	pushq %rax
	movq -16(%rbp), %rax
	subq %rax, (%rsp)
	popq %rax
	leave
	ret
