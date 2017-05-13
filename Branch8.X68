*-----------------------------------------------------------
* Title      : Branch 8
* Written by : Cameron Dillon
* Date       : 5/2/2017
* Description: Dissassembly soubroutine for Branch 8 (DIVU, OR)
*-----------------------------------------------------------


BRANCH8             MOVEM.L     D0-D7/A0-A5, -(SP)
                    CLR.L       D6
                    CLR.L       D7
                    MOVE.B      #1, D7
                    
                    MOVEA.L     #O1STRING, A1
                    MOVEA.L     #O2STRING, A2

                    MOVE.W      (A6)+, D0
                    MOVE.W      D0, D1
                    MOVE.W      D0, D2
                    AND.W       #DSTREG_MASK, D2
                    ROL.W       #7, D2
                    AND.W       #B8_OPMODE_MASK, D1
                    CMP.W       #B8_DIVU_MASK, D1
                    BEQ         B8_DIVU_DC
                    BNE         B8_OR_DC
                    
B8_DIVU_DC          MOVE.L      #DIVU_OP, OPSTRING
B8_OR_ENTRY         MOVE.B      #2, NUMOPERANDS                     ; Because I can
                    
                    MOVE.B      D2, param1
                    MOVE.B      #0, param2
                    MOVE.L      A2, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    
                    MOVE.W      D0, D1
                    MOVE.W      D0, D2
                    
                    AND.W       #SRCMODE_MASK, D1
                    LSR.B       #3, D1
                    AND.W       #SRCREG_MASK, D2
                    
                    CMP.B       #1, D1
                    BGT         B8_NOCHECKDEST
                    BEQ         B8_DATA
                    CMP.B       #1, D6
                    BEQ         B8_DATA

B8_NOCHECKDEST      MOVE.B      D2, param1
                    MOVE.B      D1, param2
                    MOVE.L      A1, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    
                    CLR.L       D1
                    CLR.L       D2
                    
                    MOVE.L      A1, param3
                    MOVE.B      ret, D3
                    MULS.W      #6, D3
                    LEA         B8_DIVU_JMPTABLE, A0
                    JMP         0(A0, D3)
                                        
B8_DIVU_JMPTABLE    JMP         BRANCH8PRINT
                    JMP         B8_DU_ABSWORD
                    JMP         B8_DU_ABSLONG
                    JMP         B8_DU_IMMEDIATE
                    JMP         B8_DATA

B8_DU_IMMEDIATE     CMP.B       #0, D6
                    BNE         B8_DATA
                    CMP.B       #2, D7
                    BGT         B8_DATA
                    
                    MOVEA.L     param3, A0
                    MOVE.B      #$23, (A0)+
                    MOVE.L      A0, param3
                    
                    CMP.B       #1, D7
                    BGT         B8_DU_ABSLONG
                    
B8_DU_ABSWORD       MOVE.W      (A6)+, D1
                    MOVE.B      #4, param1
                    BRA         B8_DU_BUILDOP
                    
B8_DU_ABSLONG       MOVE.L      (A6)+, D1
                    MOVE.B      #8, param1
                    BRA         B8_DU_BUILDOP
                    
                    
                    
B8_DU_BUILDOP       MOVE.L      D1, param2
                    JSR         HEX_TO_STRING_SC
                    BRA         BRANCH8PRINT

B8_OR_DC            MOVE.W      D0, D4
                    AND.W       #B8_OR_OPMODE_MASK, D4
                    LSR.W       #6, D4
                    AND.W       #0007, D4
                    MOVE.W      D4, D7
                    MULS.W      #6, D4
                    LEA         JMPTABLE_OR, A0
                    JMP         0(A0, D4)
                    
JMPTABLE_OR         JMP         OR1_B
                    JMP         OR2_W
                    JMP         OR3_L
                    JMP         B8_DATA
                    JMP         OR4_B
                    JMP         OR5_W
                    JMP         OR6_L
                    JMP         B8_DATA
                    
OR1_B               MOVE.L      #ORB_OP, OPSTRING
                    BRA         B8_OR_ENTRY
OR2_W               MOVE.L      #ORW_OP, OPSTRING
                    BRA         B8_OR_ENTRY
OR3_L               MOVE.L      #ORL_OP, OPSTRING
                    BRA         B8_OR_ENTRY

OR4_B               MOVE.L      #ORB_OP, OPSTRING
                    BRA         B8_SWAP_OPS
OR5_W               MOVE.L      #ORW_OP, OPSTRING
                    BRA         B8_SWAP_OPS
OR6_L               MOVE.L      #ORL_OP, OPSTRING
                    BRA         B8_SWAP_OPS

B8_SWAP_OPS         MOVEA.L     A1, A3
                    MOVEA.L     A2, A1
                    MOVEA.L     A3, A2
                    MOVE.B      #1, D6
                    BRA         B8_OR_ENTRY
                    

B8_DATA             JSR         PREP_DATA
                    BRA         BRANCH8PRINT
            

                    
BRANCH8PRINT        JSR         PRINTOP
                   
BRANCH8EXIT         MOVEM.L     (SP)+, D0-D7/A0-A5
                    RTS


B8_DIVU_MASK        EQU     $80C0
B8_OPMODE_MASK      EQU     $F1C0
B8_OR_OPMODE_MASK   EQU     $01C0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
