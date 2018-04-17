.section .rodata
intout: .string "%ld "
strout: .string "%s "
errout: .string "Wrong number of arguments"
STR0:	.string	"A equals 10"
STR1:	.string	"B is greater than -15"
STR2:	.string	"B is smaller than or equal to -15"
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
	subq $16, %rsp
	movq $10, %rax
	movq %rax, -8(%rbp)
	movq $-15, %rax
	movq %rax, -16(%rbp)
	movq -8(%rbp), %rsi
	movq $intout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
	movq -8(%rbp), %rax
	movq $10, %rbx
	cmpq %rax, %rbx
jne	 END_IF0
	movq $STR0, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
END_IF0:
	movq -8(%rbp), %rax
	movq $0, %rbx
	cmpq %rax, %rbx
jge	 END_IF1
	movq -16(%rbp), %rax
	movq $-15, %rbx
	cmpq %rax, %rbx
jge	 ELSE1
	movq $STR1, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
ELSE1:
	movq $STR2, %rsi
	movq $strout, %rdi
	call printf
	movq $'\n', %rdi
	call putchar
END_IF1:
END_IF2:
	movq $0, %rax
	leave
	ret
