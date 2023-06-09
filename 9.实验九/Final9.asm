;8255片选接IOY0
A_8255 EQU 0600H
B_8255 EQU 0602H
C_8255 EQU 0604H
CONTROL_8255 EQU 0606H

DATA SEGMENT
	TAB:
		DB 3FH,06H,5BH,4FH
		DB 66H,6DH,7DH,07H
		DB 7FH,6FH,77H,7CH
		DB 39H,5EH,79H,71H
	;Ti用于记录每个数码管的段选码
	T1 DB 00H
	T2 DB 00H
	T3 DB 00H
	T4 DB 00H
	T5 DB 00H
	T6 DB 00H
	;FLAG变量用于互斥操作
	FLAG DB 00H
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA 
START:
	MOV AX,DATA
	MOV DS,AX
	
	MOV AX,00H
	LEA BX,TAB
	
	MOV DX,CONTROL_8255
	MOV AL,81H
	OUT DX,AL
	
MAIN:
	MOV AL,11110111B;需要扫描的列，输出0,只有4列，所以初值对应的是最左边的那一列
	MOV CX,04H 
M1:
	MOV DX,A_8255
	OUT DX,AL
	SHR AL,1;右移指令，最高位补0
	OR AL,11110000B
	
	PUSH AX;保存列选信号
	PUSH CX
	MOV DX,C_8255;从C口输入键盘反馈信号
	IN AL,DX
	AND AL,0FH;只要C口低4位的内容
	CMP AL,0FH;如果低4位为1111，说明没有按键被按下
	JE M2
	CALL SHOW
	JMP M3
M2:
	CMP FLAG,00H;维持互斥信号，FLAG=MAX(0,FLAG-1)???
	JE M3
	DEC FLAG
M3:
	CALL CLEAR;显示数码管的内容
	POP CX
	POP AX
	CALL DELAY
	LOOP M1
	JMP MAIN
	
	
SHOW:
	NOT AL;取反，（从这里开始，通过Y口输入信息来判断按下的按键）
	AND AX,0FH
	CMP AL,01H
	JE D1
	CMP AL,02H
	JE D2
	CMP AL,04H
	JE D3
	CMP AL,08H
	JE D4
D1:
	MOV AL,04H
	JMP D5
D2:
	MOV AL,08H
	JMP D5
D3:
	MOV AL,0CH
	JMP D5
D4:
	MOV AL,10H
	JMP D5
D5:
	ADD AL,CL
	SUB AL,05H
	MOV SI,AX;到这里，按下的键被转化为独一无二的索引值
	CMP FLAG,00H;是否存在互斥，非0存在互斥
	JNE DFI
	
	LEA BX,TAB
	MOV AL,T5;将T5的值放到T6
	MOV T6,AL
	MOV AL,T4;将T4的值放到T5
	MOV T5,AL
	MOV AL,T3
	MOV T4,AL
	MOV AL,T2
	MOV T3,AL
	MOV AL,T1
	MOV T2,AL
	MOV AX,[BX+SI];将按键的索引值放到T1
	MOV T1,AL
	
	CALL DELAY
DFI:
	MOV FLAG,04;FLAG初值设置
	RET
	
CLEAR:
	LEA BX,T1
	MOV AL,11011111B;数码管位选码，选择最右端的数码管
	MOV SI,00H
	MOV CX,06H
MC2:
	MOV DX,A_8255
	OUT DX,AL
	SHR AL,1
	OR AL,11000000B
	PUSH AX
	MOV DX,B_8255
	MOV AL,[BX+SI]
	OUT DX,AL
	POP AX
	INC SI
	CALL DELAY
	LOOP MC2
	RET
	
DELAY:
	PUSH CX
	MOV CX,03FFH
	LOOP $
	POP CX
	RET
CODE ENDS
	END START
	