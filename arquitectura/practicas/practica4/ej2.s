MOV r3, 0x8000

STR r6, [r3, #12]     @ se guarda el valor de r6 en la direccion 0x800C

STRB r7, [r3], #4     @ se guarda el valor de los primeros 8 bits de r7 en la direccion 0x8000
                      @ y se incrementa r3 pasa a valer 0x8004

LDRH r5, [r3], #8     @ se guarda el valor de los primeros 16 bits desde la direccion 0x8000 en r5
                      @ y se incrementa r3 pasa a valer 0x800C

LDR r12, [r3, #12]!   @ se guarda el valor de los primeros 32 bits desde la direccion 0x800C en r12
                      @ y se decrementa r3 pasa a valer 0x8000
                      @ es decir, se suman los 12 para almacenar y luego vuelve a su estado inicial
