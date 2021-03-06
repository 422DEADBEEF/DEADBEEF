*-----------------------------------------------------------
* Title      : Branch 6
* Written by : Cameron Dillon
* Date       : 5/1/2017
* Description: Decoding operations for Branch 6 (BRA and Bcc)
*-----------------------------------------------------------


BRANCH6         MOVEM.L     D0-D7/A0-A5, -(SP)
                MOVE.W      (A6)+, D0
                MOVE.W      D0, D1
                CLR.L       D2
                
                AND.W       #B6_CONDITION_MASK, D1
                CMP.W       #B6_BRA, D1
                BEQ         DC_BRANCH_ALWAYS
                
                CMP.W       #B6_CC, D1
                BEQ         DC_BRANCH_CC
                
                CMP.W       #B6_GE, D1
                BEQ         DC_BRANCH_GE
                
                CMP.W       #B6_LT, D1
                BEQ         DC_BRANCH_LT
                
                JSR         PREP_DATA
                BRA         BRANCH6PRINT
                
DC_BRANCH_ALWAYS
                MOVE.W      #0, D2
                BRA         B6_GRAB_DISPLACEMENT
                
DC_BRANCH_CC
                MOVE.W      #2, D2
                BRA         B6_GRAB_DISPLACEMENT

DC_BRANCH_GE
                MOVE.W      #4, D2
                BRA         B6_GRAB_DISPLACEMENT

DC_BRANCH_LT
                MOVE.W      #6, D2
                BRA         B6_GRAB_DISPLACEMENT
                       
                
B6_GRAB_DISPLACEMENT
                CLR.L       D1                
                MOVE.W      D0, D1
                AND.W       #B6_DISPLACEMENT_MASK, D1
                
                MOVEA.L     A6, A0
                CMP.B       #0, D1
                BEQ         B6_GRAB_OP
                
                CMP.L       #$00000080, D1                  ; Is the MSB set? (is the value negative?)
                BLT         B6_POSITIVE
                OR.W        #$FF00, D1
                
B6_POSITIVE
                MOVEA.W     D1, A1
                BRA         B6_CALC_ADDRESS
                
B6_GRAB_OP
                MOVEA.W     (A6)+, A1
                ADDQ.B      #1, D2
                BRA         B6_CALC_ADDRESS
                
B6_CALC_ADDRESS
                ADDA.L      A1, A0
                MOVE.L      A0, D0
                
                MULS.W      #6, D2
                LEA         B6_OP_JMPTABLE, A3
                JMP         0(A3, D2)
                                        
B6_OP_JMPTABLE  JMP         B6_BRAB.L
                JMP         B6_BRAW.L
                JMP         B6_CCB.L
                JMP         B6_CCW.L
                JMP         B6_GEB.L
                JMP         B6_GEW.L
                JMP         B6_LTB.L
                JMP         B6_LTW.L
                
B6_BRAB         MOVE.L      #BRAB_OP, OPSTRING
                BRA         B6_END_JMP
                
B6_BRAW         MOVE.L      #BRAW_OP, OPSTRING
                BRA         B6_END_JMP
                
B6_CCB          MOVE.L      #BCCB_OP, OPSTRING
                BRA         B6_END_JMP
                
B6_CCW          MOVE.L      #BCCW_OP, OPSTRING
                BRA         B6_END_JMP
                
B6_GEB          MOVE.L      #BGEB_OP, OPSTRING
                BRA         B6_END_JMP
                
B6_GEW          MOVE.L      #BGEW_OP, OPSTRING
                BRA         B6_END_JMP
                
B6_LTB          MOVE.L      #BLTB_OP, OPSTRING
                BRA         B6_END_JMP
                
B6_LTW          MOVE.L      #BLTW_OP, OPSTRING
                BRA         B6_END_JMP
               
B6_END_JMP 
                MOVE.B      #1, NUMOPERANDS
                MOVE.B      #8, param1
                MOVE.L      D0, param2
                MOVE.L      #O1STRING, param3
                JSR         HEX_TO_STRING_SC
                
BRANCH6PRINT    JSR         PRINTOP                
                
BRANCH6EXIT     MOVEM.L     (SP)+, D0-D7/A0-A5
                RTS


B6_CONDITION_MASK       EQU     $0F00
B6_DISPLACEMENT_MASK    EQU     $00FF
B6_BRA                  EQU     $0000
B6_CC                   EQU     $0400
B6_GE                   EQU     $0C00
B6_LT                   EQU     $0D00




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
