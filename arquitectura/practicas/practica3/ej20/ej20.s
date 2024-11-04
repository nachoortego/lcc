.data
case_1: .asciz "La cantidad de argumentos es insuficiente\n"
case_2: .asciz "Cantidad de argumentos: %d, suma de los argumentos: %d\n"

.text
.global main
main:
  # Alinea el stack antes de la llamada a funcion
  pushq %rbp
  movq %rsp, %rbp

  # Obtener argc y argv
  movq %rdi, %r12  # argc
  movq %rsi, %r13  # argv

  # argc < 2
  cmpq $2, %r12
  jg case2

case1:
  movq $case_1, %rdi # El primer argumento es el formato.
  xorq %rax, %rax # Cantidad de valores de punto flotante.
  call printf
  jmp end # Llama al printf y salta al final

case2:
  xor %r14, %r14 # r14 es el valor de suma, inicializado en 0
  movq $1, %rbx  # Inicializar el índice del bucle en 1

for_loop:
  cmpq %r12, %rbx  # Comparar el índice con argc
  jge print_result # Si el índice es mayor o igual a argc, salir del bucle

  # Convertir argv[rbx] a entero y sumarlo a r14
  movq (%r13,%rbx,8), %rdi  # Cargar argv[rbx] en rdi. 
                           # Multiplica por 8 porque las entradas de argv son punteros de 8 bytes
  call atoi
  addq %rax, %r14  # Sumar el resultado de atoi a r14
  incq %rbx  # Incrementar el índice
  
  jmp for_loop

print_result:
  # Imprimir la cantidad de argumentos y la suma
  movq %r12, %rsi     # Primer argumento: argc en %rsi
  movq %r14, %rdx     # Segundo argumento: suma en %rdx
  movq $case_2, %rdi  # formato
  xorq %rax, %rax     # cantidad de valores de punto flotante
  call printf

end:
  # Restaura el stack a su posicion original
  movq %rbp, %rsp
  popq %rbp
  ret

