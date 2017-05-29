*****************************
*
*
* Created 2/18/2016
*
* Test program
*
*****************************

start		EQU	$00007000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	start

* NOP and similar instructions. Should clearly differentiate NOP and RTS from others.
		ADDQ.B	#4, D1
		ADDQ.B	#8, D1
                LEA     (A5), A2
		LEA     (A0), A6
		LEA     data1, A7
                ROL.B   #2, D1
		ROR.W   D2, D3
		ASL.B   #5, D0
		ASR.L   #4, D5
		LSL.B   D7, D1
		LSR.L   D2, D4
		LSL.W   (A1)
        JSR     add_start
		JSR     $0001
		LEA     data1, A7
		LEA     $0001, A0
		SUB.B   D1, D2
		ADDQ.B	#4, D1
	        ADDQ.W	#2, D3
	        ADDQ.L	#5, D6
	        ADDQ.B  #7, $0001
	        ;ADDQ.B  #3, A2   ;invalid code
	        ADDQ.L  #6, (A3)
	        ADDQ.L  #6, -(A3)
	        ADDQ.L  #6, (A3)+
		NOP                     *Required
		RTS                     *Required
		STOP	#$2000          * Not required instruction

* This is a group of ADD instructions

add_start	ADDI.W	#$4000,D0	
		
* This is a group of SUB instructions
subtracts	SUBA.W	(A4),A6

* Group is random data

data1		DC.B		$FF,$AA,$45,$0A

* Move instructions

moves		MOVE.B	D0,D1
                MOVEM.L (A0)+, D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7
                MOVEM.L D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7, -(A3)
                
                MOVEM.L (A0), D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7
                MOVEM.L (SP)+, D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7
                MOVEM.L $2000, D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7                
                MOVEM.L D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7, $2000
                MOVEM.L D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7, -(A3)
                MOVEM.L D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7, (A3)


                MOVEM.W D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7, $A123
                MOVEM.L D0/D1/D3/D4/D6/D7/A1/A2/A3/A5/A7, -(A3)                
data5		DC.B	'Here is some interspersed data'
		
* Divide and multiple optional instructions
	
ands		AND.B	#$01,$4568
                OR.B    D1, D0
                OR.W    $4000, D5
                OR.L    $5000, D7
                OR.B    D0, $2300
                OR.W    D5, $7211
                OR.L    D6, $A320

shifts		ASL.B	D0,D0

rolls		ROL.L	D2,D3

clear		CLR	D4

load_addr	LEA	$DC00FF00,A2

* random data	
		DC.W	2949,0411,2848,7869

compares	CMP.B	(A3),D5

* Branches	
		

* Jump and branch instructions

jmplabel	BCC	compares		
		BGT	compares		
		BLE	compares	
		
*These are not required instructions
multiply	MULS	D0,D3
		DIVU	(A3),D5	*Optional instruction
		DIVU    $4000, D1
		DIVU    $12345678, D2
		DIVU    #$97, D7
DU1             DC.W    $8ECE

		END	start
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
