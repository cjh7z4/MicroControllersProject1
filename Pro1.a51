#include<reg932.inc>

ORG 0

MOV P2M1, #0 					;making P2 bidirectional
MOV P1M1, #0 					;making P1 bidirectional
MOV P0M1, #0 					;making P0 bidirectional

INC_B:	JB P2.0, DEC_B 			;increments if P2.0 is pressed
IBSP:	ACALL DELAY				;delay to prevent debouncing
		JNB P2.0, IBSP 			;holds until button not pressed
		INC A
		SJMP LEDS

		
DEC_B:	JB P0.1, INC_B 			;deincrements if P0.1 is pressed
DBSP:	ACALL DELAY				;delay to prevent debouncing
		JNB P0.1, DBSP 			;holds until button not pressed
		DEC A
		SJMP LEDS
		
LEDS:	CPL A		;complement so bits of A are fight for LED output
		MOV C, ACC.0 			;stores 0 bit of A in C	
		MOV P0.4, C 			;o/p C to P0.4
		
		MOV C, ACC.1 			;stores 1 bit of A in C
		MOV P2.7, C 			;o/p C to P2.7

		MOV C, ACC.2 			;stores 2 bit of A in C
		MOV P0.5, C 			;o/p C to P0.5
		
		MOV C, ACC.3 			;stores 0 bit of A in C
		MOV P2.4, C 			;o/p C to P2.4
		CPL A		;restore A to proper binary not complement
		JNB ACC.4, INC_B ;back to polling if no rollover
		ANL A, #0FH				;masks the upper nibble of A
		SJMP BEEP				;jumps beep
		
		
;code above matches LEDS to A lower nibble so o/p can be seen


BEEP:   MOV R3,#64      
LOOP3:  MOV R2,#32       
LOOP2:  MOV R1,#32        
LOOP1:  MOV R0,#32         
LOOP0:	NOP               
	
		DJNZ R0,LOOP0     ;DECREMENTS REGISTER0 RETURNS TO LOOP0
		DJNZ R1,LOOP1     ;DECREMENTS REGISTER1 RETURNS TO LOOP1
		CPL  P1.7         ;BEEP!!!
		DJNZ R2,LOOP2     ;DECREMENTS REGISTER2 RETURNS TO LOOP2
		DJNZ R3,LOOP3     ;DECREMENTS REGISTER3 RETURNS TO LOOP3
		SJMP INC_B

	
DELAY:	MOV R4, #05H
DELAY1:	MOV R3, #0FFH
DELAY2:	MOV R2, #0FFH
DELAY3:	DJNZ R2, DELAY3 		;creates a delay to prevent debouncing
		DJNZ R3, DELAY2
		DJNZ R4, DELAY1
		RET		
END
