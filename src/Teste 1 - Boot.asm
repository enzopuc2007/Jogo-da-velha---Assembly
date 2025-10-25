TITLE Boot
.MODEL SMALL
.STACK 100h
.DATA
MSG1 DB 'JOGO DA VELHA',10,10,13,'Deseja jogar com outra pessoa ou com o computador?(0 - Pessoa | 1 - Computador):',10,10,13,'Digite a sua opcao: $'
MSG2 DB 10,10,'Tente novamente, digito não reconhecido...',10,10,13
MSG3 DB 'Insira o numero da linha em que você deseja inserir a sua peça do jogo (1 a 3): $',10,10,13
MSG4 DB 'Insira o numero da coluna em que você deseja inserir a sua peça do jogo (1 a 3): $'
MATRIZ DB 1,1,1
       DB 1,1,1
       DB 1,1,1
.CODE
MAIN PROC 
    MOV AX,@DATA
    MOV DS,AX

    CALL INICIACAO
    AND AL,0
    ;JE PESSOA 
    ; CALL MULTIPLAYER
    JMP CONTINUA

PESSOA:
    ; CALL COMPUTADOR  

CONTINUA:
    CALL PULAR 
    CALL IMPRESSAO
    CALL LEITURA

    MOV AH,4CH
    INT 21h
 MAIN ENDP

 INICIACAO PROC ; este procedimento é responsável por determinar a escolha de tipo de jogo que o usuário vai jogar
TENTENOVAMENTE:
    MOV AH,9
    LEA DX,MSG1 ; imprime a mensagem inicial
    INT 21h

    MOV AH,1 ; espera um valor de entrada a ser digitado pelo usuário
    INT 21h

    AND AL,0Fh ; insere o valor digitado em AL

    TEST AL,0 ; verifica se o valor digitado foi zero
    JE RETORNA1
    TEST AL,1 ; verifica se o valor digitado foi um
    JE RETORNA1
    
    ; caso o número digitado não seja 0 ou 1...

    MOV AH,9 ; imprime mensagem de opção inválida
    LEA DX,MSG2
    INT 21h
    JMP TENTENOVAMENTE ; volta para o início do escopo de verificação de opção

    RETORNA1: ; este escopo retorna para o procedimento inicial
    RET
 INICIACAO ENDP ; fim do procedimento iniciacao
 
 LEITURA PROC ; início do procedimento de leitura de posições e do jogo propriamente dito
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV AH,9
    LEA DX,MSG3 ; imprime a mensagem que solicita a entrada da linha a ser preenchida pelo usuário
    INT 21h 

    MOV AH,1 ; pega 
    INT 21h 
    SUB AL,1
    XOR BX,BX
    TEST AL,0
    JE FIM
    TEST AL,1
    JE SOMA3
    OR BH,06h
    JMP CONTINUA1
SOMA3:
    OR BH,03h

CONTINUA1:
    MOV AH,9
    LEA DX,MSG4
    INT 21h 

    MOV AH,1
    INT 21h 
    AND AL,0Fh  
    SUB AL,1
    MOV BL,AL

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

FIM: 
    RET
 LEITURA ENDP
 
 IMPRESSAO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV DL,10  
    INT 21h

    MOV CH,3
    MOV AH,2

    XOR SI,SI
REPETE1_2:
    XOR BX,BX
    MOV CL,3

REPETE1:
    MOV DL,MATRIZ[SI][BX]
    INT 21h

    MOV DL,20h
    INT 21h

    INC BX         
    DEC CL
    JNZ REPETE1  

    MOV DL,10
    INT 21h 

    ADD SI,3
    DEC CH 
    JNZ REPETE1_2

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
 IMPRESSAO ENDP

  PULAR PROC
    PUSH AX
    PUSH DX

    MOV AH,2
    MOV CX,12

ESPACO:
    MOV DL,10
    INT 21h
    MOV DL,13
    INT 21h
    LOOP ESPACO

    POP DX
    POP AX

    RET
 PULAR ENDP

 END MAIN