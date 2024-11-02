.data
a: .long 1, 2, 3, 4
g: .quad 0x1122334455667788
msg: .asciz "Imprime %c\n"
.text
.global main
main:
  subq $8, %rsp               # rsp = 0x7fffffffebc0
  movq $g, %rax               # rax = 0x404040 o 4210752
  movl g+4, %eax              # rax = 0x11223344 o 287454020
  movq $3, %rbx               # rbx = 3
  movb a(,%rbx,4), %al        # rax = 0x11223304 o 287453956
  leaq msg, %rdi              # rdi = 0x404048 o 4210760
  movb (%rdi, %rbx, 2), %sil  # sil = 0x65 o 101
  xorl %eax, %eax             # rax = 0
  call printf                 # rax = 10
  addq $8, %rsp               # rsp = 0x7fffffffdf58
  ret
