.global main
main:
  MOV     r2, #0          // res = 0
  MOV     r3, r0          // r3 = i
  MOV     r4, r1          // r4 = j

loop:
  TST     r4, #1          // Compara si j es impar (j & 1)

  ADDNE     r2, r3        // Si es impar, res += i
  SUBNE     r4, #1        // j -= 1

  LSLEQ     r3, r3, #1    // i *= 2
  LSREQ     r4, r4, #1    // j /= 2

  CMP     r4, #1          // Compara si j > 1
  BNE     loop            // Si j > 1, sigue en el loop


  ADD     r2, r3          // Agrega i al resultado final
  MOV     r0, r2          // Devuelve el resultado en r0
  BX      lr              // Retorna
