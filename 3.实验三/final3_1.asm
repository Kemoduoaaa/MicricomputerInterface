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
	
	CLI
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
	
	MOV BX,00H
	MOV AL,80H;��ʼֻ�������D7��
	
	
Judge:
    MOV DX,B_8255
    OUT DX,AL
    CALL DELAY
	CMP BX,00H
	JE Judge
	CMP BX,02H
	JE Left

Right:
	MOV DX,B_8255;PB�˿ڵ�ַ
	ROR AL,1;ѭ������1λ
	OUT DX,AL
	CALL DELAY
	JMP Judge
	
Left:
	MOV DX,B_8255;PB�˿ڵ�ַ
	ROL AL,1;ѭ������1λ
	OUT DX,AL
	CALL DELAY
	JMP Judge
	
MIR6:
	MOV BX,01H
	IRET
	
MIR7:
	MOV BX,02H
	IRET
	
DELAY PROC NEAR;ѭ��
	MOV CX,0FFFFH
	LOOP $
	RET
DELAY ENDP

CODE ENDS
	END START
