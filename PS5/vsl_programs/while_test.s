.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"foobar"
STR1:	.string	"Skip..."
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
	call	_while_test
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_while_test:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq $0
	movq $20, %rax
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	movq $0, %rbx
	cmpq %rax, %rbx
jge	 END_IF0
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
END_IF0:
	movq $0, %rax
	leave
	ret
