.arch armv7-a
.fpu vfpv3

.data
a: .float 1.0, 2.0, 3.0, 4.0, 5.0      @ Arreglo a[]
b: .float 2.0, 4.0, 6.0, 8.0, 10.0     @ Arreglo b[]
c: .space 20
format1: .asciz "%f\n"
format2: .asciz "La suma de las componentes es: %f\n"

.text
.global main
main:
  PUSH {lr}

  EOR r4, r4, r4 @ i = 0
  LDR v1, =a @ v1 = a
  LDR v2, =b @ v2 = b
  LDR v3, =c @ v3 = c

for_loop:
  CMP r4, #5 @ i < 5

  VLDR s1, [v1, r4, LSL #2] @ s1 = a[i]
  VLDR s2, [v2, r4, LSL #2] @ s2 = b[i]
  VLDR s3, [v3, r4, LSL #2] @ s3 = c[i]

  VADD.F32 s3, s3, s1 @ c[i] += a[i]
  VADD.F32 s3, s3, s2 @ c[i] += b[i]

  LDR r0, =format1
  LDR r2, [v3, r4, LSL #2] @ r2 = c[i]
  BL printf

  VADD.F32 s0, s0, s3 @ suma += c[i]

  ADD r4, r4, #1 @ i++
  BLT for_loop @ Si i < 5, sigue en el loop


  LDR r0, =format2
  VMOV r1, s0 @ r1 = suma
  BL printf

  POP {lr}
  BX lr
  