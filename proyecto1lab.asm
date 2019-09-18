processor 16f877
include<p16f877.inc>

valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 40h
cte2 equ 80h
cte3 equ 65h
var equ 80h
var2 equ 1h
contador equ h'24'
cp_porta equ h'25'
cp_w equ h'26'

org 0
goto inicio
org 5

inicio
	CLRF PORTA
	CLRF PORTB ; limpio los puertos  que usamos
	BSF STATUS,RP0
	BCF STATUS,RP1 ;Cambio al banco 1 de RAM
	MOVLW 0X06
	MOVWF ADCON1
	MOVLW 0X03
	MOVWF TRISA
	CLRF TRISB
	BCF STATUS,RP0

loop
	MOVF PORTA,W   ; W <-- (PORTA)
	MOVWF cp_porta
	ANDLW 0x03 ; filtro
	ADDWF PCL,F 
	GOTO ping_pong
	GOTO corrimiento
	GOTO expande
	GOTO equipo

ping_pong
	MOVLW b'10000000'
	MOVWF PORTB
	call retardo
	
loop_corr_der_2
	MOVFW PORTA
	SUBLW h'00'
	BTFSS STATUS,Z
	goto loop
	BCF STATUS,C
	RRF PORTB,F
	call retardo
	BTFSS PORTB,0
	GOTO loop_corr_der_2
loop_corr_izq_2
	MOVFW PORTA
	SUBLW h'00'
	BTFSS STATUS,Z
	goto loop
	BCF STATUS,C
	RLF PORTB,F
	call retardo
	BTFSS PORTB,7
	GOTO loop_corr_izq_2
	goto inicio

corrimiento
	MOVLW b'10000000' ; W <-- b'10000000'
	MOVWF PORTB			; (PORTB)<-- W
	call retardo		; llamamos a una subrutina de retardo
loop_corr_1
	MOVFW PORTA
	SUBLW h'01'
	BTFSS STATUS,Z
	goto loop
	BCF STATUS, C
	RRF PORTB,w
	ADDLW var
	MOVWF PORTB
	call retardo
	BTFSS PORTB, 0
	GOTO loop_corr_1
loop_corr_2
	MOVFW PORTA
	SUBLW h'01'
	BTFSS STATUS,Z
	goto loop
	BCF STATUS, C
	RLF PORTB, F
	BCF PORTB, 0
	call retardo
	BTFSC PORTB, 7
	GOTO loop_corr_2
	goto inicio

expande
	CLRF PORTB
	call retardo
	MOVLW b'00011000'
	MOVWF PORTB
	call retardo
loop_expande
	MOVFW PORTA
	SUBLW h'02'
	BTFSS STATUS,Z
	goto loop
	BCF STATUS, C
	RRF PORTB,W
	IORWF PORTB, F
	RLF PORTB,W
	IORWF PORTB,F
	call retardo
	BTFSS PORTB, 0
	GOTO loop_expande
loop_expande_2
	MOVFW PORTA
	SUBLW h'02'
	BTFSS STATUS,Z
	goto loop
	BCF STATUS, C
	RlF PORTB, W
	ANDWF PORTB, F
	BCF STATUS,0
	RRF PORTB,W
	ANDWF PORTB,F
	call retardo
	BTFSC PORTB,4
	
	GOTO loop_expande_2
	goto inicio

equipo
	BSF STATUS,0
	CLRF PORTB
	MOVLW b'00000000'
	MOVWF contador
	call retardo
	rlf PORTB
loop_numero_equipo
	call retardo
	INCF contador, F
	MOVLW b'0000011'
	MOVWF PORTB
	MOVFW PORTA
	SUBLW h'03'
	BTFSS STATUS,Z
	goto loop
	BCF STATUS,C
	BTFSS contador, 2
	goto loop_numero_equipo	
	CLRF PORTB
	BSF STATUS,0
	RLF PORTB
	call retardo
	RRF PORTB
	call retardo
	goto inicio



retardo movlw cte1
 movwf valor1
tres movlw cte2
 movwf valor2
dos movlw cte3
 movwf valor3
uno decfsz valor3
 goto uno
 decfsz valor2
 goto dos
 decfsz valor1
 goto tres
 return
 END