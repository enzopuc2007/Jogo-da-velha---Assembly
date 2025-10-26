TITLE Bot
.MODEL SMALL
.STACK 100h
.DATA
  MSG_BEMVINDO DB 'JOGO DA VELHA', 13, 10, 13, 10, '$'
  MSG1 DB 'Selecione o modo de jogo (0 - Multiplayer | 1 - Computador)', 13, 10, 13, 10,'Digite a sua opcao: $'
  MSG2 DB 10,10,'Tente novamente, digito nao reconhecido...',13, 13, 10, '$'
; MSG3 DB 'Insira o numero da linha em que você deseja inserir a sua peça do jogo (1 a 3): $', 13, 10
; MSG4 DB 'Insira o numero da coluna em que você deseja inserir a sua peça do jogo (1 a 3): $', 13, 10
MATRIZ DB ?,?,?
       DB ?,?,?
       DB ?,?,?

MSG_ZERO DB 13, 10, 'A opcao selecionada foi a opcao MULTIPLAYER.', 13, 10, '$'
MSG_UM DB 13, 10, 'A opcao selecionada foi a opcao JOGO COM COMPUTADOR.', 13, 10, '$'
.CODE
  INICIACAO PROC
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
  INICIACAO ENDP

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
    MOV AX,@DATA
    MOV DS,AX

    CALL INICIACAO

    CMP AL, 0
    JZ ESCOPO_ZERO

    ESCOPO_UM:
      CALL IMPRIME_UM
      JMP FIM

    ESCOPO_ZERO:
      CALL IMPRIME_ZERO
      JMP FIM

    FIM:
      MOV AH, 4CH
      INT 21H
 MAIN ENDP
END MAIN