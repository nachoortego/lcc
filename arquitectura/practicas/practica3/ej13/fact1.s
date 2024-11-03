.global fact1
fact1:
  # Prologo de la función
  pushq %rbp                # Guardar el valor de %rbp en la pila
  movq %rsp, %rbp           # Establecer el nuevo valor de %rbp
  subq $16, %rsp            # Reservar espacio en la pila para variables locales

  # Base case: if (x <= 1) return x;
  movq %rdi, -8(%rbp)       # Guardar el valor de x en la pila
  cmpq $1, %rdi             # Comparar x con 1
  jg .recurse               # Si x > 1, saltar a la recursión
  movq %rdi, %rax           # Si x <= 1, retornar x
  jmp .done                 # Saltar al final

.recurse:
  # Recursive case: return x * fact1(x - 1);
  movq -8(%rbp), %rdi       # Cargar x en %rdi
  subq $1, %rdi             # Calcular x - 1
  call fact1                # Llamar recursivamente a fact1(x - 1)
  movq -8(%rbp), %rcx       # Cargar x en %rcx
  imulq %rcx, %rax          # Multiplicar x * fact1(x - 1)

.done:
  # Epilogo de la función
  addq $16, %rsp            # Restaurar el espacio de la pila
  movq %rbp, %rsp           # Restaurar el valor de %rsp
  popq %rbp                 # Restaurar el valor de %rbp
  ret                       # Retornar el valor de %rax