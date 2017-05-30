*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

BRANCH7
                MOVEM.L     D0-D7/A0-A5, -(SP)
                CLR.L       D1
                MOVE.W      (A6)+, D0
                MOVE.W      D0, D1
                AND.W       #$F100, D1
                CMP.W       #$7000, D1
                BNE         B7_DATA
                MOVE.W      D0, D1
                AND.W       MASK_SRCREG, D1
                ROL.W       #7, D1
                
                MOVE.B      D1, param1
                MOVE.B      #0, param2
                MOVE.L      #O2STRING, param3
                JSR         DECODE_ADDRESS_MODE_AM
                
                MOVE.B      #2, param1
                
                MOVE.W      D0, D1
                AND.W       #$00FF, D1
                MOVE.L      D1, param2
                
                MOVEA.L     #O1STRING, A0
                MOVE.B      #$23, (A0)+
                MOVE.L      A0, param3
                JSR         HEX_TO_STRING_SC
                
                MOVE.L      #MOVEQ_OP, OPSTRING
                MOVE.B      #2, NUMOPERANDS
                
BRANCH7PRINT    JSR         PRINTOP
                          
BRANCH7EXIT     MOVEM.L     (SP)+, D0-D7/A0-A5
                RTS
                
B7_DATA         JSR         PREP_DATA
                BRA         BRANCH7PRINT




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
