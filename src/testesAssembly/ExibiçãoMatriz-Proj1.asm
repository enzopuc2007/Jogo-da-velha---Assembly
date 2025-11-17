TITLE EXIBE MATRIZ
.MODEL SMALL
.STACK 100h
.DATA
MATRIZ DB 6Fh,6Fh,6Fh
       DB 6Fh,78h,78h
       DB 78h,78h,6Fh
.CODE   
 EXIBE PROC
   ;Esta função faz a leitura da matriz do jogo
   ;Nenhum parâmetro é passado
   ;Não retorna nenhum parâmetro
   PUSH AX
   PUSH BX
   PUSH CX
   PUSH DX
   PUSH SI
   
   XOR BX,BX
   XOR SI,SI
   MOV AH,2
   MOV CL,3
   MOV CH,3

REPETE2:
   MOV CL,3
   XOR SI,SI
   MOV DL,20h
   INT 21h
REPETE1:
   MOV AL,MATRIZ[BX][SI]
   
   CMP AL,0
   JE IMPRIMEN

   CMP AL,6Fh
   JE IMPRIME0

   CMP AL,78h
   JE IMPRIMEX

IMPRIMEN:
   MOV DL,20h
   INT 21h
   JMP COND

IMPRIME0:
   MOV DL,6Fh
   INT 21h
   JMP COND

IMPRIMEX:
   MOV DL,78h
   INT 21h
   JMP COND

COND:
   CMP CL,1
   JE FINAL1
   MOV DL,7Ch
   INT 21h  

FINAL1:
   INC SI
   DEC CL
   JNZ REPETE1
   ADD BX,3

   CMP CH,1
   JE FINAL2

   MOV DL,10
   INT 21h

   MOV DL,20h
   INT 21h

   MOV DH,3
DENOVO:
   MOV DL,2Dh
   INT 21h

   CMP DH,1
   JE FINAL2

   MOV DL,7Ch
   INT 21h
   DEC DH
   JNZ DENOVO

FINAL2:
   MOV DL,10
   INT 21h
   DEC CH
   JNZ REPETE2

   POP SI
   POP DX
   POP CX
   POP BX
   POP AX
   RET
 EXIBE ENDP
 MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    CALL EXIBE

    MOV AH,4Ch
    INT 21h
 MAIN ENDP          
END MAIN