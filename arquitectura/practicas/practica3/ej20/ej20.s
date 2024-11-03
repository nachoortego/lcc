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
  movq %rdi, %r8  # argc
  movq %rsi, %r9  # argv

  # argc < 2
  cmpq $2, %r8
  jg case2

case1:
  movq $case_1, %rdi # El primer argumento es el formato.
  xorq %rax, %rax # Cantidad de valores de punto flotante.
  call printf
  jmp end # Llama al printf y salta al final

case2:
  xor %rdx, %rdx # rdx es el valor de suma, inicializado en 0
  movq $1, %rcx  # Inicializar el índice del bucle en 1

for_loop:
  cmpq %r8, %rcx  # Comparar el índice con argc
  jge print_result # Si el índice es mayor o igual a argc, salir del bucle

  # Convertir argv[rcx] a entero y sumarlo a rdx
  movq (%r9,%rcx,8), %rdi  # Cargar argv[rcx] en rdi. 
                           # Multiplica por 8 porque las entradas de argv son punteros de 8 bytes
  call atoi
  addq %rax, %rdx  # Sumar el resultado de atoi a rdx

  incq %rcx  # Incrementar el índice
  
  jmp for_loop

print_result:
  # Imprimir la cantidad de argumentos y la suma
  movq %r8, %rsi     # Primer argumento: argc en %rsi , Segundo argumento: suma ubicada ya en %rdx
  movq $case_2, %rdi # formato
  xorq %rax, %rax    # cantidad de valores de punto flotante
  call printf

end:
  # Restaura el stack a su posicion original
  movq %rbp, %rsp
  popq %rbp
  ret



# Implementación de atoi
atoi:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp # Reserva espacio en la pila
  movq %rdi, -8(%rbp) # rdi es el puntero a la cadena argv[], y lo guarda en la pila
  movl $0, %eax # acumulador = 0
  movl $0, %ecx # indice = 0
atoi_loop:
  movzbl (%rdi,%rcx,1), %edx # movzbl convierte un byte a 4 bytes, y carga el byte actual
                             # de la cadena argv[rcx] en %edx
  testb %dl, %dl # Comprueba que el byte no sea nulo
  je atoi_done # Si llego al final de la cadena, termina
  subl $48, %edx # Convierte ascii a numero
  imull $10, %eax # Multiplica el acumulador por 10
  addl %edx, %eax # Suma el numero al acumulador
  incl %ecx # Incrementa el indice
  jmp atoi_loop
atoi_done:
  leave
  ret
