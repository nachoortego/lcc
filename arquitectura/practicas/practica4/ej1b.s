.global main
main:
  MOV r4, #8                    @ Cargar el índice 8 en r4
  LDR r3, [r2, r4, LSL #2]      @ Cargar array[8] en r3 (8 * 4 bytes = 32)
  ADD r3, r1                    @ Sumar y (r1) a array[8] (r3)

  MOV r4, #10                   @ Cargar el índice 10 en r4
  STR r3, [r2, r4, LSL #2]      @ Almacenar el resultado en array[10] (10 * 4 bytes = 40)
  BX lr                         @ Retornar
  