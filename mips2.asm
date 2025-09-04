.data
    sequencia: .word 4, 3, 9, 5, 2, 1
    tamanho:   .word 6

.text
    .globl main

main:
    # Carrega o endere�o da lista na mem�ria para $s0
    la $s0, sequencia
    # Carrega o valor do tamanho da lista (6) para $s1
    lw $s1, tamanho

    li $t0, 0        # $t0 � o contador 'i' e come�a em 0

    outer_loop:
        # Este la�o compara os pares de n�meros vizinhos para fazer as trocas.
        li $t1, 0    # $t1 � o contador 'j' e come�a em 0
        
        # Calcula o limite do la�o interno. O loop para quando j = tamanho - i - 1
        sub $t3, $s1, $t0   # $t3 = 6 - i
        addi $t3, $t3, -1   # $t3 = 6 - i - 1

        inner_loop:
            # Calcula o endere�o do n�mero atual (sequencia[j])
            sll $t4, $t1, 2       # $t4 = j * 4 (porque cada n�mero ocupa 4 bytes)
            add $t5, $s0, $t4     # $t5 = endere�o base + offset -> Endere�o de sequencia[j]
            lw $t6, 0($t5)        # Carrega o valor de sequencia[j] para $t6
            
            # Calcula o endere�o do pr�ximo n�mero (sequencia[j+1])
            addi $t4, $t4, 4      # $t4 = (j+1) * 4
            add $t7, $s0, $t4     # $t7 = endere�o de sequencia[j+1]
            lw $t8, 0($t7)        # Carrega o valor de sequencia[j+1] para $t8

            # Se o n�mero atual for menor ou igual ao pr�ximo, a ordem est� correta.
            # Se for maior, precisamos troc�-los.
            ble $t6, $t8, no_swap # Vai para 'no_swap' se $t6 <= $t8

            # Se a condi��o acima for falsa, a troca acontece aqui:
            sw $t8, 0($t5)      # Salva o valor de $t8 (o maior) na posi��o de sequencia[j]
            sw $t6, 0($t7)      # Salva o valor de $t6 (o menor) na posi��o de sequencia[j+1]

        no_swap:
            addi $t1, $t1, 1    # Incrementa o contador 'j' (j = j + 1)
            blt $t1, $t3, inner_loop # Se j < limite, volta para o la�o interno

        addi $t0, $t0, 1    # Incrementa o contador 'i' (i = i + 1)
        blt $t0, $s1, outer_loop # Se i < tamanho, volta para o la�o externo

    li $t0, 0   # Reinicia o contador 'i' para 0
    print_loop:
        # Calcula o endere�o do elemento atual para imprimir
        sll $t1, $t0, 2
        add $t2, $s0, $t1
        lw $a0, 0($t2)      # Carrega o valor para o registrador de argumento $a0

        # Imprime o n�mero
        li $v0, 1           # C�digo 1 para "imprimir inteiro"
        syscall

        # Imprime um espa�o em branco
        li $a0, ' '         # Carrega o caractere de espa�o em $a0
        li $v0, 11          # C�digo 11 para "imprimir caractere"
        syscall

        addi $t0, $t0, 1    # Incrementa o contador 'i'
        blt $t0, $s1, print_loop # Se i < tamanho, volta para imprimir o pr�ximo

    li $v0, 10          # C�digo 10 para "terminar o programa"
    syscall
