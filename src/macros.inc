 PULA_LINHA MACRO ; macro de pular linha (será usado repetidas vezes ao longo do jogo)
    MOV AH, 02H
    MOV DL, 10
    INT 21H
  ENDM

PUSHALL MACRO 
    PUSH AX
    PUSH BX 
    PUSH CX 
    PUSH DX 
    PUSH SI 
    ; PUSH DI 
  ENDM ; MACRO DE 
; EMPILHAMENTO QUE SERÁ USADA VÁRIAS VEZES NO DECORRER DO PROGRAMA

POPALL MACRO 
    POP AX
    POP BX 
    POP CX 
    POP DX 
    POP SI 
    ; POP DI 
  ENDM

  CLS MACRO 
    MOV AH, 0H
    MOV AL, 03H
    INT 10H
  ENDM
