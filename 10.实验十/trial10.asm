DAT SEGMENT
    LEDTABLE 	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,77H,7CH,39H,5EH,79H,71H,00H
    DNUM    DB 10H,10H,10H,10H  ;LED显示内容 
    SNUM    DB 00H,00H ;LED应显示的数字
    ANUM    DB 10H  ;键盘读入字符
    TIMENUM DB 00H,00H  ;读入分钟�?两位BCD�?
    TIMERET DW 0000H,0000H,0000H,0000H ;存放废弃的time up返回地址
    FLAG    DB 00H;输入完标�?
    
    TONUM   EQU 4;LED个数 
    MAXR    EQU 3;最大读键盘次数
    LEFTLED EQU 11111110B;最左LED的位选码 
    INPUT_FLAG DB 00H
    
    PA8255  EQU 0600H
    PB8255  EQU 0602H
    PC8255  EQU 0604H
    CON8255 EQU 0606H
    
    OUT0_8254 EQU 0640H
    OUT1_8254 EQU 0642H
    OUT2_8254 EQU 0644H
    CON_8254  EQU 0646H 
    
    A_8259  EQU 0020H
    B_8259  EQU 0021H
    ICW2_8259 EQU 08H
    MIR6_8259 EQU 38H;MIR6接计时器0口每1秒减少一次数�?
    MIR7_8259 EQU 3CH;MIR7接计时器1口每0.25秒刷新一次LED
    
    MINUTE  EQU  4800H;1毫秒钟计数�?
    RETIME  EQU  4800H;LED刷新时间1毫秒
DAT ENDS
COD SEGMENT
        ASSUME CS:COD,DS:DAT
START:  MOV AX,DAT
        MOV DS,AX  
        
        CALL INIT8255;初始�?255
        CALL INIT8259;初始�?259
        CALL INITTIME;初始化计时器
        ;初始化状�?
S0:     CALL PAUSETIME;停止计数
        CALL INITSTATES;初始化LED状�?
        
        MOV FLAG,00H
        ;初值状�?
        MOV  CX,2;输入两位初�?
S1:     ;CALL DELAYS
        CALL DISPLAYER
        MOV  ANUM,10H
        CALL INPUT
        MOV  AL,ANUM
        CMP  AL,0CH
        JZ   SZ11
        CMP  AL,0AH
        JZ   S2_1
        CMP  AL,09H
        JA   S1
        CALL SHIFTNUM
        LOOP S1
        JMP S2
SZ11:   JMP NEAR PTR SZ  

S2:     ;等待状�?
        ;CALL DELAYS 
        CALL DISPLAYER
        ;读入
        MOV  ANUM,10H
        CALL INPUT
        MOV  AL,ANUM
        CMP  AL,0AH
        JZ   S2_1
        CMP  AL,0CH
        JZ   SZ
        JMP  S2
S2_1:   CALL INPUT_TO_NUM;转化为数�?
		MOV DL,TIMENUM
		MOV CL,4
        ROL DL,CL
        AND DL,0F0H
        MOV DH,TIMENUM+1
        AND DH,0FH
        OR  DL,DH
        CMP DL,00H
        JZ S0
		CALL STATESTO0;置初�?
        CALL STIME;开始计�?
        
        ;计时并等待输入状�?
S3:     ;CALL DELAYS
        CALL DISPLAYER
        MOV  ANUM,10H ;读入
        CALL INPUT
        MOV  AL,ANUM
        CMP  AL,0AH
        JZ   SS0       
        CMP  AL,0BH
        JZ   S4
        CMP  AL,0CH
        JZ   SZ
        JMP  S3
SS0:    JMP FAR PTR S0        
        ;暂停状�?
S4:     CALL PAUSETIME;暂停计时 
S5:     ;CALL DELAYS
        CALL DISPLAYER
        ;读入
        MOV  ANUM,10H 
        CALL INPUT
        MOV  AL,ANUM
        CMP  AL,0AH
        JZ   S5_0      
        CMP  AL,0BH
        JZ   S6
        CMP  AL,0CH
        JZ   SZ
        JMP  S5
S6:     CALL STIME;重新开始计�?
        JMP  S3
        
S5_0:   JMP NEAR PTR S0
          
        ;停止状�?
SZ:     ;CALL PAUSETIME;初始化计时器      
        ;CALL INITSTATES;初始化LED状�?
        CALL EXIT
EXIT:   MOV AH,4CH
        INT 21H
        ;主程序结�?

