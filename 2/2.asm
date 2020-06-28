;-----------------------------------------------------------
;
;              Build this with the "Source" menu using
;                     "Build All" option
;
;-----------------------------------------------------------
;
;                           实验二示例程序 

;-----------------------------------------------------------
;                                                          |
;                                                          |
; 功能：控制7段数码管的显示                                |
; 编写：《嵌入式系统原理与实验》课程组                     |
;-----------------------------------------------------------
		DOSSEG
		.MODEL	SMALL		; 设定8086汇编程序使用Small model
		.8086				; 设定采用8086汇编指令集;-----------------------------------------------------------
;
;              Build this with the "Source" menu using
;                     "Build All" option
;
;-----------------------------------------------------------
;
;                           实验二示例程序 

;-----------------------------------------------------------
;                                                          |
;                                                          |
; 功能：控制7段数码管的显示                                |
; 编写：《嵌入式系统原理与实验》课程组                     |
;-----------------------------------------------------------
		DOSSEG
		.MODEL	SMALL		; 设定8086汇编程序使用Small model
		.8086				; 设定采用8086汇编指令集
;-----------------------------------------------------------
;	符号定义                                               |
;-----------------------------------------------------------
;
; 8255芯片端口地址 （Port number）分配:
PortA	EQU		91H			; Port A's port number in I/O space
PortB	EQU 	93H			; Port B's port number in I/O space
PortC	EQU 	95H			; Port C's port number in I/O space
CtrlPT	EQU 	97H			; 8255 Control Register's port number in I/O space
;
Patch_Protues	EQU		IN AL, 0	;	Simulation Patch for Proteus, please ignore this line


;-----------------------------------------------------------
;	定义数据段                                             |
;-----------------------------------------------------------
		.data					; 定义数据段;

DelayShort	dw	400   			; 短延时参量	
DelayLong	dw	40000			; 长延时参量

; 显示数字
DISCHAR DB 01,02,03,04

; SEGTAB是显示字符0-F，其中有部分数据的段码有错误，请自行修正
SEGTAB  	DB 3FH	; 7-Segment Tube, 共阴极类型的7段数码管示意图
		DB 06H	;
		DB 5BH	;            a a a
		DB 4FH	;         f         b
		DB 66H	;         f         b
		DB 6DH	;         f         b
		DB 7DH	;            g g g 
		DB 07H	;         e         c
		DB 7FH	;         e         c
		DB 6FH	;         e         c
        	DB 77H	;            d d d     h h h
		DB 7CH	; ----------------------------------
		DB 39H	;       b7 b6 b5 b4 b3 b2 b1 b0
		DB 5EH	;       DP  g  f  e  d  c  b  a
		DB 79H	;
		DB 71H	; Original 7EH is wrong!!


;-----------------------------------------------------------
;	定义代码段                                             |
;-----------------------------------------------------------
		.code						; Code segment definition
		.startup					; 定义汇编程序执行入口点
;------------------------------------------------------------------------
		Patch_Protues				; Simulation Patch for Proteus,
									; Please ignore the above code line.
;------------------------------------------------------------------------


; Init 8255 in Mode 0
; PortA Output, PortB Output
;
		MOV AL,10001001B
		OUT CtrlPT,AL	;
;
; 把数字1、2、3、4显示在数码管上
;

L1: 
		IN AL,PortC
		NOT AL
		AND AL,11110000B
		OR AL,00000101B
		OUT PortA,AL
		IN AL,PortC
		NOT AL
		AND AX,000FH
		MOV BX,AX
		MOV AL,SEGTAB[BX]
		OUT PortB,AL
		CALL DELAY
		
		IN AL,PortC
		NOT AL
		AND AL,11110000B
		OR AL,00001010B
		OUT PortA,AL
		IN AL,PortC
		NOT AL
		AND AX,00F0H
		MOV CL,4
		SHR AX,CL
		MOV BX,AX
		MOV AL,SEGTAB[BX]
		OUT PortB,AL
		CALL DELAY
		
		JMP L1		
RET
;--------------------------------------------
;                                           |
; Delay system running for a while          |
; CX : contains time para.                  |
;                                           |
;--------------------------------------------

DELAY1 	PROC
    	PUSH CX
    	MOV CX,DelayLong	;
D0: 	LOOP D0
    	POP CX
    	RET
DELAY1 	ENDP


;--------------------------------------------
;                                           |
; Delay system running for a while          |
;                                           |
;--------------------------------------------

DELAY 	PROC
    	PUSH CX
    	MOV CX,DelayShort
D1: 	LOOP D1
    	POP CX
    	RET
DELAY 	ENDP


;-----------------------------------------------------------
;	定义堆栈段                                             |
;-----------------------------------------------------------
		.stack 100h				; 定义256字节容量的堆栈


		END						;指示汇编程序结束编译
;-----------------------------------------------------------
;	符号定义                                               |
;-----------------------------------------------------------
;

;-----------------------------------------------------------
;	定义数据段                                             |
;-----------------------------------------------------------
		.data					; 定义数据段;

	;		
;-----------------------------------------------------------
;	定义代码段                                             |
;-----------------------------------------------------------
		.code						; Code segment definition
		.startup					; 定义汇编程序执行入口点

;-----------------------------------------------------------
;主程序部分,向扩展的存储器内放数据                         |
;-----------------------------------------------------------
		MOV AX,4000H                    ;指定DS开始地址
		MOV DS,AX
		MOV BX,0H
	
		MOV BYTE PTR [BX],0FFH					; 内存中写入0FFh
L:     
		MOV BYTE PTR [BX],0FFH			;将AL中的数据以字节为单位送到DS:BX所指字节单元
		INC AL
		INC BX
		JNZ L

WT: 
		JMP WT

		


;-----------------------------------------------------------
;	定义堆栈段                                             |
;-----------------------------------------------------------
		.stack 100h				; 定义256字节容量的堆栈


		END						;指示汇编程序结束编译
