.data
f_foo: .asciz "Todos los argumentos deben ser positivos\n"
f_calc: .asciz "Resultado: %d\n"

.text
.global main
calculo:
  POP {r4}
  PUSH {lr}

  CMP r0, #0
  BLLE foo
  BLE end_calculo
  CMP r1, #0
  BLLE foo
  BLE end_calculo
  CMP r2, #0
  BLLE foo
  BLE end_calculo
  CMP r3, #0
  BLLE foo
  BLE end_calculo
  CMP r4, #0
  BLLE foo
  BLE end_calculo

  ADD r0, r1
  ADD r0, r2
  ADD r0, r3
  ADD r0, r4

  MOV r1, r0
  LDR r0, =f_calc
  BL printf

end_calculo:
  POP {lr}
  BX lr

foo:
  PUSH {lr}
  LDR r0, =f_foo
  BL printf
  MVN r0, #0
  POP {lr}
  BX lr
  
main:
  PUSH {lr}

  MOV r0, #1
  MOV r1, #2
  MOV r2, #3
  MOV r3, #4
  MOV r4, #5
  PUSH {r4}
  
  BL calculo

  POP {lr}
  BX lr
