.data
format: .asciz "%d %d\n"
format_a: .asciz "rsp: %p\n"
format_b: .asciz "Direccion cadena de formato: %ld\n"
format_c: .asciz "Direccion cadena de formato (hex): %p\n"
format_d: .asciz "Tope de pila: %lx\n"
format_e: .asciz "rsp + 8: %lx\n"
format_f: .asciz "i: %ld\n"
format_g: .asciz "Direccion de i: %p\n"
i: .quad 0xDEADBEEF

.text
.global main
main:
  # Alinea el stack antes de la llamada a funcion
  pushq %rbp                # Guardar el valor de %rbp en la pila
  movq %rsp, %rbp           # Establecer el nuevo valor de %rbp

  # Imrprime 1234
  movq $format, %rdi # El primer argumento es el formato.
  movq $1234, %rsi # El valor a imprimir.
  xorq %rax, %rax # Cantidad de valores de punto flotante.
  call printf

  # a) rsp
  movq %rsp, %rsi
  movq $format_a, %rdi
  xorq %rax, %rax
  call printf

  # b) Direccion cadena de formato
  movq $format_b, %rdi
  movq $format_b, %rsi
  xorq %rax, %rax
  call printf

  # c) Direccion cadena de formato en hexadecimal
  movq $format_c, %rdi
  movq $format_c, %rsi
  xorq %rax, %rax
  call printf

  # d) El quad en el tope de la pila
  movq (%rsp), %rsi
  movq $format_d, %rdi
  xorq %rax, %rax
  call printf

  # e) El quad ubicado en la direcci´on rsp + 8.
  movq 8(%rsp), %rsi
  movq $format_e, %rdi
  xorq %rax, %rax
  call printf

  # f) El valor i
  movq i, %rsi
  movq $format_f, %rdi
  xorq %rax, %rax
  call printf

  # g) La direccion de i.
  leaq i, %rsi
  movq $format_g, %rdi
  xorq %rax, %rax
  call printf

  # Restaura el stack a su posicion original
  movq %rbp, %rsp           # Restaurar el valor de %rsp
  popq %rbp                 # Restaurar el valor de %rbp

  ret