INPUT_TO_NUM PROC NEAR;输入转化为数�?
		PUSH BX
        PUSH CX
        PUSH DX
        
        LEA BX,DNUM
        MOV DL,TONUM-2[BX]
        CMP	DL,10H
        JNZ ITN1
        MOV DL,00H
ITN1:   MOV TIMENUM,DL 
        MOV DH,TONUM-1[BX]
        MOV TIMENUM+1,DH
        
        POP DX
        POP CX
        POP BX    
        RET
INPUT_TO_NUM ENDP  

      
FLASH_3_TIMES PROC NEAR;闪烁三次
        CLI 
        PUSH CX
        PUSH DX
        
        MOV CX,3
         
FLASH:  CALL INITSTATES
        MOV DX,01FFH  

P0:		CALL DISPLAYS
        DEC DX
		JNZ P0
        
        
       CALL INITSTATE0
       MOV DX,01FFH  

P1:		CALL DISPLAYS
		DEC DX
		JNZ P1
        
        
        LOOP FLASH
        
        CALL INITSTATES
        MOV DX,01FFH  

P2:		CALL DISPLAYS
		DEC DX
		JNZ P2
        
        POP DX
        POP CX
        STI     
        RET
FLASH_3_TIMES ENDP        
           
STATESTO0 PROC NEAR;LED置初�?
        PUSH AX
        PUSH BX 
        
        LEA BX,DNUM
        MOV AL,0[TIMENUM]
        MOV 0[BX],AL
        MOV AL,1[TIMENUM]
        MOV 1[BX],AL
        MOV BYTE PTR 2[BX],00H
        MOV BYTE PTR 3[BX],00H
        
        POP BX
        POP AX
        RET
STATESTO0 ENDP

INITSTATE0 PROC NEAR;LED置全0
        PUSH BX 
        
        LEA BX,DNUM
        MOV BYTE PTR 0[BX],00H
        MOV BYTE PTR 1[BX],00H
        MOV BYTE PTR 2[BX],00H
        MOV BYTE PTR 3[BX],00H
        
        POP BX
        RET
INITSTATE0 ENDP

INITSTATES PROC NEAR;初始化LED状�?
        PUSH BX 
        
        LEA BX,DNUM
        MOV BYTE PTR 0[BX],10H  
        MOV BYTE PTR 1[BX],10H
        MOV BYTE PTR 2[BX],10H
        MOV BYTE PTR 3[BX],10H
        
        POP BX
        RET
INITSTATES ENDP

INIT8255 PROC NEAR 
        PUSH AX
        PUSH DX
        
        ;A口输出，B口输出，C口高4位输�?计数器GATE)，C口低4位输�?
        MOV DX,CON8255 ;INIT 8255
        MOV AL,10000001B
        OUT DX,AL
        
        POP DX
        POP AX
        RET
INIT8255 ENDP

INIT8259 PROC NEAR;初始�?259 
        PUSH AX
        PUSH DX
        
        CLI
        MOV DX,A_8259 ;8259 ICW1
        MOV AL,00010011B
        OUT DX,AL
        MOV DX,B_8259 ;8259 ICW2
        MOV AL,08H
        OUT DX,AL
        MOV DX,B_8259 ;8259 ICW4
        MOV AL,00000111B
        OUT DX,AL 
        MOV DX,B_8259 ;8259 OCW1
        MOV AL,00111111B
        OUT DX,AL
        STI

        CLI
        ;INTP6 -> MIR6
        MOV AX,0
        MOV ES,AX
        MOV DI,MIR6_8259
        MOV AX,OFFSET INTP6
        CLD
        STOSW
        MOV AX,SEG INTP6  
        STOSW     
        ;INTP7 -> MIR7
        MOV AX,0
        MOV ES,AX
        MOV DI,MIR7_8259
        MOV AX,OFFSET INTP7
        CLD
        STOSW
        MOV AX,SEG INTP7  
        STOSW
        STI
        
        POP DX
        POP AX
        RET
INIT8259 ENDP

INITTIME PROC NEAR;初始化计时器
        PUSH AX
        PUSH DX
        
        MOV DX,CON_8254;8254 CONTROL
        MOV AL,00110110B;计数�?方式3初值MINUTE二进�?
        OUT DX,AL
        
        MOV DX,OUT0_8254;8254 COUNTER0
        MOV AX,MINUTE
        OUT DX,AL 
        MOV AL,AH
        OUT DX,AL
        
        MOV DX,CON_8254;8254 CONTROL
        MOV AL,01110110B;计数�?方式3初值RETIME二进�?
        OUT DX,AL
        
        MOV DX,OUT1_8254;8254 COUNTER1
        MOV AX,RETIME
        OUT DX,AL 
        MOV AL,AH
        OUT DX,AL  
        
        POP DX
        POP AX
        RET
