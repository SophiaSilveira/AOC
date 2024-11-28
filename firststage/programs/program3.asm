.text
 	.globl main

main: 
 	lw $a0, a                # Carrega o valor de 'a' em $a0
 	lw $a1, b                # Carrega o valor de 'b' em $a1
 	jal power                # Chama a função 'power'
 	sw $t0, res1             # Salva o resultado em 'res1'

 	lw $a0, b                # Carrega o valor de 'b' em $a0
 	lw $a1, a                # Carrega o valor de 'a' em $a1
 	jal power                # Chama a função 'power'
 	sw $t0, res2             # Salva o resultado em 'res2'

 	li $v0, 10               # Syscall para encerrar o programa
 	syscall

power:
 	li $t0, 1                # Inicializa o acumulador com 1
loop:
 	ble $a1, $zero, retorno  # Se $a1 <= 0, sai do loop
 	subi $a1, $a1, 1         # Decrementa $a1
 	j loop                   # Retorna ao início do loop

retorno: 
 	jr $ra                   # Retorna para o chamador

.data
 a: .word 2                  # Base
 b: .word 3                  # Expoente
 res1: .space 4              # Resultado de a^b
 res2: .space 4              # Resultado de b^a
