.text                # Segmento de código
.globl main          # Declaração de que 'main' é o ponto de entrada global

main:
        # Carregar endereços e valores iniciais
        la      $t0, var1        # Carrega o endereço de var1 em $t0
        li      $t1, 0      	  # Carrega o valor de var1 em $t1
        la      $t2, var2        # Carrega o endereço de var2 em $t2
        lw      $t3, 0($t2)      # Carrega o valor de var2 em $t3

loop:   
        # Comparar var1 e var2
        beq     $t1, $t3, end    # Se var1 == var2, pula para o fim
        addiu   $t1, $t1, 1      # Incrementa var1
        j       loop             # Volta para o início do loop

end:
        # Atualizar valor de var1 na memória
        sw      $t1, 0($t0)      # Salva o novo valor de var1
        li   $v0, 10      # Código de syscall para terminar o programa
        syscall           # Chama a syscall, finalizando a execução

.data                # Segmento de dados
var1:   .word   0    # Inicializa a variável com 0
var2:   .word   5    # Inicializa a variável com 5
