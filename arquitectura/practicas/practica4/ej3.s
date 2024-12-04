.global main
main:
  LDR r6, =0xBEEFFACE       @ Cargar el valor 0xBEEFFACE en r6 usando una etiqueta
  MOV r3, #0x8000
  
  STR r6, [r3] @ Guarda 0xBEEFFACE a partir de la direccion r3
  LDRB r4, [r3] @ Toma el primer byte de la direccion r3 y lo guarda en r4

  @ LITTLE-ENDIAN r4 = CE
  @ BIG-ENDIAN r4 = BE
