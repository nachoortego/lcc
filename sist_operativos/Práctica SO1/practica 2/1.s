	.file	"v1.0.c"
	.text
	.globl	molineton1
	.type	molineton1, @function
molineton1:
.LFB52:
	.cfi_startproc
	endbr64
	movl	visitantes(%rip), %edx
	leal	1(%rdx), %eax
	addl	$200000001, %edx
.L2:
	movl	%eax, %ecx
	addl	$1, %eax
	cmpl	%edx, %eax
	jne	.L2
	movl	%ecx, visitantes(%rip)
	ret
	.cfi_endproc
.LFE52:
	.size	molineton1, .-molineton1
	.globl	molineton2
	.type	molineton2, @function
molineton2:
.LFB53:
	.cfi_startproc
	endbr64
	movl	visitantes(%rip), %edx
	leal	1(%rdx), %eax
	addl	$200000001, %edx
.L5:
	movl	%eax, %ecx
	addl	$1, %eax
	cmpl	%edx, %eax
	jne	.L5
	movl	%ecx, visitantes(%rip)
	ret
	.cfi_endproc
.LFE53:
	.size	molineton2, .-molineton2
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"La cantidad final es %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB54:
	.cfi_startproc
	endbr64
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movl	$0, (%rsp)
	movl	$1, 4(%rsp)
	movq	%rsp, %rcx
	leaq	8(%rsp), %rdi
	leaq	molineton1(%rip), %rdx
	movl	$0, %esi
	call	pthread_create@PLT
	leaq	4(%rsp), %rcx
	leaq	16(%rsp), %rdi
	leaq	molineton2(%rip), %rdx
	movl	$0, %esi
	call	pthread_create@PLT
	movl	$0, %esi
	movq	8(%rsp), %rdi
	call	pthread_join@PLT
	movl	$0, %esi
	movq	16(%rsp), %rdi
	call	pthread_join@PLT
	movl	visitantes(%rip), %edx
	leaq	.LC0(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L10
	movl	$0, %eax
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L10:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE54:
	.size	main, .-main
	.globl	flag
	.bss
	.align 8
	.type	flag, @object
	.size	flag, 8
flag:
	.zero	8
	.globl	turno
	.align 4
	.type	turno, @object
	.size	turno, 4
turno:
	.zero	4
	.globl	visitantes
	.align 4
	.type	visitantes, @object
	.size	visitantes, 4
visitantes:
	.zero	4
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
