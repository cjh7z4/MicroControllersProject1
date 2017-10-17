#include<reg932.inc>

ORG 0

MOV P2M1, #0 					;making P2 bidirectional
MOV P1M1, #0 					;making P1 bidirectional
MOV P0M1, #0 					;making P0 bidirectional

;;;;;;;start button check loop and new functions
MAIN:	CLR P2.5				;turn on bottom left LED
		CLR P0.7				;turn on bottom middle LED
		CLR P2.6				;turn on bottom right LED
		JB P2.1, G_B			;jumps to main program if bottom left button pushed
MBSP:	ACALL DELAY	
		JNB P2.1, MBSP			;holds until button not pressed
		SETB P2.5				;turn off bottom left LED
		SETB P0.7				;turn off bottom middle LED
		SETB P2.6				;turn off bottom right LED
		ACALL COUNTER			;jumps to INC_B
		
G_B:	JB P0.3, D_B			;jumps to George's function if bottom middle button pushed
GBSP:	ACALL DELAY
		JNB P0.3, GBSP			;holds until button not pressed
		SETB P2.5				;turn off bottom left LED
		SETB P0.7				;turn off bottom middle LED
		SETB P2.6				;turn off bottom right LED
		SJMP GEORGE			;jumps to George's program

D_B:	JB P2.2, MAIN			;jumps to Darrin's function if bottom right button pushed
DABSP:	ACALL DELAY		
		JNB P2.2, DABSP			;holds until button not pressed
		SETB P2.5				;turn off bottom left LED
		SETB P0.7				;turn off bottom middle LED
		SETB P2.6				;turn off bottom right LED
		SJMP DARRIN				;jumps to Darrin's program
		
GEORGE:
		LJMP MAIN				;empty location for George's function
		
;;;;;;;;;Darrin's function below		
DARRIN:							;program to make a fun led display show
		ACALL DELAY
		ACALL DELAY
		CLR P1.6				;middle middle
		ACALL DELAY
		SETB P1.6
		CLR P0.7				;bottom middle
		ACALL DELAY
		SETB P0.7
		CLR P2.5				;BL
		ACALL DELAY
		SETB P2.5
		CLR P0.6				;ML
		ACALL DELAY
		SETB P0.6
		CLR P2.4				;TL
		ACALL DELAY
		SETB P2.4
		CLR P0.5				;TM
		ACALL DELAY
		SETB P0.5
		CLR P2.7				;TR
		ACALL DELAY
		SETB P2.7
		CLR P0.4				;MR
		ACALL DELAY
		SETB P0.4
		CLR P2.6				;BR
		ACALL DELAY
		SETB P2.6
		CLR P0.7				;BM
		ACALL DELAY
		SETB P0.7
		CLR P1.6				;MM ON
		ACALL DELAY
		CLR P2.4				;TL ON
		CLR P2.7				;TR ON
		CLR P2.6				;BR ON
		CLR P2.5				;BL ON
		SETB P1.6				;MM OFF
		ACALL DELAY
		CLR P0.5				;TM ON
		CLR P0.7				;BM ON
		CLR P0.6				;ML ON
		CLR P0.4				;MR ON
		ACALL DELAY
		ACALL DELAY
		SETB P2.4				;TL OFF
		ACALL DELAY
		SETB P0.6				;ML OFF
		ACALL DELAY
		SETB P2.5				;BL OFF
		ACALL DELAY
		SETB P0.7				;BM OFF
		ACALL DELAY
		SETB P2.6				;BR OFF
		ACALL DELAY
		SETB P0.4				;MR OFF
		ACALL DELAY
		SETB P2.7				;TR OFF
		ACALL DELAY
		SETB P0.5				;TM OFF
		ACALL DELAY
		CLR P1.6				;MM ON
		ACALL DELAY
		ACALL DELAY
		SETB P1.6				;MM OFF
		ACALL DELAY
		ACALL DELAY
								;START CIRCLE LOOP
		ACALL DELAY
		MOV R7, #04H
