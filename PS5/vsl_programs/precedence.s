.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"2*(3-1) := "
STR1:	.string	"2*3-1 := "
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
	call	_precedence
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_precedence:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	movq $2, %rax
	movq %rax, -8(%rbp)
	movq $3, %rax
	movq %rax, -16(%rbp)
	movq $1, %rax
	movq %rax, -24(%rbp)
	pushq %rdx
	movq -16(%rbp), %rax
	pushq %rax
	movq -24(%rbp), %rax
	subq %rax, (%rsp)
	popq %rax
	pushq %rax
	movq -8(%rbp), %rax
	mulq (%rsp)
	popq %rdx
	popq %rdx
	movq %rax, -32(%rbp)
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq -32(%rbp), %rsi
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
	pushq %rax
	movq -24(%rbp), %rax
	subq %rax, (%rsp)
	popq %rax
	movq %rax, -32(%rbp)
	movq $STR1, %rsi
	movq $strout, %rdi
	call printf
	movq -32(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
