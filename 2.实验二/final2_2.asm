;�ǹ�����
CODE SEGMENT
	ASSUME CS:CODE
START:
	MOV AX,8000H;���û���ַ
	MOV DS,AX
	MOV BX,0000H;��ʼƫ�Ƶ�ַ
	
	MOV BYTE PTR[BX],0;���͵�һ���ֽ�
	INC BX
	MOV DX,0100H;�ȵ�λ���λ
	MOV CX,15
	
A:
	MOV [BX],DX
	ADD BX,2
	INC DH
	LOOP A
	
	MOV BYTE PTR[BX],0;�������һ���ֽ�
	
	MOV AH,4CH
	INT 21H
CODE ENDS
	 END START