INITTIME ENDP

STIME PROC NEAR;开始计�?
        PUSH AX
        PUSH DX
        
        CLI
        MOV DX,B_8259 ;8259 OCW1
        MOV AL,00111111B
        OUT DX,AL
        STI
        
        MOV DX,CON8255 ;C口最高位�?
        MOV AL,00001111B
        OUT DX,AL
        
        POP DX
        POP AX
        RET
STIME ENDP 

PAUSETIME PROC NEAR;暂停计时 
        PUSH AX
        PUSH DX
        
        CLI
        MOV DX,B_8259 ;8259 OCW1
        MOV AL,11111111B
        OUT DX,AL
        STI
        MOV DX,CON8255 ;C口最高位�?
        MOV AL,00001110B
        OUT DX,AL
        
        POP DX
        POP AX
        RET
PAUSETIME ENDP

SHIFTNUM PROC NEAR;DNUM中数字向左移一,ANUM中数字加入最右边一 
        PUSH AX
        PUSH BX
        PUSH SI
        
        LEA BX,DNUM
        MOV SI,1
SH1:    MOV AL,SI[BX]
        MOV [SI-1][BX],AL
        INC SI
        CMP SI,TONUM
        JNZ SH1
        
        MOV AL,ANUM
        DEC SI
        MOV SI[BX],AL
        
        POP SI
        POP BX
        POP AX 
        
        RET
SHIFTNUM ENDP
       
DISPLAYS PROC NEAR ;显示DNUM中的4个数字一�?
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        
        LEA SI,DNUM    ;INIT DATA LEDTABLE
        LEA BX,LEDTABLE
        
D0:     MOV AH,LEFTLED;最�?
        LEA SI,DNUM
        
D1:     MOV CX,TONUM 

D2:     MOV AL,10H;送清空段�?
        XLAT
        MOV DX,PB8255
        OUT DX,AL
        
        JZ D3
        
        ROL AH
        ROL AH
        
D3:
		MOV AL,AH       ;送位�?
        MOV DX,PA8255
        OUT DX,AL 
        
        MOV AL,[SI]     ;送段�?
        XLAT
        MOV DX,PB8255
        OUT DX,AL
        
        CALL DELAY
        
        ROL AH,1  ;位选码左移,选中数码管右�?
        INC SI
        
        LOOP D2
        
        ;清最高一数码�?
        MOV AL,10H;送清空段�?
        XLAT
        MOV DX,PB8255
        OUT DX,AL                   
        
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX 
        
        RET
DISPLAYS ENDP
              
              
INPUT PROC NEAR;读键盘一个数到ANUM,连续MAXR次未读到数会返回  
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        
        MOV BX,MAXR;最大读取键盘次�?
        
I1:     DEC BX
        JZ  I5 ;超出读取次数
        
        MOV DX,PA8255
        MOV AL,00H
        OUT DX,AL
        MOV DX,PC8255
        IN  AL,DX
        AND AL,0FH
        CMP AL,0FH
        JZ  I1
        
        ;CALL DELAYS;消抖
        MOV INPUT_FLAG,01H;;;;;;;
        
        CALL DISPLAYER
        
        MOV INPUT_FLAG,00H
        
        MOV DX,PA8255
        MOV AL,00H
        OUT DX,AL
        MOV DX,PC8255
        IN  AL,DX
        AND AL,0FH
        CMP AL,0FH
        JZ  I1
        
        MOV CL,0;存键�?
        MOV AH,11111110B;列扫�?
I2:     MOV AL,AH
        MOV DX,PA8255
        OUT DX,AL
        MOV DX,PC8255
        IN  AL,DX
        AND AL,0FH
        CMP AL,0FH
        JNZ I3;找到
        ROL AH,1;扫描下一�?
        INC CL;键号加一�?
        CMP AH,11101111B
        JNZ I2
        JMP I1;未找到跳回I1

I3:     CMP AL,00001110B;在第0�?
        JZ I4
        ADD CL,4;键号加一�?
        CMP AL,00001101B;在第1�?
        JZ I4
        ADD CL,4;键号加一�?
        CMP AL,00001011B;在第2�?
        JZ I4
        ADD CL,4;键号加一�?
        CMP AL,00000111B;在第3�?
        JZ I4
        JMP I1
        
