@ 3. Escribir una funcion denominada calculo en lenguaje ensamblador ARM que realice lo siguiente: La funcion calculo
@ recibe cinco argumentos enteros y retorna un entero.En caso de que todos los argumentos sean positivos, realiza la 
@ suma de los mismos, imprime el resultado de la suma y retorna dicho valor. En caso de que alguno de los argumentos sea 
@ negativo o nulo, la funcion calculo debe llamar a otra funcion denominada foo que imprime un mensaje de error por pantalla
@  y retornar -1. La funcion foo no tiene argumentos de entrada, debe imprimir el mensaje por pantalla "Todos los argumentos 
@  deben ser positivos" y retornar -1 a la funcion calculo
.data
f_foo: .asciz "Todos los argumentos deben ser positivos\n"
f_calc: .asciz "Resultado: %d\n"

.text
.global main
calculo:
  LDR r4, [sp]

  CMP r0, #0
  BLLE foo
  CMP r1, #0
  BLLE foo
  CMP r2, #0
  BLLE foo
  CMP r3, #0
  BLLE foo
  CMP r4, #0
  BLLE foo

  ADD r0, r1
  ADD r0, r2
  ADD r0, r3
  ADD r0, r4

  MOV r1, r0
  LDR r0, =f_calc
  BL printf

end_calculo:
BX lr


foo:
  LDR r0, =f_foo
  BL printf
  MVN r0, #0
  BX lr
  
main:
  PUSH {lr}
  SUB sp, sp, #12
  MOV r4, #5
  STR r4, [sp]

  MOV r0, #1
  MOV r1, #2
  MOV r2, #3
  MOV r3, #4
  
  BL calculo

  POP {lr}
  BX lr
