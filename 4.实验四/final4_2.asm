;0809Ƭѡ��IOY1->��0640H��ʼ
;0809ʹ��ͨ��2
;8255Ƭѡ��IOY0->��0600H��ʼ
;EOC�ӵ�8255A�ڵ����λ
CODES SEGMENT
    ASSUME CS:CODES
START:
    MOV AX,0000H
    MOV DS,AX
    
    ;8255��ʼ��
    MOV AL,90H
    MOV DX,0606H;I0Y0,8255���ƼĴ����˿ڵ�ַ
    OUT DX,AL
    
WORK:
    ;IOY1,����ͨ��2
    MOV DX,0644H
    OUT DX,AL
    
ENQUIRY_BEGIN:;�ж�EOC�Ƿ�Ϊ0���ж��Ƿ����½��أ���û�п�ʼת���ͼ����ж�
	MOV DX,0600H
	IN AL,DX
	TEST AL,80H;���뿴���
	JNZ ENQUIRY_BEGIN
	
ENQUIRY_END:;�ж�EOC�Ƿ�Ϊ1���ж��Ƿ��������أ���û�н���ת���ͼ����ж�
	MOV DX,0600H
	IN AL,DX
	TEST AL,80H
	JZ ENQUIRY_END
    
    ;����
    MOV DX,0644H
    IN AL,DX
    
    ;���
    MOV DX,0602H;IOY0,B�ڶ˿ڵ�ַ
    OUT DX,AL
    CALL DELAY
    JMP WORK
    
DELAY:
	MOV CX,0FFFFH
	LOOP $
	RET
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
