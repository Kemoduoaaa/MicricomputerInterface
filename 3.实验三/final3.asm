;8255Ƭѡ��IOY1
A_8255 EQU 0640H
B_8255 EQU 0642H
C_8255 EQU 0644H
CONTROL_8255 EQU 0646H

CODE SEGMENT
	ASSUME CS:CODE
START:
	MOV AX,00H;���ݶλ�ַ����Ϊ0
	MOV DS,AX
	
	MOV DX,CONTROL_8255;����8255�����֣�A����B���
	MOV AL,90H
	OUT DX,AL
	
	MOV AX,OFFSET MIR6;�����ж�����MIR6���ж�����6����ʼ��ַΪ38H
	MOV SI,0038H
	MOV [SI],AX;�������ֽڴ洢�ж�����6��ƫ�Ƶ�ַ
	MOV AX,CS
	MOV SI,003AH
	MOV [SI],AX;�������ֽڴ洢�ж�����6�Ļ���ַ
	
	MOV AX,OFFSET MIR7;�����ж�����MIR7���ж�����7����ʼ��ַΪ3CH
	MOV SI,003CH
	MOV [SI],AX;�������ֽڴ洢�ж�����7��ƫ�Ƶ�ַ
	MOV AX,CS
	MOV SI,003EH
	MOV [SI],AX;�������ֽڴ洢�ж�����7�Ļ���ַ
	
	CLI;����8259������
	MOV AL,11H
	OUT 20H,AL
	MOV AL,08H
	OUT 21H,AL
	MOV AL,04H
	OUT 21H,AL
	MOV AL,07H
	OUT 21H,AL
	MOV AL,2FH
	OUT 21H,AL
	STI
	
Initial:
	MOV DX,B_8255;PB�˿ڵ�ַ
	MOV AL,0FFH;8����ȫ��
	OUT DX,AL
	JMP Initial
	
MIR6:
	MOV DX,B_8255;PB�˿ڵ�ַ
	MOV AL,0FH;ֻ���ĸ��̵���
	OUT DX,AL
	CALL DELAY
	IRET
	
MIR7:
	MOV DX,B_8255;PB�˿ڵ�ַ
	MOV AL,0F0H;ֻ���ĸ������
	OUT DX,AL
	CALL DELAY
	IRET
	
DELAY PROC NEAR;˫��ѭ��
	MOV CX,0FFFFH
J1:	
	MOV BX,05H
J11:
	DEC BX
	CMP BX,0000H
	JE J111
	JMP J11
J111:
	DEC CX
	CMP CX,0000H
	JNE J1
	RET
DELAY ENDP

CODE ENDS
	END START
