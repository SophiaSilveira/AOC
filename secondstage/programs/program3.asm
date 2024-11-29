.text
    .globl main

main: 
    lw $a0, a               # Carrega base (a) em $a0
    lw $a1, b               # Carrega expoente (b) em $a1
    jal power               # Chama a função power
    sw $v0, res1            # Salva o resultado em res1

    lw $a0, b               # Carrega base (b) em $a0
    lw $a1, a               # Carrega expoente (a) em $a1
    jal power               # Chama a função power novamente
    sw $v0, res2            # Salva o resultado em res2

    li $v0, 10              # Encerrar o programa
    syscall

power:
    li $v0, 1               # Inicializa o acumulador com 1 (v0 = 1)
loop:
    blez $a1, retorno       # Enquanto o expoente ($a1) > 0, continua o loop
    MULTU $v0, $a0          # Multiplica acumulador (v0) pela base (a0)
    MFLO $v0                # Move o resultado da multiplicação para $v0
    SUBU $a1, $a1, 1        # Decrementa o expoente (a1 = a1 - 1)
    j loop                  # Volta para o início do loop

retorno:
    jr $ra                  # Retorna para a função chamadora

.data
a: .word 2                  # Base a = 2
b: .word 3                  # Base b = 3
res1: .space 4              # Resultado para a^b
res2: .space 4              # Resultado para b^a
