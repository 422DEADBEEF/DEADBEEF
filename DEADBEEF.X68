*-----------------------------------------------------------
* Title      : DEADBEEF Dissasembler
* Written by : DEAFBEEF
* Date       : 04/20/2017
* Description: This will dissasemble the shit out of your binary.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program


            LEA MSSG, A1        ; load the first message into A1
            MOVE.B #14,D0       ;
            TRAP #15            ; display it

            LEA STARTMSSG, A1  ; load the start message into A1
            MOVE.B #14,D0       ;
            TRAP #15            ; display it
            
            LEA HEXINPUT, A1
            MOVE.B #2, D0       ; set up to read a string from user
            TRAP #15            ; Execute Task
            
            MOVE.L #STARTADDR, param1
            MOVE.B D1, param2
            JSR CNVFRMASCII
            

            LEA ENDMSSG, A1     ; load the end message into A1
            MOVE.B #14,D0       ;
            TRAP #15            ; display it
            
            LEA HEXINPUT, A1
            MOVE.B #2, D0       ; set up to read a string from user
            TRAP #15            ; Execute Task
            
            MOVE.L #ENDADDR, param1
            MOVE.B D1, param2
            JSR CNVFRMASCII


* Put program code here

    SIMHALT             ; halt simulator
    
*------------Subroutines---------------

*---Convert from ascii----------------------
* This subroutine will convert up to 8 ASCII
* characters stored at A1 and puts the
* numerical value in memory specified by
* param1.
*
* Assumes that param1 is a memory location
* and that the ASCII letters are capitals.
CNVFRMASCII MOVEM.L D0-D2/A2, -(SP) 
            CLR D0
            MOVEA.L param1, A2
            MOVE.L #0, (A2)
            MOVE.B param2,D1
            MOVE.L #8, -(SP)
            
            SUB.L D1, (SP)
            
            MOVE.L (SP)+, D1
            
            LSR.B #1,D1          ; quick divide by two
            
            ADDA.L D1,A2
            
            
            
CONVERTFRM  MOVE.B (A1),D1      ; copy the first hex character to D3
            CMP.B #0, D1        ; check if we found the null terminator
            BEQ CFAEXIT         ; If we do, return from subroutine
            MOVE.B (A1)+,D2     ; copy the first hex character to D4
            LSR.B #4, D1        ; shift D3 to just get the top 4 bits
            LSL.B #4, D2        ; shift D4 twice get just the bottom 4 bits
            LSR.B #4, D2
            CMP.B #3,D1         ; if D3 is equal to 3, the hex value is a number
            BEQ CNVNUM          ; convert to a number
            BRA CNVLET

CFAEXIT     MOVEM.L (SP)+,D0-D2/A2
            RTS                 ; exit the from ascii conversion subroutine


CNVNUM      CMP.B #0, D0        ; check if D0 == 0
            BEQ SHIFT           ; if equal, these are the top bits (do a shift)
            CLR D0              ; if not, clear D0 so we shift next time
            ADD.B D2, (A2)+     ; add the lower bits with the current upper bits
            BRA CONVERTFRM      ; go to convert the next value

CNVLET      ADD.B #9, D2        ; add 9 to the bits (this gives correct value)
            CMP.B #0, D0        ; check if D0 == 0
            BEQ SHIFT           ; if equal, these are the top bits (do a shift)
            CLR D0              ; if not, clear D0 so we shift next time
            ADD.B D2, (A2)+     ; add the lower bits with the current upper bits
            BRA CONVERTFRM     ; go to convert the next value

SHIFT       LSL.B #4, D2        ; do a logic shift to get lower bits into upper
            MOVE.B D2, (A2)     ; put this into the position in memory
            MOVE.B #1, D0       ; copy 1 into D1 (will skip the shift next time)
            BRA CONVERTFRM     ; go to convert the next value
 
    
    
    
    
    
    
    


