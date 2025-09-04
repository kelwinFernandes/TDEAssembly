.data
    sequencia: .word 4, 3, 9, 5, 2, 1
    tamanho:   .word 6

.text
    .globl main

main:
    # Carrega o endereço da lista na memória para $s0
    la $s0, sequencia
    # Carrega o valor do tamanho da lista (6) para $s1
    lw $s1, tamanho

    li $t0, 0        # $t0 é o contador 'i' e começa em 0

    outer_loop:
        # Este laço compara os pares de números vizinhos para fazer as trocas.
        li $t1, 0    # $t1 é o contador 'j' e começa em 0
        
        # Calcula o limite do laço interno. O loop para quando j = tamanho - i - 1
        sub $t3, $s1, $t0   # $t3 = 6 - i
        addi $t3, $t3, -1   # $t3 = 6 - i - 1

        inner_loop:
            # Calcula o endereço do número atual (sequencia[j])
            sll $t4, $t1, 2       # $t4 = j * 4 (porque cada número ocupa 4 bytes)
            add $t5, $s0, $t4     # $t5 = endereço base + offset -> Endereço de sequencia[j]
            lw $t6, 0($t5)        # Carrega o valor de sequencia[j] para $t6
            
            # Calcula o endereço do próximo número (sequencia[j+1])
            addi $t4, $t4, 4      # $t4 = (j+1) * 4
            add $t7, $s0, $t4     # $t7 = endereço de sequencia[j+1]
            lw $t8, 0($t7)        # Carrega o valor de sequencia[j+1] para $t8

            # Se o número atual for menor ou igual ao próximo, a ordem está correta.
            # Se for maior, precisamos trocá-los.
            ble $t6, $t8, no_swap # Vai para 'no_swap' se $t6 <= $t8

            # Se a condição acima for falsa, a troca acontece aqui:
            sw $t8, 0($t5)      # Salva o valor de $t8 (o maior) na posição de sequencia[j]
            sw $t6, 0($t7)      # Salva o valor de $t6 (o menor) na posição de sequencia[j+1]

        no_swap:
            addi $t1, $t1, 1    # Incrementa o contador 'j' (j = j + 1)
            blt $t1, $t3, inner_loop # Se j < limite, volta para o laço interno

        addi $t0, $t0, 1    # Incrementa o contador 'i' (i = i + 1)
        blt $t0, $s1, outer_loop # Se i < tamanho, volta para o laço externo

    li $t0, 0   # Reinicia o contador 'i' para 0
    print_loop:
        # Calcula o endereço do elemento atual para imprimir
        sll $t1, $t0, 2
        add $t2, $s0, $t1
        lw $a0, 0($t2)      # Carrega o valor para o registrador de argumento $a0

        # Imprime o número
        li $v0, 1           # Código 1 para "imprimir inteiro"
        syscall

        # Imprime um espaço em branco
        li $a0, ' '         # Carrega o caractere de espaço em $a0
        li $v0, 11          # Código 11 para "imprimir caractere"
        syscall

        addi $t0, $t0, 1    # Incrementa o contador 'i'
        blt $t0, $s1, print_loop # Se i < tamanho, volta para imprimir o próximo

    li $v0, 10          # Código 10 para "terminar o programa"
    syscall
