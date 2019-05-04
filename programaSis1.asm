.text
.globl main

main:
 j MyMain
# ROTINA PARA TRATAMENTO DAS CHAMADAS DE INTERRUPÇÃO
#####################################################
DesvioParaTratamentoDeInterrupcoes:
 subu $sp, $sp, 4
 sw $ra, 0($sp)
 la $k0, EnderecoUART
 lw $k0, 0($k0)
 sll $k0, $k0, 0x02
 la $k1, TabelaDeInterrupcoes
 addu $k0, $k0, $k1
 jalr $k0
 lw $ra, 0($sp)
 addiu $sp, $sp, 4
 eret
# ENDEREÇO DA TABELA DE ENDEREÇAMENTO DE INTERRUPÇÕES
########################################################
TabelaDeInterrupcoes:
 j CPU_TO_UART
 j UART_TO_CPU
# ROTINAS PARA TRATAR AS INTERRUPÇÕES
#####################################
CPU_TO_UART:
 subu $sp, $sp, 16
 sw $t0, 0($sp)
 sw $t1, 4($sp)
 sw $t2, 8($sp)
 sw $ra, 12($sp)
 ##
 la $t0, EnderecoUART
 addiu $t0,$t0,4
 
 ##
 lw $ra, 12($sp)
 lw $t2, 8($sp)
 lw $t1, 4($sp)
 lw $t0, 0($sp)
 addiu $sp, $sp, 20
 jr $ra
#############################################
UART_TO_CPU:
 subu $sp, $sp, 16
 sw $t0, 0($sp)
 sw $t1, 4($sp)
 sw $t2, 8($sp)
 sw $ra, 12($sp)
 ##
 lw $ra, 12($sp)
 lw $t2, 8($sp)
 lw $t1, 4($sp)
 lw $t0, 0($sp)
 addiu $sp, $sp, 20
 jr $ra
# INÍCIO DO PROGRAMA DO USUÁRIO NO ENDEREÇO
#############################################
MyMain:
 la $t3,string1
 lw $t3,0($t3)
 li $t0, 0
 li $t1, 0
 li $t2, 0
SaltoMyMain:
 addiu $t0, $t0, 1
 addu $t1, $t1, $t0
 addu $t2, $t1, $t0
 j DesvioParaTratamentoDeInterrupcoes
 j SaltoMyMain
# ENDEREÇO DA UART
##################
.data 0xFFE00000
EnderecoUART:

# SEGMENTO NORMAL DE DADOS
.data 0x10010000
string1:	.asciiz "Isto e um Teste"
string2:	.space 20