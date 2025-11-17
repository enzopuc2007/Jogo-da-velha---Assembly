TITLE Bot
.MODEL SMALL
.STACK 100h
; Warning !!!
; Program is running well only in debug mode.
; Please, execute in debug mode for this period of time.
.DATA
  MSG_BEMVINDO DB 'JOGO DA VELHA', 13, 10, 13, 10, '$'
  MSG1 DB 'Selecione o modo de jogo (0 - Multiplayer | 1 - Computador)', 13, 10, 13, 10,'Digite a sua opcao: $'
  MSG2 DB 10,10,'Tente novamente, digito nao reconhecido...',13, 13, 10, '$'
  ; MSG3 DB 'Insira o numero da linha em que você deseja inserir a sua peça do jogo (1 a 3): $', 13, 10
  ; MSG4 DB 'Insira o numero da coluna em que você deseja inserir a sua peça do jogo (1 a 3): $', 13, 10
  MATRIZ DB 3 DUP (3 DUP (?)) ; define a matriz de jogo da velha
  VETOR_G DB 9 DUP (?) ; [ , , , , , , , , ]

  MSG_ZERO DB 13, 10, 'A opcao selecionada foi a opcao MULTIPLAYER.', 13, 10, '$'
  MSG_UM DB 13, 10, 'A opcao selecionada foi a opcao JOGO COM COMPUTADOR.', 13, 10, '$'

  MSG_INSIRA_LINHA DB 'Escolha a linha da jogada(Opcoes: 0, 3 ou 6): $'
  MSG_INSIRA_COLUNA DB 'Escolha a coluna da jogada(Opcoes: 0, 1 ou 2): $'

  MSG_EMPATE DB 'Empate! $'

  MSG_VEZ_J1 DB 'Vez do jogador 1 $'
  MSG_VEZ_J2 DB 'Vez do jogador 2 $'

  MSG_GANHOU_J1 DB 'Jogador 1 ganhou $'
  MSG_GANHOU_J2 DB 'Jogador 2 ganhou $'

.CODE
INCLUDE macros.inc
INCLUDE procs.inc
  JOGO_MULTIPLAYER PROC ; procedimento de inicialização da opção multiplayer

  PUSHALL
    ; MOV CH, 9

    MOV AH, 09H
    MOV DX, OFFSET MSG_ZERO
    INT 21H
    ; PUSH CX ; 
    MOV CH, 9
    MOV CL, 2 ; 

  NOVAMENTE:
    CALL IMPRIME_MATRIZ

  LEITURA:
  ; NOVAMENTE: ; le o endereco de linha
    CMP CL, 1 ; 
    JE DOIS ; 
    
    MOV AH, 09H ; 
    LEA DX, MSG_INSIRA_LINHA ; 
    INT 21H ; 

    JMP CAPTA ; 

  DOIS: ; le o endereco de coluna
    MOV AH, 09H ;  
    LEA DX, MSG_INSIRA_COLUNA ; 
    INT 21H ;  
    SHL BX, 8 ; 

  CAPTA: 
    MOV AH, 01H
    INT 21H

    MOV BL,AL

    PULA_LINHA

    ; LOOP NOVAMENTE
    DEC CL
    JNZ LEITURA

    PUSH BX
    SHR BX, 8
    AND BX, 000Fh

    POP SI
    AND SI, 000Fh

    ; POP CX

    VERIFICA_PARIDADE: ; SE CH FOR ÍMPAR -> VEZ DO J1
                       ; SE CH FOR PAR -> VEZ DO J2
      PUSH CX
      AND CH, 1

      CMP CH, 1
      JZ IMPAR

      PAR:
        MOV BYTE PTR MATRIZ[BX][SI], 6Fh
        ADD BX,SI
        MOV BYTE PTR VETOR_G[BX], 6Fh
        ; IMPRIME_MATRIZ
        JMP RETORNA_PRINCIPAL

      IMPAR:
        MOV BYTE PTR MATRIZ[BX][SI], 78h
        ADD BX,SI
        MOV BYTE PTR VETOR_G[BX], 78h
        ; IMPRIME_MATRIZ

      RETORNA_PRINCIPAL:
        POP CX
        MOV CL, 2
        DEC CH
        CMP CH, 0
        JE FIM_JOGO
        ; CMP CH, 9
        JMP NOVAMENTE
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