;0809片选接IOY1->从0640H开始
;0809使用通道2
;8255片选接IOY0->从0600H开始
CODES SEGMENT
    ASSUME CS:CODES
START:

    MOV AX,0000H
    MOV DS,AX
    
    ;8255初始化
    MOV AL,90H
    MOV DX,0606H;IOY0,8255控制寄存器端口地址
    OUT DX,AL
    
WORK:
    ;启动通道2
    MOV DX,0644H
    OUT DX,AL
    
    CALL DELAY
    
    ;读入
    IN AL,DX
    
    ;输出
    MOV DX,0602H;B口端口地址
    OUT DX,AL
    CALL DELAY
    JMP WORK
    
DELAY:
	PUSH CX
	MOV CX,0FFFFH
	LOOP $
	POP CX
	RET
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
