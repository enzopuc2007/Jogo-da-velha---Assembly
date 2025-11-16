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
  ; IMPRIME_MATRIZ PROC
  ;   PUSHALL
  ;   ; PUSH CX

  ;   XOR BX,BX
  ;   MOV AH,2
  ;   MOV CH,3

  ; REPETE2:
  ;   MOV CL,3
  ;   XOR SI,SI
  ;   MOV DL,20h
  ;   INT 21h
  ; REPETE1:
  ;   MOV AL,MATRIZ[BX][SI]
    
  ;   CMP AL,0
  ;   JE IMPRIMEN

  ;   CMP AL,6Fh
  ;   JE IMPRIME0

  ;   CMP AL,78h
  ;   JE IMPRIMEX

  ; IMPRIMEN:
  ;   MOV DL,20h
  ;   INT 21h
  ;   JMP COND

  ; IMPRIME0:
  ;   MOV DL,6Fh
  ;   INT 21h
  ;   JMP COND

  ; IMPRIMEX:
  ;   MOV DL,78h
  ;   INT 21h
  ;   JMP COND

  ; COND:
  ;   CMP CL,1
  ;   JE FINAL1
  ;   MOV DL,7Ch
  ;   INT 21h  

  ; FINAL1:
  ;   INC SI
  ;   DEC CL
  ;   JNZ REPETE1
  ;   ADD BX,3

  ;   CMP CH,1
  ;   JE FINAL2

  ;   MOV DL,10
  ;   INT 21h

  ;   MOV DL,20h
  ;   INT 21h

  ;   MOV DH,3
  ; DENOVO:
  ;   MOV DL,2Dh
  ;   INT 21h

  ;   CMP DH,1
  ;   JE FINAL2

  ;   MOV DL,7Ch
  ;   INT 21h
  ;   DEC DH
  ;   JNZ DENOVO

  ; FINAL2:
  ;   MOV DL,10
  ;   INT 21h
  ;   DEC CH
  ;   JNZ REPETE2

  ;   ; POP CX
  ;   POPALL
  ;   RET
  ; IMPRIME_MATRIZ ENDP

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
    AND BX, 0FH

    POP SI
    AND SI, 0FH

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
        CMP CH, 9
        JB NOVAMENTE

    POPALL
    RET
  JOGO_MULTIPLAYER ENDP

  ; INICIALIZACAO PROC
  ;   PUSHALL

  ;   ; IMPRIME MENSAGEM DE BEM-VINDO
  ;   MOV AH, 09H
  ;   MOV DX, OFFSET MSG_BEMVINDO
  ;   INT 21H

  ;   ENTRADA_OPCAO:
  ;     ; IMPRIME MENSAGEM DE MODO DE JOGO
  ;     MOV DX, OFFSET MSG1
  ;     INT 21H

  ;     MOV AH, 01H
  ;     INT 21H

  ;     AND AL, 0FH

  ;     CMP AL, 0
  ;     JZ VOLTAR
  ;     CMP AL, 1
  ;     JE VOLTAR

  ;     MOV AH, 09H
  ;     MOV DX, OFFSET MSG2
  ;     INT 21H
  ;     JMP ENTRADA_OPCAO

  ;   VOLTAR:
  ;     POPALL
  ;     RET 
  ; INICIALIZACAO ENDP

  ; IMPRIME_UM PROC
  ;   MOV AH, 09H
  ;   MOV DX, OFFSET MSG_UM
  ;   INT 21H

  ;   RET
  ; IMPRIME_UM ENDP

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