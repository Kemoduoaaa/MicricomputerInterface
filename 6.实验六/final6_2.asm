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
    MOV AL,76H;8254������1�����ڷ�ʽ3�����������ź�
    OUT DX,AL
    
    MOV DX,COUNTER1
    ;д�������ֵ4800H����18.432KHZʱ��Դ����������������Ϊ1s
    ;������ֵ=��ʱʱ��/ʱ����������
    MOV AL,00H
    OUT DX,AL
    MOV AL,48H
    OUT DX,AL
AA1:
	JMP AA1
  
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
