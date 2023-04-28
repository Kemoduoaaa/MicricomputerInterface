;8255片选接IOY0
A_8255 EQU 0600H
B_8255 EQU 0602H
C_8255 EQU 0604H
CONTROL_8255 EQU 0606H

DATA SEGMENT
	TAB: 
	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
	TEMP DB 0
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,CONTROL_8255
	MOV AL,81H;A,B口输出，C口的低4位输入
	OUT DX,AL
                                                                                      

    MOV DX,A_8255
	MOV AL,00H;数码管的位选码，全0的意思是选择所有的数码管
	OUT DX,AL
	MOV DX,B_8255
	MOV AL,00H;数码管的段选码，全0的意思是让7个晶体管全灭，作用在被选择的数码管上
	OUT DX,AL
	
	LEA BX,TAB
	MOV SI,1
	
	MOV AL,11011111B;将数据从低到高依次送入x1,x2...x6；选择最右边的数码管6
	
MAIN:
	MOV CX,06H
X1:
	MOV DX,A_8255
	OUT DX,AL
	PUSH AX
	MOV AL,[BX+SI]
	MOV DX,B_8255
	OUT DX,AL;AL存的是段选码
	POP AX;弹出位选码
	INC SI
	ROR AL,1
	CALL DELAY
	LOOP X1
	MOV SI,1
	MOV AL,11011111B
	JMP MAIN	
	
DELAY:
	PUSH CX
	MOV CX,00FFH
	LOOP $
	POP CX
	RET
CODE ENDS
END START