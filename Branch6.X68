*-----------------------------------------------------------
* Title      : Branch 6
* Written by : Cameron Dillon
* Date       : 5/1/2017
* Description: Decoding operations for Branch 6 (BRA and Bcc)
*-----------------------------------------------------------


BRANCH6         MOVEM.L     D0-D7/A0-A5, -(SP)
                MOVE.W      (A6)+, D0
                MOVE.W      D0, D1
                
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
                MOVE.L      #BRA_OP, OPSTRING
                BRA         B6_GRAB_DISPLACEMENT
                
DC_BRANCH_CC
                MOVE.L      #BCC_OP, OPSTRING
                BRA         B6_GRAB_DISPLACEMENT

DC_BRANCH_GE
                MOVE.L      #BGE_OP, OPSTRING
                BRA         B6_GRAB_DISPLACEMENT

DC_BRANCH_LT
                MOVE.L      #BLT_OP, OPSTRING
                BRA         B6_GRAB_DISPLACEMENT
                       
                
B6_GRAB_DISPLACEMENT                
                MOVE.W      D0, D1
                AND.W       #B6_DISPLACEMENT_MASK, D1
                
                MOVEA.L     A6, A0
                CMP.B       #0, D1
                BEQ         B6_GRAB_OP
                MOVEA.L     D1, A1
                BRA         B6_CALC_ADDRESS
                
B6_GRAB_OP
                MOVEA.W      (A6)+, A1
                BRA         B6_CALC_ADDRESS
                
B6_CALC_ADDRESS
                ADDA.L      A1, A0
                MOVE.L      A0, D0
                
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
