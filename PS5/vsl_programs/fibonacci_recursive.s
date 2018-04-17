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
	call	_fibonacci_recursive
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_fibonacci_recursive:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $8, %rsp
	movq -8(%rbp), %rdi
	call _fibonacci_number
	movq %rax, -16(%rbp)
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
_fibonacci_number:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $8, %rsp
	movq $0, %rax
	movq %rax, -16(%rbp)
	movq -8(%rbp), %rax
	movq $2, %rbx
	cmpq %rax, %rbx
jge	 ELSE0
	movq -8(%rbp), %rax
	pushq %rax
	movq $1, %rax
	subq %rax, (%rsp)
	popq %rax
	movq %rax, %rdi
	call _fibonacci_number
	pushq %rax
	movq -8(%rbp), %rax
	pushq %rax
	movq $2, %rax
	subq %rax, (%rsp)
	popq %rax
	movq %rax, %rdi
	call _fibonacci_number
	addq %rax, (%rsp)
	popq %rax
	movq %rax, -16(%rbp)
ELSE0:
	movq $1, %rax
	movq %rax, -16(%rbp)
END_IF0:
	movq -16(%rbp), %rax
	leave
	ret
