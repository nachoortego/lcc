.global main
main:
  MOV r0, #5

  @ Para hacer con argumentos 
  @ CMP r0, #2          @ Verificar si argc < 2 (necesitamos un argumento)
  @ BNE invalid         @ Si no hay argumentos, ir a invalid

  @ LDR r1, [r1, #4]    @ Cargar argv[1] (primer argumento de usuario) en r1
  @ BL atoi             @ Llamar a la función atoi para convertir texto a número


  CMP r0, #0          @ Verificar si i < 0
  BLT invalid         @ Si i < 0, ir a invalid

  CMP r0, #31         @ Verificar si i > 31
  BGT invalid         @ Si i > 31, ir a invalid

  MOV r1, #1          @ Inicializar r1 con 1
  MOV r0, r1, LSL r0  @ r0 = 1 << i (esto calcula 2^i)
  BX lr               @ Retornar el valor calculado

invalid:
  MOV r0, #0          @ Si i está fuera de rango, retornar 0
  BX lr               @ Retornar
