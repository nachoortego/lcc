.data
a: .word 1, 2, 3, 4      @ Arreglo a[]
b: .word 2, 3, 4, 5      @ Arreglo b[]
format: .asciz "La suma es: %d\n"

.text
.global main
main:
  PUSH {lr}

  LDR r0, =a
  LDR r1, =b
  MOV r2, #4 @ int L = 4

  BL suma

  MOV r1, r0 @ r1 = resultado
  LDR r0, =format
  BL printf

  MOV r0, #0 @ return 0
  POP {lr}
  BX lr

suma:
  EOR r4, r4 @ i = 0
  EOR r5, r5 @ result = 0
loop:
  CMP r4, r2
  LDRLT r6, [r0, r4, LSL #2] @ r6 = a[i] (direccion de r0 + r4 * 4) (r0 + r4 << 2)
  LDRLT r7, [r1, r4, LSL #2] @ r7 = b[i] (direccion de r1 + r4 * 4) (r1 + r4 << 2)

  ADDLT r5, r6 @ result += a[i]
  ADDLT r5, r7 @ result += b[i]

  ADD r4, #1 @ i++
  BLT loop @ Si i < L, sigue en el loop

  MOV r0, r5 @ Devuelve el resultado en r0
  BX lr @ Retorna
  