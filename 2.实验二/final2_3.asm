;�ֽڷ�ʽ
CODE SEGMENT
	ASSUME CS:CODE
START:
	MOV AX,8000H;���û���ַ
	MOV DS,AX
	XOR BX,BX;���㣬���ڵ�ַ����
	XOR DX,DX;���㣬�����γ�����
	MOV CX,16
	
A��
	MOV [BX],DL
	MOV [BX+1],DH
	ADD BX,2
	INC DX
	LOOP A
	
	MOV AH,4CH
	INT 21H
CODE ENDS
	 END START
