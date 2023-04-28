A0832 EQU 0600H  
  

CODE SEGMENT
    ASSUME  CS:CODE

START:
    MOV CX, 030H       ;锯齿波周期数
JUCHI:
    MOV DX, A0832     ;DAC0832接IOY0,0600H为控制端口地址
    MOV AL, 00H       ;AL为数字量
JC1: 
    OUT DX, AL        ;转换为模拟量
    CALL DELAY1       ;延时，此为短延时
    CMP AL ,0FFH
    JZ JC2
    INC AL            ;AL步加1，直到等于0FFH
    JMP JC1
JC2:
    LOOP JUCHI

    ;产生矩形波
    MOV CX, 05H       ;矩形波周期数
JUXING:
    MOV DX, A0832
    MOV AL, 00H       ;先输出00H的波形
    OUT DX, AL
    CALL DELAY2       ;长延时
    MOV AL, 0FFH      ;再输出0FFH的波形
    OUT DX, AL
    CALL DELAY2       ;长延时
    LOOP JUXING

    
    ;产生三角波
A1:    MOV CX, 0FH     ;三角波周期数
SANJIAO:
MOV AL,00H
SJ1:
    OUT DX,AL
	CALL DELAY1
	INC AL
	JNZ SJ1
	DEC AL
	DEC AL;使AL=FEH,消除平顶
SJ2:
    OUT DX,AL
	CALL DELAY1
	DEC AL
	JNZ SJ2
	LOOP SANJIAO

    
    ;产生阶梯波
    MOV CX, 0FFFFH     ;产生阶梯波的周期数为0FFFF次，如果想改变阶梯波产生周期请修改这里
    MOV AX, 0FEH       
    ;波形振幅最大值为0FFH
    ;考虑到8086的DIV除法可能会出现余数为负导致加起来之后的最大值大于0FFH，故使用0FEH作最大值
    MOV BL,05H         ;阶梯波中的阶梯数，如果想改变阶梯波中的阶梯数请修改这里
    DIV BL             ;用最大振幅除以阶梯数，得到每个台阶的高度
    MOV BL, AL         ;将上述除法的商保存在BL中
    MOV BH, 00H        ;BH置0
JIETI:
    MOV AX,0000H       ;AX初始化0000H
JT1:
    MOV DX, A0832
    OUT DX, AL
    CMP AX, 00FFH      ;判断AX是否达到幅度上线
    JAE JT2            ;达到上限，表示一次阶梯波完整生成，开始新一次生成
    CALL DELAY2        ;长延时
    ADD AX, BX         ;用当前解体高度加上每个阶梯的高度得到下一阶梯的高度
    JMP JT1
JT2:    
    LOOP JIETI


DELAY1:                ;短延时
    PUSH CX
    MOV CX, 01FFH
D1: 
    PUSH AX
    POP AX
    LOOP D1
    POP CX
    RET

DELAY2:               ;长延时
    PUSH CX
    MOV CX, 0FFFFH
D2: 
    PUSH AX
    POP AX
    LOOP D2
    POP CX
    RET

CODE ENDS
    END START
