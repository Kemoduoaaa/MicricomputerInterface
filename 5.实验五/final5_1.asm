;DAC0832片选接IOY0,故起始地址为0600H
;KK1+连到MIR6上

DATAS SEGMENT
	STAGE DB 0
DATAS ENDS
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV DX,0600H
    MOV AX,00H
    
    MOV AX,OFFSET MIR6;设置中断向量MIR6，中断向量6的起始地址为38H
	MOV SI,0038H
	MOV [ES:SI],AX;低两个字节存储中断向量6的偏移地址
	MOV AX,CS
	MOV SI,003AH
	MOV [ES:SI],AX;高两个字节存储中断向量6的基地址
	
	CLI;设置8259控制字
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
	
judge:
	CMP STAGE,0
	JE ju4chi3
	CMP STAGE,1
	JE ju3xing2
	CMP STAGE,2
	JE san1jiao3
	CMP STAGE,3
	JE jie1ti1
	JMP judge	
	
ju4chi3:;锯齿波，峰值为0FFH
	MOV AL,00H
	OUT DX,AL
	CALL SHORT_DELAY
A1:
	INC AL
	JZ judge;达到峰值就返回主程序
	OUT DX,AL
	CALL SHORT_DELAY
	JMP A1
	
	
ju3xing2:;矩形波，峰值为0FFH
	MOV AL,00H
	OUT DX,AL
	CALL LONG_DELAY
	MOV AL,0FFH
	OUT DX,AL
	CALL LONG_DELAY
    JMP judge    
    
    
san1jiao3:;三角波，峰值为0FFH
	MOV AL,00H
C1:
	OUT DX,AL
	CALL SHORT_DELAY
	INC AL
	JNZ C1
	DEC AL
	DEC AL;使AL=FEH,消除平顶，因为之前已经显示过最高点了
C2:
	OUT DX,AL
	CALL SHORT_DELAY
	DEC AL
	JNZ C2
	JMP judge
	
	
jie1ti1:;阶梯波,峰值可能不是0FFH
	MOV BH,05H;设置阶梯波的阶梯数
	MOV AX,0FFH
	DIV BH;此时0FFH/05H的结果保存在AL中
	MOV BL,AL;BL保存相邻阶梯的高度

	MOV CL,BH;阶梯数循环
	AND CX,0FH
	MOV AL,00H
D1:
	OUT DX,AL
	CALL LONG_DELAY
	ADD AL,BL
	LOOP D1
	OUT DX,AL
	CALL LONG_DELAY
	JMP judge
	
	
SHORT_DELAY:
	PUSH CX
	MOV CX,0FFH
	LOOP $
	POP CX
	RET


LONG_DELAY:
	PUSH CX
	MOV CX,0FFFFH
	LOOP $
	POP CX
	RET
	
	
MIR6:
	INC STAGE
	CMP STAGE,4
	JNE E1
	MOV STAGE,0
E1:
	IRET
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
