.arch armv7-a
.fpu vfpv3

.data
f: .asciz "HEX: %x \n"

.text
.global main
main:
  PUSH {lr}
  LDR r0, =f
  MOVW r1, #0x80
  MOVT r1, #0x040
  BL printf
  POP {lr}

  BX lr
