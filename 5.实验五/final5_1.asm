;DAC0832Ƭѡ��IOY0,����ʼ��ַΪ0600H
;KK1+����MIR6��

DATAS SEGMENT
	STAGE DB 0
DATAS ENDS
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV DX,0600H
    MOV AX,00H
    
    MOV AX,OFFSET MIR6;�����ж�����MIR6���ж�����6����ʼ��ַΪ38H
	MOV SI,0038H
	MOV [ES:SI],AX;�������ֽڴ洢�ж�����6��ƫ�Ƶ�ַ
	MOV AX,CS
	MOV SI,003AH
	MOV [ES:SI],AX;�������ֽڴ洢�ж�����6�Ļ���ַ
	
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
	
judge:
	CMP STAGE,0
	JE ju4chi3
	CMP STAGE,1
	JE ju3xing2
	CMP STAGE,2
	JE san1jiao3
	CMP STAGE,3
	JE jie1ti1
	JMP judge	
	
ju4chi3:;��ݲ�����ֵΪ0FFH
	MOV AL,00H
	OUT DX,AL
	CALL SHORT_DELAY
A1:
	INC AL
	JZ judge;�ﵽ��ֵ�ͷ���������
	OUT DX,AL
	CALL SHORT_DELAY
	JMP A1
	
	
ju3xing2:;���β�����ֵΪ0FFH
	MOV AL,00H
	OUT DX,AL
	CALL LONG_DELAY
	MOV AL,0FFH
	OUT DX,AL
	CALL LONG_DELAY
    JMP judge    
    
    
san1jiao3:;���ǲ�����ֵΪ0FFH
	MOV AL,00H
C1:
	OUT DX,AL
	CALL SHORT_DELAY
	INC AL
	JNZ C1
	DEC AL
	DEC AL;ʹAL=FEH,����ƽ������Ϊ֮ǰ�Ѿ���ʾ����ߵ���
C2:
	OUT DX,AL
	CALL SHORT_DELAY
	DEC AL
	JNZ C2
	JMP judge
	
	
jie1ti1:;���ݲ�,��ֵ���ܲ���0FFH
	MOV BH,05H;���ý��ݲ��Ľ�����
	MOV AX,0FFH
	DIV BH;��ʱ0FFH/05H�Ľ��������AL��
	MOV BL,AL;BL�������ڽ��ݵĸ߶�

	MOV CL,BH;������ѭ��
	AND CX,0FH
	MOV AL,00H
D1:
	OUT DX,AL
	CALL LONG_DELAY
	ADD AL,BL
	LOOP D1
	OUT DX,AL
	CALL LONG_DELAY
	JMP judge
	
	
SHORT_DELAY:
	PUSH CX
	MOV CX,0FFH
	LOOP $
	POP CX
	RET


LONG_DELAY:
	PUSH CX
	MOV CX,0FFFFH
	LOOP $
	POP CX
	RET
	
	
MIR6:
	INC STAGE
	CMP STAGE,4
	JNE E1
	MOV STAGE,0
E1:
	IRET
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
