;0809Ƭѡ��IOY1->��0640H��ʼ
;0809ʹ��ͨ��2
;8255Ƭѡ��IOY0->��0600H��ʼ
CODES SEGMENT
    ASSUME CS:CODES
START:

    MOV AX,0000H
    MOV DS,AX
    
    ;8255��ʼ��
    MOV AL,90H
    MOV DX,0606H;IOY0,8255���ƼĴ����˿ڵ�ַ
    OUT DX,AL
    
WORK:
    ;����ͨ��2
    MOV DX,0644H
    OUT DX,AL
    
    CALL DELAY
    
    ;����
    IN AL,DX
    
    ;���
    MOV DX,0602H;B�ڶ˿ڵ�ַ
    OUT DX,AL
    CALL DELAY
    JMP WORK
    
DELAY:
	PUSH CX
	MOV CX,0FFFFH
	LOOP $
	POP CX
	RET
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
