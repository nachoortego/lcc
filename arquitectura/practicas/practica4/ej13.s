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
  LDR r6, =a @ r6 = a
  LDR r7, =b @ r7 = b
  LDR r8, =c @ r8 = c

for_loop:
  CMP r4, #5 @ i < 5

  ADD r5, r6, r4, LSL #2 @ r5 = [ a[i] ]
  VLDR s1, [r5] @ s1 = a[i]

  ADD r5, r7, r4, LSL #2 @ r5 = [ b[i] ]
  VLDR s2, [r5] @ s2 = b[i]

  ADD r5, r8, r4, LSL #2 @ r5 = [ c[i] ]
  VLDR s3, [r5] @ s3 = c[i]

  VADD.F32 s3, s3, s1 @ c[i] += a[i]
  VADD.F32 s3, s3, s2 @ c[i] += b[i]

  LDR r0, =format1
  LDR r7, [r8, r4, LSL #2] @ r7 = c[i]
  BL printf

  VADD.F32 s0, s0, s3 @ suma += c[i]

  ADD r4, r4, #1 @ i++
  BLT for_loop @ Si i < 5, sigue en el loop


  LDR r0, =format2
  VMOV r6, s0 @ r6 = suma
  BL printf

  POP {lr}
  BX lr
  