.data
	n1: .word  2025 #criando variavel int do ano 2025
	n2: .word  2002 #criando variavel int do meu ano de nascimento
.text
	lw $t0, n1 #movendo variavel n1 da memoria para o registrador t0
	lw $t1, n2 #movendo variavel n2 da memoria para o registrador t1
	
	add $t2, $t0, $t1 #somando registradores t1 e t2 e salvando resultado para o registrador t2
	
	li $v0, 1 #instrucao para impressao de inteiro
	
	move $a0, $t2 #movendo o resultado do registrador t2 para o registrador a0, que é o argumento, ou seja o registrador que pode ser impresso
	
	syscall #chamando a execucao do sistema