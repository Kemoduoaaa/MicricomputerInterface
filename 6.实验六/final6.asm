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
    ;MOV AL,70H;计数器1工作在方式0
    ;MOV AL,72H;方式1
    MOV AL,74H;方式2
    ;MOV AL,76H;方式3
    OUT DX,AL
    
    ;方式0：GATE1接5V电源，CLK1接KK1+好观察
    ;方式1：GATE1接K0开关，CLK1接时钟源18.432KHz好观察
    ;方式2：用方式三形成的周期为1s的方波做方式2的时钟源
    ;方式3：GATE1接5V电源，CLK1接时钟源18.432KHz好观察
    
    MOV DX,COUNTER1
    
    MOV AL,00H;低8位
    OUT DX,AL
    MOV AL,48;高8位
    OUT DX,AL
    
AA1:
	JMP AA1
;将GATE置为高电平，运行程序，在示波器中可以看到OUT1输出一段高电平后会输出一个宽度为一个周期的负脉冲

    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
