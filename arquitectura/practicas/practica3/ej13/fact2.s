.global fact2
fact2:
  pushq %rbp                # Guardar el valor de %rbp en la pila
  movq %rsp, %rbp           # Establecer el nuevo valor de %rbp

  movq $1, %rax             # Inicializar acc = 1 (en %rax)
  movq %rdi, %rcx           # Mover el valor de x (en %rdi) a %rcx
  cmpq $1, %rcx             # Comparar x (en %rcx) con 1
  jle .return               # Si x <= 1, saltar al final

.for:
  imulq %rcx, %rax          # acc *= x (multiplicar %rax por %rcx)
  decq %rcx                 # x--
  cmpq $1, %rcx             # Comparar x con 1
  jg .for                   # Si x > 1, repetir el ciclo

.return:
  movq %rbp, %rsp           # Restaurar el valor de %rsp
  popq %rbp                 # Restaurar el valor de %rbp
  ret                       # Retornar el valor de %rax