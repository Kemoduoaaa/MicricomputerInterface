;8255Ƭѡ��IOY0
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
	MOV AL,81H;A,B�������C�ڵĵ�4λ����
	OUT DX,AL
                                                                                      

    MOV DX,A_8255
	MOV AL,00H;����ܵ�λѡ�룬ȫ0����˼��ѡ�����е������
	OUT DX,AL
	MOV DX,B_8255
	MOV AL,00H;����ܵĶ�ѡ�룬ȫ0����˼����7�������ȫ�������ڱ�ѡ����������
	OUT DX,AL
	
	LEA BX,TAB
	MOV SI,1
	
	MOV AL,11011111B;�����ݴӵ͵�����������x1,x2...x6��ѡ�����ұߵ������6
	
MAIN:
	MOV CX,06H
X1:
	MOV DX,A_8255
	OUT DX,AL
	PUSH AX
	MOV AL,[BX+SI]
	MOV DX,B_8255
	OUT DX,AL;AL����Ƕ�ѡ��
	POP AX;����λѡ��
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