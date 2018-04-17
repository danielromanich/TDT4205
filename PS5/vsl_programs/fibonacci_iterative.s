.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"Fibonacci number #"
STR1:	.string	"is"
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
	call	_fibonacci_iterative
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_fibonacci_iterative:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $32, %rsp
	pushq $0
	movq -8(%rbp), %rax
	movq %rax, -16(%rbp)
	movq $1, %rax
	movq %rax, -24(%rbp)
	movq $1, %rax
	movq %rax, -32(%rbp)
	movq $1, %rax
	movq %rax, -40(%rbp)
	movq -16(%rbp), %rax
	movq $0, %rbx
	cmpq %rax, %rbx
jge	 END_IF0
	movq -16(%rbp), %rax
	movq $1, %rbx
	cmpq %rax, %rbx
jge	 END_IF0
	movq -16(%rbp), %rax
	movq $2, %rbx
	cmpq %rax, %rbx
jge	 ELSE0
ELSE0:
	movq $0, %rax
	movq %rax, -40(%rbp)
END_IF0:
END_IF1:
END_IF2:
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $STR1, %rsi
	movq $strout, %rdi
	call printf
	movq -40(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
