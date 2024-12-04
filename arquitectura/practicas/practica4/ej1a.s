.global main
main:
  LDR r0, [r2, #7, LSL #2]   @ x = array[7]
  ADD r0, r1                 @ x = x + y
  BX lr                      @ return x

  STR 