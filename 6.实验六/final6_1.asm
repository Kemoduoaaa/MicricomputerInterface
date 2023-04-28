;8254片选接IOY0
COUNTER0 EQU 0600H;计数器0
COUNTER1 EQU 0602H;计数器1
COUNTER2 EQU 0604H;计数器2
CONTROL8254 EQU 0606H;控制寄存器

CODES SEGMENT
    ASSUME CS:CODES
START:
    MOV AX,00H
    MOV DS,AX
    
    MOV DX,CONTROL8254
    MOV AL,70H;8254计数器1工作方式0，计数时输出低电平，到0时输出高电平
    OUT DX,AL
    
    MOV DX,COUNTER1
    
    ;写入计数值05H，KK1接8254的时钟输入口
    MOV AL,05H 
    OUT DX,AL
    MOV AL,00H
    OUT DX,AL
    
AA1:
	JMP AA1
	
;将GATE1置为高电平，在示波器中可以观察到OUT1输出低电平，等到第6次按下KK1之后，输出高电平
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