*-------------Variables-----------------

param1      DS.L    1
param2      DS.L    1
param3      DS.L    1
param4      DS.L    1

ret         DS.L    1


STARTADDR   DS.L    1
ENDADDR     DS.L    1

HEXINPUT    DS.B    9



*-------------Constants-----------------
CR          EQU     $0D
LF          EQU     $0A

MSSG        DC.B 'Please enter start and ending memroy addresses.',CR,LF,0
STARTMSSG   DC.B 'Start address: ',0
ENDMSSG     DC.B 'End address: ',0

NEWLINE     DC.B CR,LF,0

NOPOP       DC.B 'NOP',0

MOVEBOP     DC.B 'MOVE.B ',0
MOVEWOP     DC.B 'MOVE.W ',0
MOVELOP     DC.B 'MOVE.L ',0

MOVEAWOP    DC.B 'MOVEA.W ',0
MOVEALOP    DC.B 'MOVEA.L ',0

MOVEQOP     DC.B 'MOVEQ ',0

MOVEMWOP    DC.B 'MOVEM.W ',0
MOVEMLOP    DC.B 'MOVEM.L ',0

ADDBOP      DC.B 'ADD.B ',0
ADDWOP      DC.B 'ADD.W ',0
ADDLOP      DC.B 'ADD.L ',0

ADDAWOP     DC.B 'ADDA.W ',0
ADDALOP     DC.B 'ADDA.L ',0

ADDIBOP     DC.B 'ADDI.B ',0
ADDIWOP     DC.B 'ADDI.W ',0
ADDILOP     DC.B 'ADDI.L ',0

ADDQBOP     DC.B 'ADDQ.B ',0
ADDQWOP     DC.B 'ADDQ.W ',0
ADDQLOP     DC.B 'ADDQ.L ',0

SUBBOP      DC.B 'SUB.B ',0
SUBWOP      DC.B 'SUB.W ',0
SUBLOP      DC.B 'SUB.L ',0

SUBIBOP     DC.B 'SUBI.B ',0
SUBIWOP     DC.B 'SUBI.W ',0
SUBILOP     DC.B 'SUBI.L ',0

MULSOP      DC.B 'MULS.W ',0  

DIVUOP      DC.B 'DIVU.W ',0

LEAOP       DC.B 'LEA ',0

ANDBOP       DC.B 'AND.B ',0
ANDWOP       DC.B 'AND.W ',0
ANDLOP       DC.B 'AND.L ',0

ORBOP       DC.B 'OR.B ',0
ORWOP       DC.B 'OR.W ',0
ORLOP       DC.B 'OR.L ',0

LSLBOP      DC.B 'LSL.B ',0
LSLWOP      DC.B 'LSL.W ',0
LSLLOP      DC.B 'LSL.L ',0

LSRBOP      DC.B 'LSR.B ',0
LSRWOP      DC.B 'LSR.W ',0
LSRLOP      DC.B 'LSR.L ',0

ASLBOP      DC.B 'ASL.B ',0
ASLWOP      DC.B 'ASL.W ',0
ASLLOP      DC.B 'ASL.L ',0

ASRBOP      DC.B 'ASR.B ',0
ASRWOP      DC.B 'ASR.W ',0
ASRLOP      DC.B 'ASR.L ',0

ROLBOP      DC.B 'ROL.B ',0
ROLWOP      DC.B 'ROL.W ',0
ROLLOP      DC.B 'ROL.L ',0

RORBOP      DC.B 'ROR.B ',0
RORWOP      DC.B 'ROR.W ',0
RORLOP      DC.B 'ROR.L ',0

BCCOP       DC.B 'BCC ',0
BLTOP       DC.B 'BLT ',0
BGTOP       DC.B 'BGT ',0

JSROP       DC.B 'JSR ',0
RTSOP       DC.B 'RTS',0

BRAOP       DC.B 'BRA ',0



    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
