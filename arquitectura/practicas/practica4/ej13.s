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
  EOR r5, r5, r5 @ i = 0
  LDR r6, =a @ r6 = a
  LDR r7, =b @ r7 = b
  LDR r8, =c @ r8 = c

for_loop:
  MOV r8, #0
  VMOV s0, r8

  ADD r5, r6, r4, LSL #2 @ r5 = [ a[i] ]
  VLDR s1, [r5] @ s1 = a[i]

  ADD r5, r7, r4, LSL #2 @ r5 = [ b[i] ]
  VLDR s2, [r5] @ s2 = b[i]

  VADD.F32 s0, s0, s1 @ c[i] += a[i]
  VADD.F32 s0, s0, s2 @ c[i] += b[i]
  VADD.F32 s3, s3, s0 @ suma += c[i]

  LDR r0, =format1
  VCVT.F64.F32 d1, s0 
  VMOV r1, r2, d1
  BL printf

  ADD r4, r4, #1 @ i++
  CMP r4, #5 @ i < 5
  BLT for_loop @ Si i < 5, sigue en el loop


  LDR r0, =format2
  VCVT.F64.F32 d1, s3 
  VMOV r1, r2, d1
  BL printf

  POP {lr}
  BX lr
  