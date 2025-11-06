TITLE Escolha jogador
.MODEL SMALL
.STACK 100h
.DATA
MSG1 DB 'Escolha a linha da jogada: $'
MSG2 DB 'Escolha a coluna da jogada: $'
.CODE 
 JOGADOR PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV CX,2

NOVAMENTE:
    CMP CX,1
    JE DOIS 
    MOV AH,9
    LEA DX,MSG1
    INT 21h
    JMP CAPTA

DOIS:
    MOV AH,9
    LEA DX,MSG2
    INT 21h
    SHL BX,8

CAPTA:
    MOV AH,1
    INT 21h

    MOV BL,AL

    MOV AH,2
    MOV DL,10
    INT 21h

    LOOP NOVAMENTE

    POP SI
    POP DX
    POP CX
    POP AX
    RET
 JOGADOR ENDP

 MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    CALL JOGADOR

    MOV AH,4Ch
    INT 21h
 MAIN ENDP
END MAIN