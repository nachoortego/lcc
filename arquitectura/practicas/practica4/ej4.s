.global main
main:
  EOR r7, r7, r7
  MOV r7, #0x8C, 4   @ 0x0000008C → rotación → 0x00008C00 
  MOV r7, #0x42, 30  @ 60 % 32 = 28 bits a la derecha. r7 = 0xC0000008
  MVN r7, #2 @ 0x00000002 → Complemento NOT → 0xFFFFFFFD
  MVN r7, #0x8C, 4 @ 0x00008C00 → Complemento NOT → 0xFFFF73FF
  BX lr


