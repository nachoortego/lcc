.arch armv7-a
.fpu vfpv3

.global main
.text
determinante:
  @ a = s0, b = s1, c = s2, d = s3 
  PUSH {lr}
  VMUL.F32 s0, s0, s3 @ a*d
  VMUL.F32 s1, s1, s2 @ b*c
  VSUB.F32 s0, s0, s1 @ a*d - b*c

  POP {lr}
  BX lr
main:
  PUSH {lr}

  VMOV.F32 s0, #1.0 @ a = 1.0
  VMOV.F32 s1, #2.0 @ b = 2.0
  VMOV.F32 s2, #3.0 @ c = 3.0
  VMOV.F32 s3, #4.0 @ d = 4.0

  BL determinante

  POP {lr}
  BX lr

