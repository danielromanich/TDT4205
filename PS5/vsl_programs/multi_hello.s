.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"Morna"
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
	call	_hello
	jmp END
ABORT:
	movq $errout, %rdi
	call puts
END:
	movq %rax, %rdi
	call exit
_x	.zero	8
_z	.zero	8
_w	.zero	8
_y	.zero	8
_hello:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	movq $1, %rax
	pushq %rax
	movq $2, %rax
	pushq %rax
	movq $3, %rdi
	movq $4, %rsi
	movq $5, %rdx
	movq $6, %rcx
	movq $7, %r8
	movq $8, %r9
	call _goodbye
	movq %rax, _w
	movq _w, %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq _w, %rax
	leave
	ret
_goodbye:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	pushq 
	pushq (null)
	subq $0, %rsp
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -16(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -24(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -32(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -40(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -48(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -56(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq -64(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $1, %rdi
	call _tralala
	leave
	ret
_tralala:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rdi
	subq $32, %rsp
	pushq $0
	movq $3, %rax
	movq %rax, -16(%rbp)
	movq $5, %rax
	movq %rax, -24(%rbp)
	movq $2, %rax
	movq %rax, -32(%rbp)
	movq $4, %rax
	movq %rax, -40(%rbp)
	movq $42, %rax
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	pushq %rdx
	movq -24(%rbp), %rax
	pushq %rax
	movq -16(%rbp), %rax
	mulq (%rsp)
	popq %rdx
	popq %rdx
	movq %rax, %rsi
	movq $intout, %rdi
	call printf
	pushq %rdx
	movq -40(%rbp), %rax
	pushq %rax
	movq -32(%rbp), %rax
	mulq (%rsp)
	popq %rdx
	popq %rdx
	movq %rax, %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq $1, %rax
	leave
	ret
