    .data
var:      .word   50       # Inicializa a variável original com o valor 50
result:   .word   0        # Inicializa a variável para salvar o resultado final

    .text
    .globl main
main:
    # Inicializa os registradores
    lw   $t1, var         # Carrega o valor inicial de var (50) em $t1
    li   $t2, 5           # Define o divisor como 5

loop:
    # Verificar se o valor é 0
    beq  $t1, $zero, end  # Se $t1 (var) for 0, termina o loop

    # Dividir $t1 por $t2
    div  $t1, $t2         # Divide $t1 por $t2 (divisão inteira)
    mflo $t1              # Coloca o quociente em $t1

    # Retorna ao início do loop
    j    loop

end:
    # Armazenar o valor final na variável 'result'
    la   $t0, result      # Carrega o endereço de result
    sw   $t1, 0($t0)      # Salva o valor final em result

    # Finalizar o programa
    li   $v0, 10          # Código de syscall para terminar o programa
    syscall               # Termina a execução
