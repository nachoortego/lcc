.arch armv7-a
.fpu vfpv3

.data
  f: .float 3.14
  g: .float 5.6
  str: .asciz "%f %f\n"
.text
.global main
main:
  push {r7,lr}            @ Se pushea r7 para alinear el SP a 8 bytes
  ldr r0, =str            @ Primer argumento (cadena de formato)
  ldr r3, =f
  vldr.32 s15, [r3]
  vcvt.f64.f32 d1, s15    @ Convertimos a double
  vmov r2, r3, d1         @ Segundo argumento en r2 y r3
  ldr r5, =g
  vldr.32 s15, [r5]
  vcvt.f64.f32 d1, s15    @ Convertimos a double
  vmov r4, r5, d1
  push {r4, r5}           @ Tercer argumento en pila
  bl printf
  mov r0, #0
  pop {r4,r5,r7,pc}
  bx lr
