;8254Ƭѡ��IOY0
COUNTER0 EQU 0600H;������0
COUNTER1 EQU 0602H;������1
COUNTER2 EQU 0604H;������2
CONTROL8254 EQU 0606H;���ƼĴ���

CODES SEGMENT
    ASSUME CS:CODES
START:
    MOV AX,00H
    MOV DS,AX
    
    MOV DX,CONTROL8254
    MOV AL,70H;8254������1������ʽ0������ʱ����͵�ƽ����0ʱ����ߵ�ƽ
    OUT DX,AL
    
    MOV DX,COUNTER1
    
    ;д�����ֵ05H��KK1��8254��ʱ�������
    MOV AL,05H 
    OUT DX,AL
    MOV AL,00H
    OUT DX,AL
    
AA1:
	JMP AA1
	
;��GATE1��Ϊ�ߵ�ƽ����ʾ�����п��Թ۲쵽OUT1����͵�ƽ���ȵ���6�ΰ���KK1֮������ߵ�ƽ
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
