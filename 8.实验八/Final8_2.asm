;8255�ӿڳ�ʼ������CS���ӵ�IOY�˿ھ����������õ���IOY0��
A8255_CON EQU 0606H
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
;����ܵ����ݱ��ֱ��ʾ303271 ����������� �������ҿ��������֡�172303���� �ҵ�ѧ�ź���λ 
DATA 	SEGMENT
TABLE1:
    	DB 07H;7
    	DB 3FH;0
    	DB 5BH;2
    	DB 06H;1
    	DB 3FH;0
    	DB 5BH;2
		
VALUE	DB 20H						;���ڿ��ؿ���
DATA 	ENDS
CODE 	SEGMENT
		ASSUME CS:CODE,DS:DATA
START:
		MOV AX,DATA
		MOV DS,AX
		LEA SI,TABLE1
		MOV DX,A8255_CON
		MOV AL,89H					;89H=10001001B A�ڷ�ʽ0 ��� B�ڷ�ʽ0 ��� C�� ���루����λ�͵���λ���������룩
		OUT DX,AL
		;���������õ���������
		MOV DX,A8255_B
		MOV AL,3FH
		OUT DX,AL
		MOV DX,A8255_A
		MOV AL,00H
		OUT DX,AL
		;λѡ�ź���0 ��Ӧ����ܵ���
X2:    
		MOV CX,06H					;ѭ��6��
		MOV BX,0000H
		MOV VALUE,20H				;���������6
		MOV AL,11011111B			;�����6��Ҫ����
X1: 
		PUSH AX
		MOV DX,A8255_C
		IN  AL,DX					;����C��״̬ ������״̬
		TEST VALUE,AL				;���Կ�����Ӧ����ܵĿ����Ƿ�� ����Ϊ���߼� 1���� 0Ϩ��
		JZ A1						;��Ӧ����Ϊ0 ӦϨ�� תA1
		POP AX						;����Ϊ1 Ӧ���� ��������ִ��
		MOV DX,A8255_A
		OUT DX,AL	
A2:		ROR VALUE,1					;���� ������һ�������
		ROR AL,1					;���� ��Ҫ������һ�������;;;;;;;;
		PUSH AX
		MOV AL,[BX+SI]
		MOV DX,A8255_B
		OUT DX,AL					;����Ӧ���������ʾ��Ӧ���� �������Ϊ1�Ļ�
		POP AX
		CALL DELAY
		INC BX
		LOOP X1
		JMP X2
A1: 								;����Ϩ��
		MOV AL,11111111B			;����λѡ�źŲ�ѡ�� 0Ϊѡ�� 1Ϊ��ѡ��
		MOV DX,A8255_A
		OUT DX,AL
		POP AX
		JMP A2    
DELAY:
		PUSH CX
		MOV CX,0FFH					;����Ҫ��ʾ�ȶ������֡�172303�� ��ʱҪ��
X4:
		LOOP X4						
		POP CX
		RET
CODE 	ENDS
		END START