I4:     MOV ANUM,CL;存结�?

        CALL DISPLAYS
        MOV DX,PA8255
        MOV AL,00H
        OUT DX,AL
        MOV DX,PC8255
        IN  AL,DX
        AND AL,0FH
        CMP AL,0FH
        JZ  I5
        JMP I4

I5:
        POP DX
        POP CX
        POP BX
        POP AX 
        
        RET
INPUT ENDP

DELAYS PROC NESR 
        PUSH CX 
        
        MOV CX,0FFFFH
        LOOP $  

        POP CX
        RET
DELAYS ENDP

DELAY PROC NEAR
        PUSH CX 
        
        MOV CX,00F8H
        LOOP $  
        
        POP CX
        RET
DELAY ENDP 

INTP6 PROC FAR;MIR6接计时器0口每1秒减少一次数�?全嵌套方式IR6优先级高于IR7 
        STI
        PUSH AX
        
        CALL DTOS
        CALL SUBBCD
        CALL STOD 
        
        MOV AL,0[SNUM]
        CMP AL,00H
        JNZ TZ
        MOV AL,1[SNUM]
        CMP AL,00H 
        JNZ TZ
               
TIMEUP: CALL FLASH_3_TIMES
        POP AX
        POP WORD PTR TIMERET
        POP WORD PTR TIMERET+2
        ;重新开�?
        PUSH COD
        PUSH OFFSET S0
        IRET
      
TZ:     POP AX
        IRET
INTP6 ENDP

INTP7 PROC FAR;MIR7接计时器1口每0.001秒刷新一次LED
        STI
        ;CALL DISPLAYS
        
        IRET
INTP7 ENDP

DISPLAYER PROC NEAR
        PUSH CX
        MOV CX,1FH
DDD1:
        CALL DISPLAYS
        CALL DELAY
        LOOP DDD1
        POP CX
        RET
DISPLAYER ENDP

STOD PROC NEAR ;计算用压缩BCD码转化为非压缩显示用BCD数字
        PUSH AX
        PUSH CX
        PUSH SI
        PUSH DI 
        MOV CL,4   
        
        MOV SI,0
        MOV DI,0
STOD0:  MOV AL,SI[SNUM]
        AND AL,0F0H
        SHR AL,CL
        MOV DI[DNUM],AL
        MOV AL,SI[SNUM]
        AND AL,0FH
        MOV DI+1[DNUM],AL
        INC SI
        INC DI
        INC DI
        CMP DI,TONUM-1
        JNA STOD0
        
;        MOV DI,0 ;将前几位为零的数字转化为不显示的字符10H
;STOD2:  CMP DI[DNUM],00H
;        JNZ STOD1
;        CMP DI,TONUM-1
;        JZ  STOD1
;        MOV DI[DNUM],10H
;        INC DI
;        JMP STOD2    
STOD1:        
        POP DI
        POP SI
        POP CX
        POP AX
        RET
STOD ENDP

DTOS PROC NEAR ;非压缩显示用BCD数字转化为计算用压缩BCD�?
        PUSH AX
        PUSH CX
        PUSH SI
        PUSH DI
        MOV CL,4

        MOV SI,0
        MOV DI,0       
DTOS0:  MOV AL,DI[DNUM]
        AND AL,0FH
        SHL AL,CL
        MOV AH,DI+1[DNUM]
        AND AH,0FH
        OR AL,AH
        MOV SI[SNUM],AL
        INC SI
        INC DI
        INC DI
        CMP DI,TONUM-1
        JNA DTOS0
        
        POP DI
        POP SI
        POP CX
        POP AX
        RET
DTOS ENDP

SUBBCD PROC NEAR ;秒位60进制压缩BCD码减�?
        PUSH AX
        
        MOV AL,1[SNUM]
        SUB AL,1
        DAS  
        CMP AL,99H
        JNZ SUBBCDNO 
        MOV AL,59H
        STC ;有借位
        JMP SUBBCDNEXT
SUBBCDNO:
        CLC ;无借位
SUBBCDNEXT:
        MOV 1[SNUM],AL
        MOV AL,0[SNUM]
        SBB AL,00H
        DAS
        MOV 0[SNUM],AL
        
        POP AX
        RET
SUBBCD ENDP

COD ENDS   
    END START