CIRCLE: CLR P2.4				;TL ON
		CLR P2.7				;TR ON
		CLR P2.6				;BR ON
		CLR P2.5				;BL ON
		ACALL DELAY
		SETB P2.4				;TL OFF
		SETB P2.7				;TR OFF
		SETB P2.6				;BR OFF
		SETB P2.5				;BL OFF
		CLR P0.5				;TM ON
		CLR P0.7				;BM ON
		CLR P0.6				;ML ON
		CLR P0.4				;MR ON
		ACALL DELAY
		SETB P0.5				;TM OFF
		SETB P0.7				;BM OFF
		SETB P0.6				;ML OFF
		SETB P0.4				;MT OFF
		DJNZ R7, CIRCLE
		ACALL DELAY
		CLR P1.6				;MM ON
		ACALL DELAY
		ACALL DELAY
		SETB P1.6				;MM OFF
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		
		LJMP MAIN	
		
;;;;;;;end button checking loop and start of General subroutines

DELAY:	MOV R4, #08H
DELAY1:	MOV R3, #0FFH
DELAY2:	MOV R2, #0FFH
DELAY3:	DJNZ R2, DELAY3 		;creates a delay to prevent debouncing
		DJNZ R3, DELAY2
		DJNZ R4, DELAY1
RET

BEEP: 	MOV R3,#64      
LOOP3:  MOV R2,#32       
LOOP2:  MOV R1,#32        
LOOP1:  MOV R0,#32         
LOOP0:	NOP               
	
		DJNZ R0,LOOP0     ;DECREMENTS REGISTER0 RETURNS TO LOOP0
		DJNZ R1,LOOP1     ;DECREMENTS REGISTER1 RETURNS TO LOOP1
		CPL  P1.7         ;BEEP!!!
		DJNZ R2,LOOP2     ;DECREMENTS REGISTER2 RETURNS TO LOOP2
		DJNZ R3,LOOP3     ;DECREMENTS REGISTER3 RETURNS TO LOOP3
RET
	
;;;;;;;;end of general subroutines, begining of Counter subroutine

COUNTER:CLR PSW.5				;set the exit FLAG to 0.

EXIT_B:	JB P2.2, RES_B 			;resets if P2.0 is pressed
EBSP:	ACALL DELAY				;delay to prevent debouncing
		JNB P2.2, EBSP 			;holds until button not pressed
		SETB PSW.5				;R2 is a flag for exit
		SJMP CLR_EX

RES_B:	JB P2.3, INC_B 			;resets if P2.0 is pressed
RBSP:	ACALL DELAY				;delay to prevent debouncing
		JNB P2.3, RBSP 			;holds until button not pressed
CLR_EX: CLR A					;resets A
		ACALL BEEP				;beeps if reset
		SJMP LEDS
		
INC_B:	JB P2.0, DEC_B 			;increments if P2.0 is pressed
IBSP:	ACALL DELAY				;delay to prevent debouncing
		JNB P2.0, IBSP 			;holds until button not pressed
		INC A
		SJMP LEDS
		
DEC_B:	JB P0.1, EXIT_B 		;deincrements if P0.1 is pressed
DBSP:	ACALL DELAY				;delay to prevent debouncing
		JNB P0.1, DBSP 			;holds until button not pressed
		DEC A
		
LEDS:	CPL A		;complement so bits of A are fight for LED output

		MOV C, ACC.0 			;stores 0 bit of A in C	
		MOV P0.4, C 			;o/p C to P0.4
		
		MOV C, ACC.1 			;stores 1 bit of A in C
		MOV P2.7, C 			;o/p C to P2.7

		MOV C, ACC.2 			;stores 2 bit of A in C
		MOV P0.5, C 			;o/p C to P0.5
		
		MOV C, ACC.3 			;stores 0 bit of A in C
		MOV P2.4, C 			;o/p C to P2.4
;code above matches LEDS to A lower nibble so o/p can be seen

		CPL A		;re-store A to proper binary not complement
		JNB ACC.4, SKIP_BP	;jumps if NOT rollover
		ACALL BEEP			;call beep when rollover
SKIP_BP:ANL A, #0FH			;masks the upper nibble of A
	
		MOV C, PSW.0	;code for showing parity flag LED
		MOV P0.7, C		;green shows not parity
		CPL C
		MOV P2.5, C		;yellow shows parity
		
		JNB PSW.5, Res_B;back to polling if not exit flag
		SETB P0.7		;Reset not parity LED
		CLR PSW.5		;resets flag
RET						;EXITS counter

END