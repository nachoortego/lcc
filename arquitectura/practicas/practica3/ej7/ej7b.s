.global main
main:
  movq $0x123456789ABCDEF0, %rbx   # Valor de ejemplo en rbx
  movq $0, %rax                    # %rax es el contador de bits en uno
  movq $64, %rcx                   # Inicializa %rcx con 64 para iterar sobre cada bit con loop

count_bits:
  ror $1, %rbx                     # Rota el bit menos significativo hacia la bandera CF
  adc $0, %rax                     # Suma el bit de acarreo a %rax (si CF=1, incrementa %rax)
  loop count_bits                   # Repite mientras %rcx no sea cero (64 iteraciones)

  # El resultado estará en %rax, que contiene el número de bits en uno
  ret
