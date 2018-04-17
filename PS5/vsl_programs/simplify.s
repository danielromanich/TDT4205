.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
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
	call	_f
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_f:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	movq $0, %rax
	leave
	ret
_h:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	subq $8, %rsp
	pushq $0
	movq $5, %rax
	movq %rax, -24(%rbp)
	movq $1, %rax
	movq %rax, -24(%rbp)
	movq $4, %rax
	movq %rax, -24(%rbp)
	movq $2, %rax
	movq %rax, -24(%rbp)
	movq $-6, %rax
	movq %rax, -24(%rbp)
	movq $4, %rax
	movq %rax, -24(%rbp)
	movq $0, %rax
	leave
	ret
_g:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	pushq %rdx
	subq $48, %rsp
	pushq $0
	movq $1, %rax
	movq %rax, -32(%rbp)
	movq $2, %rax
	movq %rax, -40(%rbp)
	movq -56(%rbp), %rax
	pushq %rax
	movq $1, %rax
	addq %rax, (%rsp)
	popq %rax
	movq %rax, %rdi
	movq -64(%rbp), %rax
	pushq %rax
	movq $2, %rax
	addq %rax, (%rsp)
	popq %rax
	movq %rax, %rsi
	movq -72(%rbp), %rax
	pushq %rax
	movq $3, %rax
	addq %rax, (%rsp)
	popq %rax
	movq %rax, %rdx
	call _g
	movq %rax, -48(%rbp)
	movq -32(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -40(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -48(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $0, %rax
	leave
	ret
