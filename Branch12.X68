*-----------------------------------------------------------
* Title      : Branch 12
* Written by : Cameron Dillon
* Date       : 5/12/2017
* Description: Dissassembly soubroutine for Branch 12 (MULS, AND)
*-----------------------------------------------------------

BRANCH12            MOVEM.L     D0-D7/A0-A5, -(SP)
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
                    AND.W       #B12_OPMODE_MASK, D1
                    CMP.W       #B12_MULS_MASK, D1
                    BEQ         B12_MULS_DC
                    BNE         B12_AND_DC
                    
B12_MULS_DC         MOVE.L      #MULS_OP, OPSTRING
B12_AND_ENTRY       MOVE.B      #2, NUMOPERANDS                     ; Because I can
                    
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
                    BGT         B12_NOCHECKDEST
                    BEQ         B12_DATA
                    CMP.B       #1, D6
                    BEQ         B12_DATA

B12_NOCHECKDEST     MOVE.B      D2, param1
                    MOVE.B      D1, param2
                    MOVE.L      A1, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    
                    CLR.L       D1
                    CLR.L       D2
                    
                    MOVE.L      A1, param3
                    MOVE.B      ret, D3
                    MULS.W      #6, D3
                    LEA         B12_MULS_JMPTABLE, A0
                    JMP         0(A0, D3)
                                        
B12_MULS_JMPTABLE   JMP         BRANCH12PRINT
                    JMP         B12_MUL_ABSWORD
                    JMP         B12_MUL_ABSLONG
                    JMP         B12_MUL_IMMEDIATE
                    JMP         B12_DATA

B12_MUL_IMMEDIATE   CMP.B       #0, D6
                    BNE         B12_DATA
                    CMP.B       #2, D7
                    BGT         B12_DATA
                    
                    MOVEA.L     param3, A0
                    MOVE.B      #$23, (A0)+
                    MOVE.L      A0, param3
                    
                    CMP.B       #1, D7
                    BGT         B12_MUL_ABSLONG
                    
B12_MUL_ABSWORD     MOVE.W      (A6)+, D1
                    MOVE.B      #4, param1
                    BRA         B12_MUL_BUILDOP
                    
B12_MUL_ABSLONG     MOVE.L      (A6)+, D1
                    MOVE.B      #8, param1
                    BRA         B12_MUL_BUILDOP
                    
                    
                    
B12_MUL_BUILDOP     MOVE.L      D1, param2
                    JSR         HEX_TO_STRING_SC
                    BRA         BRANCH12PRINT

B12_AND_DC          MOVE.W      D0, D4
                    AND.W       #B12_AND_OPMODE_MASK, D4
                    LSR.W       #6, D4
                    AND.W       #0007, D4
                    MOVE.W      D4, D7
                    MULS.W      #6, D4
                    LEA         JMPTABLE_AND, A0
                    JMP         0(A0, D4)
                    
JMPTABLE_AND        JMP         AND1_B
                    JMP         AND2_W
                    JMP         AND3_L
                    JMP         B12_DATA
                    JMP         AND4_B
                    JMP         AND5_W
                    JMP         AND6_L
                    JMP         B12_DATA
                    
AND1_B              MOVE.L      #ANDB_OP, OPSTRING
                    BRA         B12_AND_ENTRY
AND2_W              MOVE.L      #ANDW_OP, OPSTRING
                    BRA         B12_AND_ENTRY
AND3_L              MOVE.L      #ANDL_OP, OPSTRING
                    BRA         B12_AND_ENTRY

AND4_B              MOVE.L      #ANDB_OP, OPSTRING
                    BRA         B12_SWAP_OPS
AND5_W              MOVE.L      #ANDW_OP, OPSTRING
                    BRA         B12_SWAP_OPS
AND6_L              MOVE.L      #ANDL_OP, OPSTRING
                    BRA         B12_SWAP_OPS

B12_SWAP_OPS        MOVEA.L     A1, A3
                    MOVEA.L     A2, A1
                    MOVEA.L     A3, A2
                    MOVE.B      #1, D6
                    BRA         B12_AND_ENTRY
                    

B12_DATA            JSR         PREP_DATA
                    BRA         BRANCH12PRINT
            

                    
BRANCH12PRINT       JSR         PRINTOP
                   
BRANCH12EXIT        MOVEM.L     (SP)+, D0-D7/A0-A5
                    RTS


B12_MULS_MASK        EQU     $C1C0
B12_OPMODE_MASK      EQU     $F1C0
B12_AND_OPMODE_MASK  EQU     $01C0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
