.text
    .globl main

main:
    # Carrega os valores de x e y
    lw $a0, x          # Carrega o valor de x em $a0
    lw $a1, y          # Carrega o valor de y em $a1
    li $t0, 0          # Inicializa z (acumulador) com 0
    li $t2, 0          # Inicializa um contador (contador de iterações) com 0

loop:
    beq $t2, $a1, end_loop  # Se o contador (t2) for igual a y (a1), sai do loop
    addu $t0, $t0, $a0      # Soma x (a0) ao acumulador (z em t0)
    addiu $t2, $t2, 1       # Incrementa o contador (t2) com adição sem sinal
    j loop                  # Continua o loop

end_loop:
    sw $t0, z                # Armazena o resultado em z

    # Finaliza o programa
    li $v0, 10               # Syscall para encerrar o programa
    syscall

.data
x: .word 5                 # Valor de x
y: .word 3                 # Valor de y
z: .space 4                # Espaço para o resultado de z
