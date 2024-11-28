.data
array: .word 1, 2, 3, 4, 5, 6, 7, 8  # Dados na memória principal (32 bytes)
result: .space 32                   # Espaço para resultados

.text
.globl main

main:
    # Configurar registradores
    li $t0, 0               # Índice (i = 0)
    la $t1, array           # Endereço base da matriz de entrada
    la $t2, result          # Endereço base da matriz de saída

loop:
    # Carregar dado da matriz original para a cache
    lw $t3, 0($t1)          # Carrega array[i] para $t3 (leitura)

    # Operação simulada (incrementar o valor)
    addi $t3, $t3, 1        # Incrementa o valor carregado

    # Armazenar o resultado na matriz de saída
    sw $t3, 0($t2)          # Salva o resultado na posição correspondente (escrita)

    # Atualizar endereços e índice
    addi $t0, $t0, 1        # i++
    addi $t1, $t1, 4        # Próximo elemento no array de entrada
    addi $t2, $t2, 4        # Próximo elemento no array de saída

    # Verificar se i < 8 (tamanho do array)
    li $t4, 8
    bne $t0, $t4, loop      # Repete até processar todos os elementos

exit:
    li $v0, 10              # Finaliza o programa
    syscall
