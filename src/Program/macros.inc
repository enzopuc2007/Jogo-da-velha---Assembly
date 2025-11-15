 PULA_LINHA MACRO ; macro de pular linha (será usado repetidas vezes ao longo do jogo)
    MOV AH, 02H
    MOV DL, 10
    INT 21H
  ENDM