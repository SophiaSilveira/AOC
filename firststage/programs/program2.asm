.text				 
	.globl	main	

main:
		xor 	$t0, $t0, $t0		# zera o 'i'

		la	$t1, n 
		lw	$t1, 0($t1)			

		la 	$t2, a				# get address of a  
		la 	$t3, b				# get address of b
		la 	$t5, constant		# carrega o endereço da constante
		lw 	$t5, 0($t5)			# carrega o valor da constante no registrador $t5

loop:	lw 	$t4, 0($t3)			# lê da memória b[i]

		add 	$t4, $t4, $t5		# calcula b[i]=b[i]+constant

		sw 	$t4, 0($t2)			# armazena em a[i]

		addi 	$t0, $t0, 1		# increment i 
		addi 	$t2, $t2, 4		# increment *a (+4 pois é word)
		addi 	$t3, $t3, 4		# increment *b (+4 pois é word)

		blt 	$t0, $t1, loop	# loop se i < n

end:	j	end


.data
n:	.word	5
a:	.word	  0x0   0x0   0x0   0x0   0x0
b:	.word	0x300 0x400 0x500 0x600 0x70
constant: .word 10		# constante agora como uma variável em memória
