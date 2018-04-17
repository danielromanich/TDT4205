.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"Bigger"
STR1:	.string	"Smaller"
STR2:	.string	"Equal"
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
	call	_test
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_test:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $0, %rsp
	pushq $0
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	movq $10, %rbx
	cmpq %rax, %rbx
jge	 END_IF0
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
END_IF0:
	movq -8(%rbp), %rax
	movq $10, %rbx
	cmpq %rax, %rbx
jle	 END_IF1
	movq $STR1, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
END_IF1:
	movq -8(%rbp), %rax
	movq $10, %rbx
	cmpq %rax, %rbx
jne	 END_IF2
	movq $STR2, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
END_IF2:
	movq $0, %rax
	leave
	ret
