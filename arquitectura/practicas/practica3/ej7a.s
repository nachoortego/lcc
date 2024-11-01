.global main
main:
  movq $0x123456789ABCDEF0, %rax  # Valor de ejemplo en rax
  rol $32, %rax                   # Rotar rax 32 bits a la izquierda
  ret
