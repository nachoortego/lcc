.arch armv7-a
.fpu vfpv3

.data
a: .float 1.0, 2.0, 3.0, 4.0, 5.0
b: .float 2.0, 4.0, 6.0, 8.0, 10.0
c: .space 20 @ sizeof(float) * size
size: .long 5
fmt_f: .asciz "%f\n"
fmt_s: .asciz "La suma de las componentes es: %f\n"

.text
.global main
main:
  push {lr}
  sub sp, #24

  ldr r0, =a
  str r0, [sp, #20] @ float a[5] = ...;

  ldr r0, =b
  str r0, [sp, #16]  @ float b[5] = ...;

  ldr r0, =c
  str r0, [sp, #12]  @ float c[5];

  ldr r0, =size
  ldr r0, [r0]
  str r0, [sp, #8]     @ int size = 5;

  mov r0, #0
  vmov.f32 s0, r0
  vstr.f32 s0, [sp, #4] @ float suma = 0;
  
  mov r0, #0
  str r0, [sp] @ int i = 0;

for_loop:
  @ cargar i
  ldr r3, [sp]

  @ cargar a[i]
  ldr r1, [sp, #20]
  add r1, r1, r3, LSL #2
  vldr s1, [r1]
  
  @ cargar b[i] 
  ldr r1, [sp, #16]
  add r1, r1, r3, LSL #2
  vldr s2, [r1]

  @ c[i] = a[i] + b[i] > s0
  vadd.f32 s0, s1, s2 @ a[i] + b[i]  
  ldr r1, [sp, #12]
  add r1, r1, r3, LSL #2
  vstr.f32 s0, [r1] @ c[i] = a[i] + b[i]

  @ llamada printf
  vcvt.f64.f32 d0, s0
  vmov r1, r2, d0
  ldr r0, =fmt_f
  bl printf

  @ cargar i
  ldr r3, [sp]

  @ suma += c[i]
  vldr s1, [sp, #4]
  ldr r1, [sp, #12]
  add r1, r1, r3, LSL #2
  vldr s2, [r1]
  vadd.f32 s0, s1, s2
  vstr s0, [sp, #4]

  @ i++
  add r3, #1
  str r3, [sp]
  
  ldr r2, [sp, #8]
  cmp r3, r2
  blt for_loop

  @ printear suma
  vldr s0, [sp, #4]
  vcvt.f64.f32 d0, s0
  vmov r1, r2, d0
  ldr r0, =fmt_s
  bl printf  

  add sp, #24
  eor r0, r0
  pop {lr}
  bx lr
  