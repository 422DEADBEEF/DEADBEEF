*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


BRANCH13                MOVEM.L         D0-D7/A0-A5, -(SP)


***************************************************************************************
                    CLR.L       D6
                    CLR.L       D7
                    *MOVE.B      #1, D7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    
                    MOVEA.L     #O1STRING, A1
                    MOVEA.L     #O2STRING, A2

                    MOVE.W      (A6)+, D0
                    MOVE.W      D0, D1
                    MOVE.W      D0, D2
                    MOVE.W      D0, D3
                    MOVE.W      D0, D4
                    
                    AND.W       #$F000, D3
                    CMP.W       #$D000, D3
                    BNE         B13_DATA
                    CLR.L       D3
                    
                    AND.W       #SRCMODE_MASK, D1
                    LSR.B       #3, D1
                    AND.W       #DSTREG_MASK, D2
                    ROL.W       #7, D2
                    AND.W       #B13_OPMODE_MASK, D4
                    LSR.W       #6, D4
                    
                    AND.W       #0007, D4
                    MOVE.W      D4, D7
                    MULS.W      #6, D4
                    LEA         JMPTABLE_ADD, A0
                    JMP         0(A0, D4)
                    
JMPTABLE_ADD        JMP         ADD1_B
                    JMP         ADD2_W
                    JMP         ADD3_L
                    JMP         ADDA_W
                    JMP         ADD4_B
                    JMP         ADD5_W
                    JMP         ADD6_L
                    JMP         ADDA_L
                    
ADD1_B              MOVE.L      #ADDB_OP, OPSTRING
                    BRA         B13_ADD_VALIDATE
ADD2_W              MOVE.L      #ADDW_OP, OPSTRING
                    BRA         B13_ADD_VALIDATE
ADD3_L              MOVE.L      #ADDL_OP, OPSTRING
                    BRA         B13_ADD_VALIDATE
                    
ADDA_W              MOVE.L      #ADDAW_OP, OPSTRING
                    BRA         B13_ADDAddrVALIDATE

ADD4_B              MOVE.L      #ADDB_OP, OPSTRING
                    BRA         B13_SWAP_OPS
ADD5_W              MOVE.L      #ADDW_OP, OPSTRING
                    BRA         B13_SWAP_OPS
ADD6_L              MOVE.L      #ADDL_OP, OPSTRING
                    BRA         B13_SWAP_OPS
                    
ADDA_L              MOVE.L      #ADDAL_OP, OPSTRING
                    BRA         B13_ADDAddrVALIDATE

B13_SWAP_OPS        MOVEA.L     A1, A3
                    MOVEA.L     A2, A1
                    MOVEA.L     A3, A2
                    MOVE.B      #1, D6
                    
                    CMP.B       #2, D1
                    BLT         B13_DATA
                    MOVE.B      #0, D1
                    BRA         B13_ADD_ENTRY *** KEEP? SET SIZE HERE?
                    
B13_ADDAddrVALIDATE MOVE.B      #1, D1
                    AND.B       #4, D7
                    LSR.B       #2, D7
                    ADDQ.B      #1, D7
                    BRA         B13_ADD_ENTRY

B13_ADD_VALIDATE    MOVE.B      D1, param1
                    MOVE.B      #0, D1
                    CMP.B       #0, D7
                    BNE         B13_ADD_ENTRY
                    MOVE.B      param1, D1
                    CMP.B       #1, D1
                    BEQ         B13_DATA
                    MOVE.B      #0, D1
                    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

B13_ADD_ENTRY       MOVE.B      #2, NUMOPERANDS                     ; Because I can
                    
                    MOVE.B      D2, param1
                    MOVE.B      D1, param2
                    MOVE.L      A2, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    
                    MOVE.W      D0, D1
                    MOVE.W      D0, D2
                    
                    AND.W       #SRCMODE_MASK, D1
                    LSR.B       #3, D1
                    AND.W       #SRCREG_MASK, D2

                    MOVE.B      D2, param1
                    MOVE.B      D1, param2
                    MOVE.L      A1, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    
                    CLR.L       D1
                    CLR.L       D2
                    
                    MOVE.L      A1, param3
                    MOVE.B      ret, D3
                    MULS.W      #6, D3
                    LEA         B13_MULS_JMPTABLE, A0
                    JMP         0(A0, D3)
                                        
B13_MULS_JMPTABLE   JMP         BRANCH13PRINT
                    JMP         B13_MUL_ABSWORD
                    JMP         B13_MUL_ABSLONG
                    JMP         B13_MUL_IMMEDIATE
                    JMP         B13_DATA

B13_MUL_IMMEDIATE   CMP.B       #1, D6
                    BEQ         B13_DATA
                    AND.B       #3, D7
                    CMP.B       #2, D7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    BGT         B13_CRASH ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    
                    MOVEA.L     param3, A0
                    MOVE.B      #$23, (A0)+
                    MOVE.L      A0, param3
                    
                    CMP.B       #1, D7
                    BGT         B13_MUL_ABSLONG
                    BEQ         B13_MUL_ABSWORD

B13_MUL_BYTE        MOVE.W      (A6)+, D1
                    AND.W       #$00FF, D1
                    MOVE.B      #2, param1
                    BRA         B13_MUL_BUILDOP
                    
B13_MUL_ABSWORD     MOVE.W      (A6)+, D1
                    MOVE.B      #4, param1
                    BRA         B13_MUL_BUILDOP
                    
B13_MUL_ABSLONG     MOVE.L      (A6)+, D1
                    MOVE.B      #8, param1
                    BRA         B13_MUL_BUILDOP
                    
                    
                    
B13_MUL_BUILDOP     MOVE.L      D1, param2
                    JSR         HEX_TO_STRING_SC
                    BRA         BRANCH13PRINT
                    
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

B13_CRASH ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    MOVE.L          #5, $1001 ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
***************************************************************************************

B13_DATA            JSR             PREP_DATA
                    BRA             BRANCH13PRINT
                        
BRANCH13PRINT       JSR             PRINTOP
BRANCH13EXIT        MOVEM.L         (SP)+, D0-D7/A0-A5
                    RTS


B13_OPMODE_MASK         EQU             $01C0




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
