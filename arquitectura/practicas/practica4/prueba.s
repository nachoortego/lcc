.data
  array: .word 1, 2, 3, 4, 5, 6
  str: .asciz "%d %d %d %d %d %d\n"
.text
.global main
main:
  push {ip,lr}
  ldr r0, =str @ primer argumento (direcci´on de la cadena de formato)
  ldr r7, =array
  ldr r1, [r7] @ segundo argumento
  ldr r2, [r7,#4] @ tercer argumento
  ldr r3, [r7,#8] @ cuarto argumento
  ldr r4, [r7,#12] @ quinto argumento
  ldr r5, [r7,#16] @ sexto argumento
  ldr r6, [r7,#20] @ septimo argumento
  push {r4-r6} @ se pushean en la pila los argumentos 5, 6 y 7
  bl printf
  pop {r4-r6,ip,lr}
  bx lr


@ arm-linux-gnueabi-gcc -static -o prueba prueba.s
@ qemu-arm-static prueba
