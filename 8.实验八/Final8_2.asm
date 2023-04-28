;8255接口初始化，由CS连接的IOY端口决定。这里用的是IOY0。
A8255_CON EQU 0606H
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
;数码管的数据表，分别表示303271 从右向左点亮 从左往右看就是数字“172303”了 我的学号后六位 
DATA 	SEGMENT
TABLE1:
    	DB 07H;7
    	DB 3FH;0
    	DB 5BH;2
    	DB 06H;1
    	DB 3FH;0
    	DB 5BH;2
		
VALUE	DB 20H						;用于开关控制
DATA 	ENDS
CODE 	SEGMENT
		ASSUME CS:CODE,DS:DATA
START:
		MOV AX,DATA
		MOV DS,AX
		LEA SI,TABLE1
		MOV DX,A8255_CON
		MOV AL,89H					;89H=10001001B A口方式0 输出 B口方式0 输出 C口 输入（高四位和低四位均用于输入）
		OUT DX,AL
		;当初测试用的遗留代码
		MOV DX,A8255_B
		MOV AL,3FH
		OUT DX,AL
		MOV DX,A8255_A
		MOV AL,00H
		OUT DX,AL
		;位选信号置0 相应数码管点亮
X2:    
		MOV CX,06H					;循环6次
		MOV BX,0000H
		MOV VALUE,20H				;开放数码管6
		MOV AL,11011111B			;数码管6将要点亮
X1: 
		PUSH AX
		MOV DX,A8255_C
		IN  AL,DX					;读入C口状态 即开关状态
		TEST VALUE,AL				;测试控制相应数码管的开关是否打开 这里为正逻辑 1点亮 0熄灭
		JZ A1						;相应开关为0 应熄灭 转A1
		POP AX						;开关为1 应点亮 继续往下执行
		MOV DX,A8255_A
		OUT DX,AL	
A2:		ROR VALUE,1					;调整 开放下一个数码管
		ROR AL,1					;调整 将要点亮下一个数码管;;;;;;;;
		PUSH AX
		MOV AL,[BX+SI]
		MOV DX,A8255_B
		OUT DX,AL					;在相应数码管上显示相应数字 如果开关为1的话
		POP AX
		CALL DELAY
		INC BX
		LOOP X1
		JMP X2
A1: 								;处理熄灭
		MOV AL,11111111B			;所有位选信号不选中 0为选中 1为不选中
		MOV DX,A8255_A
		OUT DX,AL
		POP AX
		JMP A2    
DELAY:
		PUSH CX
		MOV CX,0FFH					;由于要显示稳定的数字“172303” 延时要短
X4:
		LOOP X4						
		POP CX
		RET
CODE 	ENDS
		END START