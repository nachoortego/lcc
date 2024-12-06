.data
format:  .asciz "El resultado es %d\n"

.text
.global main
main:
  PUSH {lr}

  MOV     r2, #0          // res = 0
  MOV     r3, #5          // r3 = i
  MOV     r4, #1          // r4 = j

loop:
  TST     r4, #1          // Compara si j es impar (j & 1)

  ADDNE   r2, r3          // Si es impar, res += i
  SUBNE   r4, #1          // j -= 1

  LSLEQ   r3, r3, #1      // i *= 2
  LSREQ   r4, r4, #1      // j /= 2

  CMP     r4, #1          // Compara si j > 1
  BHI     loop            // Si j > 1, sigue en el loop


  ADD     r2, r3          // Agrega i al resultado final

  MOV     r1, r2          // Devuelve el resultado en r1
  LDR     r0, =format     // Carga la dirección de format en r0
  BL      printf          // Llama a printf
  POP {lr}
  BX      lr              // Retorna
