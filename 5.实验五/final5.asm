A0832 EQU 0600H  
  

CODE SEGMENT
    ASSUME  CS:CODE

START:
    MOV CX, 030H       ;��ݲ�������
JUCHI:
    MOV DX, A0832     ;DAC0832��IOY0,0600HΪ���ƶ˿ڵ�ַ
    MOV AL, 00H       ;ALΪ������
JC1: 
    OUT DX, AL        ;ת��Ϊģ����
    CALL DELAY1       ;��ʱ����Ϊ����ʱ
    CMP AL ,0FFH
    JZ JC2
    INC AL            ;AL����1��ֱ������0FFH
    JMP JC1
JC2:
    LOOP JUCHI

    ;�������β�
    MOV CX, 05H       ;���β�������
JUXING:
    MOV DX, A0832
    MOV AL, 00H       ;�����00H�Ĳ���
    OUT DX, AL
    CALL DELAY2       ;����ʱ
    MOV AL, 0FFH      ;�����0FFH�Ĳ���
    OUT DX, AL
    CALL DELAY2       ;����ʱ
    LOOP JUXING

    
    ;�������ǲ�
A1:    MOV CX, 0FH     ;���ǲ�������
SANJIAO:
MOV AL,00H
SJ1:
    OUT DX,AL
	CALL DELAY1
	INC AL
	JNZ SJ1
	DEC AL
	DEC AL;ʹAL=FEH,����ƽ��
SJ2:
    OUT DX,AL
	CALL DELAY1
	DEC AL
	JNZ SJ2
	LOOP SANJIAO

    
    ;�������ݲ�
    MOV CX, 0FFFFH     ;�������ݲ���������Ϊ0FFFF�Σ������ı���ݲ������������޸�����
    MOV AX, 0FEH       
    ;����������ֵΪ0FFH
    ;���ǵ�8086��DIV�������ܻ��������Ϊ�����¼�����֮������ֵ����0FFH����ʹ��0FEH�����ֵ
    MOV BL,05H         ;���ݲ��еĽ������������ı���ݲ��еĽ��������޸�����
    DIV BL             ;�����������Խ��������õ�ÿ��̨�׵ĸ߶�
    MOV BL, AL         ;�������������̱�����BL��
    MOV BH, 00H        ;BH��0
JIETI:
    MOV AX,0000H       ;AX��ʼ��0000H
JT1:
    MOV DX, A0832
    OUT DX, AL
    CMP AX, 00FFH      ;�ж�AX�Ƿ�ﵽ��������
    JAE JT2            ;�ﵽ���ޣ���ʾһ�ν��ݲ��������ɣ���ʼ��һ������
    CALL DELAY2        ;����ʱ
    ADD AX, BX         ;�õ�ǰ����߶ȼ���ÿ�����ݵĸ߶ȵõ���һ���ݵĸ߶�
    JMP JT1
JT2:    
    LOOP JIETI


DELAY1:                ;����ʱ
    PUSH CX
    MOV CX, 01FFH
D1: 
    PUSH AX
    POP AX
    LOOP D1
    POP CX
    RET

DELAY2:               ;����ʱ
    PUSH CX
    MOV CX, 0FFFFH
D2: 
    PUSH AX
    POP AX
    LOOP D2
    POP CX
    RET

CODE ENDS
    END START
