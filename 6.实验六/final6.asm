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
    ;MOV AL,70H;������1�����ڷ�ʽ0
    ;MOV AL,72H;��ʽ1
    MOV AL,74H;��ʽ2
    ;MOV AL,76H;��ʽ3
    OUT DX,AL
    
    ;��ʽ0��GATE1��5V��Դ��CLK1��KK1+�ù۲�
    ;��ʽ1��GATE1��K0���أ�CLK1��ʱ��Դ18.432KHz�ù۲�
    ;��ʽ2���÷�ʽ���γɵ�����Ϊ1s�ķ�������ʽ2��ʱ��Դ
    ;��ʽ3��GATE1��5V��Դ��CLK1��ʱ��Դ18.432KHz�ù۲�
    
    MOV DX,COUNTER1
    
    MOV AL,00H;��8λ
    OUT DX,AL
    MOV AL,48;��8λ
    OUT DX,AL
    
AA1:
	JMP AA1
;��GATE��Ϊ�ߵ�ƽ�����г�����ʾ�����п��Կ���OUT1���һ�θߵ�ƽ������һ�����Ϊһ�����ڵĸ�����

    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
