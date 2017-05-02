*-----------------------------------------------------------
* Title      : Branch 8
* Written by : Cameron Dillon
* Date       : 5/2/2017
* Description: Dissassembly soubroutine for Branch 8 (DIVU, OR)
*-----------------------------------------------------------


BRANCH8             MOVEM.L     D0-D7/A0-A5, -(SP)
                    MOVE.W      (A6)+, D0
                    MOVE.W      D0, D1
                    MOVE.W      D0, D2
                    AND.W       #DSTREG_MASK, D2
                    ROL.W       #7, D2
                    AND.W       #B8_DIVU_MASK, D1
                    CMP.W       #B8_DIVU_MASK, D1
                    BEQ         B8_DIVU_DC
                    BNE         B8_OR_DC
                    
B8_DIVU_DC          MOVE.L      #DIVU_OP, OPSTRING
                    MOVE.B      #2, NUMOPERANDS
                    
                    MOVE.B      D2, param1
                    MOVE.B      #0, param2
                    MOVE.L      #O2STRING, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    
                    MOVE.W      D0, D1
                    MOVE.W      D0, D2
                    
                    AND.W       #SRCMODE_MASK, D1
                    LSR.B       #3, D1
                    AND.W       #SRCREG_MASK, D2
                    
                    MOVE.B      D2, param1
                    MOVE.B      D1, param2
                    MOVE.L      #O2STRING, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    
                    CLR.L       D1
                    CLR.L       D2
                    
                    MOVE.L      #O2STRING, param3
                    MOVE.B      ret, D3
                    MULS.W      #6, D3
                    LEA         B8_DIVU_JMPTABLE, A0
                    JMP         0(A0, D3)
                                        
B8_DIVU_JMPTABLE    JMP         BRANCH8PRINT
                    JMP         B8_DU_ABSWORD
                    JMP         B8_DU_ABSLONG
                    JMP         B8_DU_IMMEDIATE
                    JMP         B8_DATA

B8_DU_IMMEDIATE     MOVEA.L     param3, A0
                    MOVE.B      #$23, (A0)+
                    MOVE.L      A0, param3
                    
B8_DU_ABSWORD       MOVE.W      (A6)+, D1
                    MOVE.B      #4, param1
                    BRA         B8_DU_BUILDOP
                    
B8_DU_ABSLONG       MOVE.L      (A6)+, D1
                    MOVE.W      #8, param1
                    BRA         B8_DU_BUILDOP
                    
                    
                    
B8_DU_BUILDOP       MOVE.L      D1, param2
                    JSR         HEX_TO_STRING_SC
                    BRA         BRANCH8PRINT

B8_OR_DC

B8_DATA             JSR         PREP_DATA
                    BRA         BRANCH8PRINT
            

                    
BRANCH8PRINT        ***DO STUFF***                    
BRANCH8EXIT         MOVEM.L     (SP)+, D0-D7/A0-A5
                    RTS


B8_DIVU_MASK        EQU     $80C0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
