.text
.globl main

main:
    # Inicializar registradores
    li $t0, 0               # Índice (i = 0)
    la $t1, array           # Endereço base da matriz de entrada
    la $t2, result          # Endereço base da matriz de saída

loop:
    # Carregar dado da matriz original para a variável t3
    lw $t3, 0($t1)          # Carrega array[i] em $t3

    # Operação simulada (incrementar o valor)
    addiu $t3, $t3, 1       # Incrementa o valor carregado (array[i] + 1)

    # Armazenar o resultado na matriz de saída
    sw $t3, 0($t2)          # Salva o resultado na posição correspondente da matriz result

    # Atualizar endereços e índice
    addiu $t0, $t0, 1       # Incrementa o índice (i++)
    addiu $t1, $t1, 4       # Avança para o próximo elemento na matriz de entrada (4 bytes por palavra)
    addiu $t2, $t2, 4       # Avança para o próximo elemento na matriz de saída (4 bytes por palavra)

    # Verificar se o índice i < 8 (tamanho do array)
    li $t4, 8               # Carrega o valor 8 em $t4 (tamanho do array)
    bne $t0, $t4, loop      # Se i != 8, repete o loop

exit:
    li $v0, 10              # Syscall para finalizar o programa
    syscall
    
.data
array: .word 1, 2, 3, 4, 5, 6, 7, 8  # Dados na memória principal (32 bytes)
result: .space 32                   # Espaço para resultados (32 bytes)

