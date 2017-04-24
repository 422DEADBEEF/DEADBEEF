*-----------------------------------------------------------
* Title      : DEADBEEF Dissasembler
* Written by : DEAFBEEF
* Date       : 04/20/2017
* Description: This will dissasemble the shit out of your binary.
*-----------------------------------------------------------
            ORG         $1000
START:                  ; first instruction of program


            LEA         MSSG, A1            ; load the first message into A1
            MOVE.B      #14,D0              ;
            TRAP        #15                 ; display it

            LEA         STARTMSSG, A1       ; load the start message into A1
            MOVE.B      #14,D0              ;
            TRAP        #15                 ; display it
            
            LEA         HEXINPUT, A1
            MOVE.B      #2, D0              ; set up to read a string from user
            TRAP        #15                 ; Execute Task
            
            MOVE.L      #STARTADDR, param1
            MOVE.B      D1, param2
            JSR         CNVFRMASCII
            

            LEA         ENDMSSG, A1         ; load the end message into A1
            MOVE.B      #14,D0              ;
            TRAP        #15                 ; display it
            
            LEA         HEXINPUT, A1
            MOVE.B      #2, D0              ; set up to read a string from user
            TRAP        #15                 ; Execute Task
            
            MOVE.L      #ENDADDR, param1
            MOVE.B      D1, param2
            JSR         CNVFRMASCII
        

            SIMHALT                         ; halt simulator    
    
*------------Subroutines---------------

*---Convert from ascii----------------------
* This subroutine will convert up to 8 ASCII
* characters stored at A1 and puts the
* numerical value in memory specified by
* param1.
*
* Assumes that param1 is a memory location
* and that the ASCII letters are capitals.
CNVFRMASCII MOVEM.L     D0-D2/A2, -(SP) 
            CLR D0
            MOVEA.L     param1, A2
            MOVE.L      #0, (A2)
            MOVE.B      param2,D1
            MOVE.L      #8, -(SP)
            
            SUB.L       D1, (SP)
            
            MOVE.L      (SP)+, D1
            
            LSR.B       #1,D1               ; quick divide by two
            
            ADDA.L      D1,A2
            
            
            
CONVERTFRM  MOVE.B      (A1),D1             ; copy the first hex character to D3
            CMP.B       #0, D1              ; check if we found the null terminator
            BEQ         CFAEXIT             ; If we do, return from subroutine
            MOVE.B      (A1)+,D2            ; copy the first hex character to D4
            LSR.B       #4, D1              ; shift D3 to just get the top 4 bits
            LSL.B       #4, D2              ; shift D4 twice get just the bottom 4 bits
            LSR.B       #4, D2
            CMP.B       #3,D1               ; if D3 is equal to 3, the hex value is a number
            BEQ         CNVNUM              ; convert to a number
            BRA         CNVLET

CFAEXIT     MOVEM.L     (SP)+,D0-D2/A2
            RTS                             ; exit the from ascii conversion subroutine


CNVNUM      CMP.B       #0, D0              ; check if D0 == 0
            BEQ         SHIFT               ; if equal, these are the top bits (do a shift)
            CLR         D0                  ; if not, clear D0 so we shift next time
            ADD.B       D2, (A2)+           ; add the lower bits with the current upper bits
            BRA         CONVERTFRM          ; go to convert the next value

CNVLET      ADD.B       #9, D2              ; add 9 to the bits (this gives correct value)
            CMP.B       #0, D0              ; check if D0 == 0
            BEQ         SHIFT               ; if equal, these are the top bits (do a shift)
            CLR         D0                  ; if not, clear D0 so we shift next time
            ADD.B       D2, (A2)+           ; add the lower bits with the current upper bits
            BRA         CONVERTFRM          ; go to convert the next value

