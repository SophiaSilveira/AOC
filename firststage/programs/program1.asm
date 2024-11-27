.text
.globl main

main:
    li $t0, 1           # Inicializa contador (t0) com 1
    li $t1, 5           # Define o limite (t1 = 5)

print_loop:
    # Imprime a mensagem "Contando: "
    li $v0, 4           # Código de syscall para imprimir string
    la $a0, message     # Endereço da mensagem
    syscall

    # Imprime o valor do contador
    li $v0, 1           # Código de syscall para imprimir inteiro
    move $a0, $t0       # Move o valor do contador para $a0
    syscall

    # Imprime uma nova linha
    li $v0, 4           # Código de syscall para imprimir string
    la $a0, newline     # Endereço da nova linha
    syscall

    addi $t0, $t0, 1    # Incrementa o contador
    ble $t0, $t1, print_loop # Continua o loop enquanto t0 <= t1

    # Finaliza o programa
    li $v0, 10          # Código de syscall para encerrar
    syscall
    
   .data
    message: .asciiz "Contando: "   # Mensagem inicial
    newline: .asciiz "\n"          # Quebra de linha

