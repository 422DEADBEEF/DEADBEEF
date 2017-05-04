
*-----------------------------------------------------------
* Title       : PREP_OPERANDS
* Written by  : Ryan Berge
* Date        : April 26th, 2017
* Description : Takes in an addressing mode and reads in
*               additional operands, advancing A6, and
*               the O1STRING and O2STRING strings.
*-----------------------------------------------------------
                        * param1.B = Mode:
                        *            1 = (xxx).w
                        *            2 = (xxx).l
                        *            3 = #<xxx>
                        *            4 = invalid
                        * param2.B = Mode:
                        *            1 = (xxx).w
                        *            2 = (xxx).l
                        *            3 = #<xxx>
                        *            4 = invalid
                        * param3.B = operand1 size
                        *            0 = N/A
                        *            1 = word
                        *            2 = long
                        * param4.B = operand2 size
                        *            0 = N/A
                        *            1 = word
                        *            2 = long
                        * param5.B = num operands
                        *            0 = 1
                        *            anything else = 2
                        * Writes to:
                        *            O1STRING
                        *            O2STRING
                        *            NUMOPERANDS
                        
PREP_OPERANDS           MOVEM.L     D0-D7/A0-A5, -(SP)
                        
                        MOVE.B      param1, D1  * op1 mode
                        MOVE.B      param2, D2  * op2 mode
                        MOVE.B      param3, D3  * op1 size
                        MOVE.B      param4, D4  * op2 size
                        MOVE.B      param5, D6  * operand order
                        
                        CLR.L       D5          * parameter
                        
                        MOVE.B      #2, NUMOPERANDS
                        CMP.B       #0, D6
                        BNE         SIZE_CONTINUE
                        MOVE.B      #1, NUMOPERANDS
                        
                        
SIZE_CONTINUE           LEA         O1STRING, A1
                        LEA         O2STRING, A2
                        
                        CMP.B       #0, D1
                        BEQ         P1_NOP
                        CMP.B       #1, D1
                        BEQ         P1_A_W
                        CMP.B       #2, D1
                        BEQ         P1_A_L
                        CMP.B       #1, D3
                        BEQ         P1_L_W
                        CMP.B       #2, D3
                        BEQ         P1_L_L
                        
EA_P2                   CLR.L       D5

                        CMP.B       #0, D2
                        BEQ         END_PREP_OPERANDS
                        CMP.B       #4, D2
                        BEQ         P2_EMPTY
                        CMP.B       #1, D2
                        BEQ         P2_A_W
                        CMP.B       #2, D2
                        BEQ         P2_A_L
                        CMP.B       #1, D4
                        BEQ         P2_L_W
                        CMP.B       #2, D4
                        BEQ         P2_L_L
                        
P1_NOP                  BRA         EA_P2                        
                        
P1_A_W                  MOVE.W      (A6)+, D5
                        MOVE.B      #4, param1
                        MOVE.L      D5, param2
                        MOVE.L      A1, param3
                        JSR         HEX_TO_STRING_SC
                        BRA         EA_P2
                        
P1_A_L                  MOVE.L      (A6)+, D5
                        MOVE.B      #8, param1
                        MOVE.L      D5, param2
                        MOVE.L      A1, param3
                        JSR         HEX_TO_STRING_SC
                        BRA         EA_P2
                        
P1_L_W                  MOVE.W      (A6)+, D5
                        MOVE.B      #POUND, (A1)+
                        MOVE.B      #4, param1
                        MOVE.L      D5, param2
                        MOVE.L      A1, param3
                        JSR         HEX_TO_STRING_SC
                        BRA         EA_P2
                        
P1_L_L                  MOVE.L      (A6)+, D5
                        MOVE.B      #POUND, (A1)+
                        MOVE.B      #8, param1
                        MOVE.L      D5, param2
                        MOVE.L      A1, param3
                        JSR         HEX_TO_STRING_SC
                        BRA         EA_P2

P2_A_W                  MOVE.W      (A6)+, D5
                        MOVE.B      #4, param1
                        MOVE.L      D5, param2
                        MOVE.L      A2, param3
                        JSR         HEX_TO_STRING_SC
                        BRA         END_PREP_OPERANDS
                        
P2_A_L                  MOVE.L      (A6)+, D5
                        MOVE.B      #8, param1
                        MOVE.L      D5, param2
                        MOVE.L      A2, param3
                        JSR         HEX_TO_STRING_SC
                        BRA         END_PREP_OPERANDS
                        
P2_L_W                  MOVE.W      (A6)+, D5
                        MOVE.B      #POUND, (A1)+
                        MOVE.B      #4, param1
                        MOVE.L      D5, param2
                        MOVE.L      A2, param3
                        JSR         HEX_TO_STRING_SC
                        BRA         END_PREP_OPERANDS
                        
P2_L_L                  MOVE.W      (A6)+, D5
                        MOVE.B      #POUND, (A1)+
                        MOVE.B      #4, param1
                        MOVE.L      D5, param2
                        MOVE.L      A2, param3
                        JSR         HEX_TO_STRING_SC
                        BRA         END_PREP_OPERANDS
                        
P2_EMPTY                

                        
END_PREP_OPERANDS       MOVEM.L     (SP)+, D0-D7/A0-A5
                        RTS
                        
                        * Writes to TMPSTRING
                        
                        
                        
                        
                        


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
