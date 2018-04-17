.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"Testing if printf format codes are left alone."
STR1:	.string	"\nOutput *should* contain percent characters, but no integers."
STR2:	.string	"\tHello, world! %d %d"
STR3:	.string	"Adding a splash of ANSI color codes - This will only work in a color terminal"
STR4:	.string	"\t\033[31mRed"
STR5:	.string	"\t\033[32mGreen"
STR6:	.string	"\t\033[34mBlue"
STR7:	.string	"\033[0m"
.globl main
.section .text
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1, %rdi
	cmpq	$0,%rdi
	jne ABORT
	cmpq $0, %rdi
	jz SKIP_ARGS
	movq %rdi, %rcx
	addq $0, %rsi
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
SKIP_ARGS:
	call	_escapecodes
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_escapecodes:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq $STR1, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $64, %rax
	movq %rax, -8(%rbp)
	movq $42, %rax
	movq %rax, -16(%rbp)
	movq $STR2, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $STR3, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $STR4, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $STR5, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $STR6, %rsi
	movq $strout, %rdi
	call printf
	movq $STR7, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
