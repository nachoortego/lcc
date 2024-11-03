.data
a: .long 1, 2, 3, 4
g: .quad 0x1122334455667788
msg: .asciz "Imprime %c\n"
.text
.global main
main:
  subq $8, %rsp               # rsp = 0x7fffffffebc0 (si rsp inicial es 0x7fffffffebc8)
  movq $g, %rax               # rax = 0x404040 (dirección de g)
  movl g+4, %eax              # rax = 0x11223344 (parte baja de g)
  movq $3, %rbx               # rbx = 3
  movb a(,%rbx,4), %al        # rax = 0x11223304 (valor de a[3] en los ultimos 2 bits, que serian al)
  leaq msg, %rdi              # rdi = 0x404048 (dirección de msg)
  movb (%rdi, %rbx, 2), %sil  # sil = 0x65 (valor de msg[6], que es 'e')
  xorl %eax, %eax             # rax = 0
  call printf                 # rax = 10 (caracteres impresos en printf)
  addq $8, %rsp               # rsp = 0x7fffffffdf58
  ret
