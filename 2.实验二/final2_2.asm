;非规则字
CODE SEGMENT
	ASSUME CS:CODE
START:
	MOV AX,8000H;设置基地址
	MOV DS,AX
	MOV BX,0000H;起始偏移地址
	
	MOV BYTE PTR[BX],0;先送第一个字节
	INC BX
	MOV DX,0100H;先低位后高位
	MOV CX,15
	
A:
	MOV [BX],DX
	ADD BX,2
	INC DH
	LOOP A
	
	MOV BYTE PTR[BX],0;处理最后一个字节
	
	MOV AH,4CH
	INT 21H
CODE ENDS
	 END START
