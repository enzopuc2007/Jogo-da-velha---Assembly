TITLE Bot
.MODEL SMALL
.STACK 100h
.DATA
  MSG_BEMVINDO DB 'JOGO DA VELHA', 13, 10, 13, 10, '$'
  MSG1 DB 'Selecione o modo de jogo (0 - Multiplayer | 1 - Computador)', 13, 10, 13, 10,'Digite a sua opcao: $'
  MSG2 DB 10,10,'Tente novamente, digito nao reconhecido...',13, 13, 10, '$'
  ; MSG3 DB 'Insira o numero da linha em que você deseja inserir a sua peça do jogo (1 a 3): $', 13, 10
  ; MSG4 DB 'Insira o numero da coluna em que você deseja inserir a sua peça do jogo (1 a 3): $', 13, 10
  MATRIZ DB 3 DUP (3 DUP (?)) ; define a matriz de jogo da velha
  VETOR_POSICOES DB 0, 1, 2, 3, 4, 5, 6, 7, 8 ; 
  VETOR_G DB 9 DUP (?); [ , , , , , , , , ]

  MSG_ZERO DB 13, 10, 'A opcao selecionada foi a opcao MULTIPLAYER.', 13, 10, '$'
  MSG_UM DB 13, 10, 'A opcao selecionada foi a opcao JOGO COM COMPUTADOR.', 13, 10, '$'

  MSG_INSIRA_LINHA DB 'Escolha a linha da jogada: $'
  MSG_INSIRA_COLUNA DB 'Escolha a coluna da jogada: $'

  MSG_EMPATE DB 'Empate! $'

  MSG_VEZ_J1 DB 'Vez do jogador 1 $'
  MSG_VEZ_J2 DB 'Vez do jogador 2 $'

  MSG_GANHOU_J1 DB 'Jogador 1 ganhou'
  MSG_GANHOU_J2 DB 'Jogador 2 ganhou'
.CODE
  PULA_LINHA MACRO 
    MOV AH, 02H
    MOV DL, 10
    INT 21H
  ENDM 
 
  ; JOGO_COMPUTADOR PROC

  ;   MOV AH, 09H
  ;   MOV DX, OFFSET MSG_ZERO
  ;   INT 21H

  ;   PUSH CX
  ;   MOV CX, 2

  ; NOVAMENTE:
  ;   CMP CX, 1
  ;   JE DOIS
    
  ;   MOV AH, 09H
  ;   LEA DX, MSG1
  ;   INT 21H

  ;   JMP CAPTA

  ; DOIS:
  ;   MOV AH, 09H
  ;   LEA DX, MSG2
  ;   INT 21H
  ;   SHL BX, 8

  ; CAPTA: 
  ;   MOV AH, 01H
  ;   INT 21H

  ;   MOV BL, AL

  ;   MOV AH, 02H
  ;   MOV DL, 10
  ;   INT 21H

  ;   LOOP NOVAMENTE

  ;   PUSH BX
  ;   SHR BX, 8
  ;   AND BX, 0FH

  ;   POP SI
  ;   AND SI, 0FH

  ;   POP DI
  ;   POP DX
  ;   POP CX
  ;   POP AX
  ;   RET
  ; ENDP JOGO_COMPUTADOR

  JOGO_MULTIPLAYER PROC

    MOV AH, 09H
    MOV DX, OFFSET MSG_ZERO
    INT 21H

    PUSH CX
    MOV CX, 2

  NOVAMENTE: ; le o endereco de linha
    CMP CX, 1
    JE DOIS
    
    MOV AH, 09H
    LEA DX, MSG_INSIRA_LINHA
    INT 21H

    JMP CAPTA

  DOIS: ; le o endereco de coluna
    MOV AH, 09H
    LEA DX, MSG_INSIRA_COLUNA
    INT 21H
    SHL BX, 8

  CAPTA: 
    MOV AH, 01H
    INT 21H

    MOV BL, AL

    PULA_LINHA

    LOOP NOVAMENTE

    PUSH BX
    SHR BX, 8
    AND BX, 0FH

    POP SI
    AND SI, 0FH

    POP CX
    RET
  ENDP JOGO_MULTIPLAYER

  MULTIPLAYER PROC 
  
    MOV AH, 09H
    MOV DX, OFFSET MSG_ZERO
    INT 21H

    CALL JOGO_MULTIPLAYER

    RET
  ENDP MULTIPLAYER

  INCIALIZACAO PROC
    ; IMPRIME MENSAGEM DE BEM-VINDO
    MOV AH, 09H
    MOV DX, OFFSET MSG_BEMVINDO
    INT 21H

    ENTRADA_OPCAO:
      ; IMPRIME MENSAGEM DE MODO DE JOGO
      MOV DX, OFFSET MSG1
      INT 21H

      MOV AH, 01H
      INT 21H

      AND AL, 0FH

      CMP AL, 0
      JZ VOLTAR
      CMP AL, 1
      JE VOLTAR

      MOV AH, 09H
      MOV DX, OFFSET MSG2
      INT 21H
      JMP ENTRADA_OPCAO

    VOLTAR:
      RET 
  INCIALIZACAO ENDP

  IMPRIME_ZERO PROC
    MOV AH, 09H
    MOV DX, OFFSET MSG_ZERO
    INT 21H

    RET
  IMPRIME_ZERO ENDP

    IMPRIME_UM PROC
    MOV AH, 09H
    MOV DX, OFFSET MSG_UM
    INT 21H

    RET
  IMPRIME_UM ENDP

 MAIN PROC 
    MOV AX,@DATA      ;Inicialização dos dados
    MOV DS,AX

    CALL INCIALIZACAO    ;Iniciação do jogo

    CMP AL, 0         ;Condição para entrar no modo multiplayer
    JZ ESCOPO_ZERO    ;Condição 

    ESCOPO_UM:
      CALL JOGO_MULTIPLAYER
      JMP FIM_PROGRAMA

    ESCOPO_ZERO:  
      MOV CX, 9   
      CALL MULTIPLAYER
      JMP FIM_PROGRAMA

    FIM_PROGRAMA:
      MOV AH, 4CH     ;Devolve o controle 
      INT 21H
 MAIN ENDP
END MAIN