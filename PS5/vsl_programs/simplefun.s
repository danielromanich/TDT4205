.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"Parameter s is"
STR1:	.string	"t is "
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
	call	_funcall
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_my_function:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $0, %rsp
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
	movq $0, %rax
	leave
	ret
_funcall:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq $0
	movq $5, %rdi
	movq $10, %rsi
	call _my_function
	movq %rax, -8(%rbp)
	movq $0, %rax
	leave
	ret
