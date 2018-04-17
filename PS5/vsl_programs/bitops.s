.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"a is"
STR1:	.string	"and b is"
STR2:	.string	"~"
STR3:	.string	"="
STR4:	.string	"|"
STR5:	.string	"="
STR6:	.string	"^"
STR7:	.string	"="
STR8:	.string	"&"
STR9:	.string	"="
STR10:	.string	"<<"
STR11:	.string	"="
STR12:	.string	">>"
STR13:	.string	"="
.globl main
.section .text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$2,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $16, %rsi
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
	popq	%rsi
SKIP_ARGS:
	call	_bitwise_operators
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_bitwise_operators:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $8, %rsp
	pushq $0
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR1, %rsi
	movq $strout, %rdi
	call printf
	movq -16(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	notq %rax
	movq %rax, -24(%rbp)
	movq $STR2, %rsi
	movq $strout, %rdi
	call printf
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR3, %rsi
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
	orq %rax, (%rsp)
	popq %rax
	movq %rax, -24(%rbp)
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR4, %rsi
	movq $strout, %rdi
	call printf
	movq -16(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR5, %rsi
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
	xorq %rax, (%rsp)
	popq %rax
	movq %rax, -24(%rbp)
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR6, %rsi
	movq $strout, %rdi
	call printf
	movq -16(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR7, %rsi
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
	andq %rax, (%rsp)
	popq %rax
	movq %rax, -24(%rbp)
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR8, %rsi
	movq $strout, %rdi
	call printf
	movq -16(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR9, %rsi
	movq $strout, %rdi
	call printf
	movq -24(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	movq %rax, %rcx
	movq -16(%rbp), %rax
	xchgq %rax, %rcx
	salq %cl, %rax
	movq %rax, -24(%rbp)
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR10, %rsi
	movq $strout, %rdi
	call printf
	movq -16(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR11, %rsi
	movq $strout, %rdi
	call printf
	movq -24(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	movq %rax, %rcx
	movq -16(%rbp), %rax
	xchgq %rax, %rcx
	sarq %cl, %rax
	movq %rax, -24(%rbp)
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR12, %rsi
	movq $strout, %rdi
	call printf
	movq -16(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR13, %rsi
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
