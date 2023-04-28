;0809片选接IOY1->从0640H开始
;0809使用通道2
;8255片选接IOY0->从0600H开始
;EOC接到8255A口的最高位
CODES SEGMENT
    ASSUME CS:CODES
START:
    MOV AX,0000H
    MOV DS,AX
    
    ;8255初始化
    MOV AL,90H
    MOV DX,0606H;I0Y0,8255控制寄存器端口地址
    OUT DX,AL
    
WORK:
    ;IOY1,启动通道2
    MOV DX,0644H
    OUT DX,AL
    
ENQUIRY_BEGIN:;判断EOC是否为0（判断是否到了下降沿），没有开始转换就继续判断
	MOV DX,0600H
	IN AL,DX
	TEST AL,80H;相与看结果
	JNZ ENQUIRY_BEGIN
	
ENQUIRY_END:;判断EOC是否为1（判断是否到了上升沿），没有结束转换就继续判断
	MOV DX,0600H
	IN AL,DX
	TEST AL,80H
	JZ ENQUIRY_END
    
    ;读入
    MOV DX,0644H
    IN AL,DX
    
    ;输出
    MOV DX,0602H;IOY0,B口端口地址
    OUT DX,AL
    CALL DELAY
    JMP WORK
    
DELAY:
	MOV CX,0FFFFH
	LOOP $
	RET
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
