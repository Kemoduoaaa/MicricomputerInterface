;8255片选接IOY1
A_8255 EQU 0640H
B_8255 EQU 0642H
C_8255 EQU 0644H
CONTROL_8255 EQU 0646H

CODE SEGMENT
	ASSUME CS:CODE
START:
	MOV AX,00H;数据段基址设置为0
	MOV DS,AX
	
	MOV DX,CONTROL_8255;设置8255控制字，A输入B输出
	MOV AL,90H
	OUT DX,AL
	
	MOV AX,OFFSET MIR6;设置中断向量MIR6，中断向量6的起始地址为38H
	MOV SI,0038H
	MOV [SI],AX;低两个字节存储中断向量6的偏移地址
	MOV AX,CS
	MOV SI,003AH
	MOV [SI],AX;高两个字节存储中断向量6的基地址
	
	MOV AX,OFFSET MIR7;设置中断向量MIR7，中断向量7的起始地址为3CH
	MOV SI,003CH
	MOV [SI],AX;低两个字节存储中断向量7的偏移地址
	MOV AX,CS
	MOV SI,003EH
	MOV [SI],AX;高两个字节存储中断向量7的基地址
	
	CLI
	MOV AL,11H
	OUT 20H,AL
	MOV AL,08H
	OUT 21H,AL
	MOV AL,04H
	OUT 21H,AL
	MOV AL,07H
	OUT 21H,AL
	MOV AL,2FH
	OUT 21H,AL
	STI
	
	MOV BX,00H
	MOV AL,80H;初始只有最左的D7亮
	
	
Judge:
    MOV DX,B_8255
    OUT DX,AL
    CALL DELAY
	CMP BX,00H
	JE Judge
	CMP BX,02H
	JE Left

Right:
	MOV DX,B_8255;PB端口地址
	ROR AL,1;循环右移1位
	OUT DX,AL
	CALL DELAY
	JMP Judge
	
Left:
	MOV DX,B_8255;PB端口地址
	ROL AL,1;循环左移1位
	OUT DX,AL
	CALL DELAY
	JMP Judge
	
MIR6:
	MOV BX,01H
	IRET
	
MIR7:
	MOV BX,02H
	IRET
	
DELAY PROC NEAR;循环
	MOV CX,0FFFFH
	LOOP $
	RET
DELAY ENDP

CODE ENDS
	END START
