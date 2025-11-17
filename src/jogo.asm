TITLE Bot
.MODEL SMALL
.STACK 100h
.DATA
  MSG_BEMVINDO DB 'JOGO DA VELHA', 13, 10, 13, 10, '$'
  MSG1 DB 'Selecione o modo de jogo (0 - Multiplayer | 1 - Computador)', 13, 10, 13, 10,'Digite a sua opcao: $'
  MSG2 DB 10,10,'Tente novamente, digito nao reconhecido...',13, 13, 10, '$'
  MATRIZ DB 31H, 32H, 33H
         DB 34H, 35H, 36H
         DB 37H, 38H, 39H
  VETOR_G DB 9 DUP (?) ; [ , , , , , , , , ]

  MSG_ZERO DB 13, 10, 'A opcao selecionada foi a opcao MULTIPLAYER.', 13, 10, '$'
  MSG_UM DB 13, 10, 'A opcao selecionada foi a opcao JOGO COM COMPUTADOR.', 13, 10, '$'

  MSG_INSIRA_POSICAO DB 'Escolha a posicao da jogada(Opcoes: 1 A 9): $'

  MSG_INVALIDO DB 'Posicao invalida. Tente novamente... $', 13, 10

  MSG_EMPATE DB 'Empate! $'

  MSG_VEZ_J1 DB 'Vez do jogador 1 $'
  MSG_VEZ_J2 DB 'Vez do jogador 2 $'

  MSG_GANHOU_J1 DB 'Jogador 1 ganhou $'
  MSG_GANHOU_J2 DB 'Jogador 2 ganhou $'

.CODE
INCLUDE macros.inc
INCLUDE procs.inc

  VERIFICACAO_VIABILIDADE MACRO 

    CMP BL, 9
    JB CONTINUA1
    TEST BL, 0
    JNZ CONTINUA1

    MOV AH, 09H
    LEA DX, MSG_INVALIDO
    INT 21H
    JMP LEITURA
  ENDM

  JOGO_MULTIPLAYER PROC ; procedimento de inicialização da opção multiplayer
  PUSHALL
  MOV CX, 9

  MOV AH, 09H
  MOV DX, OFFSET MSG_ZERO
  INT 21h

  NOVAMENTE:
    CALL IMPRIME_MATRIZ

  LEITURA:    
    MOV AH, 09H ; 
    LEA DX, MSG_INSIRA_POSICAO ; 
    INT 21H ; 

    MOV AH, 01H
    INT 21H

    XOR BX,BX
    MOV BL,AL
    AND BL, 0FH
    SUB BL,1

    VERIFICACAO_VIABILIDADE

CONTINUA1:

    PULA_LINHA

    VERIFICA_PARIDADE: ; SE CH FOR ÍMPAR -> VEZ DO J1
                       ; SE CH FOR PAR -> VEZ DO J2

      TEST CX, 1
      JZ IMPAR

      PAR:
        MOV BYTE PTR MATRIZ[BX], 6Fh
        MOV BYTE PTR VETOR_G[BX], 6Fh
        JMP RETORNA_PRINCIPAL

      IMPAR:
        MOV BYTE PTR MATRIZ[BX], 78h
        MOV BYTE PTR VETOR_G[BX], 78h

      RETORNA_PRINCIPAL:
        LOOP NOVAMENTE
    FIM_JOGO:
      CALL IMPRIME_MATRIZ
      POPALL
    RET
  JOGO_MULTIPLAYER ENDP

 MAIN PROC 
    MOV AX,@DATA      ;Inicialização dos dados
    MOV DS,AX

    CALL INICIALIZACAO    ;Iniciação do jogo

    CMP AL, 0         ;Condição para entrar no modo multiplayer
    JZ ESCOPO_ZERO    ;Condição 

    ESCOPO_UM:
      CALL IMPRIME_UM
      JMP FIM_PROGRAMA

    ESCOPO_ZERO:   
      CALL JOGO_MULTIPLAYER
      JMP FIM_PROGRAMA

    FIM_PROGRAMA:
      MOV AH, 4CH     ;Devolve o controle 
      INT 21H
 MAIN ENDP
END MAIN