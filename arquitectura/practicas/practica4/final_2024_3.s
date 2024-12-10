.arch armv7-a
.fpu vfpv3

.data
a: .float 4095.0
b: .float 80.0
three: .float 3.0
format: .asciz "El resultado es: %f\n"

.text
.global main

promedio:
  VADD.F32 s0, s0, s1
  VADD.F32 s0, s0, s2
  LDR r0, =three
  VLDR.F32 s3, [r0]
  VDIV.F32 s0, s0, s3  @ Dividir s0 por s3
  BX lr
main:
  PUSH {lr}

  LDR r1, =a
  LDR r2, =b
  VLDR.F32 s1, [r1]
  VLDR.F32 s2, [r2]
  VMUL.F32 s0, s1, s2

  BL promedio

  VCVT.F64.F32 d1, s0
  VMOV r1, r2, d1
  LDR r0, =format
  BL printf
  EOR r0, r0

  POP {lr}
  BX lr
