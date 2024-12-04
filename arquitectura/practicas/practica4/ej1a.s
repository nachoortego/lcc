.global main
main:
  MOV r3, #7                 @ Cargar el índice 7 en r3
  LDR r0, [r2, r3, LSL #2]   @ x = array[7]
  ADD r0, r1                 @ x = x + y
  BX lr                      @ return x
