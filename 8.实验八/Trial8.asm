;8255Ƭѡ��IOY0
A_8255 EQU 0600H
B_8255 EQU 0602H
C_8255 EQU 0604H
CONTROL_8255 EQU 0606H

DATA SEGMENT
	TAB: 
	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH;0~9
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
	MOV SI,0
	
	MOV DX,A_8255
	MOV AL,11011111B;�����ݴӵ͵�����������x1,x2...x6��ѡ�����ұߵ������6

MAIN:
X1:
	CMP AL,01111111B;�ж��Ƿ��Ѿ���������ߵ�����ܣ�ѡ������ߵ�����ܶ�Ӧ��λѡ����11111110B
	JZ X2
	
	MOV DX,A_8255
	OUT DX,AL;AL�����λѡ��
	PUSH AX
	MOV AL,[BX+SI]
	MOV DX,B_8255
	OUT DX,AL;AL����Ƕ�ѡ��
	POP AX;����λѡ��
	CALL DELAY
	ROR AL,1;ѭ������1λ
	JMP X1
X2:
	MOV AL,11011111B
	INC SI
	CMP SI,10
	JZ X3
	JMP MAIN
X3: MOV SI,0
	JMP MAIN
	
DELAY:;�Գ�һ�����ʱ
	PUSH CX
	PUSH BX
	MOV BX,04H
D1:
	MOV CX,0FFFFH
	LOOP $
	DEC BX
	JNZ D1
	POP BX
	POP CX
	RET
CODE ENDS
END START
