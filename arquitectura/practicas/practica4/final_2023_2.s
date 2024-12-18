.data
d: .word 4
f: .word 0
format: .asciz "La suma es %d\n"

.text
.global main
main:
  PUSH {lr}
  
  MOV r0, #1  @ a = 1
  MOV r1, #2  @ b = 2
  MOV r2, #3  @ c = 3
  LDR r3, =d    @ Carga la dirección de d en r3
  LDR r3, [r3]  @ Carga el valor contenido en esa dirección en r3
  
  MOV r4, #5
  PUSH {r4}

  BL suma

  MOV r1, r0
  LDR r0, =format
  BL printf

  POP {lr}
  BX lr

suma:
  POP {r4}
  LDR r5, =f
  LDR r5, [r5]

  ADD r5, r5, r0
  ADD r5, r5, r1
  ADD r5, r5, r2
  ADD r5, r5, r3
  ADD r5, r5, r4


  CMP r5, #20
  MOVGT r0, #99
  MOVLE r0, r5

  BX lr