SHIFT       LSL.B       #4, D2              ; do a logic shift to get lower bits into upper
            MOVE.B      D2, (A2)            ; put this into the position in memory
            MOVE.B      #1, D0              ; copy 1 into D1 (will skip the shift next time)
            BRA         CONVERTFRM          ; go to convert the next value
 
    
    
    
    
    
    
    


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

MSSG        DC.B    'Please enter start and ending memroy addresses.',CR,LF,0
STARTMSSG   DC.B    'Start address: ',0
ENDMSSG     DC.B    'End address: ',0

NEWLINE     DC.B    CR,LF,0

NOP_OP      DC.B    'NOP',0

MOVEB_OP    DC.B    'MOVE.B ',0
MOVEW_OP    DC.B    'MOVE.W ',0
MOVEL_OP    DC.B    'MOVE.L ',0

MOVEAW_OP   DC.B    'MOVEA.W ',0
MOVEAL_OP   DC.B    'MOVEA.L ',0

MOVEQ_OP    DC.B    'MOVEQ ',0

MOVEMW_OP   DC.B    'MOVEM.W ',0
MOVEML_OP   DC.B    'MOVEM.L ',0

ADDB_OP     DC.B    'ADD.B ',0
ADDW_OP     DC.B    'ADD.W ',0
ADDL_OP     DC.B    'ADD.L ',0

ADDAW_OP    DC.B    'ADDA.W ',0
ADDAL_OP    DC.B    'ADDA.L ',0

ADDIB_OP    DC.B    'ADDI.B ',0
ADDIW_OP    DC.B    'ADDI.W ',0
ADDIL_OP    DC.B    'ADDI.L ',0

ADDQB_OP    DC.B    'ADDQ.B ',0
ADDQW_OP    DC.B    'ADDQ.W ',0
ADDQL_OP    DC.B    'ADDQ.L ',0

SUBB_OP     DC.B    'SUB.B ',0
SUBW_OP     DC.B    'SUB.W ',0
SUBL_OP     DC.B    'SUB.L ',0

SUBIB_OP    DC.B    'SUBI.B ',0
SUBIW_OP    DC.B    'SUBI.W ',0
SUBIL_OP    DC.B    'SUBI.L ',0

MULS_OP     DC.B    'MULS.W ',0  

DIVU_OP     DC.B    'DIVU.W ',0

LEA_OP      DC.B    'LEA ',0

ANDB_OP     DC.B    'AND.B ',0
ANDW_OP     DC.B    'AND.W ',0
ANDL_OP     DC.B    'AND.L ',0

ORB_OP      DC.B    'OR.B ',0
ORW_OP      DC.B    'OR.W ',0
ORL_OP      DC.B    'OR.L ',0

LSLB_OP     DC.B    'LSL.B ',0
LSLW_OP     DC.B    'LSL.W ',0
LSLL_OP     DC.B    'LSL.L ',0

LSRB_OP     DC.B    'LSR.B ',0
LSRW_OP     DC.B    'LSR.W ',0
LSRL_OP     DC.B    'LSR.L ',0

ASLB_OP     DC.B    'ASL.B ',0
ASLW_OP     DC.B    'ASL.W ',0
ASLL_OP     DC.B    'ASL.L ',0

ASRB_OP     DC.B    'ASR.B ',0
ASRW_OP     DC.B    'ASR.W ',0
ASRL_OP     DC.B    'ASR.L ',0

ROLB_OP     DC.B    'ROL.B ',0
ROLW_OP     DC.B    'ROL.W ',0
ROLL_OP     DC.B    'ROL.L ',0

RORB_OP     DC.B    'ROR.B ',0
RORW_OP     DC.B    'ROR.W ',0
RORL_OP     DC.B    'ROR.L ',0

BCC_OP      DC.B    'BCC ',0
BLT_OP      DC.B    'BLT ',0
BGT_OP      DC.B    'BGT ',0

JSR_OP      DC.B    'JSR ',0
RTS_OP      DC.B    'RTS',0

BRA_OP      DC.B    'BRA ',0



            END     START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
